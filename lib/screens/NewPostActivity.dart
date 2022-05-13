import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/NewPostForm.dart';


/// screen of new post form
///
class NewPostActivity extends StatefulWidget {
  const NewPostActivity({Key? key}) : super(key: key);

  @override
  _NewPostActivityState createState() => _NewPostActivityState();
}

class _NewPostActivityState extends State<NewPostActivity> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  void _sendItem(String itemTitle, String itemDescription,
      List<File> imageList, BuildContext context) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    List<String> imageUrls = <String>[];

    try {
      setState(() {
        _isLoading = true;
      });
      // upload pictures and get images' url
      for (int i = 0; i < imageList.length; i++) {
        File _image = imageList[i];
        String index = (i + 1).toString();
        String time = DateTime.now().toString();
        final ref = FirebaseStorage.instance
            .ref()
            .child('Images')
            .child(user!.uid + time + '_' + index + '.jpg');

        await ref.putFile(_image);

        final imageUrl = await ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      //send data to firebase
      FirebaseFirestore.instance.collection('posts').add({
        'title': itemTitle,
        'description': itemDescription,
        'createdAt': Timestamp.now(),
        'userId': user!.uid,
        'username': userData.data()!['username'],
        'userImage': imageUrls,
      });
      _controller.clear();

      //snack bar for successful post
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post Successful!')));

      // back to home page
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on PlatformException catch (error) {
      String? message = 'An error occurred, please check your credentials!';
      print("PlatformException error: ");
      print(error);

      if (error.message != null) {
        message = error.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print("caught error: ");
      print(err);

      showDialog(
        builder: (context) => const SimpleDialog(
          backgroundColor: Colors.pink,
          contentPadding: EdgeInsets.all(10.0),
          title: Center(
            child: Text("ERROR"),
          ),
          children: <Widget>[
            Center(
              child: Text("Something wrong, please try again"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
        context: context,
      );

      // add logged in user's info to firebase dataset
      if (userData.data() == null && user.uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'username': user.displayName,
          'email': user.email,
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post Page'),
      ),
      body: NewPostForm(_sendItem, _isLoading),
    );
  }
}

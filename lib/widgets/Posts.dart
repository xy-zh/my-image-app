import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_image/widgets/FavoriteAndComments.dart';
import 'package:my_image/src/ItemCollection.dart';
import 'package:my_image/widgets/photo-widgets.dart';

import '../screens/PostDetails.dart';
import 'Texts.dart';

///A widget that shows all of the posted items

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> postsSnapshot) {
        if (postsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (postsSnapshot.data == null) {
          return const Text("no posts");
        }
        final postCollection = postsSnapshot.data!.docs;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: postCollection.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String _title = postCollection[index]['title'];
                      String _description =
                          postCollection[index]['description'];
                      List<dynamic> _imageUrl =
                          postCollection[index]['userImage'];
                      String _timeStamp =
                          postCollection[index]['createdAt'].toString();
                      String _username = postCollection[index]['username'];

                      String _imageID = postCollection[index].id.toString();

                      ItemCollection _detail = ItemCollection(_title, _username,
                          _description, _imageUrl, _timeStamp);
                      return Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: 320,
                              child: Container(
                                width: double.infinity,
                                height: 640,
                                child: ImageSlider(images: _imageUrl),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Color(0x3416202A),
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 4, 4, 4),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      TextContents(
                                        username: _username,
                                        title: _title,
                                      ),
                                      const Divider(
                                        height: 8,
                                        thickness: 1,
                                        indent: 4,
                                        endIndent: 4,
                                        color: Color(0xFFDBE2E7),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 4, 4),
                                        child: FavoriteAndComments(
                                            imageId: _imageID),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

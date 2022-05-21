import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FavoriteAndComments extends StatefulWidget {
  const FavoriteAndComments({Key? key, this.imageId}) : super(key: key);
  final imageId;

  @override
  State<FavoriteAndComments> createState() => _FavoriteAndCommentsState();
}

class _FavoriteAndCommentsState extends State<FavoriteAndComments> {
  final user = FirebaseAuth.instance.currentUser;
  int _numOfFavorite = 0;

  late List<dynamic> favoriteList;
  List<dynamic> comments = [];
  bool isLiked = false;
  bool _disposed = false;

  @override
  initState() {
    if (!_disposed) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((userData) {
        setState(() {
          favoriteList = userData.data()!['favorite'];
          isLiked = favoriteList.contains(widget.imageId);
        });
      });
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.imageId)
          .get()
          .then((imageData) {
        setState(() {
          comments = imageData.data()!['comments'];
          _numOfFavorite = imageData.data()!['numOfFavorite'];
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  getComment() {
    //TODO: add comment page
  }

  void addFavorite(String imageID) {
    favoriteList.add(imageID);
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'favorite': favoriteList,
    });
  }

  void deleteFavorite(String imageID) {
    favoriteList.remove(imageID);
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'favorite': favoriteList,
    });
  }

  _setFavorite() async {
    setState(() {
      if (isLiked) {
        deleteFavorite(widget.imageId);
        _numOfFavorite--;
      } else {
        addFavorite(widget.imageId);
        _numOfFavorite++;
      }
      FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.imageId)
          .update({'numOfFavorite': _numOfFavorite});
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getFavoriteList();
    // _getImageMessage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
              child: IconButton(
                onPressed: () {
                  _setFavorite();
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
              child: IconButton(
                  onPressed: () {
                    getComment();
                  },
                  icon: const Icon(Icons.mode_comment_outlined)),
            ),
          ],
        ),
        if (_numOfFavorite > 0)
          Text(
            _numOfFavorite.toString() + "likes",
            textAlign: TextAlign.left,
          ),
      ],
    );
  }
}

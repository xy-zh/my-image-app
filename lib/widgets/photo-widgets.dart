import 'dart:io';

import 'package:flutter/material.dart';

class Photo extends StatelessWidget {
  const Photo({Key? key, required this.photoUrl}) : super(key: key);

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: () {// tap to open the image on e full screen
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FullScreenImage(imageUrl: photoUrl);
          }));
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints size) {
            return Image.network(
              photoUrl,
              fit: BoxFit.fitHeight,
              // width: 128 * 2,
              height: 128,
            );
          },
        ),
      ),
    );
  }
}

class PickedImage extends StatelessWidget {
  const PickedImage({Key? key, required this.image}) : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: () { // tap to open image on full screen
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FullScreenImage(imageFile: image);
          }));
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints size) {
            return Image.file(
              image,
              fit: BoxFit.fitWidth,
              width: 64,
            );
          },
        ),
      ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({Key? key, this.imageUrl, this.imageFile})
      : super(key: key);
  final imageUrl;
  final imageFile;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Container(// get image from a url or a file
        child: (widget.imageUrl == null)
            ? Image.file(widget.imageFile)
            : Image.network(widget.imageUrl),
      ),
    );
  }
}

class OverviewImage extends StatefulWidget {
  const OverviewImage({Key? key, this.imageUrl}) : super(key: key);
  final imageUrl;

  @override
  State<OverviewImage> createState() => _OverviewImageState();
}

class _OverviewImageState extends State<OverviewImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return Image.asset(//show image placeholder if there is no image posted
        'images/no-image.PNG',
        fit: BoxFit.fitWidth,
        width: 128,
      );
    } else {
      return Image.network( // show one of the image from database
        widget.imageUrl[0].toString(),
        fit: BoxFit.fitHeight,
        height: 128,
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Photo extends StatelessWidget {
  const Photo({Key? key, required this.photoUrl}) : super(key: key);

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.25),
      child: InkWell(
        onTap: () { // tap to open the image on e full screen
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
      color: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.25),
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
      body: Container( // get image from a url or a file
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
      return Image.asset( //show image placeholder if there is no image posted
        'images/no-image.PNG',
        fit: BoxFit.fitHeight,
        height: 128 * 2,

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

class ImageSlider extends StatefulWidget {
  const ImageSlider({this.images, Key? key}) : super(key: key);
  final images;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  @override
  Widget build(BuildContext context) {
    List<dynamic> images = widget.images;

    PageController _controller = PageController(
      initialPage: 0,
    );
    int activePage = 1;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              0, 0, 0, 50),
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            onPageChanged: (page) {
              setState(() {
                activePage = page;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index].toString(),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0, 1),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                0, 0, 0, 10),
            child: SmoothPageIndicator(
              controller: _controller,
              count: images.length,
              axisDirection: Axis.horizontal,
              onDotClicked: (i) {
                _controller.animateToPage(
                  i,
                  duration:
                  const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              effect: const ExpandingDotsEffect(
                expansionFactor: 2,
                spacing: 8,
                radius: 16,
                dotWidth: 16,
                dotHeight: 16,
                dotColor: Color(0xFF9E9E9E),
                activeDotColor: Colors.pink,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
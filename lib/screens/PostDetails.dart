import 'package:flutter/material.dart';
import 'package:my_image/widgets/photo-widgets.dart';
import 'package:my_image/src/ItemCollection.dart';

class PostDetails extends StatefulWidget {
  PostDetails({
    Key? key,
    this.detail,
  }) : super(key: key);

  final detail;

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {

  @override
  Widget build(BuildContext context) {
    ItemCollection detail = widget.detail;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Detail"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Text(
              detail.title,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
            Text("Post by " + detail.username),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
            const ListTile(
              title: Text(
                "Description ",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Text(
              detail.description,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18),
            ),
            const ListTile(
              title: Text(
                "Images ",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            if (detail.imageUrlList.isEmpty) // image placeholder
              Image.asset(
                'images/no-image.PNG',
                fit: BoxFit.fitWidth,
              ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: detail.imageUrlList.length,
                  // scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List<dynamic> imageList = detail.imageUrlList;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Photo(photoUrl: imageList[index].toString()),
                        const Divider(
                          height: 8,
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                          color: Colors.grey,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      // _buildProductDetailsPage(context),
    );
  }
}

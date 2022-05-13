import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_image/widgets/photo-widgets.dart';
import 'package:image_picker/image_picker.dart';

/// a form to post a new item

class NewPostForm extends StatefulWidget {
  NewPostForm(this.itemInfo, this.isLoading);

  final bool isLoading;
  final void Function(
    String title,
    String itemDescription,
    List<File> imageList,
    BuildContext context,
  ) itemInfo;

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _itemDescription = '';

  bool emptyTitle = true;

  final List<File> _imageList = <File>[];

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.itemInfo(
        _title.trim(),
        _itemDescription.trim(),
        _imageList,
        context,
      );
    }
  }

  List<File> _currImageList = <File>[];

  void _pickImage(File image) {
    _imageList.add(image);
  }

  Future getImage(String method) async {
    if (_imageList.length >= 9) {
      //Error message handler
      return showDialog(
        builder: (context) => const SimpleDialog(
          backgroundColor: Colors.pink,
          contentPadding: EdgeInsets.all(10.0),
          title: Center(
            child: Text("You can't add more photos"),
          ),
          children: <Widget>[
            Center(
              child: Text("Maximum number of attach image is 9"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
        context: context,
      );
    }
    try {
      final _tempImage = method == 'camera'
          ? await ImagePicker().pickImage(source: ImageSource.camera)
          : await ImagePicker().pickImage(source: ImageSource.gallery);
      File _image = File(_tempImage!.path);
      _pickImage(_image);

      setState(() {
        _currImageList.add(_image);
      });

    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('Title'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a title';
                      }
                      if (value.length > 15) {
                        return 'Only allow at most 15 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    onChanged: (text) {
                      setState(() {
                        if (text.isNotEmpty) {
                          emptyTitle = false;
                        } else {
                          emptyTitle = true;
                        }
                      });
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('Description'),
                    maxLines: 30,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onSaved: (value) {
                      _itemDescription = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(// get images from gallery and/or camera
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: (_imageList.length >= 9
                            ? null
                            : () {
                                getImage('camera');
                              }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_photo_alternate_rounded),
                        onPressed: (_currImageList.length >= 9
                            ? null
                            : () {
                                getImage('gallery');
                              }),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: (emptyTitle
                        ? () {
                            //error message snack bar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    "Item title and price cannot be empty"),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            );
                          }
                        : () {
                            _trySubmit();
                          }),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 160,
                        child: (_currImageList.isNotEmpty) ?
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _currImageList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: PickedImage(image: _currImageList[index]),
                              );
                            })
                        // PickedImage(image: _currImage)
                            : const Text("You can add at most 9 images"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

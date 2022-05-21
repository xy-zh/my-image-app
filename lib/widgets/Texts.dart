import 'package:flutter/material.dart';

class TextContents extends StatefulWidget {
  const TextContents({this.username, this.title, Key? key}) : super(key: key);
  final username;
  final title;

  @override
  State<TextContents> createState() => _TextContentsState();
}

class _TextContentsState extends State<TextContents> {

  @override
  Widget build(BuildContext context) {
    String _username = widget.username;
    String _title = widget.title;

    return Column(children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                //TODO: supports user avatar
                'images/no-image.PNG',
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Text(
                _username,
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF090F13),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                _title,
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF57636C),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

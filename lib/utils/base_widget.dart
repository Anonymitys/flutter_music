import 'package:flutter/material.dart';

Widget playAll(BuildContext context, int num) {
  return Container(
    padding: EdgeInsets.only(left: 10),
    height: 45,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey, width: 0.2),
      ),
      color: Colors.white,
    ),
    child: Row(
      children: <Widget>[
        Icon(Icons.play_arrow),
        Padding(padding: EdgeInsets.only(right: 10)),
        Text(
          '播放全部',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text('(共$num首)'),
      ],
    ),
  );
}

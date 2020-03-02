

import 'package:flutter/material.dart';

Widget title(String title, String trailing,double padding, VoidCallback callback) =>
    SliverToBoxAdapter(
      child: GestureDetector(
        onTap: callback,
        child: Container(
          margin: EdgeInsets.only(top: 10,bottom: 10),
          padding: EdgeInsets.only(left: padding,right: padding),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Text(trailing),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
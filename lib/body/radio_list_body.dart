import 'package:flutter/material.dart';
import 'package:flutter_music/bean/radio_list.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class RadioListBody extends StatefulWidget {
  @override
  State createState() => _RadioListStates();
}

class _RadioListStates extends State<RadioListBody> {
  var _futureBuilderFuture;
  RadioGroup _radioGroup;

  @override
  void initState() {
    _futureBuilderFuture = HttpRequest.getRadioList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐电台'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print('还没有开始网络请求');
                return Text('还没有开始网络请求');
              case ConnectionState.active:
                print('active');
                return Text('ConnectionState.active');
              case ConnectionState.waiting:
                print('waiting');
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                print('done');
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                _radioGroup = RadioGroup.fromJson(snapshot.data);
                return _getMainWidget(context);
              default:
                return null;
            }
          },
          future: _futureBuilderFuture),
    );
  }

  _getMainWidget(context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemBuilder: (context, index) => _ItemCatagory(context, index),
        itemCount: _radioGroup.groupList.length,
      ),
    );
  }

  _ItemCatagory(BuildContext context, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              _radioGroup.groupList[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 9/11,
            ),
            itemBuilder: (context, subIndex) => GestureDetector(
              onTap: () {
                print(_radioGroup.groupList[index].radioList[subIndex].radioId);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        _radioGroup
                            .groupList[index].radioList[subIndex].radioImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(_radioGroup.groupList[index].radioList[subIndex].radioName),
                ],
              ),
            ),
            itemCount: _radioGroup.groupList[index].radioList.length,
          ),
        ],
      ),
    );
  }
}

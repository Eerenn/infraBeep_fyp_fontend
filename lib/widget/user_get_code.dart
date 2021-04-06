import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/constants.dart';
import 'package:ee_fyp/providers/auth_provider.dart';

import 'package:ee_fyp/widget/user_create_group.dart';
import 'package:ee_fyp/widget/user_join_code.dart';

enum CodeType { CreateNew, JoinExisting }

class UserGetCode extends StatelessWidget {
  const UserGetCode({
    Key key,
    @required this.appBarHeight,
  }) : super(key: key);

  final double appBarHeight;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        height: size.height - appBarHeight,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              white,
              Color.fromRGBO(168, 192, 255, 1).withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GetCodeCard(
                size: size,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}

class GetCodeCard extends StatefulWidget {
  const GetCodeCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final size;

  @override
  _GetCodeCardState createState() => _GetCodeCardState();
}

class _GetCodeCardState extends State<GetCodeCard> {
  final _textController = TextEditingController();
  CodeType _codeType = CodeType.JoinExisting;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void _switchCodeMode() {
    if (_codeType == CodeType.JoinExisting) {
      setState(() {
        _codeType = CodeType.CreateNew;
      });
    } else {
      setState(() {
        _codeType = CodeType.JoinExisting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthClass>(context);
    String random = user.getRandString(6);
    return Container(
      width: widget.size.width * 0.7,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueGrey[50],
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            offset: Offset(3, 4.0),
            color: fontColor,
          ),
        ],
      ),
      child: Column(
        children: [
          _codeType == CodeType.CreateNew
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 8.0,
                  ),
                  child: Text('Create a new group'),
                )
              : Container(),
          _codeType == CodeType.CreateNew
              ? Text(
                  random,
                  style: TextStyle(fontSize: 36),
                )
              : Container(),
          _codeType == CodeType.CreateNew
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 25.0,
                  ),
                  child: CreateGroup(
                    user: user,
                    code: random,
                  ),
                )
              : Container(),
          _codeType == CodeType.JoinExisting
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 8.0,
                  ),
                  child: Text('Or use an invitation code'),
                )
              : Container(),
          _codeType == CodeType.JoinExisting
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Invitation code',
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    ),
                    controller: _textController,
                  ),
                )
              : Container(),
          _codeType == CodeType.JoinExisting
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 25.0,
                  ),
                  child: JoinGroup(
                    user: user,
                    textController: _textController,
                  ),
                )
              : Container(),
          FlatButton(
            child: Text(
                'or ${_codeType == CodeType.CreateNew ? 'Create NEW code' : 'Join Existing code'} instead'),
            onPressed: _switchCodeMode,
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

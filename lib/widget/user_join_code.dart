import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({
    Key key,
    @required this.user,
    @required this.textController,
  }) : super(key: key);

  final AuthClass user;
  final TextEditingController textController;
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> _updateProfile() async {
      setState(() {
        _isLoading = true;
      });
      final update = AuthClass(
        userId: widget.user.getUserId,
        userEmail: widget.user.getUserEmail,
        userName: widget.user.getUserName,
        userPassword: widget.user.getUserPassword,
        userCode: widget.textController.text,
        isAdmin: false,
      );
      String callback = await Provider.of<AuthClass>(context, listen: false)
          .update(update, UpdateType.JoinExistingCode);

      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(callback),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      print('updated');
    }

    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: fontColor,
          )
        : RaisedButton(
            onPressed: _updateProfile,
            child: Text(
              'Join Group',
              style: TextStyle(color: white),
            ),
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 15.0,
            ),
          );
  }
}

import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CreateGroup extends StatefulWidget {
  final AuthClass user;
  final String code;

  const CreateGroup({
    Key key,
    @required this.user,
    @required this.code,
  }) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    String random = widget.code;

    Future<void> _updateProfile() async {
      setState(() {
        _isLoading = true;
      });
      final update = AuthClass(
        userId: widget.user.getUserId,
        userEmail: widget.user.getUserEmail,
        userName: widget.user.getUserName,
        userPassword: widget.user.getUserPassword,
        userCode: random,
        isAdmin: true,
      );
      String callback = await Provider.of<AuthClass>(context, listen: false)
          .update(update, UpdateType.CreateUserCode);

      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(callback),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
      print('updated');
    }

    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: fontColor,
          )
        : RaisedButton(
            onPressed: _updateProfile,
            child: Text(
              'Create Group',
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

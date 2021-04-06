import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ee_fyp/modal/device_action.dart';

import '../constants.dart'; // ignore: must_be_immutable

// ignore: must_be_immutable
class DeviceForm extends StatefulWidget {
  DeviceForm({
    Key key,
    @required GlobalKey<FormState> form,
    @required this.nameController,
    @required this.topicController,
    @required this.args,
    @required this.saveForm,
    @required this.saveName,
    @required this.saveTopic,
    @required this.uploadImage,
    @required this.base64Image,
  })  : _form = form,
        super(key: key);

  final GlobalKey<FormState> _form;
  final TextEditingController nameController;
  final TextEditingController topicController;
  final DeviceActions args;
  final Function(Method, BuildContext) saveForm;
  final Function(String) saveName;
  final Function(String) saveTopic;
  final Function(String) uploadImage;
  String base64Image;

  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  File _image;
  final picker = ImagePicker();
  List<int> imageBytes;
  File _resizedImage;

//store image in s3 instead
  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      _resizedImage = await FlutterNativeImage.compressImage(pickedFile.path,
          quality: 100, targetWidth: 300, targetHeight: 300);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);

          imageBytes = _resizedImage.readAsBytesSync();
          widget.base64Image = base64Encode(imageBytes);
          print(widget.base64Image);
          widget.uploadImage(widget.base64Image);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: widget._form,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ListView(
              children: [
                _rederImage(context),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Device Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    controller: widget.nameController,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      widget.saveName(value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please name your device';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Device Topic',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 5.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      controller: widget.topicController,
                      onSaved: (value) {
                        widget.saveTopic(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a topic like \'livingroom/fan/1\'';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: RaisedButton(
                    onPressed: () {
                      widget.saveForm(widget.args.action, context);
                    },
                    padding: const EdgeInsets.all(15.0),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 18, color: white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rederImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: GestureDetector(
        onTap: getImage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: width / 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: widget.args.action == Method.EditExisting
                    ? widget.args.device.imageUrl != null
                        ? Image.network(widget.args.device.imageUrl)
                        : Text('No image selected.')
                    : _image == null
                        ? Text('No image selected.')
                        // ? Image.network(
                        //     'https://png2.cleanpng.com/sh/393693d563c7e0df5a76c7ad26a3b966/L0KzQYm3WcI3N6dBjpH0aYP2gLBuTfNmcZ1uhtk2ZnHxg370jB51bV5oeeR1bz3wccfskvlkc15qfthyY3nofsW0hf5mephARag2cYXyhH70ggZmeppog59sZXnvebBuTfZidl5ogeRsYT3vebjvlPlvb146etNrYkHmQYS6UcM6QV85UaQAOUG5RoK8U8c6P2k9Sak7MEm1PsH1h5==/kisspng-ceiling-fans-monte-carlo-maverick-efficient-energy-6-quot-maverick-ceiling-fan-circa-lighting-5babb1c1331399.4925916615379788172092.png',
                        //   )
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                            width: width / 3,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

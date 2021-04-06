import 'package:flutter/material.dart';

import 'package:ee_fyp/modal/device.dart';
import 'package:ee_fyp/modal/payload.dart';
import 'package:ee_fyp/providers/payload_provider.dart';

class DisplayPayload extends StatefulWidget {
  const DisplayPayload({
    Key key,
    @required this.payloadsData,
    @required this.nameController,
    @required Payload payloadData,
    @required Device deviceData,
    @required Function addPayload,
  })  : _payloadData = payloadData,
        _deviceData = deviceData,
        _addPayload = addPayload,
        super(key: key);

  final Payloads payloadsData;
  final TextEditingController nameController;
  final Payload _payloadData;
  final Device _deviceData;
  final Function(Payload) _addPayload;

  @override
  _DisplayPayloadState createState() => _DisplayPayloadState();
}

class _DisplayPayloadState extends State<DisplayPayload> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      itemCount: widget.payloadsData.count,
      itemBuilder: (BuildContext ctx, int i) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.payloadsData.payloads[i].hexVal),
              FlatButton(
                child: Text('Config'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(
                      context,
                      i,
                      widget.nameController,
                      widget._payloadData,
                      widget.payloadsData,
                      widget._deviceData,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext ctx, int i) => const Divider(),
    );
  }

  Widget _buildPopupDialog(
    BuildContext context,
    int index,
    TextEditingController nameController,
    Payload payload,
    Payloads listPayload,
    Device device,
  ) {
    return AlertDialog(
      title: const Text('Name the button'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'New button name',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 5.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            controller: nameController,
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            payload = Payload(
              name: nameController.text,
              hexVal: listPayload.payloads[index].hexVal,
              decodeType: listPayload.payloads[index].decodeType,
              frequency: listPayload.payloads[index].frequency,
              rawlen: listPayload.payloads[index].rawlen,
            );
            widget._addPayload(payload);

            nameController.text = '';
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

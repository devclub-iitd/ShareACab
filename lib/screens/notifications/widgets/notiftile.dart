import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/screens/notifications/services/notifservices.dart';
import 'package:intl/intl.dart';

class NotifTile extends StatefulWidget {
  final docId;
  final fromuid;
  final name;
  final createdAt;
  final response;
  final purpose;
  NotifTile(this.docId, this.fromuid, this.name, this.createdAt, this.response, this.purpose);
  @override
  _NotifTileState createState() => _NotifTileState();
}

class _NotifTileState extends State<NotifTile> {
  final NotifServices _notifServices = NotifServices();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key('${widget.docId}'),
      onDismissed: (direction) async {
        widget.response == null && widget.purpose == 'Request to Join' ? await _notifServices.removeNotif(widget.docId, widget.purpose, widget.fromuid, false) : await _notifServices.removeNotif(widget.docId, widget.purpose, widget.fromuid, true);
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        color: Theme.of(context).accentColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 0.15, color: Theme.of(context).accentColor),
        )),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            radius: 40,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                widget.name.substring(0, 1),
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poiret',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: widget.purpose == 'Request to Join' ? Text('${widget.name} requested to join your trip') : widget.purpose == 'joined the group' ? Text('${widget.name} joined your group') : widget.purpose == 'Request to Join Declined' ? Text('Your request to join the trip is declined') : widget.purpose == 'Your request is accepted' ? Text('Your request is accepted') : Text('${widget.name} left your group'),
          subtitle: widget.purpose == 'Request to Join'
              ? widget.response == null
                  ? Container(
                      child: Wrap(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              ProgressDialog pr;
                              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                              pr.style(
                                message: 'Accepting...',
                                backgroundColor: Theme.of(context).backgroundColor,
                                messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                              );
                              await pr.show();
                              await Future.delayed(Duration(seconds: 1));
                              try {
                                await _notifServices.responseToRequest(true, widget.docId);
                                await pr.hide();
                              } catch (e) {
                                await pr.hide();
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              try {
                                await _notifServices.responseToRequest(false, widget.docId);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Decline',
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                          )
                        ],
                      ),
                    )
                  : widget.response == true ? Text('You accepted the request') : Text('You declined the request')
              : null,
          trailing: Text(DateFormat.yMMMd().format(widget.createdAt.toDate())),
        ),
      ),
    );
  }
}

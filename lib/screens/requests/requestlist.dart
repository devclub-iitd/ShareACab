import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RequestDetails {
  @required
  final String name;
  @required
  final String finalDestination;
  @required
  final String id;
  @required
  final String destination;
  @required
  final DateTime startDate;
  @required
  final TimeOfDay startTime;
  @required
  final DateTime endDate;
  @required
  final TimeOfDay endTime;
  @required
  final String status;

  // Give status as Pending, Accepted and Declined.

  RequestDetails({this.name, this.id, this.destination, this.finalDestination, this.startDate, this.startTime, this.endDate, this.endTime, this.status});
}

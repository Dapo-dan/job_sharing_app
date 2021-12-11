import 'package:flutter/material.dart';

class JobDetails extends StatefulWidget {

  final String uploadedBy;
  final String jobId;

  const JobDetails({
    required this.uploadedBy,
    required this.jobId});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

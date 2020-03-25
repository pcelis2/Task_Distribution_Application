import 'package:flutter/cupertino.dart';
import 'job_card.dart';

class JobListDriver{
  List<Widget> _listOfJobs;
  JobListDriver()
  {
    _listOfJobs = new List<Widget>();
  }
  List<Widget> getListOfJobs()
  {
    return _listOfJobs;
  }
  void addARandomJob()
  {
    _listOfJobs.add(JobCard.getTestCase());
  }
}
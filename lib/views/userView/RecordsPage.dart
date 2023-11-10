import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:medrecs/views/userView/RecordsFilter.dart';

class RecordsPage extends StatefulWidget {
  final int userID;
  RecordsPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<RecordsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<RecordsPage> {
  patientInfoService collector = patientInfoService();
  Future<PatientInfo>? patientInfo;
  late List<iMedicalData> entries;
  List<bool> lastFilters = [true, true, true, true, true, true, true];
  List<String> filterNames = [
    "Surgery",
    "Access",
    "Injury",
    "Incident",
    "Drug",
    "Appointment",
    "Allergy"
  ];

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<bool> newFilters = [
      lastFilters[0],
      lastFilters[1],
      lastFilters[2],
      lastFilters[3],
      lastFilters[4],
      lastFilters[5],
      lastFilters[6]
    ];
    var recordsFilter = RecordsFilter(filters: newFilters);
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text("MEDICAL RECORDS",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false),
      body: Column(
        children: [
          Center(
              child: ExpansionTile(
            initiallyExpanded: false,
            backgroundColor: Color.fromRGBO(219, 219, 219, 1),
            title: const Text(
              "Filters",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[recordsFilter],
            onExpansionChanged: (value) {
              if (value == false) {
                if (lastFilters != recordsFilter.getCurrentFilters()) {
                  setState(() {
                    lastFilters = recordsFilter.getCurrentFilters();
                  });
                }
              }
            },
          )),
          FutureBuilder(
              future: blockAccessorService.getEntries(widget.userID,
                  blockAccessorService.searchFilter(lastFilters)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasData) {
                  entries = snapshot.data;
                  return Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (_, index) {
                        return Card(
                            color: Colors.blue,
                            elevation: 4,
                            child: ExpansionTile(
                                initiallyExpanded: false,
                                title: entries[index].getTitle(),
                                subtitle: entries[index].getSubtitle(),
                                leading: entries[index].getIcon(),
                                children: entries[index].createInfo()));
                      },
                    ),
                  ));
                } else {
                  return const Expanded(
                      child: Center(
                          child: Text("Unable to connect to the servers.")));
                }
              })
        ],
      ),
    );
  }
}

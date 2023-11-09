import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class RecordsPage extends StatefulWidget {
  final int userID;
  const RecordsPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<RecordsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<RecordsPage> {
  patientInfoService collector = patientInfoService();
  Future<PatientInfo>? patientInfo;
  late List<iMedicalData> entries;
  List<bool> filters = [true, true, true, true, true, true, true];
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
    return FutureBuilder(
        future: blockAccessorService.getEntries(
            widget.userID, blockAccessorService.searchFilter(filters)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            entries = snapshot.data;
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
                    backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
                    title: const Text(
                      "Filters",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      generateFilters(),
                    ],
                  )),
                  Expanded(
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
                  ))
                ],
              ),
            );
          } else {
            return const Center(
                child: Text("Unable to connect to the servers."));
          }
        });
  }

  ListView generateFilters() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        itemCount: filterNames.length,
        itemBuilder: ((context, index) {
          return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filterNames[index],
                      style: const TextStyle(color: Colors.blue),
                    ),
                    SizedBox(
                        height: 25,
                        child: Checkbox(
                            value: filters[index],
                            onChanged: (bool? newValue) {
                              setState(() {
                                filters[index] = !filters[index];
                              });
                            }))
                  ]));
        }));
  }
}

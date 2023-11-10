import 'package:flutter/material.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

// ignore: must_be_immutable
class RecordsFilter extends StatefulWidget {
  List<bool> filters;
  RecordsFilter({Key? key, required this.filters}) : super(key: key);
  @override
  State<RecordsFilter> createState() => _ProfilePageState();

  List<bool> getCurrentFilters() {
    return filters;
  }
}

class _ProfilePageState extends State<RecordsFilter> {
  patientInfoService collector = patientInfoService();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    List<bool> stateFilters = widget.filters;
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
                            value: stateFilters[index],
                            onChanged: (bool? newValue) {
                              setState(() {
                                stateFilters[index] = !stateFilters[index];
                              });
                              widget.filters = stateFilters;
                            }))
                  ]));
        }));
  }
}

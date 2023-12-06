import 'package:flutter/material.dart';

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
    ThemeData theme = Theme.of(context);
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
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filterNames[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                        height: 25,
                        child: Checkbox(
                            activeColor: theme.colorScheme.primary,
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

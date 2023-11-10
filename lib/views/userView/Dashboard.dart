import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class Dashboard extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const Dashboard({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  patientInfoService collector = patientInfoService();
  late List<iMedicalData> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            getHomeHeaders(),
            const SizedBox(
              height: 10,
            ),
            getHomeReminders()
          ],
        ),
      ),
    );
  }

  Padding getHomeHeaders() {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime now = DateTime.now();
    String date = "${now.day} ${months[now.month - 1]}, ${now.year}";
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${widget.userInfo.name}!",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(date,
                    style: TextStyle(
                      color: Colors.blue[200],
                    ))
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.medical_information,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_people_sharp,
              color: Colors.white,
            ),
            Text(
              "How do you feel?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]),
    );
  }

  Expanded getHomeReminders() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: Colors.grey[200],
        child: Center(
            child: FutureBuilder(
                future: blockAccessorService.getReminderEntries(widget.userID),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasData) {
                    return Column(
                      children:
                          buildReminders(snapshot.data as List<iReminderData>),
                    );
                  } else {
                    return const Expanded(
                        child: Center(
                      child: Text("Unable to connect to the servers."),
                    ));
                  }
                })),
      ),
    );
  }

  List<Widget> buildReminders(List<iReminderData> reminderData) {
    List<Widget> list = [];
    int count = 0;
    list.add(const Row(children: [
      Text(
        "Relevant Reminders",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Icon(Icons.notifications)
    ]));

    for (iReminderData tempData in reminderData) {
      if (count == 5) {
        return list;
      }
      list.add(const SizedBox(
        height: 15,
      ));
      list.add(Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: tempData.getReminderIcon(),
          title: tempData.getReminderTitle(),
          subtitle: tempData.getReminderSubtitle(),
        ),
      ));
      count++;
    }

    if (count < 5) {
      if (count < 4) {
        if (count == 0) {
          list.add(const SizedBox(
            height: 15,
          ));
          list.add(Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.notifications_off),
              title: Text("No available reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text("You seem to be in good shape!",
                  style: TextStyle(fontSize: 16)),
            ),
          ));
        }
        list.add(const SizedBox(
          height: 15,
        ));
        list.add(Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const ListTile(
            leading: Icon(Icons.info),
            title: Text(
                "Press the top-right buttom on your next visit to the doctor",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(
                "Use it to give Medical Staff access to your records.",
                style: TextStyle(fontSize: 16)),
          ),
        ));
      }
      list.add(const SizedBox(
        height: 15,
      ));
      list.add(Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const ListTile(
          leading: Icon(Icons.safety_check),
          title: Text("Do NOT share your passwords",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(
              "Keep your personal data safe!\nWe will NOT ask for your password",
              style: TextStyle(fontSize: 16)),
        ),
      ));
    }

    return list;
  }
}

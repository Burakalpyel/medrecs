import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:medrecs/views/userView/nfc_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final int userID;

  const Dashboard({Key? key, required this.userID})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<iMedicalData> entries;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            getHomeHeaders(userData.userInfo, theme),
            const SizedBox(
              height: 10,
            ),
            getHomeReminders(theme)
          ],
        ),
      ),
    );
  }

  Padding getHomeHeaders(PatientInfo userInfo, ThemeData theme) {
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
                  "Hi ${userInfo.name}!",
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(date,
                    style: TextStyle(
                      color: theme.colorScheme.primaryContainer,
                    ))
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NFCScreen(userID: widget.userID)
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: theme.colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.medical_information,
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_people_sharp,
              color: theme.colorScheme.onPrimary,
            ),
            Text(
              "How do you feel?",
              style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]),
    );
  }

  Expanded getHomeReminders(ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: theme.colorScheme.surfaceVariant,
        child: Center(
          child: FutureBuilder(
            future: blockAccessorService.getReminderEntries(widget.userID),
            builder: (BuildContext context, AsyncSnapshot<List<iReminderData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(), // This makes it scrollable
                  children: [
                    Column(
                      children: buildReminders(snapshot.data as List<iReminderData>),
                    ),
                  ],
                );
              } else {
                return const Text("Unable to connect to the servers.");
              }
            },
          ),
        ),
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

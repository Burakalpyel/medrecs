import 'package:flutter/material.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatefulWidget {
  final int userID;

  const AppointmentsPage(
      {Key? key, required this.userID})
      : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context); // Access the app's theme

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            getAppointmentsHeaders(theme),
            const SizedBox(
              height: 10,
            ),
            getAppointmentsList(theme)
          ],
        ),
      ),
    );
  }

  Padding getAppointmentsHeaders(ThemeData theme) {
    var userData = Provider.of<UserData>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: theme.colorScheme.onPrimary,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hi ${userData.userInfo.name}!",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Appointments",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Expanded getAppointmentsList(ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: theme.colorScheme.background,
        child: FutureBuilder(
          future: blockAccessorService.getDoctorsAppoitments(widget.userID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Container(
                color: theme.colorScheme.background,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                      appointmentData: snapshot.data[index] as iReminderData,
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("Unable to connect to the servers."),
              );
            }
          },
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final iReminderData appointmentData;

  const AppointmentCard({Key? key, required this.appointmentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context); // Access the app's theme

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        tileColor: theme.colorScheme.onPrimary,
        leading: appointmentData.getReminderIcon(),
        title: appointmentData.getReminderTitle(),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appointmentData.getReminderSubtitle(),
            appointmentData.getSubtitleForDoctor(),
            // Add more Text widgets for additional lines as needed
          ],
        ),
      ),
    );
  }
}

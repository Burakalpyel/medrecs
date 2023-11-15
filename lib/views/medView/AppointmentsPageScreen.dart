import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class AppointmentsPage extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const AppointmentsPage({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            getAppointmentsHeaders(),
            const SizedBox(
              height: 10,
            ),
            getAppointmentsList()
          ],
        ),
      ),
    );
  }

  Padding getAppointmentsHeaders() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  Text(
                    "Appointments",
                    style: TextStyle(
                      color: Colors.blue[200],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Expanded getAppointmentsList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: Colors.grey[200],
        child: FutureBuilder(
          future: blockAccessorService.getEntries(widget.userID, {
            "appointment": true,
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Container(
                color: Colors.grey[200], // Set the desired color here
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
              return Center(
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
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
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

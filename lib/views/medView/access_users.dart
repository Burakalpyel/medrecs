import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:medrecs/views/userView/RecordsPage.dart';

class AccessUsers extends StatefulWidget {
  final int userID;

  const AccessUsers({Key? key, required this.userID})
      : super(key: key);

  @override
  State<AccessUsers> createState() => _AccessUsersState();
}

class _AccessUsersState extends State<AccessUsers> {
  late Future<List<UserHasAccess>> users;

  @override
  void initState() {
    super.initState();
    users = blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Access Patient",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<UserHasAccess>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No users available.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserHasAccess user = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.person_2_rounded),
                  title: Text(user.userID.toString()),
                  onTap: () {
                    navigateToRecords(user.userID);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
  
  void navigateToRecords(int userID) async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordsPage(
          userID: userID,
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medrecs/views/medView/access_users.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../util/services/authenticationService.dart';

class MedNFCScreen extends StatefulWidget {
  final int userID;

  const MedNFCScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  State<MedNFCScreen> createState() => _MedNFCScreenState();
}

class _MedNFCScreenState extends State<MedNFCScreen> {
  late Future<String> nfcStateText;
  String nfcOperationStatus = '';
  late Completer<void> nfcCompleter;

  @override
  initState(){
    super.initState();
    nfcStateText = getNFCStateText();
    nfcCompleter = Completer<void>();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NFC",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<String>(
              future: nfcStateText,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  String nfcData = snapshot.data ?? '';
                  return Column(
                    children: [
                      Text(
                        "NFC State: $nfcData",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      if (nfcData == "Available")
                        ElevatedButton(
                          onPressed: () {
                            nfc();
                            nfcCompleter.future.then((_) {
                              print("Completed");
                            });
                          },
                          child: const Text(
                            "Receive Data",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      Text(
                        nfcOperationStatus,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text("or"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                navigateToEditProfile();
              },
              child: const Text(
                "Patients List",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getNFCStateText() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      return "Not available";
    }
    return "Available";
  }
  
  Future<void> nfc() async {
    try {
      setState(() {
        nfcOperationStatus = 'Loading...';
      });

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          debugPrint('NFC Tag Detected: ${tag.data}');
          print("Successful reading data via NFC: ${tag.data}");

          setState(() {
            nfcOperationStatus = 'Received successfully ${tag.data}';
          });
        },
      );
    } catch (e) {
      setState(() {
        nfcOperationStatus = 'Error: $e';
      });
    }
    NfcManager.instance.stopSession();
    nfcCompleter.complete();
  }
    
  void navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccessUsers(
          userID: widget.userID,
        ),
      ),
    );
  }

  Future<void> authenticate() async {
    bool isAuthenticated = await AuthenticationService().authenticate();
    if (!isAuthenticated) {
      // Handle case when authentication fails, you can show an error message or navigate back.
      Navigator.pop(context);
    }
  }
}

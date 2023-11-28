import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medrecs/views/medView/access_users.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
  void initState() {
    super.initState();
    nfcStateText = getNFCStateText();
    nfcCompleter = Completer<void>();
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
          NdefMessage? message = await Ndef.from(tag)?.read();
          if (message != null && message.records.isNotEmpty) {
            NdefRecord record = message.records[0];
            String extractedData = String.fromCharCodes(record.payload);
            setState(() {
              nfcOperationStatus = 'Received data via NFC: $extractedData';
            });
          } else {
            setState(() {
              nfcOperationStatus = 'No NDEF data found on the NFC tag.';
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        nfcOperationStatus = 'Error: $e';
      });
    }  finally {
      NfcManager.instance.stopSession();
      nfcCompleter.complete();
    }
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
}

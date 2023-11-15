import 'dart:async';

import 'package:flutter/material.dart';
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
                  String nfcData = snapshot.data ?? ''; // Store the value in a variable
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
                      const SizedBox(height: 20),
                      Text(
                        nfcOperationStatus,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the text representation of NFC state
  Future<String> getNFCStateText() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      return "Not available";
    }
    return "Available";
  }
  
  Future<void> nfc() async {
    try {
      // Set loading state
      setState(() {
        nfcOperationStatus = 'Loading...';
      });

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          debugPrint('NFC Tag Detected: ${tag.data}');
          print("Successful reading data via NFC: ${tag.data}");

          // Set success state
          setState(() {
            nfcOperationStatus = 'Received successfully ${tag.data}';
          });
        },
      );
    } catch (e) {
      // Set error state
      setState(() {
        nfcOperationStatus = 'Error: $e';
      });
    }
    NfcManager.instance.stopSession();
    nfcCompleter.complete();
  }
}

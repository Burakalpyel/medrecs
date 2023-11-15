import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCScreen extends StatefulWidget {
  final int userID;

  const NFCScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  late Future<String> nfcStateText;
  String nfcOperationStatus = '';
  late Completer<void> nfcCompleter;
  TextEditingController doctorIdController = TextEditingController(); 
  bool showTextField = false;

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
                            "Share Data",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      Text(
                        nfcOperationStatus,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
            const Text("or"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showTextField = true; // Set the state to show the text field
                });
              },
              child: const Text(
                "Doctor ID",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (showTextField)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 5.0),
                child: Column(
                  children: [
                    TextField(
                      controller: doctorIdController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor ID',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        print("Entered Doctor ID: ${doctorIdController.text}");
                      },
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )
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
          try {
            print("Tag detected");
            NdefMessage message = NdefMessage([NdefRecord.createText(widget.userID.toString())]);
            await Ndef.from(tag)?.write(message);

            // Set success state
            setState(() {
              nfcOperationStatus = 'Sent successfully';
            });
          } catch (e) {
            // Set error state
            setState(() {
              nfcOperationStatus = 'Error: $e';
            });
          }
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

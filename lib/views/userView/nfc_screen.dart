import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:medrecs/util/services/blockWriterService.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCScreen extends StatefulWidget {
  final int userID;

  const NFCScreen({Key? key, required this.userID}) : super(key: key);

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
                  String nfcData = snapshot.data ?? '';
                  return Column(
                    children: [
                      Text(
                        "NFC State: $nfcData",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                  showTextField = true;
                });
              },
              child: const Text(
                "Doctor ID",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (showTextField)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70.0, vertical: 5.0),
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
                        _sendDoctorID();
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

  void _sendDoctorID() async {
    String doctorID = doctorIdController.text;
    DateTime now = DateTime.now();
    UserHasAccess access = UserHasAccess(
        userID: widget.userID,
        userGrantedAccessID: int.parse(doctorID),
        date: "${now.day}/${now.month}/${now.year}");
    if (await _checkDoctorsID(doctorID)) {
      try {
        List<UserHasAccess> listAccesses = await blockAccessorService
            .getUsersDoctorHasAccessTo(int.parse(doctorID));
        bool hasAccess = false;
        for (UserHasAccess temp in listAccesses) {
          if (temp.userID == widget.userID) {
            hasAccess = true;
          }
        }
        if (!hasAccess) {
          await blockWriterService.write(widget.userID, access);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Successfuly gave access to doctor with ID $doctorID'),
          ));
          Navigator.pop(context);
        } else {
          _showDialog("Unnecessary Operation",
              "The given doctor already can already write to your records");
        }
      } catch (e) {
        _showDialog("Something went wrong", e.toString());
      }
    } else {
      _showDialog("Invalid Doctor ID",
          "That ID doesn't exist. That ID doesn't exist. Please try again");
    }
  }

  Future<bool> _checkDoctorsID(String doctorID) async {
    List<String> firebaseIDs = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('SocialSec');

    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where("MedTeam", isEqualTo: true).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        firebaseIDs.add(documentSnapshot.id);
      }
    } catch (e) {
      _showDialog("Something went wrong", 'Error: $e');
    }
    return firebaseIDs.contains(doctorID);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Something went wrong"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
          try {
            print("Tag detected");
            NdefMessage message =
                NdefMessage([NdefRecord.createText(widget.userID.toString())]);
            await Ndef.from(tag)?.write(message);

            setState(() {
              nfcOperationStatus = 'Sent successfully';
            });
          } catch (e) {
            setState(() {
              nfcOperationStatus = 'Error: $e';
            });
          }
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
}

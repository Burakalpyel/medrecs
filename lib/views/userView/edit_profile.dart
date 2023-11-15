import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final int userID;

  const EditProfile({Key? key, required this.userID})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Access UserData provider
    var userData = Provider.of<UserData>(context, listen: false);

    _nameController.text = userData.userInfo.name;
    _surnameController.text = userData.userInfo.surname;
    _birthdayController.text = userData.userInfo.birthday;
    _addressController.text = userData.userInfo.address;
    _phoneController.text = userData.userInfo.phone;
    _locationController.text = userData.userInfo.location;
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EDIT DETAILS",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold)
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height:10),
              TextFormField(
                controller: _nameController,
                decoration: myInputDecoration("Name"),
              ),
              const SizedBox(height:10),
              TextFormField(
                controller: _surnameController,
                decoration: myInputDecoration("Surname"),
              ),
              const SizedBox(height:10),
              TextFormField(
                controller: _birthdayController,
                decoration: myInputDecoration("Birth Date"),
              ),
              const SizedBox(height:10),
              TextFormField(
                controller: _addressController,
                decoration: myInputDecoration("Address"),
              ),
              const SizedBox(height:10),
              TextFormField(
                controller: _phoneController,
                decoration: myInputDecoration("Phone Number"),
              ),
              const SizedBox(height:10),
              TextFormField(
                controller: _locationController,
                decoration: myInputDecoration("Location"),
              ),
              const SizedBox(height:10),
              ElevatedButton(
                onPressed: updateData, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
  
  InputDecoration myInputDecoration(String labelText) {
    ThemeData theme = Theme.of(context);
    return InputDecoration(
      labelText: labelText,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(
        color: theme.colorScheme.primary, // Adjust the color here
      ),
    );
  }

  void updateData() async {
    var userData = Provider.of<UserData>(context, listen: false);

    String enteredName = _nameController.text;
    String enteredSurname = _surnameController.text;
    String enteredBirthday = _birthdayController.text;
    String enteredAddress = _addressController.text;
    String enteredPhone = _phoneController.text;
    String enteredLocation = _locationController.text;

    DocumentReference documentReference = FirebaseFirestore.instance.collection('SocialSec').doc(widget.userID.toString());

    try {
      // Update the data in firebase
      await documentReference.update({
        'Name': enteredName,
        'Surname': enteredSurname,
        'Birthday': enteredBirthday,
        'Address': enteredAddress,
        'Phone': enteredPhone,
        'Location': enteredLocation,
      });
      debugPrint("Data updated successfully");
    } catch (e) {
      debugPrint("Error updating data: $e");
      return;
    }

    PatientInfo userInfo = PatientInfo(
        name: enteredName,
        surname: enteredSurname,
        birthday: enteredBirthday,
        address: enteredAddress,
        phone: enteredPhone,
        location: enteredLocation,
        medteamstatus: userData.userInfo.medteamstatus,
        password: userData.userInfo.password,
    );

    Navigator.pop(context, userInfo);
  }
}
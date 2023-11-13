import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
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
  patientInfoService collector = patientInfoService();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT DETAILS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.blue[800],
      ),
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
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
    return InputDecoration(
      labelText: labelText,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
      ),
      labelStyle: const TextStyle(
        color: Colors.blue, // Adjust the color here
      ),
    );
  }

  void updateData() async {
    var userData = Provider.of<UserData>(context);

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
      print('Data updated successfully');
    } catch (e) {
      print('Error updating data: $e');
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
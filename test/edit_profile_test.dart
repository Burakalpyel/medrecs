// integration testing

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medrecs/configs/firebase_options.dart';

class TestRepository {
  final FirebaseFirestore firestore;
  TestRepository({required this.firestore});

  late final document = firestore.doc('SocialSec/300');

  Future<Map<String, dynamic>?> fetch() async {
    try {
      final snapshot = await document.get();
      return snapshot.data();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateData(Map<String, dynamic> newData) async {
    await document.update(newData);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  group('Test Firestore', () {
    late TestRepository testRepository;

    setUp(() {
      final firestore = FirebaseFirestore.instance;
      testRepository = TestRepository(firestore: firestore);
      setDummyFirestore(firestore);
    });

    test('Test update data', () async {
      await testRepository.updateData({
        'Name': 'UpdatedName',
        'Surname': 'UpdatedSurname',
        'Birthday': 'UpdatedBirthday',
        'Address': 'UpdatedAddress',
        'Phone': '987654321',
        'Location': 'UpdatedLocation',
      });

      final updatedResult = await testRepository.fetch();
      expect(updatedResult, isNotNull);

      expect(updatedResult?['Name'], 'UpdatedName');
      expect(updatedResult?['Surname'], 'UpdatedSurname');
      expect(updatedResult?['Birthday'], 'UpdatedBirthday');
      expect(updatedResult?['Address'], 'UpdatedAddress');
      expect(updatedResult?['Phone'], '987654321');
      expect(updatedResult?['Location'], 'UpdatedLocation');
    });
  });
}

void setDummyFirestore(FirebaseFirestore firestore) {
  firestore.collection('SocialSec').doc('300').set({
    'Name': 'NameTest',
    'Surname': 'SurnameTest',
    'Birthday': 'BirthdayTest',
    'Address': 'AddressTest',
    'Phone': '123456789',
    'Location': 'LocationTest',
  });
}

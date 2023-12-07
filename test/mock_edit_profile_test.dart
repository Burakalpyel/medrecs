import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class TestRepository {
  final FirebaseFirestore firestore;
  TestRepository({required this.firestore});

  late final document = firestore.doc('SocialSec/200');

  Future<Map<String, dynamic>?> fetch() async {
    try {
      final snapshot = await document.get();
      return snapshot.data();
    } catch (e) {
      return null; // Error occurred while fetching data
    }
  }

  Future<void> updateData(Map<String, dynamic> newData) async {
    await document.update(newData);
  }
}

void main() {
  group('Test Firestore', () {
    final firestore = FakeFirebaseFirestore();
    late TestRepository testRepository;

    setUp(
      () {
        testRepository = TestRepository(firestore: firestore);
        setDummyFirestore(firestore);
      },
    );

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

setDummyFirestore(FirebaseFirestore firestore) {
  firestore.collection('SocialSec').doc('200').set({
    'Name': 'NameTest',
    'Surname': 'SurnameTest',
    'Birthday': 'BirthdayTest',
    'Address': 'AddressTest',
    'Phone': '123456789',
    'Location': 'LocationTest',
  });
}

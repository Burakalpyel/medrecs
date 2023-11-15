import 'package:flutter/foundation.dart';
import 'package:medrecs/util/model/patientinfo.dart';

class UserData extends ChangeNotifier {
  PatientInfo _userInfo = PatientInfo(name: '', surname: '', birthday: '', address: '', location: '', phone: '', medteamstatus: false, password: '');

  PatientInfo get userInfo => _userInfo;

  void updateUserInfo(PatientInfo updatedUserInfo) {
    _userInfo = updatedUserInfo;
    notifyListeners();
  }
}

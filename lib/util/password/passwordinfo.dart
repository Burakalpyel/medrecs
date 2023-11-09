enum passwords{
  user,
  admin,
  doctor
}

extension PasswordExtention on passwords {
  int get name {
    switch (this) {
      case passwords.user:
        return 1234;
      case passwords.admin:
        return 1234;
      case passwords.doctor:
        return 1234;
    }
  }
}

bool checkIfPasswordValid(int pass) {
  if (pass == passwords.admin.name) {
    print('Admin password is correct.');
    return true;
  } else {
    print('Invalid password.');
    return false;
  }
}
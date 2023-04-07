import 'package:fluttertoast/fluttertoast.dart';

emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Email Required';
  } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return 'Email Invalid';
  } else {
    return '';
  }
}

extension FicListExtension<T> on List<T> {
  /// Maps each element of the list.
  /// The [map] function gets both the original [item] and its [index].
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }
}

bool checkPasswordvalidation({required String password, required String confirmPassword}) {
  if (password.trim() == "") {
    Fluttertoast.showToast(msg: "Password Required");
    return false;
  } else if (confirmPassword == "") {
    Fluttertoast.showToast(msg: "Confirm Password Required");
    return false;
  } else if (password.length < 6) {
    Fluttertoast.showToast(msg: "Password must be at least 6 characters");
    return false;
  } else if (password != confirmPassword) {
    Fluttertoast.showToast(msg: "Both password are not match");
    return false;
  } else {
    return true;
  }
}

emptyValidator(value, msg) {
  if (value == null || value.isEmpty) {
    return msg;
  } else {
    return "";
  }
}

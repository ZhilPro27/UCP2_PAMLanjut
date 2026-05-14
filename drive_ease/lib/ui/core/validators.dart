

class AppValidators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? email(String? value) {
    final req = requiredField(value, 'Email');
    if (req != null) return req;

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 3}) {
    final req = requiredField(value, 'Password');
    if (req != null) return req;

    if (value!.length < minLength) {
      return 'Password minimal $minLength karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final req = requiredField(value, 'Konfirmasi Password');
    if (req != null) return req;

    if (value != password) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  static String? price(String? value) {
    final req = requiredField(value, 'Harga');
    if (req != null) return req;

    final cleanValue = value!.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) return 'Harga tidak valid';
    
    final number = double.tryParse(cleanValue);
    if (number == null || number < 0) {
      return 'Harga tidak valid (harus >= 0)';
    }
    return null;
  }

  static String? licensePlate(String? value) {
    final req = requiredField(value, 'Nomor Polisi');
    if (req != null) return req;

    final regex = RegExp(r'^[A-Z]{1,2}\s?[0-9]{1,4}\s?([A-Z]{1,3})?$');
    if (!regex.hasMatch(value!.toUpperCase())) {
      return 'Format nomor polisi tidak valid';
    }
    return null;
  }
}

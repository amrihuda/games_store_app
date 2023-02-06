import 'package:http/http.dart' as http;
import 'dart:convert';

userLogin(form) {
  return http.post(Uri.parse('http://localhost:3000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(form));
}

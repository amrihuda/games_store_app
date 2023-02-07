import 'package:http/http.dart' as http;
import 'dart:convert';

userRegister(form) {
  return http.post(Uri.parse('http://localhost:3000/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(form));
}

userLogin(form) {
  return http.post(Uri.parse('http://localhost:3000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(form));
}

getGenres() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/genres'));
  return jsonDecode(response.body);
}

getGames() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/games'));
  return jsonDecode(response.body);
}

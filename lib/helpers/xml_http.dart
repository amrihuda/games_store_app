import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('games_store_app');

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

getProfile() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/users/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    },
  );
  return jsonDecode(response.body);
}

userUpdate(form) async {
  var uri = Uri.parse('http://localhost:3000/api/users/user/update');
  var request = http.MultipartRequest('PUT', uri)
    ..headers.addAll(<String, String>{
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    })
    ..fields['username'] = form['username']
    ..fields['email'] = form['email']
    ..fields['password'] = form['password']
    ..fields['age'] = form['age'];
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  return response;
}

getGenres() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/genres'),
  );
  return jsonDecode(response.body);
}

getGames() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/games'),
  );
  return jsonDecode(response.body);
}

getGame(id) async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/games/game/$id'),
  );
  return jsonDecode(response.body);
}

addCart(gameId) {
  return http.post(Uri.parse('http://localhost:3000/api/carts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_token': jsonDecode(storage.getItem('user'))['user_token'],
      },
      body: jsonEncode(gameId));
}

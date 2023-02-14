import 'package:flutter/material.dart';
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
    ..fields['password'] = form['password'].toString()
    ..fields['age'] = form['age'].toString();
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

getGenre(id) async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/genres/genre/$id'),
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
  return http.post(Uri.parse('http://localhost:3000/api/carts/cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_token': jsonDecode(storage.getItem('user'))['user_token'],
      },
      body: jsonEncode({'gameId': gameId}));
}

getCart() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/carts/cart'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    },
  );
  return jsonDecode(response.body);
}

deleteAllCart() {
  return http.delete(
    Uri.parse('http://localhost:3000/api/carts/cart/delete-all'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    },
  );
}

addTransaction(form) {
  return http.post(
      Uri.parse('http://localhost:3000/api/transactions/transaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_token': jsonDecode(storage.getItem('user'))['user_token'],
      },
      body: jsonEncode(form));
}

getTransactions() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/transactions/transaction'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    },
  );
  return jsonDecode(response.body);
}

getUserLibrary() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/libraries/library'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'user_token': jsonDecode(storage.getItem('user'))['user_token'],
    },
  );
  return jsonDecode(response.body);
}

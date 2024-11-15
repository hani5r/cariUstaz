import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: 10000, // 10 seconds timeout
    receiveTimeout: 10000,
  ));

  // Method to get token
  Future<String?> getToken(String email, String password) async {
    try {
      var response = await _dio.post(
        'http://10.0.2.2:8000/api/login', // Adjust IP for Android emulator or real device
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != '') {
        // Store token in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token',
            response.data['token']); // Assuming the token is in 'token' field

        // Return the token
        return response.data['token'];
      } else {
        // Handle unsuccessful response
        return null;
      }
    } catch (error) {
      if (error is DioError) {
        return error.response != null ? error.response!.data : error.message;
      } else {
        return error.toString();
      }
    }
  }

  // Method to get user data
  Future<dynamic> getUser(String token) async {
    try {
      var user = await _dio.get(
        'http://10.0.2.2:8000/api/user', // Adjust for your API URL
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data); // Return user data
      }
    } catch (error) {
      if (error is DioError) {
        return error.response != null ? error.response!.data : error.message;
      } else {
        return error.toString();
      }
    }
  }

  // Method to register new user
  Future<bool> registerUser(
      String username, String email, String password) async {
    try {
      var user = await _dio.post(
        'http://10.0.2.2:8000/api/register',
        data: {'name': username, 'email': email, 'password': password},
      );

      print('Status Code: ${user.statusCode}');
      print('Response Data: ${user.data}');

      if (user.statusCode == 201) {
        return true;
      } else {
        print('Unexpected status code: ${user.statusCode}');
        return false;
      }
    } catch (error) {
      if (error is DioError) {
        // Log the complete error response to debug further
        print('DioError: ${error.response?.data ?? error.message}');
      } else {
        print('Error: $error');
      }
      return false;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post(
        'http://10.0.2.2:8000/api/book',
        data: {
          'date': date,
          'day': day,
          'time': time,
          'doctor_id': doctor,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Add this for consistency
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode; // Return success status
      } else {
        print('Failed: ${response.data}');
        return 'Error: ${response.statusCode}'; // Return more details on error
      }
    } catch (error) {
      print('Error making appointment: $error'); // Log the error
      return 'Failed to book appointment'; // Return meaningful error message
    }
  }
}

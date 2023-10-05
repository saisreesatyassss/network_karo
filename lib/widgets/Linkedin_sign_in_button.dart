import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LinkedInLoginScreen extends StatefulWidget {
  @override
  _LinkedInLoginScreenState createState() => _LinkedInLoginScreenState();
}

class _LinkedInLoginScreenState extends State<LinkedInLoginScreen> {
  final String clientId = '86onjaijzdbiwm';
  final String clientSecret = '4Z21KhqttFA157Jp';
  final String redirectUri = 'https://www.linkedin.com/company/network-karo/';
  final String scope = 'r_liteprofile r_emailaddress openid';

  String? accessToken;
  Map<String, dynamic>? userData;

  Future<void> _getAccessToken(String code) async {
    final tokenUrl = Uri.parse('https://www.linkedin.com/oauth/v2/accessToken');
    final response = await http.post(
      tokenUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      accessToken = data['access_token'];
      _fetchUserProfile();
    } else {
      // Handle error
      print('Error getting access token: ${response.statusCode}');
    }
  }

  Future<void> _fetchUserProfile() async {
    final profileUrl = Uri.parse('https://api.linkedin.com/v2/me');
    final response = await http.get(
      profileUrl,
      headers: {'Authorization': 'Bearer AQUPTxOi_kUasZHuDGIE8MVAWxiGWbqW2HQhS0bCB46wCf-90mmZkCkp33erV1z_l9JiAiCrcNetPDUsKqn6ofiIjCkHECYWhIutWSOu5CocmGHs7AoygYocpqqq3RVyh941nW1qNNwujNqyv4MU3-FwgOhBzNdPTavmFaNuDpPSOXMevLXDJp90JWhBg-tzMY0C554N_KGnGdqaECRpyOjaFaCepzSrbXUlayG_YQi3gtyvui_YdfjZR4Zc2VzVmhkuNISeCvhJ-x_z8NLlxE1l41ymOq8dIby9np21LTwQXRAYb81eY73JQMNweDZc07MnlqYsE5d2OV4i2-Ic6XPL_CEQ2w'},
    );

    if (response.statusCode == 200) {
      userData = json.decode(response.body);
      // Handle user data here
      print('User ID: ${userData?['id']}');
      print('First Name: ${userData?['localizedFirstName']}');
      print('Last Name: ${userData?['localizedLastName']}');
      // Add your logic to navigate to the next screen or perform other actions.
    } else {
      // Handle error
      print('Error fetching user profile: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LinkedIn Login Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Redirect the user to LinkedIn for authentication
            final authUrl =
                'https://www.linkedin.com/oauth/v2/authorization?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=$scope';
            // Replace this with your preferred method of opening URLs
            // (e.g., the url_launcher package).
            // For testing, you can manually open this URL in a web browser.
          },
          child: Text('Login with LinkedIn'),
        ),
      ),
    );
  }
}

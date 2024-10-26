import 'dart:convert';
import 'package:blockchain_upi/models/get_home_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpApiCalls {
  Future<String> getApiLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String apiLink = prefs.getString("ip_address") ?? "";
    return "http://10.1.210.255:5000";
  }

  Future<Map<String, dynamic>> transaction(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();

    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/transaction'));
    request.fields.addAll({
      "acc1": data['acc1'],
      'acc2': data['acc2'],
      "p1": data['p1'],
      "eth": data['eth'],
      "tx_name": data['tx_name'],
      "date": data['date'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);

      final response = json.decode(responsedata.body) as Map<String, dynamic>;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(data['acc1']);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          int currentCount = userData[response['analysis']] ?? 0;
          transaction.update(userRef, {response['analysis']: currentCount + 1});
        }
      });
      return response;
    } else {
      print("error in transaction");
      print(response.reasonPhrase);
      return {};
    }
  }

  Future<Map<String, dynamic>> makeAccount(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/make_account'));
    request.fields.addAll({
      "pri_key": data['pri_key'],
      'name': data['name'],
      "image": data['image'],
      'date': data['date']
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);
      return json.decode(responsedata.body) as Map<String, dynamic>;
    } else {
      print(response.reasonPhrase);
      print("eegegegeg");
      return {};
    }
  }

  Future<HomeModel?> getHomeData(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$apiUrl/get_all_transactions'));
    request.fields.addAll({
      "address": data['address'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      // print(responsedata.body);
      return HomeModelFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<HomeModel?> getTransactions() async {
    String apiUrl = await getApiLink();
    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/get_transactions'));

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      // print(responsedata.body);
      return HomeModelFromJson(responsedata.body);
    } else {
      print("Herererer");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<Map<String, dynamic>> getUserDetails(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/user_details'));
    request.fields.addAll({
      "address": data['address'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);
      return json.decode(responsedata.body) as Map<String, dynamic>;
    } else {
      print(response.reasonPhrase);
      print("eegegegeg");
      return {};
    }
  }

  Future<dynamic> getBitcoin() async {
    try {
      print("Called function");

      var response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'),
        headers: {
          'x-cg-demo-api-key': 'CG-eiZFMa9jMAv61gfBwLH1fNiW',
        },
      );

      if (response.statusCode == 200) {
        // print("Inside api call");
        // print(response.body);
        return (response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return {};
      }
    } catch (error) {
      print('Error sending request: $error');
      return {};
    }
  }

  Future<bool> aadhaarVerification(String uid) async {
    try {
      dynamic body = {
        'txn_id': '17c6fa41-778f-49c1-a80a-cfaf7fae2fb8',
        'consent': 'Y',
        'uidnumber': uid,
        'clientid': '222',
        'method': 'uidvalidatev2',
      };

      var response = await http.post(
        Uri.parse(
            'https://verifyaadhaarnumber.p.rapidapi.com/Uidverifywebsvcv1/VerifyAadhaarNumber'),
        headers: {
          'content-type': 'application/x-www-form-urlencoded',
          'X-RapidAPI-Key':
              'af3c052c2bmsh68eed52c9c52bd5p1bc597jsnb3e78f4decd1',
          'X-RapidAPI-Host': 'verifyaadhaarnumber.p.rapidapi.com',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        if (responseData['Succeeded'] != null &&
            responseData['Succeeded']['Verify_status'] == 'Uid is Valid') {
          return true;
        } else {
          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending request: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> buyCoin(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/buy_coin'));
    request.fields.addAll({
      "acc1": data['acc1'],
      "p1": data['p1'],
      "price": data['price'],
      "tx_name": data['tx_name'],
      "date": data['date'],
      'coin_name': data['coin_name']
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);

      final response = json.decode(responsedata.body) as Map<String, dynamic>;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(data['acc1']);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          int currentCount = userData[response['analysis']] ?? 0;
          transaction.update(userRef, {response['analysis']: currentCount + 1});
        }
      });
      return response;
    } else {
      print("error in transaction");
      print(response.reasonPhrase);
      return {};
    }
  }

  Future<Map<String, dynamic>> getPortfolioDetails(String address) async {
    String apiUrl = await getApiLink();
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/analyze_investment'));
    request.fields['address'] = address;

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);
      print(json.decode(responsedata.body));

      final response = json.decode(responsedata.body) as Map<String, dynamic>;
      return response;
    } else {
      print("error in getting data");
      return {};
    }
  }

  Future<dynamic> getTopLosers() async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=price_change_percentage_24h_asc&per_page=10&page=1',
        ),
        headers: {
          'accept': 'application/json',
          'x-cg-demo-api-key': 'CG-eiZFMa9jMAv61gfBwLH1fNiW', // Replace with your actual API key
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Decode response here
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error sending request: $error');
      return [];
    }
  }

  Future<dynamic> getTopGainers() async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=price_change_percentage_24h_desc&per_page=10&page=1',
        ),
        headers: {
          'accept': 'application/json',
          'x-cg-demo-api-key': 'CG-eiZFMa9jMAv61gfBwLH1fNiW',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error sending request: $error');
      return [];
    }
  }
}

import 'package:dio/dio.dart';
import 'package:paymob/constant.dart';
import 'package:paymob/paymob_service/payment_apis.dart';

class PaymobService {
  Future<String> getPaymentKey(int amount, String currency) async {
    try {
      // use api to get token
      String authenticationToken = await _authenticationToken();
      // use api to get order id
      int orderId = await _getOrderId(
          authenticationToken: authenticationToken,
          amount: (amount * 100).toString(),
          currency: currency);
      // use api to get payment key
      String paymentKey = await _getPaymentKey(
          authenticationToken: authenticationToken,
          orderId: orderId.toString(),
          amount: (amount * 100).toString(),
          currency: currency);

      return paymentKey;
    } catch (e) {
      throw Exception();
    }
  }

  // this function will return the authentication token to use it in the next function
  //in this function take paymentKey and reterun token
  Future<String> _authenticationToken() async {
    final Response response = await Dio().post(PaymentApis.authTokenUrl, data: {
      "api_key": PaymentConstants.apikey,
    });
    return response.data["token"];
  }

  // in this function i will pass the token and amount to make order and return the order id
  Future<int> _getOrderId(
      {required String authenticationToken,
      required String amount,
      required String currency}) async {
    final Response response = await Dio().post(PaymentApis.orderIdUrl, data: {
      'auth_token': authenticationToken,
      "amount_cents": amount,
      'currency': currency,
      'delivery_needed': "false",
      'items': []
    });
    return response.data["id"];
  }

  //in this function i will get payment token to pay
  Future<String> _getPaymentKey({
    required String authenticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response =
        await Dio().post(PaymentApis.paymentKeyUrl, data: {
      //ALL OF THEM ARE REQIERD
      "expiration": 3600, // number of seconds with valid to use

      "auth_token": authenticationToken, //From First Api
      "order_id": orderId, //From Second Api (STRING)
      "integration_id":
          PaymentConstants.integrationId, //Integration Id Of The Payment Method

      "amount_cents": amount,
      "currency": currency,

      "billing_data": {
        //must be filled Values
        "first_name": "Clifford",
        "last_name": "Nicolas",
        "email": "claudette09@exa.com",
        "phone_number": "+86(8)9135210487",

        //Can Set "NA"
        "apartment": "NA",
        "floor": "NA",
        "street": "NA",
        "building": "NA",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "state": "NA"
      },
    });
    return response.data["token"];
  }
}

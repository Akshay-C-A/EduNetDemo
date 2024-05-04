import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_TVioNvOp7yQ2wA',
      'amount': amount,
      'name': 'Geeks',
      'order_id': 'hska5s766sdahdkka',
      'description': 'Edunet Event',
      'prefill': {'contact': '1234567890', 'email': 'himynameiskennithjoseph@gmail.com'},
      // 'external': {
      //   'wallets': []
      // }
      // "options": {
      //   "checkout": {
      //     "method": {
      //       //here you have to specify
      //       "netbanking": "1",
      //       "card": "1",
      //       "upi": "1",
      //       "wallet": "0"
      //     }
      //   }
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Success${response.paymentId!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Failed${response.message!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet${response.walletName!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.network(
              'https://media.geeksforgeeks.org/gfg-gg-logo.svg',
              height: 100,
              width: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome to RazorPay Payment Gateway Inteegration',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(fontSize: 15, color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1)),
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Amount to be paid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (amtController.text.toString().isNotEmpty) {
                  setState(() {
                    int amount = int.parse(amtController.text.toString());
                    openCheckout(amount);
                  });
                }
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Make Payment'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

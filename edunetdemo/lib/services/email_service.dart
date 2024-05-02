import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  Future sendEmail({
    required String studentName,
    required String studentEmail,
    required String eventTitle,
    required String communityMail,
    required String communityName,
  }) async {
    // final String subject = ,
    // required String message,
    final serviceId = 'service_xzougrq';
    final templateId = 'template_zqgdi4m';
    final userId = 'FGJFphxyAq4i7_WV-';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'studentName': studentName,
          'studentEmail': studentEmail,
          'eventTitle': eventTitle,
          'communityMail': communityMail,
          'communityName': communityName,
        }
      }),
    );

    print(response.body);
  }
}

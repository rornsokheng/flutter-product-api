import 'package:basic_flutter/model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String TELEGRAM_BOT_TOKEN =
    '8420874385:AAG89KOYSxNNtLQCqrT3Uwtc3U6IxKhikoQ';
const String TELEGRAM_CHAT_ID = '1084261917';

class TelegramService {
  static Future<bool> sendOrderToTelegram({
    required String name,
    required String email,
    required String address,
    required String city,
    required String zip,
    required List<CartItem> items,
    required double total,
  }) async {
    try {
      String message = '🛍️ *NEW ORDER RECEIVED*\n\n';
      message += '👤 *Customer Information:*\n';
      message += 'Name: $name\n';
      message += 'Email: $email\n';
      message += 'Address: $address\n';
      message += 'City: $city\n';
      message += 'ZIP: $zip\n\n';
      message += '📦 *Order Details:*\n';

      for (var item in items) {
        message += '• ${item.product.title}\n';
        message +=
            '  Qty: ${item.quantity} x \$${item.product.price.toStringAsFixed(2)} = \$${(item.product.price * item.quantity).toStringAsFixed(2)}\n\n';
      }

      message += '💰 *Total: \$${total.toStringAsFixed(2)}*\n';
      message += '\n📅 ${DateTime.now().toString().split('.')[0]}';

      final url = Uri.parse(
        'https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': TELEGRAM_CHAT_ID,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending to Telegram: $e');
      return false;
    }
  }
}

import 'package:equatable/equatable.dart';

/// Ответ сервера на перевод
class TransferResult extends Equatable {
  final String message;
  final int senderNewBalance; // в копейках

  const TransferResult({required this.message, required this.senderNewBalance});

  factory TransferResult.fromJson(Map<String, dynamic> json) {
    return TransferResult(message: json['message']?.toString() ?? '', senderNewBalance: (json['senderNewBalance'] as num).toInt());
  }

  @override
  List<Object?> get props => [message, senderNewBalance];
}

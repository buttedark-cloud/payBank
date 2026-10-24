import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../blocs/bank/bank_bloc.dart';

void showTransferModal({
  required BuildContext context,
  required String senderCard,
  required double currentBalance,
  required bool isDarkMode,
  required Function(double amount, String recipient) onTransferSuccess,
}) {
  final recipientController = TextEditingController();
  final amountController = TextEditingController();

  final cardMask = MaskTextInputFormatter(mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDarkMode ? const Color(0xFF161B22) : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (modalContext) {
      String? inlineError;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Перевод средств',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (inlineError != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Text(
                      inlineError!,
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const Text('Карта получателя', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: recipientController,
                  inputFormatters: [cardMask],
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '4400-9999-8888-7777',
                    hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF0D1117) : Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Сумма перевода (мин. 100 ₽)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '100',
                    hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF0D1117) : Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final recipient = recipientController.text.trim();
                      final amount = double.tryParse(amountController.text) ?? 0;

                      if (recipient.isEmpty || recipient.length < 19) {
                        setModalState(() {
                          inlineError = 'Введите полный номер карты получателя!';
                        });
                        return;
                      }

                      if (amount < 100) {
                        setModalState(() {
                          inlineError = 'Минимальная сумма перевода — 100 ₽!';
                        });
                        return;
                      }

                      if (amount > currentBalance) {
                        setModalState(() {
                          inlineError = 'Недостаточно средств на балансе!';
                        });
                        return;
                      }

                      onTransferSuccess(amount, recipient);

                      context.read<BankBloc>().add(
                        TransferMoneyEvent(senderCardNumber: senderCard, recipientCardNumber: recipient, amount: amount),
                      );

                      Navigator.pop(modalContext);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Перевод успешно выполнен!'), backgroundColor: Colors.green));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Перевести', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

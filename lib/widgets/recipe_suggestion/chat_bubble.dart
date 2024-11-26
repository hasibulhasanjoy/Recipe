import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isTyping;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(12.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isTyping
              ? Colors.grey[300]
              : (isUser ? Colors.white : const Color(0xFF368136)),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: isTyping
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 8.0,
                    height: 8.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF8BD08D),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Typing...",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.black : Colors.white,
                  fontSize: 16.0,
                ),
              ),
      ),
    );
  }
}

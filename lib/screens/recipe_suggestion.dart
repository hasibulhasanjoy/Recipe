import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe/widgets/recipe_suggestion/chat_bubble.dart';
import 'package:recipe/widgets/recipe_suggestion/message_input.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecipeSuggestionScreen extends StatefulWidget {
  const RecipeSuggestionScreen({super.key});

  @override
  RecipeSuggestionScreenState createState() => RecipeSuggestionScreenState();
}

class RecipeSuggestionScreenState extends State<RecipeSuggestionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = []; // Stores messages as user/ai
  late GenerativeModel _model;
  bool _isTyping = false; // Tracks if AI is typing

  @override
  void initState() {
    super.initState();
    // Initialize the Gemini API model
    String apiKey = dotenv.env['gemini_api_key'] ?? '';

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    // Add user message to the list
    setState(() {
      _messages.add({'sender': 'user', 'text': _messageController.text.trim()});
      _isTyping = true; // Start typing indicator
    });

    // Clear input field
    final prompt = _messageController.text.trim();
    _messageController.clear();

    // Call the Gemini API
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      setState(() {
        _messages.add(
            {'sender': 'ai', 'text': response.text ?? 'No response from AI'});
      });
    } catch (error) {
      setState(() {
        _messages.add({
          'sender': 'ai',
          'text': 'Error: Unable to fetch a response. Try again.'
        });
      });
    } finally {
      setState(() {
        _isTyping = false; // Stop typing indicator
      });
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear(); // Clear all messages
      _isTyping = false; // Ensure typing indicator is off
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF48B04C), // Primary color
        title: const Text(
          'Generate Recipe',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChat, // Reset button functionality
            tooltip: 'Reset Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // Check if this is the typing indicator
                if (_isTyping && index == 0) {
                  return const ChatBubble(
                    text: 'Typing...',
                    isUser: false, // AI message
                    isTyping: true, // Special flag for typing
                  );
                }

                // Normal messages
                final message = _messages[
                    _messages.length - 1 - (index - (_isTyping ? 1 : 0))];
                final isUser = message['sender'] == 'user';

                return ChatBubble(
                  text: message['text'] ?? '',
                  isUser: isUser,
                );
              },
            ),
          ),
          // Input Area
          MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

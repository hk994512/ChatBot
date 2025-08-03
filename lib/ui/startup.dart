import 'package:chat_bubbles/chat_bubbles.dart';
import '/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../helpers/ui_helpers.dart';
import '../requests/api_request.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> _chatMessages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _chatMessages.add({'text': message, 'isUser': true});
      _isTyping = true;
    });
    _scrollToBottom();

    final response = await getChatbotResponse(message);

    setState(() {
      _isTyping = false;
      if (response != null && response.isNotEmpty) {
        _chatMessages.add({'text': response, 'isUser': false});
      } else {
        _chatMessages.add({
          'text': '⚠️ No response received from the bot.',
          'isUser': false,
        });
      }
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.deepPurple),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIHelpers.text(
                    'Instant Bot',
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  8.wt,
                  Icon(Icons.smart_toy, color: AppColors.white),
                ],
              ),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.home, color: AppColors.green),
              title: UIHelpers.text(
                'Home',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.refresh, color: AppColors.teal),
              title: UIHelpers.text('New Chat', fontSize: 16),
              onTap: () {
                setState(() {
                  _chatMessages.clear();
                  _isTyping = false;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.red),
              title: UIHelpers.text('Clear Chat', fontSize: 16),
              onTap: () {
                setState(() {
                  _chatMessages.clear();
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: AppColors.deepPurple),
              title: UIHelpers.text('Exit App', fontSize: 16),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 200), () {
                  SystemNavigator.pop();
                });
              },
            ),
            const Divider(),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: UIHelpers.text(
                  'Select Theme Mode',
                  color: AppColors.grey600,
                ),
              ),
            ),
            SwitchListTile(
              title: UIHelpers.text(
                'Dark Mode',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),

      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        title: UIHelpers.text(
          'Instant Bot',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: _chatMessages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _chatMessages.length && _isTyping) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        10.wt,
                        CircularProgressIndicator(strokeWidth: 2),
                        10.wt,

                        UIHelpers.text(
                          "Typing...",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  );
                }
                final msg = _chatMessages[index];
                return BubbleSpecialThree(
                  text: msg['text'],
                  isSender: msg['isUser'],
                  color: msg['isUser'] ? AppColors.deepPurple : AppColors.white,
                  tail: true,
                  textStyle: TextStyle(
                    color: msg['isUser'] ? AppColors.white : AppColors.black,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
          MessageBar(
            sendButtonColor: AppColors.deepPurple,
            onSend: _handleSend,
            actions: [
              InkWell(
                child: Icon(Icons.add, color: AppColors.black, size: 24),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

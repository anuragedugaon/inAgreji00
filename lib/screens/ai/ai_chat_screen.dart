

import 'package:flutter/material.dart';
import '../ai_teacher/ai_service.dart';
import 'voice_chat_screen.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AIService ai = AIService();
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isThinking = false;
  bool isListening = false;

  final ChatSession chatSession = ChatSession();

  // 🔽 Auto scroll
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ✉️ Send text
  Future<void> sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatSession.messages.add({"text": text, "isUser": true});
      isThinking = true;
    });

    _msgController.clear();
    _scrollToBottom();

    final aiReply = await ai.getAnswer(text);

    setState(() {
      chatSession.messages.add({"text": aiReply, "isUser": false});
      isThinking = false;
    });

    _scrollToBottom();
    ai.speakText(aiReply);
  }

  // // 🎤 Voice input
  // Future<void> startListening() async {
  //   setState(() => isListening = true);

  //   final text = await ai.listenVoice();

  //   setState(() => isListening = false);

  //   if (text.trim().isNotEmpty) {
  //     processVoice(text);
  //   }
  // }

  Future<void> processVoice(String text) async {
    setState(() {
      chatSession.messages.add({"text": text, "isUser": true});
      isThinking = true;
    });

    _scrollToBottom();

    final aiReply = await ai.getAnswer(text);

    setState(() {
      chatSession.messages.add({"text": aiReply, "isUser": false});
      isThinking = false;
    });

    _scrollToBottom();
    ai.speakText(aiReply);
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color bubbleColor = Color(0xFF1C1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios, color: accentColor),
                  ),
                  const Spacer(),
                  const Text(
                    "Ask me anything",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // 🤖 AVATAR
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bubbleColor,
                border: Border.all(color: accentColor, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/ai.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("SIA", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),

            // 💬 CHAT LIST
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                    chatSession.messages.length + (isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatSession.messages.length &&
                      isThinking) {
                    return _typingIndicator();
                  }

                  final msg = chatSession.messages[index];
                  final bool isUser = msg["isUser"];

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: accentColor, width: 1.2),
                      ),
                      child: Text(
                        msg["text"],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 📝 INPUT BAR
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: accentColor, width: 1.2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle:
                              TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => sendMessage(),
                      ),
                    ),
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send,
                          color: accentColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                 VoiceChatScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.mic,
                          color: accentColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⏳ Typing indicator
  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: const Text(
          "SIA is typing...",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}




// 💾 Chat session model
class ChatSession {
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Welcome, I’m Sia,\nYour AI teacher. Ask me anything.",
      "isUser": false,
    },
  ];
}


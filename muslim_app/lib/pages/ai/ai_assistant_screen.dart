import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../theme/colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': 'Assalamualaikum! Saya adalah AI Assistant Islami. Silakan tanyakan hal seputar Islam (Aqidah, Fiqih, Al-Qur\'an, dll).'}
  ];
  
  final List<String> _suggestedQuestions = [
    "Apa keutamaan shalat tahajud?",
    "Bagaimana cara mandi wajib?",
    "Doa agar dimudahkan rezeki",
    "Sejarah singkat Nabi Muhammad SAW"
  ];
  
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTts();
  }
  
  void _initTts() async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_controller.text.isNotEmpty) {
        _sendMessage();
      }
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Teks berhasil disalin"), duration: Duration(seconds: 1)),
    );
  }

  void _sendMessage([String? text]) {
    final query = text ?? _controller.text.trim();
    if (query.isEmpty) return;
    
    setState(() {
      _messages.add({'role': 'user', 'text': query});
      _isTyping = true;
    });

    _controller.clear();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          if (_isIslamicTopic(query.toLowerCase())) {
            _messages.add({
              'role': 'ai',
              'text': 'Ini adalah jawaban contoh dari MuslimMate AI. Silakan sambungkan dengan API seperti OpenAI atau Gemini untuk balasan dinamis terkait pertanyaan Anda.'
            });
          } else {
            _messages.add({
              'role': 'ai',
              'text': 'Maaf, saya adalah AI Assistant Islami dan hanya dapat membantu pertanyaan seputar Islam.'
            });
          }
        });
      }
    });
  }

  bool _isIslamicTopic(String query) {
    List<String> nonIslamic = ['politik', 'game', 'coding', 'teknologi', 'hiburan', 'film', 'musik', 'olahraga'];
    for (var topic in nonIslamic) {
      if (query.contains(topic)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Islamic Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Suggested Questions
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _suggestedQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_suggestedQuestions[index], style: const TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    side: const BorderSide(color: AppColors.primary, width: 0.5),
                    onPressed: () => _sendMessage(_suggestedQuestions[index]),
                  ),
                ).animate().fadeIn(delay: (200 + (index * 100)).ms).slideX(begin: 0.2, end: 0);
              },
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildChatBubble(msg['role']!, msg['text']!);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.psychology, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text('MuslimMate sedang mengetik...', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12)),
          ],
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1000.ms),
      ),
    );
  }

  Widget _buildChatBubble(String role, String text) {
    final isAi = role == 'ai';
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isAi ? Theme.of(context).colorScheme.surface : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isAi ? 0 : 20),
            bottomRight: Radius.circular(isAi ? 20 : 0),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAi) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.psychology, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('MuslimMate AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: isAi ? Theme.of(context).colorScheme.onSurface : Colors.white,
              ),
            ),
            if (isAi) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _copy(text),
                    child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.copy, size: 16, color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _speak(text),
                    child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.volume_up, size: 16, color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur bagikan segera hadir")));
                    },
                    child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.share, size: 16, color: Colors.grey)),
                  ),
                ],
              )
            ]
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: _isListening ? Colors.red : AppColors.primary),
            onPressed: _listen,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _isListening ? 'Mendengarkan...' : 'Tanyakan sesuatu...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(),
            ),
          )
        ],
      ),
    );
  }
}

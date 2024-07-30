import 'package:flutter/material.dart';
import 'package:seekhobuddy/chatsrc/constants/colors.dart';
import 'package:seekhobuddy/chatsrc/features/chat/components/message_tile.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Content> history = [];
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _loading = false;

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _fetchApiKey().then((key) {
      _apiKey = key;
      _model = GenerativeModel(
        model: 'gemini-pro', apiKey: _apiKey,
      );
      _chat = _model.startChat();
    });
  }

  Future<String> _fetchApiKey() async {
    DocumentSnapshot doc = await _firestore.collection('AIkey').doc('AI_KEY').get();
    return doc['api_key'];
  }

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: const Text(
        'Seekho-Buddy AI',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
    ),
    body: Stack(
      children: [
        history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text(
                      'Seekho apne buddy ke saath!',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/SplashLogo.png', // Replace with your logo asset
                      height: 150, // Adjust the height as desired
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 90),
                itemCount: history.reversed.length,
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, index){
                  var content = history.reversed.toList()[index];
                  var text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return MessageTile(
                    sendByMe: content.role == 'user',
                    message: text,
                  );
                },
                separatorBuilder: (context, index){
                  return const SizedBox(height: 15,);
                },
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  border: Border(top: BorderSide(color: Colors.black))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: TextField(
                        cursorColor: MyColors.primaryColor,
                        controller: _textController,
                        focusNode: _textFieldFocus,
                        decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true, fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        history.add(Content('user', [TextPart(_textController.text)]));
                      });
                      _sendChatMessage(_textController.text, history.length);
                    },
                    child: Container(
                      width: 50, height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(offset: const Offset(1,1), blurRadius: 3, spreadRadius: 3, color: Colors.black.withOpacity(0.05))
                          ]
                      ),
                      child: _loading
                          ? const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: CircularProgressIndicator.adaptive(
                                                    backgroundColor: Colors.black, ),
                          )
                          : const Icon(Icons.send_rounded, color: Colors.black,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message, int historyIndex) async {
    setState(() {
      _loading = true;
      _textController.clear();
      _textFieldFocus.unfocus();
      _scrollDown();
    });

    List<Part> parts = [];

    try {
      var response = _chat.sendMessageStream(
        Content.text(message),
      );
      await for(var item in response){
        var text = item.text;
        if (text == null) {
          _showError('No response from API.');
          return;
        } else {
          setState(() {
            _loading = false;
            parts.add(TextPart(text));
            if((history.length - 1) == historyIndex){
              history.removeAt(historyIndex);
            }
            history.insert(historyIndex, Content('model', parts));

          });
        }
      }


    } catch (e, t) {
      print(e);
      print(t);
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
  
}
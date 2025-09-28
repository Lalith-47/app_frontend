import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/message_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  
  const ChatScreen({
    super.key,
    required this.roomId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Text(
                'D',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Sarah Johnson',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // TODO: Implement voice call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _getMockMessages().length,
              itemBuilder: (context, index) {
                final message = _getMockMessages()[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isMe = message.senderId == 'current_user'; // This should come from auth state
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            if (!isMe) const SizedBox(height: 4),
            Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe 
                    ? Colors.white.withOpacity(0.7)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // TODO: Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                _sendMessage(_messageController.text.trim());
                _messageController.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    // TODO: Implement sending message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending: $text'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<MessageModel> _getMockMessages() {
    return [
      MessageModel(
        id: '1',
        senderId: 'mentor1',
        senderName: 'Dr. Sarah Johnson',
        receiverId: 'student1',
        receiverName: 'You',
        message: 'Hello! How are you doing with your studies?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      MessageModel(
        id: '2',
        senderId: 'student1',
        senderName: 'You',
        receiverId: 'mentor1',
        receiverName: 'Dr. Sarah Johnson',
        message: 'Hi Dr. Johnson! I\'m doing well, thank you for asking. I just completed the aptitude test.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      MessageModel(
        id: '3',
        senderId: 'mentor1',
        senderName: 'Dr. Sarah Johnson',
        receiverId: 'student1',
        receiverName: 'You',
        message: 'That\'s great! How did you find it? Any particular areas you\'d like to focus on?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'student1',
        senderName: 'You',
        receiverId: 'mentor1',
        receiverName: 'Dr. Sarah Johnson',
        message: 'I scored 85% overall. I think I need to work more on logical reasoning.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      MessageModel(
        id: '5',
        senderId: 'mentor1',
        senderName: 'Dr. Sarah Johnson',
        receiverId: 'student1',
        receiverName: 'You',
        message: 'Excellent score! I can help you with logical reasoning. Let\'s schedule a session this week.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
    ];
  }
}



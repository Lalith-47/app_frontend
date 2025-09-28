import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/message_model.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
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
      body: ListView.builder(
        itemCount: _getMockChatRooms().length,
        itemBuilder: (context, index) {
          final chatRoom = _getMockChatRooms()[index];
          return _buildChatRoomItem(chatRoom);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New chat feature coming soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChatRoomItem(ChatRoom chatRoom) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          chatRoom.name.isNotEmpty ? chatRoom.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        chatRoom.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        chatRoom.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chatRoom.lastMessageTime != null)
            Text(
              _formatTime(chatRoom.lastMessageTime!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (chatRoom.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chatRoom.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // TODO: Navigate to chat room
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening chat with ${chatRoom.name}'),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<ChatRoom> _getMockChatRooms() {
    return [
      ChatRoom(
        id: '1',
        name: 'Dr. Sarah Johnson',
        participants: ['mentor1', 'student1'],
        lastMessage: 'Great work on your latest quiz!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ChatRoom(
        id: '2',
        name: 'John Doe',
        participants: ['mentor1', 'student2'],
        lastMessage: 'Thank you for the guidance session',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChatRoom(
        id: '3',
        name: 'Jane Smith',
        participants: ['mentor1', 'student3'],
        lastMessage: 'I have a question about career paths',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
        unreadCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}



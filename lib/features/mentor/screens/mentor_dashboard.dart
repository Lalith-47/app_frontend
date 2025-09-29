import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../quiz/providers/quiz_provider.dart';
import '../../../core/services/mock_data_service.dart';

class MentorDashboard extends ConsumerStatefulWidget {
  const MentorDashboard({super.key});

  @override
  ConsumerState<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends ConsumerState<MentorDashboard> {
  int _selectedIndex = 0;
  final MockDataService _mockDataService = MockDataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      ref.read(quizProvider.notifier).loadMentorAnalytics(currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => context.go('/chat'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildStudentsTab(),
          _buildAnalyticsTab(),
          _buildSessionsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Sessions',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final currentUser = ref.watch(currentUserProvider);
    final analytics = ref.watch(quizAnalyticsProvider);
    final students = currentUser != null 
        ? _mockDataService.getStudentsByMentorId(currentUser.id)
        : <UserModel>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${currentUser?.name ?? 'Mentor'}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to guide your students today?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          if (analytics != null) ...[
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  title: 'Total Students',
                  value: '${analytics['totalStudents'] ?? 0}',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  title: 'Active Students',
                  value: '${analytics['activeStudents'] ?? 0}',
                  icon: Icons.schedule,
                  color: Colors.green,
                ),
                _buildStatCard(
                  title: 'Sessions',
                  value: '${analytics['totalSessions'] ?? 0}',
                  icon: Icons.message,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  title: 'Upcoming',
                  value: '${analytics['upcomingSessions'] ?? 0}',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
          ],
          
          const SizedBox(height: 24),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                icon: Icons.people,
                title: 'My Students',
                subtitle: 'View all students',
                onTap: () => context.go('/mentor/students'),
                color: Colors.blue,
              ),
              _buildActionCard(
                icon: Icons.analytics,
                title: 'Analytics',
                subtitle: 'View insights',
                onTap: () => context.go('/mentor/analytics'),
                color: Colors.green,
              ),
              _buildActionCard(
                icon: Icons.schedule,
                title: 'Sessions',
                subtitle: 'Manage sessions',
                onTap: () => context.go('/mentor/sessions'),
                color: Colors.purple,
              ),
              _buildActionCard(
                icon: Icons.chat,
                title: 'Chat',
                subtitle: 'Message students',
                onTap: () => context.go('/chat'),
                color: Colors.orange,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          if (analytics != null && analytics['recentActivity'] != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: (analytics['recentActivity'] as List).map((activity) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            _getActivityIcon(activity['type']),
                            color: _getActivityColor(activity['type']),
                          ),
                          title: Text(activity['title'] ?? 'Activity'),
                          subtitle: Text(activity['subtitle'] ?? ''),
                          trailing: activity['score'] != null
                              ? Text('${activity['score']}%')
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Handle activity tap
                          },
                        ),
                        if (activity != (analytics['recentActivity'] as List).last)
                          const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.timeline,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No recent activity',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activity will appear here as students interact',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    final currentUser = ref.watch(currentUserProvider);
    final students = currentUser != null 
        ? _mockDataService.getStudentsByMentorId(currentUser.id)
        : <UserModel>[];

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No students assigned',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Students will appear here once assigned',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentCard(student);
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('Analytics Tab - Coming Soon'),
    );
  }

  Widget _buildSessionsTab() {
    return const Center(
      child: Text('Sessions Tab - Coming Soon'),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(UserModel student) {
    final analytics = student.analytics;
    final averageScore = analytics?['averageScore'] ?? 0.0;
    final quizzesCompleted = analytics?['quizzesCompleted'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showStudentDetails(student),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: student.profileImage != null
                    ? NetworkImage(student.profileImage!)
                    : null,
                child: student.profileImage == null
                    ? Text(
                        student.initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      student.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        _buildStudentStat(
                          icon: Icons.quiz,
                          label: 'Quizzes',
                          value: '$quizzesCompleted',
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        _buildStudentStat(
                          icon: Icons.trending_up,
                          label: 'Avg Score',
                          value: '${averageScore.toStringAsFixed(1)}%',
                          color: _getScoreColor(averageScore),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () => _startChat(student),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showStudentDetails(UserModel student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: student.profileImage != null
                                  ? NetworkImage(student.profileImage!)
                                  : null,
                              child: student.profileImage == null
                                  ? Text(
                                      student.initials,
                                      style: const TextStyle(fontSize: 32),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              student.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              student.email,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      if (student.analytics != null) ...[
                        Text(
                          'Performance Overview',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              title: 'Quizzes Taken',
                              value: '${student.analytics!['quizzesCompleted'] ?? 0}',
                              icon: Icons.quiz,
                              color: Colors.blue,
                            ),
                            _buildStatCard(
                              title: 'Average Score',
                              value: '${(student.analytics!['averageScore'] ?? 0).toStringAsFixed(1)}%',
                              icon: Icons.trending_up,
                              color: Colors.green,
                            ),
                            _buildStatCard(
                              title: 'Time Spent',
                              value: '${(student.analytics!['totalTimeSpent'] ?? 0) ~/ 60}m',
                              icon: Icons.timer,
                              color: Colors.orange,
                            ),
                            _buildStatCard(
                              title: 'Strengths',
                              value: '${(student.analytics!['strengths'] as List?)?.length ?? 0}',
                              icon: Icons.star,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _startChat(student),
                              icon: const Icon(Icons.chat),
                              label: const Text('Start Chat'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Implement schedule session
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Schedule session coming soon')),
                                );
                              },
                              icon: const Icon(Icons.schedule),
                              label: const Text('Schedule'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startChat(UserModel student) {
    // Navigate to chat with specific student
    context.go('/chat');
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'quiz_completed':
        return Icons.quiz;
      case 'message_received':
        return Icons.message;
      case 'session_scheduled':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'quiz_completed':
        return Colors.green;
      case 'message_received':
        return Colors.blue;
      case 'session_scheduled':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

class MentorDashboard extends ConsumerStatefulWidget {
  const MentorDashboard({super.key});

  @override
  ConsumerState<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends ConsumerState<MentorDashboard> {
  int _selectedIndex = 0;

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
                    'Welcome back, Mentor!',
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
                value: '12',
                icon: Icons.people,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'Active Sessions',
                value: '3',
                icon: Icons.schedule,
                color: Colors.green,
              ),
              _buildStatCard(
                title: 'Messages',
                value: '5',
                icon: Icons.message,
                color: Colors.orange,
              ),
              _buildStatCard(
                title: 'This Week',
                value: '8',
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ],
          ),
          
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
          
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.message, color: Colors.blue),
                    title: const Text('New message from John Doe'),
                    subtitle: const Text('2 hours ago'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.assessment, color: Colors.green),
                    title: const Text('Quiz completed by Jane Smith'),
                    subtitle: const Text('4 hours ago'),
                    trailing: const Text('85%'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.schedule, color: Colors.purple),
                    title: const Text('Session scheduled with Mike Johnson'),
                    subtitle: const Text('Tomorrow at 2:00 PM'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return const Center(
      child: Text('Students Tab - Coming Soon'),
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
}



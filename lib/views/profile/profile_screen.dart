import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _biometrics = false;

  void _showEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 24),
            // Mock Edit Form
             const TextField(
                decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              ),
               const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
             title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
             scrolledUnderElevation: 0,
             actions: [
                IconButton(icon: const Icon(Icons.logout), onPressed: () {
                   Provider.of<AuthProvider>(context, listen: false).logout();
                   Navigator.pushReplacementNamed(context, '/login');
                }),
             ],
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                 if (isDesktop) ...[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Text(
                          'Profile & Settings',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                // color: AppColors.textPrimary, // Allow theme to handle color
                              ),
                        ),
                        IconButton(icon: const Icon(Icons.logout), onPressed: () {
                          Provider.of<AuthProvider>(context, listen: false).logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        }),
                     ],
                   ),
                  const SizedBox(height: 20),
                ],
                
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                         radius: 40,
                         backgroundColor: Colors.white,
                         child: Text(
                           'JD', 
                           style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'John Doe',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'john.doe@example.com',
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showEditProfile,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Settings Section
                _SettingsSection(
                  title: 'Preferences',
                  children: [
                    _SettingsTile(
                      icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      title: isDark ? 'Light Mode' : 'Dark Mode',
                      trailing: Switch(
                        value: isDark, 
                        onChanged: (val) => themeProvider.toggleTheme(val),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      trailing: Switch(
                         value: _notifications, 
                         onChanged: (val) => setState(() => _notifications = val),
                         activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                _SettingsSection(
                  title: 'Account & Security',
                  children: [
                     _SettingsTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Login',
                      trailing: Switch(
                         value: _biometrics, 
                         onChanged: (val) => setState(() => _biometrics = val),
                         activeColor: AppColors.primary,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                      onTap: (){},
                    ),
                  ],
                ),

                 const SizedBox(height: 24),
                _SettingsSection(
                  title: 'Support',
                  children: [
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                       onTap: (){},
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About FinTrack',
                      trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                       onTap: (){},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white, // Dark Slate or White
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

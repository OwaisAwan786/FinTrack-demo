import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/constants.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/splash/splash_screen.dart';
import 'views/dashboard/dashboard_screen.dart';
import 'views/home/home_screen.dart';
import 'views/expenses/add_transaction_screen.dart';
import 'views/expenses/transaction_list_screen.dart';
import 'views/budget/budget_screen.dart';
import 'views/insights/insights_screen.dart';
import 'views/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FinTrack',
            debugShowCheckedModeBanner: false,
            // Use themes from provider
            theme: themeProvider.lightTheme.copyWith(
               textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
            ),
            darkTheme: themeProvider.darkTheme.copyWith(
               textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
            ),
            themeMode: themeProvider.themeMode,
            
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => const SplashScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              DashboardScreen.routeName: (context) => const DashboardScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              AddTransactionScreen.routeName: (context) => const AddTransactionScreen(),
              TransactionListScreen.routeName: (context) => const TransactionListScreen(),
              BudgetScreen.routeName: (context) => const BudgetScreen(),
              InsightsScreen.routeName: (context) => const InsightsScreen(),
              ProfileScreen.routeName: (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}

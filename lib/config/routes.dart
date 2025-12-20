import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/baby/add_baby_screen.dart';
import '../screens/baby/baby_profile_screen.dart';
import '../screens/growth/growth_screen.dart';
import '../screens/growth/add_growth_screen.dart';
import '../screens/development/development_screen.dart';
import '../screens/food/food_screen.dart';
import '../screens/vaccination/vaccination_screen.dart';
import '../screens/appointment/appointment_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addBaby = '/add-baby';
  static const String babyProfile = '/baby-profile';
  static const String growth = '/growth';
  static const String addGrowth = '/add-growth';
  static const String development = '/development';
  static const String food = '/food';
  static const String vaccination = '/vaccination';
  static const String appointment = '/appointment';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    addBaby: (context) => const AddBabyScreen(),
    babyProfile: (context) => const BabyProfileScreen(),
    growth: (context) => const GrowthScreen(),
    addGrowth: (context) => const AddGrowthScreen(),
    development: (context) => const DevelopmentScreen(),
    food: (context) => const FoodScreen(),
    vaccination: (context) => const VaccinationScreen(),
    appointment: (context) => const AppointmentScreen(),
  };
}
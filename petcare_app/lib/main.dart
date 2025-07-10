import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/news_screen.dart';
import 'screens/care_screen.dart';
import 'screens/breed_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(PetCareApp());
}

class PetCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Color(0xFFFDF9F5),
      ),
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    NewsScreen(),
    CareScreen(),
    HomeScreen(),
    BreedListScreen(),
    ProfileScreenMain(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/news_paw.png',
              width: 28,
              height: 28,
              errorBuilder: (c, e, s) => Icon(Icons.error, color: Colors.red),
            ),
            label: 'Notícias',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/heart_cross.png',
              width: 28,
              height: 28,
              errorBuilder: (c, e, s) => Icon(Icons.error, color: Colors.red),
            ),
            label: 'Cuidados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Raças',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

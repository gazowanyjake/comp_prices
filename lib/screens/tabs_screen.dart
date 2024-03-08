import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/map_screen.dart';
import '../screens/list_screen.dart';
import '../provider/brain.dart';
import '../screens/favorite_list_screen.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen({super.key});
  static const routeName = '/tabs-screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _tabs = [
    {'tab': MapScreen(), 'title': 'Shops map'},
    {'tab': FavoriteListScreen(), 'title': 'Favorites'},
    {'tab': ListScreen(), 'title': 'Products'},
  ];
  int _selectedTabIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  late final Future<void> _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = Provider.of<Brain>(context, listen: false).getLocationPermission();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _locationFuture,
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: _tabs[_selectedTabIndex]['tab'] as Widget,
              bottomNavigationBar: Container(
                child: ClipRRect(
                  child: BottomNavigationBar(
                    onTap: _selectTab,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Color(0xFF464949),
                    selectedItemColor: Theme.of(context).colorScheme.onPrimary,
                    currentIndex: _selectedTabIndex,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.map_outlined),
                        label: 'Shops map',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites products',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_basket_outlined),
                        label: 'Products search',
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

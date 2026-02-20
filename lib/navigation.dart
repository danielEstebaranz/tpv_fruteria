import 'package:flutter/material.dart';
import 'package:tpv_fruteria/pantallas/administracion.dart';
import 'package:tpv_fruteria/pantallas/manager.dart';
import 'package:tpv_fruteria/pantallas/tienda.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => Navigationstate();
}

class Navigationstate extends State<Navigation> {
    int _selectedIntex=0;


    final List<Widget> pantallas=[Tienda(),Manager(), Administracion()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [ 
          NavigationRail(
            backgroundColor: Colors.green,
            selectedIndex: _selectedIntex,
            onDestinationSelected: (value) {
            setState(() {
              _selectedIntex = value;
            });
            
          },
          labelType: NavigationRailLabelType.all,
          leading:Column(
            children: [
              SizedBox(height: 20,),
              Image.asset("assets/images/logo.jpg",height: 70, width: 70,),
              SizedBox(height: 30,)
            ],
          ),
          destinations: [
            NavigationRailDestination(icon: Icon(Icons.store_outlined),selectedIcon: Icon(Icons.store), label: Text("Tienda")),
            NavigationRailDestination(icon: Icon(Icons.trending_up),selectedIcon: Icon(Icons.trending_down), label: Text("Manager")),
            NavigationRailDestination(icon: Icon(Icons.settings_outlined),selectedIcon: Icon(Icons.settings), label: Text("Admin")),
          ]),
            Expanded(child: pantallas[_selectedIntex])
        ],
      ),
    );
  }
}
import 'package:camilolealev3/pages/add_game_page.dart';
import 'package:camilolealev3/widgets/game_tile.dart';
import 'package:flutter/material.dart';
import 'package:camilolealev3/services/auth_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:camilolealev3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(MdiIcons.gamepadVariant, color: Colors.white, size: 35,),
            Text(' Mis Juegos', style: TextStyle(color: Colors.white),),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/img/fondo.jpg'), fit: BoxFit.cover) 
        ),
        child: StreamBuilder(
          stream: FirestoreService().getGames(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
        
            final games = snapshot.data!.docs;
        
            return ListView.separated(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                final fecha = game['fecha'].toDate();
                return GameTile(id: game.id, status: game['status'] ,name: game['name'], platforms: List<String>.from(game['platforms']), imageUrl: game['image'], fecha: fecha,);
              },
              separatorBuilder: (context, index) => Divider(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddGamePage()),);
        },
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
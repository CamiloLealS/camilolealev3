import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:camilolealev3/services/firestore_service.dart';
import 'package:intl/intl.dart';

class GameTile extends StatelessWidget {
  final String name;
  final List<String> platforms;
  final String imageUrl;
  final bool status;
  final String id;
  final DateTime fecha;
  final formatoFecha = DateFormat('dd/MM/yyyy');

  GameTile({
    required this.name,
    required this.platforms,
    required this.imageUrl,
    required this.id,
    required this.status,
    required this.fecha
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        showGameDetails(context, status, name, platforms.join(', '), imageUrl, formatoFecha.format(fecha));
      },
      child: Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            if (!status)
              SlidableAction(
                onPressed: (context) => _updateGame(context, id),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Color.fromARGB(255, 0, 255, 13),
                icon: Icons.verified,
              )
            else 
              SlidableAction(
                onPressed: (context) => _updateGame(context, id),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Color.fromARGB(255, 255, 0, 0),
                icon: Icons.close,
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _confirmDelete(context, id),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          height: 50,
          color: Color.fromARGB(83, 255, 255, 255),
          child: Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Text(name, style: TextStyle(fontSize: 18, color: Colors.white),),
                  Text('Plataformas: '+ platforms.join(', '), style: TextStyle(color: Colors.white,fontSize: 15, fontStyle: FontStyle.italic),)
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Borrar Juego'),
          content: Text('¿Estás seguro de que deseas borrar este juego?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                FirestoreService().deleteGame(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGame(BuildContext context, String id) {
    // Aquí debes navegar a la página de actualización del juego.
    if (!status)
      FirestoreService().updateGame(id, true);
    else
      FirestoreService().updateGame(id, false);
  }
  void showGameDetails(BuildContext context, bool status , String name, String platforms , String imageUrl, String fecha) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Image(image: AssetImage('assets/img/${imageUrl}'), height: 250),
              //SizedBox(height: 250, width: 60,),
              SizedBox(height: 20,),
              Text('Agregado a la Lista el ${fecha}', style: TextStyle(fontSize: 18),),
              if (status)
                Text("Estado: Completado", style: TextStyle(fontSize: 18, color: Colors.green))
              else 
                Text("Estado: -", style: TextStyle(fontSize: 18, color: Colors.red)),
              SizedBox(height: 8),
              Text("Plataformas: ${platforms}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camilolealev3/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.white,),
            Text(' Inicio de Sesión', style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight  
          )
        ),
        child: Center(
          child: Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(5, 5)
                )
              ],
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 255, 255, 255)
            ),
            child: Row(
              children: [
                Text(' Iniciar Sesión con Google: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () async {
                    User? user = await _authService.signInWithGoogle();
                    if (user != null) {
                      // Navega a la página principal después de iniciar sesión
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      // Maneja el error de inicio de sesión
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al iniciar sesión con Google',)),
                      );
                    }
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds){
                      return LinearGradient(
                        colors: [Color.fromARGB(255, 255, 0, 0), const Color.fromARGB(255, 0, 255, 8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      ).createShader(bounds);
                    },
                    child: Icon(MdiIcons.google, size: 45,)
                  ),
                ),
                SizedBox(width: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:camilolealev3/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddGamePage extends StatefulWidget {
  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _imageUrl = '';
  List<String> _platforms = [];
  bool _status = false;
  String _errPlatforms = '';
  DateTime _currentDate = DateTime.now();

  Map<String, bool> _platformSelections = {
    'Windows': false,
    'Xbox': false,
    'PlayStation': false,
    'Nintendo': false,
    'Mobile': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Agregar Juego', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Juego'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe ingresar el nombre del juego';
                  } else if (value.length < 2) {
                    return 'El nombre debe tener al menos 2 letras';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              Text(
                'Fecha de Agregado: ${_currentDate.day}/${_currentDate.month}/${_currentDate.year}',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Plataformas Disponibles:', style: TextStyle(fontSize: 16)),
              ),
              Text(_errPlatforms, style: TextStyle(color: Colors.red),),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  children: _platformSelections.keys.map((platform) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _platformSelections[platform] = !_platformSelections[platform]!;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _platformSelections[platform]!
                                ? Colors.green
                                : Colors.transparent,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset('assets/platforms/${platform.toLowerCase()}.png'),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _platformSelections.containsValue(true)) {
                        _formKey.currentState!.save();
                        List<String>_image = _name.split(' ');
                        _imageUrl = _image.join().toLowerCase()+'.jpg';
                        _platforms = _platformSelections.keys
                            .where((platform) => _platformSelections[platform]!)
                            .toList();
                        FirestoreService().addGame(_name, _imageUrl, _platforms, _status, _currentDate);
                        Navigator.pop(context);
                      } else{
                        setState(() {
                          _errPlatforms = 'Debe seleccionar al menos una plataforma';
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.save, color: Color.fromARGB(255, 4, 0, 255),),
                        Text(' Guardar', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
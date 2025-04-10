import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Para convertir el cuerpo de la respuesta a JSON

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulario en Flutter Moshe',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: FormularioScreen(backgroundColor: const Color.fromARGB(255, 70, 251, 64)),
    );
  }
}

class FormularioScreen extends StatefulWidget {
  final Color backgroundColor;

  const FormularioScreen({super.key, required this.backgroundColor});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave global del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dirrecionController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // URL de la API
  final String apiUrl = 'https://postman-rest-api-learner.glitch.me/api/v1/carsmovies'; 

  // Función para obtener las películas
  Future<void> obtenerPeliculas() async {
    try {
      // Realizamos la solicitud GET a la API
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, puedes procesar los datos aquí
        List<dynamic> peliculas = json.decode(response.body);
        print(peliculas);  // Imprimir las películas en consola
      } else {
        throw Exception('Error al cargar las películas');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Llamamos la función obtenerPeliculas cuando la pantalla se cargue
    obtenerPeliculas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario Flutter', style: TextStyle(color: Colors.orange))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Colors.green)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dirrecionController,
                decoration: InputDecoration(labelText: 'Dirección', labelStyle: TextStyle(color: Colors.green)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Coloque una dirección';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Formulario válido')));
                  }
                },
                child: Text('Enviar', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

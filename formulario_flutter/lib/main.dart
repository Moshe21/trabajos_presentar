import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulario en Flutter Moshe',
      theme: ThemeData(primarySwatch:Colors.purple),
      home: FormularioScreen(backgroundColor: const Color.fromARGB(255, 70, 251, 64)),
    );
  }
}

class FormularioScreen extends StatefulWidget {
  final Color backgroundColor;

  FormularioScreen({required this.backgroundColor});

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

  @override
  Widget build(BuildContext context,
    
                ) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario Flutter',
                      style: TextStyle(
      color: Colors.orange   ),
              ),
            ),
                                
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre',
                                            labelStyle: TextStyle(
                                              color: Colors.green
                                              )
                                            ),
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
                decoration: InputDecoration(labelText: 'Direccion',
                                            labelStyle: TextStyle(
                                              color: Colors.green
                                              )
                                            ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'coloque una una dirrecion';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _celularController,
                decoration: InputDecoration(labelText: 'celular',
                                            labelStyle: TextStyle(
                                              color: Colors.green
                                              )
                                            ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'coloque un numero celular';
                  }if(int.tryParse(value)== null){
                    return 'coloque solo numeros';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico',
                                            labelStyle: TextStyle(
                                              color: Colors.green
                                              )
                                            ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su correo';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña',
                                            labelStyle: TextStyle(
                                              color: Colors.green
                                              )
                                            ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Formulario válido')),
                    );
                  }
                },
                child: Text('Enviar',
                            style: TextStyle(
                              color: Colors.blue
                            ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
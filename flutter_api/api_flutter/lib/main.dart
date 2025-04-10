 import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class Usuario {
  final int? id;
  final String nombre;
  final String direccion;
  final String celular;
  final String email;
  final String password;

  Usuario({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.celular,
    required this.email,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    String nombreCompleto = '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}';
    String direccionCompleta = json['address'] != null 
        ? '${json['address']['address'] ?? ''}, ${json['address']['city'] ?? ''}, ${json['address']['state'] ?? ''}'
        : '';
    
    return Usuario(
      id: json['id'],
      nombre: nombreCompleto,
      direccion: direccionCompleta, 
      celular: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    // Dividir el nombre en nombre y apellido
    List<String> nombreParts = nombre.split(' ');
    String firstName = nombreParts.isNotEmpty ? nombreParts[0] : '';
    String lastName = nombreParts.length > 1 ? nombreParts.sublist(1).join(' ') : '';
    
    // Dividir la dirección en partes
    List<String> direccionParts = direccion.split(',');
    String addressStreet = direccionParts.isNotEmpty ? direccionParts[0].trim() : '';
    String city = direccionParts.length > 1 ? direccionParts[1].trim() : '';
    String state = direccionParts.length > 2 ? direccionParts[2].trim() : '';
    
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': celular,
      'password': password,
      'address': {
        'address': addressStreet,
        'city': city,
        'state': state,
      },
    };
  }
}

class FormularioScreen extends StatefulWidget {
  final Color backgroundColor;

  const FormularioScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final String apiUrl = 'https://dummyjson.com/users';
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isError = false;
  List<Usuario> _usuarios = [];
  Usuario? usuarioSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }
  
  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _celularController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // READ - Cargar usuarios
  Future<void> cargarUsuarios() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
      _isError = false;
    });
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('users') && data['users'] is List) {
          setState(() {
            _usuarios = (data['users'] as List)
                .map((userJson) => Usuario.fromJson(userJson))
                .toList();
            _isLoading = false;
          });
          print('Usuarios cargados: ${_usuarios.length}');
        } else {
          throw Exception('Formato de respuesta inesperado');
        }
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isError = true;
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
  
  // CREATE - Crear usuario
  Future<void> crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = '';
      _isError = false;
    });
    
    final nuevoUsuario = Usuario(
      nombre: _nombreController.text,
      direccion: _direccionController.text,
      celular: _celularController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nuevoUsuario.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final createdUser = Usuario.fromJson(json.decode(response.body));
        setState(() {
          _usuarios.add(createdUser);
          _statusMessage = 'Usuario creado correctamente';
          _isError = false;
          _isLoading = false;
        });
        
        // Limpiar formulario
        limpiarFormulario();
      } else {
        throw Exception('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isError = true;
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
  
  // UPDATE - Actualizar usuario
  Future<void> actualizarUsuario() async {
    if (!_formKey.currentState!.validate() || usuarioSeleccionado == null) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = '';
      _isError = false;
    });
    
    final usuarioActualizado = Usuario(
      id: usuarioSeleccionado!.id,
      nombre: _nombreController.text,
      direccion: _direccionController.text,
      celular: _celularController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${usuarioSeleccionado!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuarioActualizado.toJson()),
      );
      
      if (response.statusCode == 200) {
        // Actualiza la lista de usuarios
        final index = _usuarios.indexWhere((u) => u.id == usuarioSeleccionado!.id);
        if (index != -1) {
          setState(() {
            _usuarios[index] = usuarioActualizado;
            _statusMessage = 'Usuario actualizado correctamente';
            _isError = false;
            _isLoading = false;
            usuarioSeleccionado = null;
          });
          
          // Limpiar formulario
          limpiarFormulario();
        }
      } else {
        throw Exception('Error al actualizar usuario: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isError = true;
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
  
  // DELETE - Eliminar usuario
  Future<void> eliminarUsuario(int id) async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
      _isError = false;
    });
    
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _usuarios.removeWhere((usuario) => usuario.id == id);
          _statusMessage = 'Usuario eliminado correctamente';
          _isError = false;
          _isLoading = false;
          usuarioSeleccionado = null;
        });
        
        // Limpiar formulario
        limpiarFormulario();
      } else {
        throw Exception('Error al eliminar usuario: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isError = true;
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
  
  // Limpiar formulario
  void limpiarFormulario() {
    _nombreController.clear();
    _direccionController.clear();
    _celularController.clear();
    _emailController.clear();
    _passwordController.clear();
    usuarioSeleccionado = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Flutter', style: TextStyle(color: Colors.orange)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Formulario
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(color: Colors.green),
                        prefixIcon: Icon(Icons.person),
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
                      controller: _direccionController,
                      decoration: InputDecoration(
                        labelText: 'Direccion',
                        labelStyle: TextStyle(color: Colors.green),
                        prefixIcon: Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Coloque una dirrecion';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _celularController,
                      decoration: InputDecoration(
                        labelText: 'Celular',
                        labelStyle: TextStyle(color: Colors.green),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Coloque un numero celular';
                        }
                        if (int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) == null) {
                          return 'Coloque solo numeros';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: TextStyle(color: Colors.green),
                        prefixIcon: Icon(Icons.email),
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
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.green),
                        prefixIcon: Icon(Icons.lock),
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
                    
                    // Mostrar mensajes de estado
                    if (_statusMessage.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: _isError ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                            color: _isError ? Colors.red[900] : Colors.green[900],
                          ),
                        ),
                      ),
                    
                    // Indicador de usuario seleccionado
                    if (usuarioSeleccionado != null)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue[900]),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Usuario seleccionado: ${usuarioSeleccionado!.nombre}',
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.blue[900]),
                              onPressed: () {
                                setState(() {
                                  usuarioSeleccionado = null;
                                  limpiarFormulario();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                    // BOTONES CRUD
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón CREAR
                          ElevatedButton(
                            onPressed: _isLoading ? null : crearUsuario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  'CREAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          
                          // Botón LEER
                          ElevatedButton(
                            onPressed: _isLoading ? null : cargarUsuarios,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  'LEER',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          
                          // Botón ACTUALIZAR
                          ElevatedButton(
                            onPressed: _isLoading || usuarioSeleccionado == null ? null : actualizarUsuario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  'ACTUALIZAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          
                          // Botón ELIMINAR
                          ElevatedButton(
                            onPressed: _isLoading || usuarioSeleccionado == null ? null : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirmar eliminación'),
                                  content: Text('¿Está seguro de eliminar a ${usuarioSeleccionado!.nombre}?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancelar'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: Text('Eliminar', style: TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        eliminarUsuario(usuarioSeleccionado!.id!);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  'ELIMINAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Botón para limpiar el formulario
                    TextButton.icon(
                      icon: Icon(Icons.refresh),
                      label: Text('Limpiar formulario'),
                      onPressed: limpiarFormulario,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Lista de usuarios
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Usuarios Registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    
                    if (_isLoading && _usuarios.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_usuarios.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No hay usuarios registrados'),
                        ),
                      )
                    else
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: _usuarios.length,
                          itemBuilder: (context, index) {
                            final usuario = _usuarios[index];
                            final bool seleccionado = usuarioSeleccionado?.id == usuario.id;
                            
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              color: seleccionado ? Colors.blue.shade50 : null,
                              elevation: seleccionado ? 3 : 1,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  child: Text(
                                    usuario.nombre.isNotEmpty
                                        ? usuario.nombre.substring(0, 1).toUpperCase()
                                        : '?',
                                  ),
                                ),
                                title: Text(usuario.nombre),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(usuario.email),
                                    Text(usuario.celular),
                                    Text(
                                      usuario.direccion,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  setState(() {
                                    usuarioSeleccionado = usuario;
                                    // Cargar datos en el formulario
                                    _nombreController.text = usuario.nombre;
                                    _direccionController.text = usuario.direccion;
                                    _celularController.text = usuario.celular;
                                    _emailController.text = usuario.email;
                                    _passwordController.text = usuario.password;
                                  });
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          usuarioSeleccionado = usuario;
                                          // Cargar datos en el formulario
                                          _nombreController.text = usuario.nombre;
                                          _direccionController.text = usuario.direccion;
                                          _celularController.text = usuario.celular;
                                          _emailController.text = usuario.email;
                                          _passwordController.text = usuario.password;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          usuarioSeleccionado = usuario;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Confirmar eliminación'),
                                            content: Text('¿Está seguro de eliminar a ${usuario.nombre}?'),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancelar'),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                child: Text('Eliminar', style: TextStyle(color: Colors.white)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  if (usuario.id != null) {
                                                    eliminarUsuario(usuario.id!);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
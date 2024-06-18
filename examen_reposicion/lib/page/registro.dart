import 'package:flutter/material.dart';
import 'package:app/services/usuarios.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Registrar',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (val) => val!.isEmpty ||
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)
                        ? 'Ingresa un email válido'
                        : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 200,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? 'La contraseña debe tener al menos 6 caracteres'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        dynamic result = await _auth.registerWithEmailAndPassword(
                            email, password);
                        if (result == null) {
                          setState(() =>
                              error = 'Error al registrar. Verifica tus datos.');
                        } else {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() => error = e.toString());
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Registrar'),
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.orange, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app/page/registro.dart';
import 'package:app/services/usuarios.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false; // Estado para controlar la carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: Colors.blue, // Cambia esto al color que prefieras.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Ingresa un email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (val) => val!.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              isLoading // Mostrar un indicador de carga si isLoading es true
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() =>
                              isLoading = true); // Activar el estado de carga
                          try {
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => error =
                                  'Error al iniciar sesión. Verifica tus credenciales.');
                              setState(() => isLoading =
                                  false); // Desactivar el estado de carga
                            }
                          } catch (e) {
                            setState(() => error = e.toString());
                            setState(() => isLoading =
                                false); // Desactivar el estado de carga
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Cambia esto al color que prefieras.
                      ),
                      child: const Text('Iniciar sesión'),
                    ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(
                    color: Color.fromRGBO(255, 152, 0, 1),
                    fontSize: 14.0), // Cambia esto al color que prefieras.
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('¿No tienes cuenta? Regístrate aquí'),
              ),
              TextButton(
                onPressed: () {
                  _auth.resetPassword(email); // Restablecer contraseña
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

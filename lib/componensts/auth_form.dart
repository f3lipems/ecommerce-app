import 'package:ecomm/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:ecomm/models/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String> _authData = <String, String>{
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  // bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
   
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.7),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _suitchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);
    _formKey.currentState?.save();
    Auth _auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin()) {
        await _auth.login(_authData['email']!, _authData['password']!);
      } else {
        await _auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        width: deviceSize.width * 0.8,
        height: _isLogin() ? 320 : 380,
        // height: _heightAnimation?.value?.height ?? (_isLogin() ? 320 : 380),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) => _authData['email'] = email ?? '',
                    validator: (emailField) {
                      if (emailField == null || emailField.isEmpty || !emailField.contains('@')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (password) => _authData['password'] = password ?? '',
                    validator: (passwordField) {
                      if (passwordField == null || passwordField.isEmpty) {
                        return 'Informe uma senha válida';
                      } else if (passwordField.length <= 5) {
                        return 'Senha precisa ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                    AnimatedContainer(
                      constraints: BoxConstraints(
                        minHeight: _isLogin() ? 0 : 60,
                        maxHeight: _isLogin() ? 0 : 120,
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear,
                      child: FadeTransition(
                        opacity: _opacityAnimation!,
                        child: SlideTransition(
                          position: _slideAnimation!,
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                            obscureText: true,
                            validator: _isLogin()
                                ? null
                                : (confirmPasswordField) {
                                    final password = confirmPasswordField ?? '';
                                    if (password != _passwordController.text) {
                                      return 'Senhas não conferem';
                                    }
                                    return null;
                                  },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _authMode == AuthMode.Login ? 'Entrar' : 'Registrar',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              TextButton(
                onPressed: _suitchAuthMode,
                child: Text(_isLogin() ? 'Registrar' : 'Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

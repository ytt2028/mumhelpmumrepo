import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  DateTime? _birthday;
  bool _busy = false;
  String? _error;

  final _pwdRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?]).{8,}$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 3, now.month, now.day),
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_birthday == null) {
      setState(() => _error = 'Please select birthday');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _email.text.trim(),
            password: _password.text.trim(),
          );
      await cred.user!.updateDisplayName(_name.text.trim());

      // 保存扩展资料到 Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'displayName': _name.text.trim(),
        'birthday': Timestamp.fromDate(_birthday!),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) Navigator.pop(context); // AuthGate 会自动进入主界面
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Sign-up failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: _pickBirthday,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        prefixIcon: Icon(Icons.cake_outlined),
                        border: OutlineInputBorder()),
                      child: Text(
                        _birthday == null
                          ? 'Select date'
                          : '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      helperText: '≥ 8 chars, include a letter & a special char',
                    ),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return 'Required';
                      if (!_pwdRegex.hasMatch(t)) {
                        return 'Must be ≥8 & contain letter + special char';
                      }
                      return null;
                    },
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              height: 18, width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Create account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

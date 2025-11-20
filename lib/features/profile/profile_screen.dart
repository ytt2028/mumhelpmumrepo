import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  DateTime? _birthday;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser!;
    _name.text = user.displayName ?? '';
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final ts = doc.data()?['birthday'] as Timestamp?;
    if (ts != null) _birthday = ts.toDate();
    if (mounted) setState(() {});
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 3, now.month, now.day),
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(_name.text.trim());
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': _name.text.trim(),
      if (_birthday != null) 'birthday': Timestamp.fromDate(_birthday!),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    setState(() => _busy = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Username', prefixIcon: Icon(Icons.person_outline)),
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
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _birthday == null
                      ? 'Select date'
                      : '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: _busy
                    ? const SizedBox(height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

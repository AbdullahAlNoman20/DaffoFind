import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _uploadData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> postData = {
      "name": _nameController.text,
      "location": _locationController.text,
      "date": _dateController.text,
      "contact": _contactController.text,
      "description": _descriptionController.text,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection("find_posts").add(postData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post Submitted Successfully!")),
    );

    _formKey.currentState!.reset();
    _nameController.clear();
    _locationController.clear();
    _dateController.clear();
    _contactController.clear();
    _descriptionController.clear();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Found Something?")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Your Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your name" : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter location" : null,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Pick a date" : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: "Contact Info"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter contact info" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a description" : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _uploadData,
                        child: const Text("Submit Post"),
                      ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back to Home"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

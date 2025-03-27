import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LostPage extends StatefulWidget {
  const LostPage({super.key});

  @override
  State<LostPage> createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _uploadLostPost() async {
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

    await FirebaseFirestore.instance.collection("lost_posts").add(postData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lost Item Reported Successfully!")),
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
      appBar: AppBar(
        title: const Text("Lost Something?"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Your Name",
                  icon: Icons.person,
                ),
                _buildTextField(
                  controller: _locationController,
                  label: "Location",
                  icon: Icons.location_on,
                ),
                _buildDateField(),
                _buildTextField(
                  controller: _contactController,
                  label: "Contact Info",
                  icon: Icons.phone,
                ),
                _buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _uploadLostPost,
                        icon: const Icon(Icons.report_problem),
                        label: const Text("Report Lost Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for Text Fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }

  // Date Field with Calendar Icon
  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      decoration: const InputDecoration(
        labelText: "Date",
        suffixIcon: Icon(Icons.calendar_today, color: Colors.redAccent),
        border: OutlineInputBorder(),
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
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) => value!.isEmpty ? "Pick a date" : null,
    );
  }
}

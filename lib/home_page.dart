import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E7BE8),
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _degreesController = TextEditingController();

  final List<String> _types = ['Fahrenheit', 'Celsius'];
  String _selectedType = 'Fahrenheit';
  String _result = '';

  @override
  void dispose() {
    _degreesController.dispose();
    super.dispose();
  }

  String? _validateDegrees(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter degrees';
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Only whole numbers are allowed';
    }
    return null;
  }

  void _convert() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _result = '');
      return;
    }

    final double input = double.parse(_degreesController.text.trim());

    setState(() {
      if (_selectedType == 'Fahrenheit') {
        final c = (input - 32) * 5 / 9;
        _result = '${c.toStringAsFixed(2)} °C';
      } else {
        final f = (input * 9 / 5) + 32;
        _result = '${f.toStringAsFixed(2)} °F';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Temperature converter',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _degreesController,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        inputFormatters: [
                          
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                        ],
                        validator: _validateDegrees,
                        decoration: const InputDecoration(
                          labelText: 'Degrees',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: UnderlineInputBorder(),
                        ),
                        items: _types
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                              _result = '';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

               
                const Text(
                  'Result',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  _result,
                  style: const TextStyle(fontSize: 18),
                ),
                const Divider(),

                const SizedBox(height: 40),

                
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _convert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E7BE8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Convert',
                      style: TextStyle(fontSize: 16),
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
}
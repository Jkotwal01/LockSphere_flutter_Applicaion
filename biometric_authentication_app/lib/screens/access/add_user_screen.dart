import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/access_provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _contact = '';
  String _role = 'Guest';
  
  DateTime? _startDate;
  DateTime? _endDate;
  
  bool _isProcessing = false;

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_role == 'Guest' && (_startDate == null || _endDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guests require a valid time window')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    final success = await context.read<AccessProvider>().addAccess(
      'esp32_device_01', // mock device
      _name,
      _contact,
      _role,
      _startDate,
      _endDate,
    );

    setState(() => _isProcessing = false);

    if (success && mounted) {
      context.pop(); // Go back to list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_name added successfully')),
      );
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final datetime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    
    setState(() {
      if (isStart) {
        _startDate = datetime;
      } else {
        _endDate = datetime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Basic Info', style: AppTextStyles.titleMd),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onSaved: (v) => _name = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone or Email', prefixIcon: Icon(Icons.contact_mail_outlined)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onSaved: (v) => _contact = v!,
            ),
            const SizedBox(height: 32),
            
            Text('Access Role', style: AppTextStyles.titleMd),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.admin_panel_settings_outlined)),
              items: ['Owner', 'Member', 'Guest']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _role = v!),
            ),
            
            const SizedBox(height: 32),
            if (_role == 'Guest') ...[
              Text('Time Restriction', style: AppTextStyles.titleMd),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(_startDate == null ? 'Start Date' : DateFormat('MMM d, h:mm a').format(_startDate!)),
                      onPressed: () => _pickDateTime(true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.event_busy, size: 16),
                      label: Text(_endDate == null ? 'End Date' : DateFormat('MMM d, h:mm a').format(_endDate!)),
                      onPressed: () => _pickDateTime(false),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _saveUser,
                child: _isProcessing
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.surface))
                    : const Text('Send Invitation', style: TextStyle(color: AppTheme.surface)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

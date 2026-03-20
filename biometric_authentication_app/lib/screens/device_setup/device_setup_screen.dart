import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants.dart';
import '../../../services/ble_service.dart';
import '../../../services/api_service.dart';

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({super.key});

  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  final BleService _bleService = BleService();
  final ApiService _apiService = ApiService();
  
  int _currentStep = 0;
  List<ScanResult> _devices = [];
  BluetoothDevice? _selectedDevice;
  
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _bleService.stopScan();
    _ssidController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _startScan() {
    _bleService.startScan();
    _bleService.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          // Filter for devices that look like our ESP32 lock
          _devices = results.where((r) => r.device.platformName.isNotEmpty).toList();
        });
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isProcessing = true;
      _selectedDevice = device;
    });

    _bleService.stopScan();
    bool connected = await _bleService.connectToDevice(device);
    
    setState(() {
      _isProcessing = false;
      if (connected) {
        _currentStep = 1; // Move to Wi-Fi config
      } else {
        _selectedDevice = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect to device')),
        );
      }
    });
  }

  Future<void> _configureAndRegister() async {
    if (_ssidController.text.trim().isEmpty || _pwdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Wi-Fi credentials')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // 1. Send Wi-Fi credentials over BLE
    bool wroteCreds = await _bleService.writeWifiCredentials(
      _selectedDevice!, 
      _ssidController.text.trim(), 
      _pwdController.text.trim()
    );

    if (wroteCreds) {
      setState(() => _currentStep = 2); // Move to Registration step

      // 2. Register with backend API
      bool registered = await _apiService.registerDevice(_selectedDevice!.remoteId.str);
      
      setState(() => _isProcessing = false);

      if (registered && mounted) {
        // Disconnect BLE as we transition to MQTT/Wi-Fi
        _bleService.disconnectFromDevice(_selectedDevice!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device setup complete!')),
        );
        context.go(AppConstants.homeRoute);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    } else {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send Wi-Fi credentials to device')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        controlsBuilder: (context, details) {
          return const SizedBox.shrink(); // Hide default buttons
        },
        type: StepperType.vertical,
        steps: [
          // STEP 0: Scan
          Step(
            title: Text('Scan for Devices', style: AppTextStyles.titleMd),
            content: _buildScanStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          // STEP 1: Wi-Fi Config
          Step(
            title: Text('Connect to Wi-Fi', style: AppTextStyles.titleMd),
            content: _buildWifiStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          // STEP 2: Registration
          Step(
            title: Text('Registering Device', style: AppTextStyles.titleMd),
            content: _buildRegistrationStep(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildScanStep() {
    return Column(
      children: [
        if (_isProcessing)
          const CircularProgressIndicator(color: AppTheme.primary)
        else ...[
          const SizedBox(height: 16),
          if (_devices.isEmpty)
             const Padding(
               padding: EdgeInsets.all(24.0),
               child: Text('Scanning for nearby Sentinel locks...', style: TextStyle(color: Colors.grey)),
             ),
          ..._devices.map((r) => ListTile(
            leading: const Icon(Icons.bluetooth_audio, color: AppTheme.primary),
            title: Text(r.device.platformName.isEmpty ? 'Unknown Device' : r.device.platformName),
            subtitle: Text(r.device.remoteId.str),
            trailing: ElevatedButton(
              onPressed: () => _connectToDevice(r.device),
              child: const Text('Connect'),
            ),
          )),
        ]
      ],
    );
  }

  Widget _buildWifiStep() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Sentinel needs your Wi-Fi details to stay connected when you are away.',
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _ssidController,
          decoration: const InputDecoration(
            labelText: 'Wi-Fi Network Name (SSID)',
            prefixIcon: Icon(Icons.wifi),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pwdController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Wi-Fi Password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _configureAndRegister,
            child: _isProcessing 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.surface))
                : const Text('Send to Device', style: TextStyle(color: AppTheme.surface)),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppTheme.primary),
            const SizedBox(height: 24),
            Text('Registering device securely on the cloud...', style: AppTextStyles.bodyMd),
          ],
        ),
      ),
    );
  }
}

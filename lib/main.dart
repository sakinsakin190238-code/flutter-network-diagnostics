import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        title: 'Network Diagnostics',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF0A0E27),
          primaryColor: const Color(0xFF00D9FF),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF00D9FF)),
            titleLarge: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
            bodyMedium: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.white60),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF0F1629),
            elevation: 0,
            titleTextStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF00D9FF)),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: child,
      ),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Network Diagnostics')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Network & Security Tools', style: Theme.of(context).textTheme.displayLarge),
              SizedBox(height: 24.h),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildToolCard(context, Icons.router, 'Port Scanner', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortScannerScreen()))),
                  _buildToolCard(context, Icons.dns, 'DNS Lookup', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DNSLookupScreen()))),
                  _buildToolCard(context, Icons.lock, 'Cryptography', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CryptoScreen()))),
                  _buildToolCard(context, Icons.phone_android, 'Device Info', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceInfoScreen()))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF00D9FF), width: 1.5),
          color: const Color(0xFF1A1F3A),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00D9FF), size: 40.sp),
            SizedBox(height: 12.h),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class PortScannerScreen extends StatefulWidget {
  const PortScannerScreen({Key? key}) : super(key: key);

  @override
  State<PortScannerScreen> createState() => _PortScannerScreenState();
}

class _PortScannerScreenState extends State<PortScannerScreen> {
  final hostController = TextEditingController();
  final portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Port Scanner')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: hostController, decoration: const InputDecoration(hintText: 'Host (e.g., google.com)')),
              SizedBox(height: 12.h),
              TextField(controller: portController, decoration: const InputDecoration(hintText: 'Port (e.g., 80)'), keyboardType: TextInputType.number),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => provider.scanPort(hostController.text, int.tryParse(portController.text) ?? 80),
                  child: provider.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Scan'),
                ),
              ),
              SizedBox(height: 24.h),
              if (provider.result.isNotEmpty) _buildResultCard(provider.result),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hostController.dispose();
    portController.dispose();
    super.dispose();
  }
}

class DNSLookupScreen extends StatefulWidget {
  const DNSLookupScreen({Key? key}) : super(key: key);

  @override
  State<DNSLookupScreen> createState() => _DNSLookupScreenState();
}

class _DNSLookupScreenState extends State<DNSLookupScreen> {
  final domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DNS Lookup')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: domainController, decoration: const InputDecoration(hintText: 'Domain (e.g., google.com)')),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => provider.dnsLookup(domainController.text),
                  child: provider.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Lookup'),
                ),
              ),
              SizedBox(height: 24.h),
              if (provider.result.isNotEmpty) _buildResultCard(provider.result),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    domainController.dispose();
    super.dispose();
  }
}

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({Key? key}) : super(key: key);

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cryptography')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: inputController, decoration: const InputDecoration(hintText: 'Enter text'), maxLines: 3),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                children: ['MD5', 'SHA256', 'Base64'].map((algo) {
                  return ElevatedButton(
                    onPressed: () => provider.generateHash(inputController.text, algo),
                    child: Text(algo),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
              if (provider.result.isNotEmpty) _buildResultCard(provider.result),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({Key? key}) : super(key: key);

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppProvider>().loadDeviceInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : (provider.result.isNotEmpty ? _buildResultCard(provider.result) : const SizedBox()),
        ),
      ),
    );
  }
}

Widget _buildResultCard(Map<String, dynamic> data) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFF006E), width: 1.5),
      color: const Color(0xFF1A1F3A),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.key, style: const TextStyle(color: Color(0xFF00D9FF), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF2A2F45), borderRadius: BorderRadius.circular(6)),
                child: Text(e.value.toString(), style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

class AppProvider with ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic> result = {};

  Future<void> scanPort(String host, int port) async {
    if (host.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 3)).then((s) {
        s.destroy();
        return s;
      }).catchError((_) => null);

      result = {'host': host, 'port': port, 'status': socket != null ? 'OPEN' : 'CLOSED'};
    } catch (e) {
      result = {'error': e.toString()};
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> dnsLookup(String domain) async {
    if (domain.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      final addresses = await InternetAddress.lookup(domain);
      result = {'domain': domain, 'ips': addresses.map((a) => a.address).toList()};
    } catch (e) {
      result = {'error': e.toString()};
    }

    isLoading = false;
    notifyListeners();
  }

  void generateHash(String input, String algorithm) {
    if (input.isEmpty) return;

    String hash = '';
    switch (algorithm) {
      case 'MD5':
        hash = md5.convert(utf8.encode(input)).toString();
        break;
      case 'SHA256':
        hash = sha256.convert(utf8.encode(input)).toString();
        break;
      case 'Base64':
        hash = base64.encode(utf8.encode(input));
        break;
    }

    result = {'algorithm': algorithm, 'input': input, 'output': hash};
    notifyListeners();
  }

  Future<void> loadDeviceInfo() async {
    isLoading = true;
    notifyListeners();

    try {
      final deviceInfo = DeviceInfoPlugin();
      final android = await deviceInfo.androidInfo;

      result = {
        'device': android.device,
        'brand': android.brand,
        'model': android.model,
        'version': android.version.release,
      };
    } catch (e) {
      result = {'error': e.toString()};
    }

    isLoading = false;
    notifyListeners();
  }
}

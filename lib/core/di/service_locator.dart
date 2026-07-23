import 'package:get_it/get_it.dart';
import '../../data/repositories/network_repository.dart';
import '../../data/repositories/crypto_repository.dart';
import '../../data/repositories/device_repository.dart';
import '../../domain/usecases/port_scan_usecase.dart';
import '../../domain/usecases/dns_lookup_usecase.dart';
import '../../domain/usecases/hash_usecase.dart';
import '../../domain/usecases/device_info_usecase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerSingleton<NetworkRepository>(NetworkRepository());
  getIt.registerSingleton<CryptoRepository>(CryptoRepository());
  getIt.registerSingleton<DeviceRepository>(DeviceRepository());

  // Use Cases
  getIt.registerSingleton<PortScanUseCase>(
    PortScanUseCase(getIt<NetworkRepository>()),
  );
  getIt.registerSingleton<DNSLookupUseCase>(
    DNSLookupUseCase(getIt<NetworkRepository>()),
  );
  getIt.registerSingleton<HashUseCase>(
    HashUseCase(getIt<CryptoRepository>()),
  );
  getIt.registerSingleton<DeviceInfoUseCase>(
    DeviceInfoUseCase(getIt<DeviceRepository>()),
  );
}

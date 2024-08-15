import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/utils/logger.dart';

class WalletService {
  final Logger logger;
  final _walletBox = HiveDataSource.walletBox;

  WalletService(this.logger);

  // Add a method to initialize default sources
  Future<void> initializeDefaultData() async {
    if (_walletBox.isEmpty) {
      final defaultSources = [
        Wallet(id: 1, name: 'Cash'),
        Wallet(id: 2, name: 'Gopay'),
        Wallet(id: 3, name: 'OVO'),
      ];
      await _walletBox.addAll(defaultSources);
    }
  }

  // Get all sources from the Hive box
  List<Wallet> list() {
    return _walletBox.values.cast<Wallet>().toList();
  }
}

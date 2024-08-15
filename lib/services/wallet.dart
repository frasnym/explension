import 'package:explension/data/core/seeds/seed_values.dart';
import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/utils/logger.dart';

class WalletService {
  final Logger logger;
  final _walletBox = HiveDataSource.walletBox;

  WalletService(this.logger);

  // Add a method to initialize default wallets
  Future<void> initializeDefaultData() async {
    if (_walletBox.isEmpty) {
      await _walletBox.addAll(defaultWallets);
    }
  }

  // Get all wallets from the Hive box
  List<Wallet> list() {
    return _walletBox.values.cast<Wallet>().toList();
  }
}

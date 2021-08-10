import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/domain/usecases/fetch_stores.dart';

class StoresProvider extends BaseProvider {
  final FetchStores _fetchStores;

  bool _isMap = false;
  bool get isMap => _isMap;
  set isMap(bool isMap) {
    _isMap = isMap;
    notifyListeners();
  }

  List<Store> _stores = [];

  List<Store> get stores => [..._stores];

  StoresProvider(this._fetchStores);

  Future<void> fetchStore() async {
    final result = await _fetchStores(NoParams());
    result.fold(
      (failure) =>
          //TODO handling failure here
          null,
      (stores) {
        _stores = stores;
        notifyListeners();
      },
    );
  }

  List<Store> searchStore(String searchString) {
    return stores
        .where((store) => store.address
            .trim()
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList();
  }

  String getStoreNameById(String id) =>
      stores.firstWhere((store) => store.id == id).name;

  Store getStoreById(String id) =>
      stores.firstWhere((store) => store.id == id, orElse: () => null);
}

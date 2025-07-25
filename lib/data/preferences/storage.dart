import 'package:drift/drift.dart';
import '../bank/bank.dart';

class PreferenceStorage extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().map(const MapConverter())();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

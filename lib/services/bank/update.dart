import 'package:dio/dio.dart';
import 'package:lyric/main.dart';

import '../../data/bank/bank.dart';

Future updateBanks() async {
  List<Bank> banks = await getAvailableBanks();
  print('hi');
}

Future<List<Bank>> getAvailableBanks() async {
  Dio dio = Dio();

  List<Map>? protoBanks = (await dio.get<List<Map>>(
    '${constants.apiRoot}/banks',
  )).data;

  print('hi');
  if (protoBanks == null) {
    throw Exception('Nem sikerült lekérni az elérhető daltárakat');
  }

  throw UnimplementedError();
}

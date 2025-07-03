import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:lyric/data/database.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/bank/from_uuid.dart';
import 'package:lyric/services/bank/tempBankSchemas/sofar_kottatar.dart';

import '../../data/bank/bank.dart';

Future updateBanks() async {
  Dio dio = Dio();

  late List protoBanks;
  try {
    protoBanks = (await dio.get<List>('${constants.apiRoot}/banks')).data!;
  } catch (e) {
    throw Exception('Nem sikerült lekérni az elérhető daltárakat: $e');
  }

  for (final protoBank in protoBanks) {
    late Map details;
    /* TODO uncomment when enpoint is ready
    try {
      bankDetails = (await dio.get<Map>('${protoBank['api']}/about')).data!;
    } catch (e) {
      throw Exception(
        'Nem sikerült lekérni a(z) ${protoBank['name']} tár adatait: $e',
      );
    }*/

    details = jsonDecode(sofarKottatarTempData);

    Bank? existingBank = await dbWatchBankWithUuid(details['uuid']).first;

    Uint8List? logo;
    if (details['logo'] != null &&
        (existingBank == null || existingBank.logo == null)) {
      try {
        logo = (await dio.get<Uint8List>(
          details['logo'],
          options: Options(responseType: ResponseType.bytes),
        )).data;
      } catch (_) {}
    } else {
      logo = existingBank?.logo;
    }
    Uint8List? tinyLogo;
    if (details['tinyLogo'] != null &&
        (existingBank == null || existingBank.tinyLogo == null)) {
      try {
        tinyLogo = (await dio.get<Uint8List>(
          details['tinyLogo'],
          options: Options(responseType: ResponseType.bytes),
        )).data;
      } catch (_) {}
    } else {
      tinyLogo = existingBank?.tinyLogo;
    }

    bool isEnabled = false;
    if (existingBank != null) {
      isEnabled = existingBank.isEnabled;
    } else {
      isEnabled = protoBank['defaultEnabled'] ?? false;
    }

    bool offlineMode = existingBank?.isOfflineMode ?? false;

    BanksCompanion banksCompanion = BanksCompanion(
      id: Value.absentIfNull(existingBank?.id),
      uuid: Value(details['uuid']!),
      baseUrl: Value(Uri.parse(protoBank['api'])),
      logo: Value.absentIfNull(logo),
      tinyLogo: Value.absentIfNull(tinyLogo),
      name: Value(details['name']!),
      description: Value.absentIfNull(details['description']),
      legal: Value.absentIfNull(details['legal']),
      parallelUpdateJobs: Value(details['parallelUpdateJobs']!),
      amountOfSongsInRequest: Value(details['amountOfSongsInRequest']!),
      noCms: Value(details['noCms'] ?? false),
      songFields: Value(details['songFields']),
      isEnabled: Value(isEnabled),
      isOfflineMode: Value(offlineMode),
      lastUpdated: Value.absent(),
    );

    await db.into(db.banks).insertOnConflictUpdate(banksCompanion);
  }

  return;
}


import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../config/config.dart';
import '../../data/database.dart';
import 'from_uuid.dart';

import '../../data/bank/bank.dart';
import '../http/html_unescape.dart';

Future updateBanks(Dio dio) async {
  late List<Map<String, dynamic>> protoBanks;
  try {
    final bankData = (await dio.get<List>('${appConfig.apiRoot}/banks')).data!;
    protoBanks = bankData
        .map(
          (bank) => unescapeHtmlMap(
            Map<String, dynamic>.from(
              bank as Map<dynamic, dynamic>,
            ),
          ),
        )
        .toList();
  } catch (e) {
    throw Exception('Nem sikerült lekérni az elérhető daltárakat: $e');
  }

  for (final protoBank in protoBanks) {
    late Map<String, dynamic> details;

    try {
      final detailsData =
          (await dio.get<Map>('${protoBank['api']}/about')).data!;
      details = unescapeHtmlMap(
        Map<String, dynamic>.from(detailsData as Map<dynamic, dynamic>),
      );
    } catch (e) {
      throw Exception(
        'Nem sikerült lekérni a(z) ${protoBank['name']} tár adatait: $e',
      );
    }

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
      aboutLink: Value.absentIfNull(details['aboutLink']),
      contactEmail: Value.absentIfNull(details['contactEmail']),
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

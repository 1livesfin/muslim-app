import 'package:flutter/material.dart';

import '../services/doa_service.dart';

class DoaProvider extends ChangeNotifier {

  final DoaService service =
      DoaService();

  List doa = [];

  Future fetchDoa() async {

    doa = await service.getDoa();

    notifyListeners();
  }
}
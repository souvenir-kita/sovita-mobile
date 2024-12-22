import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/promo/models/promo.dart';

Future<List<Promo>> fetchPromo(CookieRequest request) async {
  final response = await request.get('https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/promo/json_api/');
  var data = response;
  List<Promo> listPromo = [];
  for (var d in data) {
    if (d != null) {
      listPromo.add(Promo.fromJson(d));
    }
  }
  return listPromo;
}

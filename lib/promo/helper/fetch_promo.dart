import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/promo/models/promo.dart';

Future<List<Promo>> fetchPromo(CookieRequest request) async {
  final response = await request.get('http://127.0.0.1:8000/promo/json_api/');
  var data = response;
  List<Promo> listPromo = [];
  for (var d in data) {
    if (d != null) {
      listPromo.add(Promo.fromJson(d));
    }
  }
  return listPromo;
}

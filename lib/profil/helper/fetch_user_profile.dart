import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/profil/model/user_profil.dart';

Future<UserProfile> fetchUserProfile(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/authentication/user-profile/');
    return UserProfile.fromJson(response);
  } catch (e) {
    throw Exception("Failed to fetch user: $e");
  }
}

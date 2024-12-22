import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/adminview/screens/adminmain.dart';
import 'package:sovita/auth/screens/login.dart';
import 'package:sovita/profil/helper/fetch_user_profile.dart';
import 'package:sovita/profil/model/user_profil.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/screens/promo_screen.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isAdmin = request.cookies.containsKey("isAdmin") &&
        request.cookies["isAdmin"]!.value == "1";
    return Scaffold(
      body: FutureBuilder<UserProfile>(
        future: fetchUserProfile(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFFF09027),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            UserProfile userProfile = snapshot.data!;

            return Container(
              // Container ini untuk memastikan gradiennya merata
              height: double.infinity, // Pastikan tinggi penuh
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF09027),
                    Color(0xFF8CBEAA),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userProfile.username,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isAdmin ? "Admin" : "Pengguna",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: const Color(0x80D9D9D9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      _buildCollapsibleInfo(userProfile),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Konten lainnya
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Divider(color: Colors.white30),
                          const SizedBox(height: 5),
                          if (isAdmin) ...[
                            _ProfileListTile(
                              icon: Icons.admin_panel_settings,
                              title: "AdminView",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AdminPage()),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _ProfileListTile(
                              icon: Icons.discount,
                              title: "Kelola Promo",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PromoPage()),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 10),
                          _ProfileListTile(
                            icon: Icons.settings_outlined,
                            title: "Pengaturan",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          _ProfileListTile(
                            icon: Icons.help_outline,
                            title: "Bantuan & FAQ",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          _ProfileListTile(
                            icon: Icons.info_outline,
                            title: "Tentang Kami",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          _ProfileListTile(
                            icon: Icons.logout,
                            title: "Keluar",
                            textColor: const Color.fromARGB(255, 248, 0, 0),
                            iconColor: const Color.fromARGB(255, 248, 0, 0),
                            onTap: () async {
                              final response = await request.logout(
                                  "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/authentication/api-logout/");
                              String message = response["message"];
                              if (context.mounted) {
                                if (response['status']) {
                                  request.cookies.remove("isAdmin");
                                  String uname = response["username"];
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("$message Sampai jumpa, $uname."),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildCollapsibleInfo(UserProfile userProfile) {
    return ExpansionTile(
      title: const Text(
        "Informasi Pribadi",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      children: [
        _buildInfoRow("Umur", userProfile.age.toString()),
        const SizedBox(height: 12),
        _buildInfoRow("Alamat", userProfile.address),
        const SizedBox(height: 12),
        _buildInfoRow("No Telp", userProfile.phoneNumber),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ProfileListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        color: Color(0x80D9D9D9),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor ?? Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}

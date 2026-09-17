import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/therapist_profile_model.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final TherapistProfileModel profile;
  final VoidCallback onProfileUpdated;
  final bool isNepali;

  const ProfilePage({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBF8),
        elevation: 0,
        title: Text(
          isNepali ? 'प्रोफाइल विवरण' : 'Profile Details',
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2A2E),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E2A2E)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF2F5D50)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    profile: profile,
                    onProfileUpdated: onProfileUpdated,
                    isNepali: isNepali,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD1E8D5),
                      border: Border.all(color: const Color(0xFF2F5D50), width: 2),
                      image: DecorationImage(
                        image: NetworkImage(profile.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      profile.specialization,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2F5D50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E2A2E).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileRow(Icons.email_outlined, isNepali ? 'इमेल' : 'Email', profile.email),
                  const Divider(color: Color(0xFFEEF1EE), height: 24),
                  _buildProfileRow(Icons.phone_outlined, isNepali ? 'फोन नम्बर' : 'Phone', profile.phone),
                  const Divider(color: Color(0xFFEEF1EE), height: 24),
                  _buildProfileRow(Icons.work_outline, isNepali ? 'अनुभव' : 'Experience', profile.experience),
                  const Divider(color: Color(0xFFEEF1EE), height: 24),
                  _buildProfileRow(Icons.location_on_outlined, isNepali ? 'ठेगाना' : 'Address', profile.address),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8FA8A0)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.ibmPlexMono(fontSize: 11, color: const Color(0xFF8FA8A0)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E2A2E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
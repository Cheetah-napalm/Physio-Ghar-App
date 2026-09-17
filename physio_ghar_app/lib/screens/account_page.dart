import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(therapistProvider);
    final profile = appState.profile;
    final isNepali = appState.isNepali;
    final complaints = appState.complaints;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNepali ? 'खाता सेटिङहरू' : 'Account & Profile',
                style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.secondary,
                      backgroundImage: NetworkImage(profile.imageUrl),
                      onBackgroundImageError: (e, s) {},
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.name, style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(profile.specialization, style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(profile.email, style: GoogleFonts.ibmPlexMono(fontSize: 11, color: AppColors.textSubtle)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _showEditProfileDialog(context, ref),
                  child: Text(isNepali ? 'प्रोफाइल सम्पादन गर्नुहोस्' : 'Edit Profile', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Language / भाषा (नेपाली)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMain)),
                    Switch(
                      value: isNepali,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        ref.read(therapistProvider.notifier).toggleLanguage(val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                isNepali ? 'सहायता तथा गुनासो' : 'Support & Complaints',
                style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _showComplaintDialog(context, ref),
                  child: Text(isNepali ? 'गुनासो पेश गर्नुहोस्' : 'Submit Complaint / Issue', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              if (complaints.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Success State: Submitted Reports (${complaints.length})', style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(therapistProvider).profile;
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile', style: GoogleFonts.fraunces(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: AppSpacing.md),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final updated = profile.copyWith(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                );
                ref.read(therapistProvider.notifier).updateProfile(updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated successfully!')),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showComplaintDialog(BuildContext context, WidgetRef ref) {
    final complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Submit Complaint', style: GoogleFonts.fraunces(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: complaintController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Describe your issue or feedback...'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                if (complaintController.text.trim().isNotEmpty) {
                  ref.read(therapistProvider.notifier).submitComplaint(complaintController.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Success State: Complaint submitted successfully!')),
                  );
                }
              },
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
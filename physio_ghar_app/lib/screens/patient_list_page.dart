import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/patient_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_states_view.dart';

class PatientListPage extends ConsumerWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(therapistProvider);
    final patientsList = appState.patients;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patients Record',
                style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'View history and add clinical session notes.',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSubtle),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: patientsList.isEmpty
                    ? const AppEmptyState(message: 'No patient records found.')
                    : ListView.separated(
                        itemCount: patientsList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final patient = patientsList[index];
                          return Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(patient.name, style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                                    Text('${patient.gender}, ${patient.age} yrs', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSubtle)),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Condition: ${patient.condition}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                                const SizedBox(height: AppSpacing.sm),
                                Text('Contact: ${patient.contact}', style: GoogleFonts.ibmPlexMono(fontSize: 11, color: AppColors.primary)),
                                const SizedBox(height: AppSpacing.md),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () => _showAddNoteBottomSheet(context, ref, patient.id),
                                    icon: const Icon(Icons.note_add_outlined, size: 16, color: AppColors.primary),
                                    label: Text('Add Note', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context, WidgetRef ref, String patientId) {
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Session Note', style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Enter clinical observations...'),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, elevation: 0),
                  onPressed: () {
                    if (noteController.text.trim().isNotEmpty) {
                      final newNote = SessionNoteModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        date: 'Today',
                        note: noteController.text.trim(),
                        exercises: ['Stretching', 'Core Stability'],
                        nextSessionPlan: 'Continue progression',
                      );
                      ref.read(therapistProvider.notifier).addSessionNote(patientId, newNote);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note Saved Successfully!')),
                      );
                    }
                  },
                  child: const Text('Save Note', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
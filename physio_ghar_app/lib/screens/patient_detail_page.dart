import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/patient_model.dart';

class PatientDetailPage extends StatefulWidget {
  final PatientModel patient;
  final VoidCallback onPatientUpdated;

  const PatientDetailPage({
    super.key,
    required this.patient,
    required this.onPatientUpdated,
  });

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBF8),
        elevation: 0,
        title: Text(
          widget.patient.name,
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2A2E),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E2A2E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientBioCard(),
            const SizedBox(height: 20),
            _buildSectionHeader('Treatment History', Icons.medical_services_outlined),
            const SizedBox(height: 8),
            _buildTreatmentHistoryCard(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Session Notes', Icons.note_alt_outlined),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5D50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () => _showAddOrEditNoteModal(context, null),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text('Add Note', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            widget.patient.sessionNotes.isEmpty
                ? _buildNoNotesPlaceholder()
                : ListView.separated(
                    itemCount: widget.patient.sessionNotes.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildNoteCard(widget.patient.sessionNotes[index], index);
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientBioCard() {
    return Container(
      padding: const EdgeInsets.all(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.patient.name,
                style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1E8D5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.patient.condition,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2F5D50)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFEEF1EE), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildBioItem('Age', '${widget.patient.age} yrs')),
              Expanded(child: _buildBioItem('Gender', widget.patient.gender)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildBioItem('Contact', widget.patient.contact)),
              Expanded(child: _buildBioItem('Last Session', widget.patient.lastSessionDate)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBioItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.ibmPlexMono(fontSize: 11, color: const Color(0xFF8FA8A0))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E2A2E))),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2F5D50)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
        ),
      ],
    );
  }

  Widget _buildTreatmentHistoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF1EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.patient.treatmentHistory.map((historyItem) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Color(0xFF2F5D50), fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    historyItem,
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5854)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoteCard(SessionNoteModel note, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF1EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.date,
                style: GoogleFonts.ibmPlexMono(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2F5D50)),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF8FA8A0)),
                onPressed: () => _showAddOrEditNoteModal(context, note, noteIndex: index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.note,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E2A2E)),
          ),
          const SizedBox(height: 10),
          Text('Exercises:', style: GoogleFonts.ibmPlexMono(fontSize: 11, color: const Color(0xFF8FA8A0))),
          const SizedBox(height: 4),
          ...note.exercises.map((ex) => Text('• $ex', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5854)))),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next Session Plan:', style: GoogleFonts.ibmPlexMono(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF2F5D50))),
                const SizedBox(height: 2),
                Text(note.nextSessionPlan, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF1E2A2E))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoNotesPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF1EE)),
      ),
      child: Text('No session notes recorded yet.', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8FA8A0))),
    );
  }

  void _showAddOrEditNoteModal(BuildContext context, SessionNoteModel? existingNote, {int? noteIndex}) {
    final TextEditingController noteController = TextEditingController(text: existingNote?.note ?? '');
    final TextEditingController exerciseController = TextEditingController(text: existingNote?.exercises.join(', ') ?? '');
    final TextEditingController nextSessionController = TextEditingController(text: existingNote?.nextSessionPlan ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFBFBF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingNote == null ? 'Add Session Note' : 'Edit Session Note',
                  style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Session Remarks / Patient Progress',
                    labelStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5854)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: exerciseController,
                  decoration: InputDecoration(
                    labelText: 'Exercises (comma separated)',
                    hintText: 'e.g., Knee flexion, Stretching',
                    labelStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5854)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nextSessionController,
                  decoration: InputDecoration(
                    labelText: 'Next Session Plan',
                    hintText: 'e.g., Continue strengthening exercises',
                    labelStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5854)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F5D50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      if (noteController.text.trim().isNotEmpty) {
                        List<String> parsedExercises = exerciseController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        setState(() {
                          if (existingNote == null) {
                            final newNote = SessionNoteModel(
                              id: DateTime.now().toString(),
                              date: '15 Sept 2026',
                              note: noteController.text.trim(),
                              exercises: parsedExercises.isEmpty ? ['Standard Routine'] : parsedExercises,
                              nextSessionPlan: nextSessionController.text.trim().isEmpty ? 'Regular review' : nextSessionController.text.trim(),
                            );
                            widget.patient.sessionNotes.insert(0, newNote);
                          } else if (noteIndex != null) {
                            // Using copyWith to safely replace immutable session note fields
                            widget.patient.sessionNotes[noteIndex] = existingNote.copyWith(
                              note: noteController.text.trim(),
                              exercises: parsedExercises.isEmpty ? ['Standard Routine'] : parsedExercises,
                              nextSessionPlan: nextSessionController.text.trim(),
                            );
                          }
                        });
                        widget.onPatientUpdated();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      existingNote == null ? 'Save Note' : 'Update Note',
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
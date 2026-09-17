import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_state_models.dart';
import '../models/patient_model.dart';
import '../models/therapist_profile_model.dart';

class TherapistAppState {
  final List<SessionItem> sessions;
  final List<PatientModel> patients;
  final TherapistProfileModel profile;
  final bool isNepali;
  final List<String> blockedSlots;
  final List<String> complaints;

  TherapistAppState({
    required this.sessions,
    required this.patients,
    required this.profile,
    required this.isNepali,
    required this.blockedSlots,
    required this.complaints,
  });

  TherapistAppState copyWith({
    List<SessionItem>? sessions,
    List<PatientModel>? patients,
    TherapistProfileModel? profile,
    bool? isNepali,
    List<String>? blockedSlots,
    List<String>? complaints,
  }) {
    return TherapistAppState(
      sessions: sessions ?? this.sessions,
      patients: patients ?? this.patients,
      profile: profile ?? this.profile,
      isNepali: isNepali ?? this.isNepali,
      blockedSlots: blockedSlots ?? this.blockedSlots,
      complaints: complaints ?? this.complaints,
    );
  }
}

class TherapistNotifier extends StateNotifier<TherapistAppState> {
  TherapistNotifier()
      : super(TherapistAppState(
          sessions: [
            SessionItem(
              id: 'req_1',
              time: 'Tomorrow, 11:00 AM',
              patientName: 'Gita Karki',
              treatment: 'Post-Stroke Mobility',
              location: 'Home Visit',
              status: 'Request',
            ),
            SessionItem(
              id: 'up_1',
              time: 'Today, 4:00 PM',
              patientName: 'Sita Sharma',
              treatment: 'Lower Back Pain Therapy',
              location: 'Clinic Consultation',
              status: 'Upcoming',
            ),
          ],
          patients: [
            PatientModel(
              id: 'p_1',
              name: 'Sita Sharma',
              age: 42,
              gender: 'Female',
              contact: '+977 9812345678',
              condition: 'Lower Back Pain',
              lastSessionDate: '10 Sept 2026',
              treatmentHistory: ['Initial Assessment & Posture Correction'],
              sessionNotes: [
                SessionNoteModel(
                  id: 'note_1',
                  date: '10 Sept 2026',
                  note: 'Patient showed good compliance with stretches.',
                  exercises: ['Cat-Cow Stretch', 'Pelvic Tilts'],
                  nextSessionPlan: 'Introduce core strengthening.',
                ),
              ],
            ),
          ],
          profile: TherapistProfileModel(
            name: 'Dr. Anjali Ray',
            email: 'anjali.ray@physioghar.com',
            phone: '+977 9841234567',
            experience: '8+ Years Experience',
            specialization: 'Senior Physiotherapist',
            address: 'Kathmandu, Nepal',
            imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200',
          ),
          isNepali: false,
          blockedSlots: [],
          complaints: [],
        ));

  void acceptBooking(String sessionId) {
    state = state.copyWith(
      sessions: state.sessions.map((session) {
        if (session.id == sessionId) {
          return session.copyWith(status: 'Upcoming');
        }
        return session;
      }).toList(),
    );
  }

  void rejectBooking(String sessionId) {
    state = state.copyWith(
      sessions: state.sessions.where((s) => s.id != sessionId).toList(),
    );
  }

  void completeSession(String sessionId) {
    state = state.copyWith(
      sessions: state.sessions.map((session) {
        if (session.id == sessionId) {
          return session.copyWith(status: 'Completed');
        }
        return session;
      }).toList(),
    );
  }

  void blockSlot(String slotDateTime) {
    if (!state.blockedSlots.contains(slotDateTime)) {
      state = state.copyWith(
        blockedSlots: [...state.blockedSlots, slotDateTime],
      );
    }
  }

  void unblockSlot(String slotDateTime) {
    state = state.copyWith(
      blockedSlots: state.blockedSlots.where((slot) => slot != slotDateTime).toList(),
    );
  }

  void addSessionNote(String patientId, SessionNoteModel note) {
    state = state.copyWith(
      patients: state.patients.map((patient) {
        if (patient.id == patientId) {
          final updatedNotes = [note, ...patient.sessionNotes];
          return PatientModel(
            id: patient.id,
            name: patient.name,
            age: patient.age,
            gender: patient.gender,
            contact: patient.contact,
            condition: patient.condition,
            lastSessionDate: patient.lastSessionDate,
            treatmentHistory: patient.treatmentHistory,
            sessionNotes: updatedNotes,
          );
        }
        return patient;
      }).toList(),
    );
  }

  void updateProfile(TherapistProfileModel updatedProfile) {
    state = state.copyWith(profile: updatedProfile);
  }

  void submitComplaint(String complaintDetails) {
    state = state.copyWith(
      complaints: [...state.complaints, complaintDetails],
    );
  }

  void toggleLanguage(bool isNepaliVal) {
    state = state.copyWith(isNepali: isNepaliVal);
  }
}

final therapistProvider = StateNotifierProvider<TherapistNotifier, TherapistAppState>(
  (ref) => TherapistNotifier(),
);
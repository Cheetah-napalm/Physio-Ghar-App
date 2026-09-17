import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/session_model.dart';

class BookingManagementPage extends StatefulWidget {
  final List<SessionModel> sessionsList;
  final VoidCallback onStateChanged;

  const BookingManagementPage({
    super.key,
    required this.sessionsList,
    required this.onStateChanged,
  });

  @override
  State<BookingManagementPage> createState() => _BookingManagementPageState();
}

class _BookingManagementPageState extends State<BookingManagementPage> {
  String activeTab = 'Requests';

  @override
  Widget build(BuildContext context) {
    List<SessionModel> filteredList = widget.sessionsList.where((s) {
      if (activeTab == 'Requests') return s.status == 'Request';
      if (activeTab == 'Upcoming') return s.status == 'Upcoming';
      if (activeTab == 'Completed') return s.status == 'Completed';
      if (activeTab == 'Cancelled') return s.status == 'Cancelled';
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBF8),
        elevation: 0,
        title: Text(
          'Booking & Sessions',
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2A2E),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E2A2E)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildSessionCard(filteredList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTabs() {
    List<String> tabs = ['Requests', 'Upcoming', 'Completed', 'Cancelled'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          bool isActive = activeTab == tab;
          int count = widget.sessionsList.where((s) {
            if (tab == 'Requests') return s.status == 'Request';
            if (tab == 'Upcoming') return s.status == 'Upcoming';
            if (tab == 'Completed') return s.status == 'Completed';
            if (tab == 'Cancelled') return s.status == 'Cancelled';
            return false;
          }).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => setState(() => activeTab = tab),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2F5D50) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive ? const Color(0xFF2F5D50) : const Color(0xFFDFE3E1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      tab,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : const Color(0xFF4A5854),
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFEEF1EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : const Color(0xFF2F5D50),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSessionCard(SessionModel session) {
    Color badgeBg = const Color(0xFFEEF1EE);
    Color badgeTextColor = const Color(0xFF2F5D50);

    if (session.status == 'Request') {
      badgeBg = const Color(0xFFFBEFDF);
      badgeTextColor = const Color(0xFFE2962F);
    } else if (session.status == 'Cancelled') {
      badgeBg = const Color(0xFFFCE8E8);
      badgeTextColor = const Color(0xFFC84B48);
    } else if (session.status == 'Completed') {
      badgeBg = const Color(0xFFD1E8D5);
      badgeTextColor = const Color(0xFF2F5D50);
    }

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  session.time,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F5D50),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  session.status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            session.patientName,
            style: GoogleFonts.fraunces(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E2A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            session.treatment,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF4A5854),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEEF1EE), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF8FA8A0)),
              const SizedBox(width: 6),
              Text(
                session.location,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF8FA8A0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _buildCardActionButtons(session),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardActionButtons(SessionModel session) {
    if (session.status == 'Request') {
      return Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC84B48),
              minimumSize: const Size(44, 36),
            ),
            onPressed: () {
              setState(() => session.status = 'Cancelled');
              widget.onStateChanged();
              _showFeedbackMessage('Booking request declined.');
            },
            child: Text('Decline', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F5D50),
              minimumSize: const Size(44, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            onPressed: () {
              setState(() => session.status = 'Upcoming');
              widget.onStateChanged();
              _showFeedbackMessage('Request accepted! Moved to Upcoming.');
            },
            child: Text('Accept', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      );
    } else if (session.status == 'Upcoming') {
      return Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(44, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              side: const BorderSide(color: Color(0xFF2F5D50)),
            ),
            onPressed: () => _showRescheduleDialog(session),
            child: Text('Reschedule', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2F5D50))),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F5D50),
              minimumSize: const Size(44, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            onPressed: () => _showCompleteSessionModal(session),
            child: Text('Complete', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      );
    } else {
      return TextButton(
        onPressed: () => _showSessionDetailsModal(session),
        child: Text('View Details →', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF2F5D50))),
      );
    }
  }

  void _showCompleteSessionModal(SessionModel session) {
    final TextEditingController notesController = TextEditingController();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Session',
                style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
              ),
              const SizedBox(height: 8),
              Text('Patient: ${session.patientName} (${session.treatment})', style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0))),
              const SizedBox(height: 20),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Therapist Remarks / Notes',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF4A5854)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEEF1EE)),
                  ),
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
                    setState(() {
                      session.status = 'Completed';
                      session.therapistNotes = notesController.text.trim().isEmpty 
                          ? 'Session completed successfully with routine follow-up advice.' 
                          : notesController.text.trim();
                    });
                    widget.onStateChanged();
                    Navigator.pop(context);
                    _showFeedbackMessage('Session successfully completed and logged.');
                  },
                  child: Text('Save & Finish Session', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRescheduleDialog(SessionModel session) {
    String newTimeInput = session.time;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFBFBF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reschedule Session',
                style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'New Date & Time (e.g., Thursday, 3:00 PM)',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF4A5854)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (val) => newTimeInput = val,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5D50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    if (newTimeInput.isNotEmpty) {
                      setState(() {
                        session.time = newTimeInput;
                      });
                      widget.onStateChanged();
                      Navigator.pop(context);
                      _showFeedbackMessage('Session rescheduled successfully.');
                    }
                  },
                  child: Text('Confirm New Time', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSessionDetailsModal(SessionModel session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFBFBF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Session Summary',
                    style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E2A2E)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF4A5854)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Patient', session.patientName),
              _buildDetailRow('Treatment', session.treatment),
              _buildDetailRow('Date / Time', session.time),
              _buildDetailRow('Status', session.status.toUpperCase()),
              _buildDetailRow('Location', session.location),
              const SizedBox(height: 12),
              Text('Therapist Remarks / Notes:', style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0))),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEEF1EE)),
                ),
                child: Text(
                  session.therapistNotes ?? 'No notes provided for this session.',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5854)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0))),
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E2A2E))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined, size: 48, color: Color(0xFF8FA8A0)),
          const SizedBox(height: 12),
          Text(
            'No items found under "$activeTab".',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF4A5854)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFF2F5D50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
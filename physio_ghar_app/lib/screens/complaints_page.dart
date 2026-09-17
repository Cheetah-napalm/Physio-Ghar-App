import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/complaint_model.dart';
import 'submit_complaint_page.dart';

class ComplaintsPage extends StatefulWidget {
  final bool isNepali;

  const ComplaintsPage({super.key, required this.isNepali});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final List<ComplaintModel> _complaints = [
    ComplaintModel(
      id: 'c_1',
      category: 'Payment Issue',
      subject: 'Delayed settlement for Aug session',
      description: 'The payout for the session completed on 28 Aug has not reflected yet.',
      dateSubmitted: '30 Aug 2026',
      status: 'In Review',
    ),
  ];

  void _addNewComplaint(ComplaintModel complaint) {
    setState(() {
      _complaints.insert(0, complaint);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBF8),
        elevation: 0,
        title: Text(
          widget.isNepali ? 'गुनासो र समस्याहरू' : 'Complaints & Issues',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isNepali ? 'तपाईंका रिपोर्ट गरिएका मुद्दाहरू' : 'Your Submitted Issues',
                  style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5D50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitComplaintPage(
                          onComplaintSubmitted: _addNewComplaint,
                          isNepali: widget.isNepali,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    widget.isNepali ? 'नयाँ रिपोर्ट' : 'New Report',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _complaints.isEmpty
                  ? Center(
                      child: Text(
                        widget.isNepali ? 'कुनै गुनासो दर्ता गरिएको छैन।' : 'No complaints reported yet.',
                        style: GoogleFonts.inter(color: const Color(0xFF8FA8A0)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _complaints.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final complaint = _complaints[index];
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
                                      complaint.category,
                                      style: GoogleFonts.ibmPlexMono(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2F5D50)),
                                    ),
                                  ),
                                  Text(
                                    complaint.dateSubmitted,
                                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8FA8A0)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                complaint.subject,
                                style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1E2A2E)),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                complaint.description,
                                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5854)),
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: Color(0xFFEEF1EE), height: 1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Status: ',
                                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8FA8A0)),
                                  ),
                                  Text(
                                    complaint.status,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: complaint.status == 'Resolved' ? const Color(0xFF2F5D50) : const Color(0xFFC84B48),
                                    ),
                                  ),
                                ],
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
    );
  }
}
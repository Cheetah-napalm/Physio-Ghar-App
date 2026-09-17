import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/complaint_model.dart';

class SubmitComplaintPage extends StatefulWidget {
  final Function(ComplaintModel) onComplaintSubmitted;
  final bool isNepali;

  const SubmitComplaintPage({
    super.key,
    required this.onComplaintSubmitted,
    required this.isNepali,
  });

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Patient Issue';
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Patient Issue',
    'Booking Issue',
    'Payment Issue',
    'Technical Issue',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newComplaint = ComplaintModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        dateSubmitted: '15 Sept 2026', // Current mock date
      );

      widget.onComplaintSubmitted(newComplaint);
      Navigator.pop(context);

      // Success Confirmation Dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBF8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2F5D50), size: 24),
                const SizedBox(width: 8),
                Text(
                  widget.isNepali ? 'सफलता' : 'Success',
                  style: GoogleFonts.fraunces(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Text(
              widget.isNepali
                  ? 'तपाईको गुनासो सफलतापूर्वक दर्ता भयो। प्रशासक टोलीले यसको समीक्षा गर्नेछ।'
                  : 'Your complaint has been successfully submitted. The admin team will review it shortly.',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5854)),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F5D50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  widget.isNepali ? 'ঠিক छ' : 'OK',
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBF8),
        elevation: 0,
        title: Text(
          widget.isNepali ? 'समस्या रिपोर्ट गर्नुहोस्' : 'Report an Issue',
          style: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2A2E),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E2A2E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isNepali ? 'गुनासो श्रेणी चयन गर्नुहोस्' : 'Select Complaint Category',
                style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEF1EE)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1E2A2E)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isNepali ? 'विषय' : 'Subject',
                style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: 'e.g., Issue with payout settlement',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8FA8A0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEEF1EE))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEEF1EE))),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                widget.isNepali ? 'विवरण' : 'Description',
                style: GoogleFonts.ibmPlexMono(fontSize: 12, color: const Color(0xFF8FA8A0)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Provide details about the problem you are facing...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8FA8A0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEEF1EE))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEEF1EE))),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5D50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    widget.isNepali ? 'गुनासो पेस गर्नुहोस्' : 'Submit Complaint',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
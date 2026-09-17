import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../models/app_state_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_states_view.dart';

class TherapistDashboardScreen extends ConsumerWidget {
  const TherapistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(therapistProvider);
    final isNepali = appState.isNepali;

    final requests = appState.sessions.where((s) => s.status == 'Request').toList();
    final upcomingSessions = appState.sessions.where((s) => s.status == 'Upcoming').toList();
    final completedSessions = appState.sessions.where((s) => s.status == 'Completed').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNepali ? 'स्वागत छ, डा. अञ्जली' : 'Welcome back,',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSubtle),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        appState.profile.name,
                        style: GoogleFonts.fraunces(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                      image: DecorationImage(
                        image: NetworkImage(appState.profile.imageUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                    child: appState.profile.imageUrl.isEmpty
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Booking Requests
              Text(
                isNepali ? 'बुकिङ अनुरोधहरू (${requests.length})' : 'Booking Requests (${requests.length})',
                style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.md),
              requests.isEmpty
                  ? AppEmptyState(
                      message: isNepali ? 'कुनै नयाँ अनुरोध छैन।' : 'No pending booking requests.',
                      icon: Icons.notifications_none_outlined,
                    )
                  : ListView.separated(
                      itemCount: requests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) => _buildRequestCard(context, ref, requests[index], isNepali),
                    ),

              const SizedBox(height: AppSpacing.xxl),

              // Upcoming Sessions
              Text(
                isNepali ? 'आगामी सत्रहरू' : 'Upcoming Sessions',
                style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.md),
              upcomingSessions.isEmpty
                  ? AppEmptyState(
                      message: isNepali ? 'कुनै आगामी सत्र छैन।' : 'No upcoming sessions scheduled.',
                      icon: Icons.event_busy_outlined,
                    )
                  : ListView.separated(
                      itemCount: upcomingSessions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) => _buildUpcomingCard(context, ref, upcomingSessions[index], isNepali),
                    ),

              const SizedBox(height: AppSpacing.xxl),

              // Completed Sessions
              Text(
                isNepali ? 'सम्पन्न सत्रहरू' : 'Completed Sessions',
                style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.md),
              completedSessions.isEmpty
                  ? AppEmptyState(
                      message: isNepali ? 'कुनै सम्पन्न सत्र छैन।' : 'No completed sessions recorded.',
                      icon: Icons.done_all,
                    )
                  : ListView.separated(
                      itemCount: completedSessions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) => _buildCompletedCard(completedSessions[index]),
                    ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, WidgetRef ref, SessionItem request, bool isNepali) {
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
              Text(request.patientName, style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accentYellow, borderRadius: BorderRadius.circular(12)),
                child: Text(request.time, style: GoogleFonts.ibmPlexMono(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accentYellowText)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('${request.treatment} • ${request.location}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    ref.read(therapistProvider.notifier).rejectBooking(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking rejected.')));
                  },
                  child: Text(isNepali ? 'अस्वीकार' : 'Decline', style: GoogleFonts.inter(fontSize: 12, color: AppColors.error)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    ref.read(therapistProvider.notifier).acceptBooking(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking accepted -> Moved to Upcoming!')));
                  },
                  child: Text(isNepali ? 'स्वीकार गर्नुहोस्' : 'Accept', style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, WidgetRef ref, SessionItem session, bool isNepali) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.event_available, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.patientName, style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(session.treatment, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(session.time, style: GoogleFonts.ibmPlexMono(fontSize: 11, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ref.read(therapistProvider.notifier).completeSession(session.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session completed successfully -> Moved to Completed!')),
                );
              },
              child: Text(isNepali ? 'सत्र समाप्त गर्नुहोस्' : 'Complete Session', style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(SessionItem session) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(session.patientName, style: GoogleFonts.fraunces(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMain)),
              const SizedBox(height: AppSpacing.xs),
              Text(session.treatment, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
            child: Text('Completed', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
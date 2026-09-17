import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ScheduleAvailabilityScreen extends ConsumerWidget {
  const ScheduleAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(therapistProvider);
    final blockedSlots = appState.blockedSlots;

    final List<String> timeSlots = [
      '09:00 AM - 10:00 AM',
      '10:30 AM - 11:30 AM',
      '02:00 PM - 03:00 PM',
      '04:00 PM - 05:00 PM',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule & Availability',
                style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Block or unblock clinic and home visit time slots.',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSubtle),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: timeSlots.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final slot = timeSlots[index];
                    final isBlocked = blockedSlots.contains(slot);

                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isBlocked ? AppColors.error.withValues(alpha: 0.5) : AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isBlocked ? Icons.block : Icons.access_time,
                                color: isBlocked ? AppColors.error : AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(slot, style: GoogleFonts.fraunces(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    isBlocked ? 'Slot Blocked' : 'Available for Booking',
                                    style: GoogleFonts.inter(fontSize: 12, color: isBlocked ? AppColors.error : AppColors.success),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: isBlocked,
                            activeThumbColor: AppColors.error,
                            onChanged: (val) {
                              if (val) {
                                ref.read(therapistProvider.notifier).blockSlot(slot);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot Blocked successfully!')));
                              } else {
                                ref.read(therapistProvider.notifier).unblockSlot(slot);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot unblocked!')));
                              }
                            },
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
}
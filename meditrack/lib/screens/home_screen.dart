import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medication_provider.dart';
import 'add_medication_screen.dart';
import '../services/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meds = context.watch<MedicationProvider>().medications;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background glow orbs
          Positioned(
            top: -60,
            right: -80,
            child: _GlowOrb(color: const Color(0xFF3B5BDB), size: 240),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: _GlowOrb(color: const Color(0xFF1A3A5C), size: 200),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Brand mark
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4C6EF5), Color(0xFF748FFC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4C6EF5).withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'MediTrack',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      // Logout button
                      GestureDetector(
                        onTap: () {
                          context.read<AuthProvider>().logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.logout,
                            color: Colors.white.withOpacity(0.6),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Title + count ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your\nMedications',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meds.isEmpty
                            ? 'No medications added yet'
                            : '${meds.length} medication${meds.length == 1 ? '' : 's'} tracked',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── List or empty state ───────────────────────────────
                Expanded(
                  child: meds.isEmpty
                      ? _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 4, 24, 100),
                          itemCount: meds.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final med = meds[index];
                            return _MedCard(
                              med: med,
                              index: index,
                              onDelete: () => context
                                  .read<MedicationProvider>()
                                  .removeMedication(med),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // ── FAB ────────────────────────────────────────────────────
          Positioned(
            right: 24,
            bottom: 32,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddMedicationScreen()),
              ),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4C6EF5), Color(0xFF748FFC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4C6EF5).withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Medication card ──────────────────────────────────────────────────────────

class _MedCard extends StatelessWidget {
  final dynamic med;
  final int index;
  final VoidCallback onDelete;

  // Cycle through accent colors for variety
  static const _accents = [
    Color(0xFF4C6EF5),
    Color(0xFF7950F2),
    Color(0xFF1C7ED6),
    Color(0xFF0CA678),
    Color(0xFFE8590C),
  ];

  const _MedCard({
    required this.med,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accents[index % _accents.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          // Left accent strip + icon
          Container(
            width: 56,
            height: 72,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            child: Icon(Icons.medical_services, color: accent, size: 24),
          ),

          const SizedBox(width: 16),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    med.dosage,
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white.withOpacity(0.25),
              size: 20,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(
              Icons.medical_services,
              color: Colors.white.withOpacity(0.2),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No medications yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first medication',
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background glow orb ──────────────────────────────────────────────────────

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.35), Colors.transparent],
        ),
      ),
    );
  }
}
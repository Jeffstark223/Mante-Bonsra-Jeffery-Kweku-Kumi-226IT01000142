import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medication_provider.dart';
import '../models/medication.dart';
import 'package:uuid/uuid.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final List<String> _times = ['08:00', '20:00'];
  String? _nameError;
  String? _dosageError;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void addMedication() {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? 'Please enter a name' : null;
      _dosageError =
          _dosageController.text.trim().isEmpty ? 'Please enter a dosage' : null;
    });

    if (_nameError != null || _dosageError != null) return;

    final med = Medication(
      id: Uuid().v4(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      times: List.from(_times),
    );
    context.read<MedicationProvider>().addMedication(med);
    Navigator.pop(context);
  }

  Future<void> _pickTime(int index) async {
    final parts = _times[index].split(':');
    final initial = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4C6EF5),
              onPrimary: Colors.white,
              surface: Color(0xFF141928),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF141928),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _times[index] =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _addTime() {
    setState(() => _times.add('12:00'));
  }

  void _removeTime(int index) {
    if (_times.length > 1) {
      setState(() => _times.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background glow orbs
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(color: const Color(0xFF3B5BDB), size: 240),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: _GlowOrb(color: const Color(0xFF1A3A5C), size: 200),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 24, 0),
                      child: Row(
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
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
                                Icons.arrow_back_ios,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Title ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon mark
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4C6EF5), Color(0xFF748FFC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF4C6EF5).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Add\nMedication',
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
                            'Fill in the details below',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Form ───────────────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name field
                            _StyledTextField(
                              controller: _nameController,
                              label: 'Medication Name',
                              icon: Icons.local_pharmacy,
                              errorText: _nameError,
                            ),

                            const SizedBox(height: 16),

                            // Dosage field
                            _StyledTextField(
                              controller: _dosageController,
                              label: 'Dosage (e.g. 500mg)',
                              icon: Icons.science,
                              errorText: _dosageError,
                            ),

                            const SizedBox(height: 28),

                            // Reminder times section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reminder Times',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _addTime,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4C6EF5)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF4C6EF5)
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.add,
                                            color: Color(0xFF748FFC), size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add time',
                                          style: TextStyle(
                                            color: Color(0xFF748FFC),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            ..._times.asMap().entries.map((entry) {
                              final i = entry.key;
                              final time = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () => _pickTime(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4C6EF5)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.access_time,
                                            color: Color(0xFF748FFC),
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Text(
                                          _formatTime(time),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (_times.length > 1)
                                          GestureDetector(
                                            onTap: () => _removeTime(i),
                                            child: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.white
                                                  .withOpacity(0.25),
                                              size: 20,
                                            ),
                                          ),
                                        if (_times.length == 1)
                                          Icon(
                                            Icons.chevron_right,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 32),

                            // Add button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4C6EF5),
                                      Color(0xFF748FFC)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4C6EF5)
                                          .withOpacity(0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: addMedication,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add Medication',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }
}

// ── Reusable styled text field ───────────────────────────────────────────────

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? errorText;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: Colors.white38, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText != null
                    ? const Color(0xFFFF6B6B).withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF4C6EF5), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          cursorColor: const Color(0xFF4C6EF5),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFFF6B6B), size: 13),
                const SizedBox(width: 5),
                Text(
                  errorText!,
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
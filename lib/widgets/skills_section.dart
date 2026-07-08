import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkillsSection extends StatefulWidget {
  final ScrollController scrollController;
  const SkillsSection({super.key, required this.scrollController});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  late ScrollController _row1Controller;
  late ScrollController _row2Controller;

  final skillsRow1 = [
    'Flutter',
    'Dart',
    'Firebase',
    'REST API',
    'Git/GitHub',
    'Google Play',
    'Clean Code',
  ];
  final skillsRow2 = [
    'HTML',
    'CSS',
    'JavaScript',
    'SQL',
    'UI Design',
    'Figma',
    'Postman',
  ];

  @override
  void initState() {
    super.initState();
    _row1Controller = ScrollController();
    _row2Controller = ScrollController();

    // Jalankan animasi marquee setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee(_row1Controller, true);
      _startMarquee(_row2Controller, false);
    });
  }

  void _startMarquee(ScrollController controller, bool forward) {
    if (!controller.hasClients) return;

    double maxExtent = controller.position.maxScrollExtent;
    double currentPos = controller.offset;

    // Kecepatan: Jarak / Waktu (Piksel per detik)
    // Semakin besar durasi, semakin lambat
    int durationInSeconds = 50;

    if (forward) {
      controller
          .animateTo(
            maxExtent,
            duration: Duration(seconds: durationInSeconds),
            curve: Curves.linear,
          )
          .then((_) {
            if (mounted) {
              controller.jumpTo(0);
              _startMarquee(controller, forward);
            }
          });
    } else {
      // Untuk baris kedua, kita buat dia di posisi akhir lalu scroll ke awal
      if (currentPos == 0) controller.jumpTo(maxExtent);
      controller
          .animateTo(
            0,
            duration: Duration(seconds: durationInSeconds),
            curve: Curves.linear,
          )
          .then((_) {
            if (mounted) {
              controller.jumpTo(maxExtent);
              _startMarquee(controller, forward);
            }
          });
    }
  }

  @override
  void dispose() {
    _row1Controller.dispose();
    _row2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: Colors.blue.shade50,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
            child:
                Text(
                      'Keahlian Saya',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontSize: isMobile ? 28 : 32),
                      textAlign: TextAlign.center,
                    )
                    .animate(
                      adapter: ScrollAdapter(
                        widget.scrollController,
                        begin: 2400,
                        end: 2600,
                      ),
                    )
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0),
          ),
          const SizedBox(height: 60),

          _buildMarqueeRow(_row1Controller, skillsRow1, isMobile),
          const SizedBox(height: 30),
          _buildMarqueeRow(_row2Controller, skillsRow2, isMobile),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMarqueeRow(
    ScrollController controller,
    List<String> skills,
    bool isMobile,
  ) {
    // Gandakan list 5x agar terlihat tanpa batas saat di-scroll
    final items = [...skills, ...skills, ...skills, ...skills, ...skills];

    return SizedBox(
      height: 80, // Tinggi ditambah agar shadow tidak terpotong
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: items.map((s) => _buildSkillChip(s, isMobile)).toList(),
            ),
          ),

          // Efek Fading Gradient di pinggir
          IgnorePointer(
            child: Row(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.blue.shade50,
                        Colors.blue.shade50.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.blue.shade50,
                        Colors.blue.shade50.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 30,
        vertical: isMobile ? 12 : 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
        ),
      ),
    );
  }
}

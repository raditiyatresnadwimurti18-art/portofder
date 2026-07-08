import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ServicesSection extends StatelessWidget {
  final ScrollController scrollController;
  const ServicesSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 100,
        vertical: 80,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
                'Apa yang Saya Lakukan',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isMobile ? 28 : 32,
                ),
                textAlign: TextAlign.center,
              )
              .animate(
                adapter: ScrollAdapter(
                  scrollController,
                  begin: 1800,
                  end: 2100,
                ),
              )
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildServiceCard(
                context,
                icon: Icons.web,
                title: 'Web Development',
                description:
                    'Membuat website yang responsif, cepat, dan modern untuk berbagai kebutuhan bisnis.',
                isMobile: isMobile,
                index: 0,
              ),
              _buildServiceCard(
                context,
                icon: Icons.design_services,
                title: 'UI/UX Design',
                description:
                    'Merancang antarmuka pengguna yang intuitif dan pengalaman pengguna yang menyenangkan menggunakan platform figma.',
                isMobile: isMobile,
                index: 1,
              ),
              _buildServiceCard(
                context,
                icon: Icons.cast_for_education,
                title: 'Asisten Labolatorium',
                description:
                    'Mengajar, menyusun materi, dan menyampaikan ilmu dangan jelas kepada Mahasiswa.',
                isMobile: isMobile,
                index: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isMobile,
    required int index,
  }) {
    // Menghitung range scroll untuk setiap kartu agar muncul bergantian
    final double start = 2000 + (index * 100);
    final double end = 2400 + (index * 100);

    return Container(
          width: isMobile ? double.infinity : 350,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 50, color: const Color(0xFF1A237E)),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        )
        .animate(
          adapter: ScrollAdapter(scrollController, begin: start, end: end),
        )
        .fadeIn()
        .slideY(begin: 0.2, end: 0);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;
  const AboutSection({super.key, required this.scrollController});

  Future<void> _launchCVUrl() async {
    final Uri url = Uri.parse(
      'https://drive.google.com/drive/folders/1Ev2S2389UuyTQFJ6ZDmot2C-KZdLKQmd',
    );

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Tidak bisa membuka link $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 100,
        vertical: 100,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildProfileImage(isMobile),
            const SizedBox(height: 50),
            _buildAboutText(
              context,
              textAlign: TextAlign.center,
              isMobile: isMobile,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildAboutText(context, isMobile: isMobile)),
                const SizedBox(width: 100),
                _buildProfileImage(isMobile),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage(bool isMobile) {
    final double size = isMobile ? 250 : 350;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Efek Dekorasi Belakang
        Container(
              width: size + 20,
              height: size + 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 2,
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 2000.ms,
            ),

        // Gambar Utama
        Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/profil.jpeg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            )
            .animate(adapter: ScrollAdapter(scrollController, end: 400))
            .fadeIn()
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildAboutText(
    BuildContext context, {
    TextAlign textAlign = TextAlign.left,
    required bool isMobile,
  }) {
    final alignment = textAlign == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Role Badge
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'WEB DEVELOPER',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
            )
            .animate(adapter: ScrollAdapter(scrollController, end: 150))
            .fadeIn()
            .slideX(begin: -0.1, end: 0),
        const SizedBox(height: 20),
        Text(
              'Halo, Saya Dheriel',
              textAlign: textAlign,
              style: TextStyle(
                fontSize: isMobile ? 32 : 56,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1.1,
              ),
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 20, end: 200),
            )
            .fadeIn()
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),
        Text(
              'Saya adalah mahasiswa Sistem Informasi yang memiliki ketertarikan pada pengembangan web, jaringan komputer, dan teknologi informasi. Berpengalaman sebagai Asisten Laboratorium Sistem Informasi (LABSI), saya terbiasa bekerja sama dalam tim, membantu pemecahan masalah teknis, serta mendampingi proses praktikum. Saya terus mengembangkan kemampuan teknis dan komunikasi untuk menciptakan solusi digital yang bermanfaat serta memberikan dampak positif di dunia teknologi.',
              textAlign: textAlign,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                height: 1.6,
              ),
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 50, end: 250),
            )
            .fadeIn(),
        const SizedBox(height: 40),

        // Stats atau Highlight Info
        // Wrap(
        //       spacing: 30,
        //       runSpacing: 20,
        //       alignment: WrapAlignment.start,
        //       children: [
        //         _buildStatItem("2+", "Tahun Pengalaman"),
        //         _buildStatItem("3+", "Proyek Selesai"),
        //       ],
        //     )
        //     .animate(
        //       adapter: ScrollAdapter(scrollController, begin: 100, end: 300),
        //     )
        //     .fadeIn(),

        // const SizedBox(height: 50),

        // Action Buttons
        Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _launchCVUrl,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download CV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 22,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 150, end: 350),
            )
            .fadeIn()
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
        ),
      ],
    );
  }
}

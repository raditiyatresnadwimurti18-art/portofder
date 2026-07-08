import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class ProjectsSection extends StatelessWidget {
  final ScrollController scrollController;
  const ProjectsSection({super.key, required this.scrollController});

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
        children: [
          Text(
            'Sudah Membuat Apa Saja',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: isMobile ? 28 : 32),
            textAlign: TextAlign.center,
          ).animate(adapter: ScrollAdapter(scrollController, begin: 3000, end: 3300)).fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildProjectCard(
                context,
                title: 'Discovery Match',
                description:
                    'Aplikasi pencarian partner lomba yang berhasil dipublikasikan di Google Play Store. Dibangun dengan Flutter dan Firebase.',
                category: 'Mobile App',
                imagePath: 'assets/images/logoD.png',
                icon: Icons.sports_soccer,
                isMobile: isMobile,
                url: 'https://discoverydemo.vercel.app',
                index: 0,
              ),
              _buildProjectCard(
                context,
                title: 'Anonym',
                description:
                    'Proyek absensi_raditya adalah aplikasi manajemen presensi (absensi) berbasis Flutter yang dirancang untuk melacak kehadiran pengguna (peserta pelatihan) secara real-time menggunakan koordinat GPS dan integrasi peta.',
                category: 'Web/Mobile App',
                imagePath: 'assets/images/logoA.png',
                icon: Icons.person_outline,
                isMobile: isMobile,
                url: 'https://anonym-xi.vercel.app',
                index: 1,
              ),
              _buildProjectCard(
                context,
                title: 'Sistem Manajemen Lab',
                description:
                    'Konsep desain dan pengembangan sistem internal untuk manajemen asisten laboratorium di Universitas Gunadarma.',
                category: 'Management System',
                imagePath: 'assets/images/aslab.png',
                icon: Icons.computer,
                isMobile: isMobile,
                index: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required String description,
    required String category,
    IconData? icon,
    String? imagePath,
    required bool isMobile,
    String? url,
    required int index,
  }) {
    final double start = 3200 + (index * 200);
    final double end = 3600 + (index * 200);

    return Container(
      width: isMobile ? double.infinity : 350,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image Placeholder or Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            icon ?? Icons.broken_image,
                            size: 80,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  )
                : Icon(
                    icon ?? Icons.work,
                    size: 80,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 25),
                OutlinedButton(
                  onPressed: () async {
                    if (url != null) {
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    .animate(adapter: ScrollAdapter(scrollController, begin: start, end: end))
    .fadeIn()
    .slideY(begin: 0.2, end: 0);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:photo_view/photo_view.dart';
import '../theme/app_colors.dart';

class JourneySection extends StatelessWidget {
  final ScrollController scrollController;
  const JourneySection({super.key, required this.scrollController});

  // ─── DATA ───────────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _journeyData = [
    {
      'year': '2022 - 2024',
      'title': 'English Club',
      'subtitle': 'Kelas 12, SMAS Yadika 5',
      'desc':
          'Membimbing rekan sekelas dalam pemahaman materi Bahasa Inggris menjelang ujian. '
          'Melatih kemampuan menyampaikan materi di depan audiens sejak SMA.',
      'images': ['assets/images/englishclub.jpeg'],
      'icon': Icons.code_rounded,
    },
    {
      'year': '2024 – 2025',
      'title': 'Universitas Gunadarma(HIMSI)',
      'subtitle': 'Anggota Divisi Hubungan Masyarakat',
      'desc':
          'Membantu komunikasi dan publikasi kegiatan himpunan ke mahasiswa dan pihak eksternal.'
          'Berkolaborasi dalam tim untuk mendukung program kerja organisasi.',
      'images': ['assets/images/himsi.jpeg'],
      'icon': Icons.school_outlined,
    },
    {
      'year': '2025 – Saat Ini',
      'title': 'Universitas Gunadarma(Labsi)',
      'subtitle': 'Sistem Informasi (S1) & Asisten Lab',
      'desc':
          'Mahasiswa semester 3 jurusan Sistem Informasi. '
          'Sedang menjalani posisi asisten laboratorium Sistem Informasi di Gunadarma.',
      'images': ['assets/images/labsi.jpg'],
      'icon': Icons.account_balance_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 100,
        vertical: 120,
      ),
      child: Column(
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 80),
          _buildTimeline(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Text(
              'RIWAYAT PERJALANAN',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppColors.secondary,
              ),
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 400, end: 550),
            )
            .fadeIn()
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 12),
        Text(
              'Edukasi & Pengalaman Profesional',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 28 : 44,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1.2,
              ),
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 450, end: 600),
            )
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 20),
        Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            )
            .animate(
              adapter: ScrollAdapter(scrollController, begin: 500, end: 650),
            )
            .scaleX(begin: 0, end: 1),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, bool isMobile) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        children: List.generate(_journeyData.length, (idx) {
          final data = _journeyData[idx];
          return _TimelineItem(
            year: data['year'] as String,
            title: data['title'] as String,
            subtitle: data['subtitle'] as String,
            desc: data['desc'] as String,
            images: List<String>.from(data['images'] as List),
            icon: data['icon'] as IconData,
            isLast: idx == _journeyData.length - 1,
            isMobile: isMobile,
            index: idx,
            onImageTap: (img) => _showFullImage(context, img),
            scrollController: scrollController,
          );
        }),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: PhotoView(
                  imageProvider: AssetImage(imagePath),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String subtitle;
  final String desc;
  final List<String> images;
  final IconData icon;
  final bool isLast;
  final bool isMobile;
  final int index;
  final void Function(String) onImageTap;
  final ScrollController scrollController;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.images,
    required this.icon,
    required this.isLast,
    required this.isMobile,
    required this.index,
    required this.onImageTap,
    required this.scrollController,
  });

  static const _navy = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    // Estimasi posisi scroll untuk setiap item timeline (Snappier)
    final double itemStart = 600 + (index * 250);
    final double itemEnd = 800 + (index * 250);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isMobile ? 52 : 72,
          child: Column(
            children: [
              Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _navy, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: _navy, size: 20),
                  )
                  .animate(
                    adapter: ScrollAdapter(
                      scrollController,
                      begin: itemStart,
                      end: itemStart + 150,
                    ),
                  )
                  .fadeIn()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              if (!isLast)
                Container(
                      width: 2,
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _navy.withOpacity(0.4),
                            _navy.withOpacity(0.04),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      adapter: ScrollAdapter(
                        scrollController,
                        begin: itemStart + 50,
                        end: itemEnd + 100,
                      ),
                    )
                    .fadeIn()
                    .scaleY(begin: 0, end: 1, alignment: Alignment.topCenter),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8, bottom: isLast ? 0 : 80),
            child:
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _navy.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _navy.withOpacity(0.12)),
                          ),
                          child: Text(
                            year,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _navy,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.65),
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (images.isNotEmpty) ...[
                          if (images.length == 1)
                            _buildSingleImagePreview(context, images.first, itemStart)
                          else
                            _buildMultipleImageGrid(context, images, itemStart),
                        ],
                      ],
                    )
                    .animate(
                      adapter: ScrollAdapter(
                        scrollController,
                        begin: itemStart + 50,
                        end: itemEnd,
                      ),
                    )
                    .fadeIn()
                    .slideX(begin: 0.04, end: 0),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImagePreview(BuildContext context, String imagePath, double itemStart) {
    final double maxWidth = isMobile ? double.infinity : 320;
    final double height = isMobile ? 180 : 200;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onImageTap(imagePath),
        child: Container(
          width: maxWidth,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textMuted,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gagal memuat gambar',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      .animate(
        adapter: ScrollAdapter(
          scrollController,
          begin: itemStart + 100,
          end: itemStart + 250,
        ),
      )
      .fadeIn()
      .scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1.0, 1.0),
      ),
    );
  }

  Widget _buildMultipleImageGrid(BuildContext context, List<String> images, double itemStart) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: images.asMap().entries.map((e) {
        final imgIndex = e.key;
        final img = e.value;
        final double imgStart = itemStart + 100 + (imgIndex * 30);
        return GestureDetector(
          onTap: () => onImageTap(img),
          child: Container(
            width: isMobile ? 90 : 130,
            height: isMobile ? 90 : 130,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(0.25),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.asset(
                img,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No image',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate(
            adapter: ScrollAdapter(
              scrollController,
              begin: imgStart,
              end: imgStart + 150,
            ),
          )
          .fadeIn()
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        );
      }).toList(),
    );
  }
}

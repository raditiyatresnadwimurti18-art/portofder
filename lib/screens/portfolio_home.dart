import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/about_section.dart';
import '../widgets/journey_section.dart';
import '../widgets/services_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/projects_section.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  int? _targetIndex;

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _journeyKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  late final List<GlobalKey> _sectionKeys;
  static const double _navThreshold = 120.0;

  @override
  void initState() {
    super.initState();
    _sectionKeys = [
      _aboutKey,
      _journeyKey,
      _servicesKey,
      _skillsKey,
      _projectsKey,
    ];
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_targetIndex != null) return;

    int newIndex = 0;
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= _navThreshold) {
        newIndex = i;
        break;
      }
    }

    if (_selectedIndex != newIndex) {
      setState(() => _selectedIndex = newIndex);
    }
  }

  void _scrollToSection(int index, GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final sectionOffset =
        box.localToGlobal(Offset.zero).dy +
        _scrollController.offset -
        _navThreshold +
        1;

    final targetOffset = sectionOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    setState(() {
      _selectedIndex = index;
      _targetIndex = index;
    });

    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        )
        .whenComplete(() {
          if (mounted) setState(() => _targetIndex = null);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dheriel Portofolio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: isMobile
            ? null
            : [
                _buildNavButton('Tentang', 0, _aboutKey),
                _buildNavButton('Perjalanan', 1, _journeyKey),
                _buildNavButton('Layanan', 2, _servicesKey),
                _buildNavButton('Keahlian', 3, _skillsKey),
                // _buildNavButton('Proyek', 4, _projectsKey),
                const SizedBox(width: 20),
              ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: StreamBuilder<double>(
            stream: Stream.periodic(const Duration(milliseconds: 50), (_) {
              if (!_scrollController.hasClients) return 0.0;
              return _scrollController.offset /
                  _scrollController.position.maxScrollExtent;
            }),
            builder: (context, snapshot) {
              return LinearProgressIndicator(
                value: snapshot.data ?? 0,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1A237E),
                ),
                minHeight: 3,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            AboutSection(key: _aboutKey, scrollController: _scrollController),
            JourneySection(
              key: _journeyKey,
              scrollController: _scrollController,
            ),
            ServicesSection(
              key: _servicesKey,
              scrollController: _scrollController,
            ),
            SkillsSection(key: _skillsKey, scrollController: _scrollController),
            // ProjectsSection(
            //   key: _projectsKey,
            //   scrollController: _scrollController,
            // ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, int index, GlobalKey key) {
    final isSelected = _selectedIndex == index;
    return TextButton(
      onPressed: () => _scrollToSection(index, key),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          color: isSelected ? const Color(0xFF1A237E) : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _scrollToSection(index, _sectionKeys[index]),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tentang',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Journey'),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Layanan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Skill'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.work_outline),
          //   label: 'Proyek',
          // ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF1A237E),
      width: double.infinity,
      child: Column(
        children: [
          const Text(
            'Mari Bekerja Sama',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Saya selalu terbuka untuk diskusi proyek menarik atau peluang kolaborasi.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                icon: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Colors.white,
                  size: 24,
                ),
                label: 'Instagram',
                url:
                    'https://www.instagram.com/rielptr_?igsh=MXQzemhwOTNzeXc5Yg==',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 24,
                ),
                label: 'WhatsApp',
                url: 'https://wa.me/qr/O6YLMHBYSTJPM1',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: SvgPicture.string(
                  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>',
                  width: 24,
                  height: 24,
                ),
                label: 'GitHub',
                url: 'https://github.com/Zyein',
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24, indent: 80, endIndent: 80),
          const SizedBox(height: 20),
          const Text(
            '© 2026 Dheriel Portofolio. Dibuat dengan Flutter.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  Future<void> _launch() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _launch,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: icon,
          ),
        ),
      ),
    );
  }
}

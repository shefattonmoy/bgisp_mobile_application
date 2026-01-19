import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:bgisp/widgets/language_toggle.dart';
import 'package:bgisp/widgets/language_text.dart';
import 'package:bgisp/widgets/expandable_committee.dart';
import 'package:bgisp/widgets/expandable_others.dart';
import 'package:bgisp/widgets/expandable_tools.dart';
import 'package:bgisp/views/About/about_page.dart';
import 'package:bgisp/views/HelpAndSupport/help_and_support_page.dart';
import 'package:bgisp/views/Committees/ExecutiveCommittee/executive_committe_page.dart';
import 'package:bgisp/views/Committees/TechnicalCommittee/technical_committee_page.dart';
import 'package:bgisp/views/MemberOrganizations/member_organizations_page.dart';
import 'package:bgisp/views/FocalPersons/focal_persons_page.dart';
import 'package:bgisp/views/Gallery/gallery_page.dart';
import 'package:bgisp/views/DataDissemination/data_dissemination_page.dart';
import 'package:bgisp/views/IntegratedGeoportal/integrated_geoportal_page.dart';
import 'package:bgisp/views/Metadata/metadata_page.dart';
import 'package:bgisp/views/Login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSlide = 0;
  final PageController _pageController = PageController();
  final List<String> _sliderImages = [
    'assets/slider_images/image1.jpeg',
    'assets/slider_images/image2.jpeg',
    'assets/slider_images/image3.jpeg',
    'assets/slider_images/image4.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        if (_currentSlide < _sliderImages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.jumpToPage(0);
        }
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSlider(),
            _buildObjectiveSection(),
            _buildMissionSection(),
            _buildVisionSection(),
            _buildContentSections(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const LanguageText(
        translationKey: 'app_title',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ), text: '',
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF0D47A1),
      elevation: 4,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // Language Toggle Button on AppBar
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: LanguageToggle(
            width: 60,
            height: 32, margin: EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
            itemCount: _sliderImages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_sliderImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Indicator dots
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _sliderImages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: Colors.grey[50],
      child: Column(
        children: [
          // Title
          const LanguageText(
            translationKey: 'our_objective',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ), text: '',
          ),
          const SizedBox(height: 12),
          Container(width: 100, height: 3, color: const Color(0xFF0D47A1)),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              BootstrapIcons.bullseye,
              size: 28,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LanguageText(
              translationKey: 'objective_desc',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.60,
              ), text: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: Colors.white,
      child: Column(
        children: [
          const LanguageText(
            translationKey: 'our_mission',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ), text: '',
          ),
          const SizedBox(height: 12),
          Container(width: 100, height: 3, color: const Color(0xFF1565C0)),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              BootstrapIcons.eye,
              size: 28,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LanguageText(
              translationKey: 'mission_desc',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.60,
              ), text: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: Colors.grey[50],
      child: Column(
        children: [
          const LanguageText(
            translationKey: 'our_vision',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ), text: '',
          ),
          const SizedBox(height: 12),
          Container(width: 100, height: 3, color: const Color(0xFF0D47A1)),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              BootstrapIcons.globe,
              size: 28,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LanguageText(
              translationKey: 'vision_desc',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.60,
              ), text: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSections() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LanguageText(
            translationKey: 'our_core_values',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ), text: '',
          ),
          const SizedBox(height: 12),
          Container(width: 100, height: 3, color: const Color(0xFF0D47A1)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildCoreValuesCard(
                icon: Icons.show_chart,
                translationKey: 'innovation',
                descriptionKey: 'innovation_desc',
              ),
              _buildCoreValuesCard(
                icon: Icons.groups,
                translationKey: 'collaboration',
                descriptionKey: 'collaboration_desc',
              ),
              _buildCoreValuesCard(
                icon: BootstrapIcons.bullseye,
                translationKey: 'excellence',
                descriptionKey: 'excellence_desc',
              ),
              _buildCoreValuesCard(
                icon: Icons.handshake_outlined,
                translationKey: 'accessibility',
                descriptionKey: 'accessibility_desc',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoreValuesCard({
    required IconData icon,
    required String translationKey,
    required String descriptionKey,
  }) {
    return Card(
      elevation: 2,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF0D47A1)),
            const SizedBox(height: 8),
            LanguageText(
              translationKey: translationKey,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ), text: '',
            ),
            const SizedBox(height: 6),
            LanguageText(
              translationKey: descriptionKey,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey), text: '',
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const LanguageText(
                        translationKey: 'app_title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ), text: '',
                      ),
                      const SizedBox(height: 8),
                      const LanguageText(
                        translationKey: 'welcome_user',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ), text: '',
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.home,
                  translationKey: 'home',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.business,
                  translationKey: 'organizations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MemberOrganizationsPage(),
                      ),
                    );
                  },
                ),
                ExpandableCommittee(
                  icon: Icons.groups,
                  titleKey: 'committees',
                  initiallyExpanded: false,
                  children: [
                    DrawerSubItem(
                      icon: Icons.engineering,
                      titleKey: 'technical_committee',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TechnicalCommitteePage(),
                          ),
                        );
                      },
                    ),
                    DrawerSubItem(
                      icon: Icons.business,
                      titleKey: 'executive_committee',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExecutiveCommitteePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ExpandableTools(
                  icon: Icons.build,
                  titleKey: 'tools',
                  initiallyExpanded: false,
                  children: [
                    ToolsSubItem(
                      icon: Icons.map,
                      titleKey: 'integrated_geoportal',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntegratedGeoportalPage(),
                          ),
                        );
                      },
                      color: const Color(0xFF0D47A1),
                    ),
                    ToolsSubItem(
                      icon: Icons.description,
                      titleKey: 'metadata',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MetadataPage(),
                          ),
                        );
                      },
                      color: const Color(0xFF0D47A1),
                    ),
                    ToolsSubItem(
                      icon: Icons.cloud_upload,
                      titleKey: 'data_dissemination',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataDisseminationPage(),
                          ),
                        );
                      },
                      color: const Color(0xFF0D47A1),
                    ),
                  ],
                ),
                ExpandableOthers(
                  icon: Icons.more_horiz,
                  titleKey: 'others',
                  initiallyExpanded: false,
                  children: [
                    OthersSubItem(
                      icon: Icons.contacts,
                      titleKey: 'focal_persons',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FocalPersonsPage(),
                          ),
                        );
                      },
                      color: const Color(0xFF0D47A1),
                    ),
                    OthersSubItem(
                      icon: Icons.photo_library,
                      titleKey: 'gallery',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GalleryPage(),
                          ),
                        );
                      },
                      color: const Color(0xFF0D47A1),
                    ),
                  ],
                ),
                const Divider(),
                
                // Sign In Button
                _buildDrawerItem(
                  icon: Icons.login,
                  translationKey: 'sign_in',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
                
                _buildDrawerItem(
                  icon: Icons.help,
                  translationKey: 'help_support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  translationKey: 'about',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Version name at the bottom
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.grey[50],
            child: Text(
              'BGISP v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String translationKey,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: LanguageText(
        translationKey: translationKey,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), text: '',
      ),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
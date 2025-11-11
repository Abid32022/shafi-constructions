import 'package:construction_website/documents_viewer_screen.dart';
import 'package:construction_website/project_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    setState(() => _currentPage = page);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 80),
                _buildSection(_currentPage),
              ],
            ),
          ),
          _buildHeader(),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildSection(int page) {
    switch (page) {
      case 0:
        return HomeSection(onNavigate: _navigateToPage);
      case 1:
        return const PortfolioSection();
      case 2:
        return const AboutSection();
      case 3:
        return const ContactSection();
      default:
        return HomeSection(onNavigate: _navigateToPage);
    }
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: _isScrolled
            ? const Color(0xFF0F0E47).withOpacity(0.95)
            : const Color(0xFF0F0E47).withOpacity(0.7),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            _buildLogo(),
            const Spacer(),
            if (MediaQuery.of(context).size.width > 768)
              _buildDesktopMenu()
            else
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF505081), Color(0xFF8686AC)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.architecture,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Adaptive font sizing based on screen width
                  double fontSize = constraints.maxWidth * 0.045;

                  if (constraints.maxWidth < 360) {
                    fontSize = 12; // Extra small phones
                  } else if (constraints.maxWidth < 400) {
                    fontSize = 14; // Small phones
                  } else if (constraints.maxWidth < 600) {
                    fontSize = 16; // Standard phones
                  } else if (constraints.maxWidth < 800) {
                    fontSize = 18; // Large phones / Small tablets
                  } else if (constraints.maxWidth < 1200) {
                    fontSize = 20; // Tablets
                  } else {
                    fontSize = 24; // Desktop / Web
                  }

                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      'MS Shafi Ullah',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopMenu() {
    final items = ['Home', 'Projects', 'About Us', 'Contact'];
    return Row(
      children: [
        ...items.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _MenuButton(
              text: entry.value,
              isActive: _currentPage == entry.key,
              onTap: () => _navigateToPage(entry.key),
            ),
          );
        }),
        const SizedBox(width: 16),
        _GlassmorphicButton(
          text: 'Explore Projects',
          onTap: () => _navigateToPage(1),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    final items = ['Home', 'Projects', 'About Us', 'Contact'];
    return Drawer(
      backgroundColor: const Color(0xFF0F0E47),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 60),
          ...items.asMap().entries.map((entry) {
            return ListTile(
              title: Text(
                entry.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: _currentPage == entry.key,
              selectedTileColor: const Color(0xFF505081).withOpacity(0.3),
              onTap: () {
                _navigateToPage(entry.key);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}

// List<String> list1 = [
//   'assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg'
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  8.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  10.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  11.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  12.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  13.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
//   // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  15.jpg',
// ];

// List<ProjectData> detailList=[
//
//   ProjectData(title: title,
//       category: category,
//       location: location,
//       date: date,
//       description: description,
//       imagePaths: imagePaths)
//
//
//
// ];

// ProjectData _createProjectData(String title, String location, String category) {
//   final Map<String, List<String>> projectImages = {
//     'Commissioner House': [
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  8.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  10.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  11.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  12.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  13.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
//       'assets/images/Construction of Commishnor House at GOR-1/commissor house  15.jpg',
//     ],
//     'Commercial Plaza DHA 5 Islamabad': [
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 1.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 2.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 3.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 4.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 5.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 6.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 7.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 8.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 9.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 10.jpg',
//       'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 11.jpg',
//     ],
//     'Community Hall Islamabad': [
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  1.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  2.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  3.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  4.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  5.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  6.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  7.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  8.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  9.jpg',
//       'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  11.jpg',
//     ],
//     'Commissioner Office': [
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 13.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 1.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 2.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 3.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 4.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 5.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 6.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 7.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 8.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 9.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 10.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 11.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 12.jpg',
//       'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 14.jpg',
//     ],
//   };
//
//   return ProjectData(
//     title: title,
//     category: category,
//     location: location,
//     date: 'Completed 2024',
//     description:
//         'A stunning construction project featuring modern architecture, sustainable design, and world-class execution.',
//     imagePaths: projectImages[title] ?? [], // This will now find matches
//   );
// }
List<String> list1 = [
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  8.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  10.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  11.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  12.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  13.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg",
  "assets/images/Construction of Commishnor House at GOR-1/commissor house  15.jpg",
];
List<String> list2 = [
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 1.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 2.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 3.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 4.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 5.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 6.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 7.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 8.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 9.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 10.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 11.jpg",
  "assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg",
];
List<String> list3 = [
  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  1.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  2.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  3.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  4.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  5.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  6.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  7.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  8.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  9.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg",

  "assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  11.jpg",
];
List<String> list4 = [
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 1.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 2.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 3.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 4.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 5.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 6.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 7.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 8.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 9.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 10.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 11.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 12.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 13.jpg",
  "assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 14.jpg",
];
List<String> list5 = [
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  1.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  2.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  3.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  4.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  5.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  6.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  7.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  8.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  9.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  10.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  11.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  12.jpg",
  "assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  13.jpg",
];
List<String> list6 = [
  "assets/images/Stone work nathia Gali/Stone work  1.jpg",
  "assets/images/Stone work nathia Gali/Stone work  2.jpg",
  "assets/images/Stone work nathia Gali/Stone work  3.jpg",
  "assets/images/Stone work nathia Gali/Stone work  4.jpg",
  "assets/images/Stone work nathia Gali/Stone work  5.jpg",
  "assets/images/Stone work nathia Gali/Stone work  6.jpg",
  "assets/images/Stone work nathia Gali/Stone work  7.jpg",
  "assets/images/Stone work nathia Gali/Stone work  8.jpg",
  "assets/images/Stone work nathia Gali/Stone work  9.jpg",
  "assets/images/Stone work nathia Gali/Stone work  10.jpg",
  "assets/images/Stone work nathia Gali/Stone work  11.jpg",
];
List<String> list7 = [
  "assets/images/Artificial work swat zoo/zoo 1.jpg",
  "assets/images/Artificial work swat zoo/zoo 2.jpg",
  "assets/images/Artificial work swat zoo/zoo 3.jpg",
  "assets/images/Artificial work swat zoo/zoo 4.jpg",
  "assets/images/Artificial work swat zoo/zoo 5.jpg",
  "assets/images/Artificial work swat zoo/zoo 6.jpg",
  "assets/images/Artificial work swat zoo/zoo 7.jpg",
  "assets/images/Artificial work swat zoo/zoo 8.jpg",
  "assets/images/Artificial work swat zoo/zoo 9.jpg",
  "assets/images/Artificial work swat zoo/zoo 10.jpg",
  "assets/images/Artificial work swat zoo/zoo 11.jpg",
  "assets/images/Artificial work swat zoo/zoo 12.jpg",
  "assets/images/Artificial work swat zoo/zoo 13.jpg",
  "assets/images/Artificial work swat zoo/zoo 14.jpg",
];
List<String> list8 = [
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 1.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 2.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 3.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 4.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 5.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 6.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 7.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 8.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 9.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 10.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 11.jpg",
  "assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 12.jpg",
];
List<String> list9 = [
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  1.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  2.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  3.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  4.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  5.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  6.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  7.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  8.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  9.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  10.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  11.jpg",
  "assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  12.jpg",
];
List<String> list10 = [
  "assets/images/Boundary wall work Rawat/boundary wall 1.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 2.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 3.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 4.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 5.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 6.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 7.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 8.jpg",
  "assets/images/Boundary wall work Rawat/boundary wall 9.jpg",
];
List<String> list11 = [
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  1.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  2.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  3.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  4.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  5.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  6.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  7.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  8.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  9.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  10.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  11.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  12.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  13.jpg",
  "assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  14.jpg",
];
List<String> list12 = [
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 1.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 2.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 3.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 4.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 5.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 6.jpg",
  "assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 7.jpg",
];
List<String> list13 = [
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  1.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  2.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  3.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  4.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  5.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  6.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  7.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  8.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  9.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  10.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  11.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  12.jpg",
  "assets/images/Drain work DHA 5 Islamabad/Drain work DHA  13.jpg",
];

class _MenuButton extends StatefulWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: _isHovered || widget.isActive ? 40 : 0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF505081), Color(0xFF8686AC)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassmorphicButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _GlassmorphicButton({required this.text, required this.onTap});

  @override
  State<_GlassmorphicButton> createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<_GlassmorphicButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [const Color(0xFF505081), const Color(0xFF8686AC)]
                  : [const Color(0xFF0F0E47), const Color(0xFF505081)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF505081).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HOME SECTION
class HomeSection extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeSection({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroSection(onNavigate: onNavigate),
        const _StatsSection(),
        _FeaturedWorkSection(onNavigate: onNavigate),
        const _FooterSection(),
      ],
    );
  }
}

class _HeroSection extends StatefulWidget {
  final Function(int) onNavigate;

  const _HeroSection({required this.onNavigate});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  String _displayText = '';
  final String _fullText = "Building Tomorrow's Landmarks.";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: size.height * 0.9,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0F0E47).withOpacity(0.9),
            const Color(0xFF272757).withOpacity(0.7),
          ],
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpeg'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                builder: (context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      _displayText,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isMobile ? 36 : 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              TweenAnimationBuilder(
                tween: Tween<Offset>(
                  begin: const Offset(0, 20),
                  end: Offset.zero,
                ),
                duration: const Duration(milliseconds: 1200),
                builder: (context, Offset offset, child) {
                  return Transform.translate(
                    offset: offset,
                    child: Opacity(
                      opacity: (20 - offset.dy) / 20,
                      child: Text(
                        'Crafting exceptional spaces with precision and innovation',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: const Color(0xFF8686AC),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              _GlassmorphicButton(
                text: 'View Our Projects',
                onTap: () => widget.onNavigate(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: isMobile
          ? Column(
              children: const [
                _StatCard(
                  icon: Icons.apartment,
                  label: 'Projects',
                  value: 100,
                  suffix: '+',
                ),
                SizedBox(height: 16),
                _StatCard(
                  icon: Icons.people,
                  label: 'Happy Clients',
                  value: 100,
                  suffix: '+',
                ),
                SizedBox(height: 16),
                _StatCard(
                  icon: Icons.emoji_events,
                  label: 'Awards',
                  value: 25,
                  suffix: '',
                ),
                SizedBox(height: 16),
                _StatCard(
                  icon: Icons.calendar_today,
                  label: 'Years',
                  value: 13,
                  suffix: '+',
                ),
              ],
            )
          : Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    icon: Icons.apartment,
                    label: 'Projects',
                    value: 100,
                    suffix: '+',
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    label: 'Happy Clients',
                    value: 100,
                    suffix: '+',
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events,
                    label: 'Awards',
                    value: 25,
                    suffix: '',
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today,
                    label: 'Years',
                    value: 13,
                    suffix: '+',
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int value;
  final String suffix;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool _isHovered = false;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasAnimated && mounted) {
        _controller.forward();
        _hasAnimated = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F0E47).withOpacity(0.4),
              const Color(0xFF505081).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8686AC).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF505081).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF505081), Color(0xFF8686AC)],
                ),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  '${_animation.value}${widget.suffix}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF8686AC),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedWorkSection extends StatelessWidget {
  final Function(int) onNavigate;

  const _FeaturedWorkSection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Featured Projects',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Discover our latest masterpieces',
            style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: [
                    _ProjectCard(
                      image:
                          'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
                      title:
                          'Commissioner House', // Changed from 'Modern Corporate Tower'
                      location: 'Islamabad', // Changed location
                      category: 'Government Office Building',
                      delay: 0,
                      onTap: () => onNavigate(1),
                      index: 0,
                    ),
                    const SizedBox(height: 24),
                    _ProjectCard(
                      image:
                          'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg',
                      title:
                          'Commercial Plaza DHA 5 Islamabad', // Changed from 'Luxury Residential Complex'
                      location: 'Islamabad', // Changed location
                      category: 'Commercial',
                      delay: 200,
                      onTap: () => onNavigate(1),
                      index: 1,
                    ),
                    const SizedBox(height: 24),
                    _ProjectCard(
                      image:
                          'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg',
                      title:
                          'Community Hall Islamabad', // Changed from 'Innovation Hub'
                      location: 'Islamabad', // Changed location
                      category: 'Commercial',
                      delay: 400,
                      onTap: () => onNavigate(1),
                      index: 2,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _ProjectCard(
                        image:
                            'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
                        title:
                            'Commissioner House', // Changed from 'Modern Corporate Tower'
                        location: 'Islamabad', // Changed location
                        category: 'Government Office Building',
                        delay: 0,
                        onTap: () => onNavigate(1),
                        index: 0,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _ProjectCard(
                        image:
                            'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg',
                        title:
                            'Commercial Plaza DHA 5 Islamabad', // Changed from 'Luxury Residential Complex'
                        location: 'Islamabad', // Changed location
                        category: 'Commercial',
                        delay: 200,
                        onTap: () => onNavigate(1),
                        index: 1,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _ProjectCard(
                        image:
                            'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg',
                        title:
                            'Community Hall Islamabad', // Changed from 'Innovation Hub'
                        location: 'Islamabad', // Changed location
                        category: 'Commercial',
                        delay: 400,
                        onTap: () => onNavigate(1),
                        index: 2,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String image;
  final String title;
  final String location;
  final String category;
  final int delay;
  final VoidCallback onTap;
  final int index;

  const _ProjectCard({
    required this.image,
    required this.title,
    required this.location,
    required this.category,
    required this.delay,
    required this.onTap,
    required this.index,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: const Color(0xFF505081).withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            widget.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF0F0E47),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Color(0xFF8686AC),
                                    size: 64,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _isHovered
                                    ? const Color(0xFF0F0E47).withOpacity(0.9)
                                    : const Color(0xFF0F0E47).withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF505081), Color(0xFF8686AC)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            offset: _isHovered
                                ? Offset.zero
                                : const Offset(0, 0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF8686AC),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        child: Expanded(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            widget.location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF8686AC),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_isHovered) ...[
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        print('THe index is ${widget.index}');

                                        switch (widget.index) {
                                          case 0:
                                            print('A');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list1,
                                                      category: 'Residential',
                                                      location: 'Islamabad',
                                                      title:
                                                          'Commissioner House',
                                                      backgroundimage:
                                                          'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
                                                      // index: widget.index,
                                                      date: '2024',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 1:
                                            print('1');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list2,
                                                      category: 'Commercial',
                                                      location:
                                                          'Commercial Plaza DHA Phase 5, Islamabad',
                                                      title:
                                                          'Community Hall & Shops',
                                                      backgroundimage:
                                                          'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg',
                                                      // index: widget.index,
                                                      date: '2025',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 2:
                                            print('2');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list3,
                                                      category: 'Residential',
                                                      location:
                                                          'Commissioner Colony',
                                                      title: 'Camp Office',
                                                      backgroundimage:
                                                          'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg',
                                                      // index: widget.index,
                                                      date: '2023',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 3:
                                            print('3');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list4,
                                                      category:
                                                          'Infrastructure',
                                                      location:
                                                          'Islamabad–Peshawar',
                                                      title: 'Sand Work',
                                                      backgroundimage:
                                                          'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 13.jpg',
                                                      // index: widget.index,
                                                      date: '2022',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 4:
                                            print('4');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list5,
                                                      category: 'Finishing',
                                                      location: 'Nathia Gali',
                                                      title: 'Stone Work',
                                                      backgroundimage:
                                                          'assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  6.jpg',
                                                      // index: widget.index,
                                                      date: '2023',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 5:
                                            print('5');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list6,
                                                      category: 'Decorative',
                                                      location: 'Swat Zoo',
                                                      title: 'Artificial Zoo',
                                                      backgroundimage:
                                                          'assets/images/Stone work nathia Gali/Stone work  3.jpg',
                                                      // index: widget.index,
                                                      date: '2021',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 6:
                                            print('6');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list7,
                                                      category:
                                                          'Road Construction',
                                                      location:
                                                          'Punjab Regiment Center',
                                                      title:
                                                          'Asphalt and PCC Road',
                                                      backgroundimage:
                                                          'assets/images/Artificial work swat zoo/zoo 2.jpg',
                                                      // index: widget.index,
                                                      date: '2021',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 7:
                                            print('7');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list8,
                                                      category:
                                                          'Infrastructure',
                                                      location:
                                                          'Commissioner Colony, Rawalpindi',
                                                      title: 'Road Work',
                                                      backgroundimage:
                                                          'assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 2.jpg',
                                                      // index: widget.index,
                                                      date: '2020',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 8:
                                            print('8');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list9,
                                                      category: 'Residential',
                                                      location: 'Rawat',
                                                      title:
                                                          'Boundary Wall Work',
                                                      backgroundimage:
                                                          'assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  2.jpg',
                                                      // index: widget.index,
                                                      date: '2019',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 9:
                                            print('9');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list10,
                                                      category: 'Drainage',
                                                      location:
                                                          'Askari 13, Rawalpindi',
                                                      title:
                                                          'Construction of Drain Work',
                                                      backgroundimage:
                                                          'assets/images/Boundary wall work Rawat/boundary wall 1.jpg',
                                                      // index: widget.index,
                                                      date: '2020',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 10:
                                            print('10');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list11,
                                                      category: 'Commercial',
                                                      location: 'Islamabad',
                                                      title:
                                                          'Construction of Commercial Plaza',
                                                      backgroundimage:
                                                          'assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  8.jpg',
                                                      // index: widget.index,
                                                      date: '2019',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 11:
                                            print('11');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list12,
                                                      category: 'Drainage',
                                                      location: 'Islamabad',
                                                      title:
                                                          'Drain Work, DHA Phase 5',
                                                      backgroundimage:
                                                          'assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 5.jpg',
                                                      // index: widget.index,
                                                      date: '2021',
                                                    ),
                                              ),
                                            );
                                            break;
                                          case 12:
                                            print('12');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectShowcaseScreen(
                                                      list: list13,
                                                      category: 'sdfd',
                                                      location: 'sdf',
                                                      title: 'sdf',
                                                      backgroundimage:
                                                          'assets/images/Drain work DHA 5 Islamabad/Drain work DHA  13.jpg',
                                                      // index: widget.index,
                                                      date: '',
                                                    ),
                                              ),
                                            );
                                            break;
                                          default:
                                            print('Invalid number');
                                        }
                                      },
                                      child: AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        opacity: _isHovered ? 1.0 : 0.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF505081),
                                                Color(0xFF8686AC),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'View Details →',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// PORTFOLIO SECTION
class PortfolioSection extends StatelessWidget {
  const PortfolioSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'image':
            'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
        'title': 'Commissioner House',
        'location': 'Islamabad',
        'category': 'Government Office Building',
      },
      {
        'image':
            'assets/images/Construction of commercial palaza DHA 5 Islamabad/commercial palaza dha islamabad 12.jpg',
        'title': 'Commercial Plaza',
        'location': 'DHA Phase 5, Islamabad',
        'category': 'Commercial',
      },
      {
        'image':
            'assets/images/Construction of Community Hall & shops. Sec D askari 14/Community Hall  10.jpg',
        'title': 'Community Hall & Shops',
        'location': 'Islamabad',
        'category': 'Commercial',
      },
      {
        'image':
            'assets/images/Construction of Camp Office Commishnor Colony at GOR-1/camp office commishnor 13.jpg',
        'title': 'Camp Office',
        'location': 'Commissioner Colony',
        'category': 'Residential',
      },
      {
        'image':
            'assets/images/Karachi sand work Islamabad & Peshawar/sand work Islamabad Peshawar  6.jpg',
        'title': 'Sand Work',
        'location': 'Islamabad–Peshawar',
        'category': 'Residential',
      },
      {
        'image': 'assets/images/Stone work nathia Gali/Stone work  3.jpg',
        'title': 'Stone Work',
        'location': 'Nathia Gali',
        'category': 'Finishing',
      },
      {
        'image': 'assets/images/Artificial work swat zoo/zoo 2.jpg',
        'title': 'Artificial Zoo',
        'location': 'Swat Zoo',
        'category': 'Decorative',
      },
      {
        'image':
            'assets/images/Asphalt and PCC road Punjab regiment centr/pcc road punjab 2.jpg',
        'title': 'Asphalt and PCC Road',
        'location': 'Punjab Regiment Center',
        'category': 'Road Construction',
      },
      {
        'image':
            'assets/images/Road work commissioner colony Rawalpindi/Road work commissioner  2.jpg',
        'title': 'Road Work',
        'location': 'Commissioner Colony, Rawalpindi',
        'category': 'Infrastructure',
      },
      {
        'image': 'assets/images/Boundary wall work Rawat/boundary wall 1.jpg',
        'title': 'Boundary Wall Work',
        'location': 'Rawat ,Pakistan',
        'category': 'Residential',
      },
      {
        'image':
            'assets/images/Construction of drain work askari 13 Rawalpindi/rain work askari  13.jpg',
        'title': 'Construction of Drain Work',
        'location': 'Askari 13, Rawalpindi',
        'category': 'Drainage',
      },
      {
        'image':
            'assets/images/Construction of commercial palaza Islamabad/commercial palaza islamabad 6.jpg',
        'title': 'Construction of Commercial Plaza',
        'location': 'Islamabad',
        'category': 'Commercial',
      },
      {
        'image':
            'assets/images/Drain work DHA 5 Islamabad/Drain work DHA  7.jpg',
        'title': 'Drain Work',
        'location': 'DHA Phase 5, Islamabad',
        'category': 'Drainage',
      },
    ];

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Our Portfolio',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Showcasing excellence in every project',
            style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _ProjectCard(
                image: projects[index]['image']!,
                title: projects[index]['title']!,
                location: projects[index]['location']!,
                category: projects[index]['category']!,
                delay: index * 100,
                onTap: () {},
                index: index,
              );
            },
          ),
          const SizedBox(height: 48),
          const _FooterSection(),
        ],
      ),
    );
  }
}

// ABOUT SECTION
class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TeamSection(),
        _TimelineSection(),
        _CertificationsSection(),
        _FooterSection(),
      ],
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Meet Our Leadership',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F0E47).withOpacity(0.4),
                  const Color(0xFF505081).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF8686AC).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF505081), Color(0xFF8686AC)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/shafi.jpg'),
                          fit: BoxFit.cover,
                          // scale: 6,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Shafi Ullah',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Founder & CEO',
                  style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'With over 20 years of experience in construction and architecture, '
                  'John leads our team with vision and dedication to excellence.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8686AC),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          isMobile
              ? Column(
                  children: const [
                    _MissionCard(
                      icon: Icons.visibility,
                      title: 'Our Vision',
                      description:
                          'To be the global leader in sustainable construction excellence.',
                    ),
                    SizedBox(height: 24),
                    _MissionCard(
                      icon: Icons.rocket_launch,
                      title: 'Our Mission',
                      description:
                          'Delivering innovative solutions that exceed expectations.',
                    ),
                  ],
                )
              : Row(
                  children: const [
                    Expanded(
                      child: _MissionCard(
                        icon: Icons.visibility,
                        title: 'Our Vision',
                        description:
                            'To be the global leader in sustainable construction excellence.',
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _MissionCard(
                        icon: Icons.rocket_launch,
                        title: 'Our Mission',
                        description:
                            'Delivering innovative solutions that exceed expectations.',
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _MissionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<_MissionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F0E47).withOpacity(0.4),
              const Color(0xFF505081).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8686AC).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF505081).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF505081), Color(0xFF8686AC)],
                ),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF8686AC),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection();

  @override
  Widget build(BuildContext context) {
    final milestones = [
      {
        'year': '2013',
        'title': 'Company Founded',
        'description': 'Started with a vision to transform construction',
      },

      {
        'year': '2018',
        'title': 'Private Projects',
        'description':
            'Worked on various residential and institutional construction projects including houses and schools, focusing on quality workmanship and timely completion.',
      },
      {
        'year': '2018 – 2020',
        'title': 'Punjab Regiment Center, Mardan',
        'description':
            'Contributed to multiple infrastructure projects including grounds, roads, building renovations, and new constructions within the military premises.',
      },
      {
        'year': '2020 – 2022',
        'title': 'Commissioner House Project',
        'description':
            'Involved in the construction and maintenance of the Commissioner’s House, ensuring high standards of civil work and finishing.',
      },
      {
        'year': '2022 – 2023',
        'title': 'Drain Construction Project',
        'description':
            'Executed drainage system construction with emphasis on durability, proper flow design, and adherence to municipal standards.',
      },
      {
        'year': '2023 – 2024',
        'title': 'DHA Phase 5, Islamabad (Plaza Project)',
        'description':
            'Worked on a commercial plaza project, handling structural work, finishing, and coordination with engineers and contractors.',
      },
      {
        'year': '2024 – 2025',
        'title': 'Community Hall, Askari Chowk',
        'description':
            'Currently engaged in the construction of a modern community hall, overseeing site activities, material management, and quality control.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: const Color(0xFF0F0E47).withOpacity(0.2),
      child: Column(
        children: [
          const Text(
            'Our Journey',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Building excellence over the years',
            style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
          ),
          const SizedBox(height: 48),
          ...milestones.asMap().entries.map((entry) {
            return _TimelineTile(
              year: entry.value['year']!,
              title: entry.value['title']!,
              description: entry.value['description']!,
              isLast: entry.key == milestones.length - 1,
              delay: entry.key * 200,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatefulWidget {
  final String year;
  final String title;
  final String description;
  final bool isLast;
  final int delay;

  const _TimelineTile({
    required this.year,
    required this.title,
    required this.description,
    required this.isLast,
    required this.delay,
  });

  @override
  State<_TimelineTile> createState() => _TimelineTileState();
}

class _TimelineTileState extends State<_TimelineTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile) ...[
                    SizedBox(
                      width: 100,
                      child: Text(
                        widget.year,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8686AC),
                        ),
                      ),
                    ),
                  ],
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF505081), Color(0xFF8686AC)],
                          ),
                        ),
                      ),
                      if (!widget.isLast)
                        Container(
                          width: 2,
                          height: 80,
                          color: const Color(0xFF8686AC).withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMobile)
                          Text(
                            widget.year,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8686AC),
                            ),
                          ),
                        if (isMobile) const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8686AC),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CertificationsSection extends StatelessWidget {
  const _CertificationsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Certifications & Partners',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Trusted by industry leaders worldwide',
            style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentsViewerScreen(
                    ownerName: 'Shafi Ullah', // Replace with actual owner name
                  ),
                ),
              );
            },
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: const [
                _CertificationLogo(
                  text: 'Licence of Pakistani Constructor',
                  tooltip: '',
                ),
                _CertificationLogo(
                  text: 'Contractor Registration Card',
                  tooltip: '',
                ),
                _CertificationLogo(text: 'Renewal Licence', tooltip: ''),
                _CertificationLogo(
                  text: 'Affidavit of Non-Blacklisting',
                  tooltip: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificationLogo extends StatefulWidget {
  final String text;
  final String tooltip;

  const _CertificationLogo({required this.text, required this.tooltip});

  @override
  State<_CertificationLogo> createState() => _CertificationLogoState();
}

class _CertificationLogoState extends State<_CertificationLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      decoration: BoxDecoration(
        color: const Color(0xFF505081),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 280,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0F0E47).withOpacity(0.4),
                const Color(0xFF505081).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF8686AC).withOpacity(0.6)
                  : const Color(0xFF8686AC).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF505081).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isHovered ? Colors.white : const Color(0xFF8686AC),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// CONTACT SECTION
class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Get In Touch',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Let\'s build something amazing together',
            style: TextStyle(fontSize: 18, color: Color(0xFF8686AC)),
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: const [
                    _ContactForm(),
                    SizedBox(height: 32),
                    _ContactInfo(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 6, child: _ContactForm()),
                    SizedBox(width: 48),
                    Expanded(flex: 4, child: _ContactInfo()),
                  ],
                ),
          const SizedBox(height: 64),
          const _FooterSection(),
        ],
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Message sent successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF505081),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F0E47).withOpacity(0.4),
            const Color(0xFF505081).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8686AC).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CustomTextField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 24),
            _CustomTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _CustomTextField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.message,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            _SubmitButton(onPressed: _submitForm, isSubmitting: _isSubmitting),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused
                ? const Color(0xFF505081)
                : const Color(0xFF8686AC).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF505081).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused
                  ? const Color(0xFF8686AC)
                  : const Color(0xFF8686AC).withOpacity(0.6),
            ),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused
                  ? const Color(0xFF8686AC)
                  : const Color(0xFF8686AC).withOpacity(0.6),
            ),
            filled: true,
            fillColor: const Color(0xFF0F0E47).withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            if (widget.keyboardType == TextInputType.emailAddress) {
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSubmitting;

  const _SubmitButton({required this.onPressed, this.isSubmitting = false});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isSubmitting ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isSubmitting
                  ? [const Color(0xFF8686AC), const Color(0xFF8686AC)]
                  : _isHovered
                  ? [const Color(0xFF505081), const Color(0xFF8686AC)]
                  : [const Color(0xFF0F0E47), const Color(0xFF505081)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered && !widget.isSubmitting
                ? [
                    BoxShadow(
                      color: const Color(0xFF505081).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          transform: Matrix4.identity()
            ..scale(_isHovered && !widget.isSubmitting ? 1.02 : 1.0),
          child: Center(
            child: widget.isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _InfoCard(
          icon: Icons.email,
          title: 'Email',
          info: 'ms.constructionmrd@gmail.com',
        ),
        SizedBox(height: 24),
        _InfoCard(icon: Icons.phone, title: 'Phone', info: '+923402839827'),
        SizedBox(height: 24),
        _InfoCard(
          icon: Icons.location_on,
          title: 'Location',
          info: 'Post Office Wari, Shalgah, Tehsil Wari, Dir Upper',
        ),
        SizedBox(height: 24),
        _InfoCard(
          icon: Icons.access_time,
          title: 'Business Hours',
          info: 'Mon-Fri: 8AM - 6PM',
        ),
      ],
    );
  }
}

class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String info;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.info,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F0E47).withOpacity(0.4),
              const Color(0xFF505081).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8686AC).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF505081).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF505081), Color(0xFF8686AC)],
                ),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.info,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8686AC),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FOOTER SECTION
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 32 : 48,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0E47).withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF8686AC).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF505081), Color(0xFF8686AC)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.architecture,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'MS Shafi Ullah',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Building tomorrow\'s landmarks with precision, innovation, and excellence.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8686AC),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _SocialIcon(
                            icon: Icons.facebook,
                            onTap: () {
                              html.window.open(
                                'https://www.facebook.com/share/1UZ2cZftxB/',
                                '_blank', // opens in new browser tab
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _SocialIcon(
                            icon: Icons.mail,
                            onTap: () async {
                              final Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: 'ms.constructionmrd@gmail.com',
                                query:
                                    'subject=Inquiry&body=Hello, I would like to know more about your services.',
                              );
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          _SocialIcon(
                            icon: Icons.phone,
                            onTap: () async {
                              final Uri phoneUri = Uri(
                                scheme: 'tel',
                                path: '+923402839827',
                              );
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: _FooterColumn(
                    title: 'Quick Links',
                    items: ['Home', 'Projects', 'About Us', 'Contact'],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF505081), Color(0xFF8686AC)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.architecture,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'MS Shafi Ullah',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Building tomorrow\'s landmarks with precision, innovation, and excellence.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8686AC),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _SocialIcon(
                      icon: Icons.facebook,
                      onTap: () {
                        html.window.open(
                          'https://www.facebook.com/share/1UZ2cZftxB/',
                          '_blank', // opens in new browser tab
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _SocialIcon(
                      icon: Icons.mail,
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'ms.constructionmrd@gmail.com',
                          query:
                              'subject=Inquiry&body=Hello, I would like to know more about your services.',
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _SocialIcon(
                      icon: Icons.phone,
                      onTap: () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: '+923402839827',
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 32),
          Container(height: 1, color: const Color(0xFF8686AC).withOpacity(0.2)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MS Shafi Ullah',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              if (!isMobile)
                Row(
                  children: const [
                    _FooterLink(text: 'Privacy Policy'),
                    SizedBox(width: 16),
                    _FooterLink(text: 'Terms of Service'),
                  ],
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _FooterLink(text: 'Privacy'),
                SizedBox(width: 16),
                _FooterLink(text: 'Terms'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FooterLink(text: item),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 14,
            color: _isHovered ? Colors.white : const Color(0xFF8686AC),
            decoration: _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isHovered
                ? const LinearGradient(
                    colors: [Color(0xFF505081), Color(0xFF8686AC)],
                  )
                : null,
            color: _isHovered ? null : const Color(0xFF0F0E47).withOpacity(0.5),
            border: Border.all(
              color: const Color(0xFF8686AC).withOpacity(0.3),
              width: 1,
            ),
          ),
          transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
          child: Icon(widget.icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

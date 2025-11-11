import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class ProjectData {
//   final String title;
//   final String category;
//   final String location;
//   final String date;
//   final String description;
//   final List<String> imagePaths;
//
//   ProjectData({
//     required this.title,
//     required this.category,
//     required this.location,
//     required this.date,
//     required this.description,
//     required this.imagePaths,
//   });
// }

class ProjectShowcaseScreen extends StatefulWidget {
  // final ProjectData projectData;
  dynamic list;
  dynamic title;
  dynamic category;
  dynamic location;
  dynamic backgroundimage;
  dynamic date;

  ProjectShowcaseScreen({
    Key? key,
    required this.title,
    required this.location,
    required this.category,
    required this.list,
    required this.backgroundimage,
    required this.date,
  }) : super(key: key);

  @override
  State<ProjectShowcaseScreen> createState() => _ProjectShowcaseScreenState();
}

class _ProjectShowcaseScreenState extends State<ProjectShowcaseScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _headerAnimController;
  late AnimationController _statsAnimController;

  double _scrollOffset = 0.0;
  List<String> list1 = [
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg',
    'assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  9.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  1.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  2.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  3.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  4.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  5.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  6.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  7.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  8.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  10.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  11.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  12.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  13.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
    // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  15.jpg',
  ];
  // Stats animation values
  int _duration = 0;
  int _sqft = 0;
  int _team = 0;

  final int _finalDuration = 24;
  final int _finalSqft = 125000;
  final int _finalBudget = 45;
  final int _finalTeam = 150;

  // late List<ProjectImage> images;

  @override
  void initState() {
    super.initState();

    // Convert image paths to ProjectImage objects
    // images = widget.projectData.imagePaths.asMap().entries.map((entry) {
    //   return ProjectImage(
    //     id: entry.key + 1,
    //     url: entry.value,
    //     caption: 'Construction Phase ${entry.key + 1}',
    //   );
    // }).toList();

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _statsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scrollController.addListener(_onScroll);

    // Trigger animations
    Future.delayed(const Duration(milliseconds: 500), () {
      _headerAnimController.forward();
    });
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });

    // Animate stats when scrolled to stats section
    if (_scrollOffset > 300 &&
        _statsAnimController.status != AnimationStatus.completed) {
      _statsAnimController.forward();
      _animateStats();
    }
  }

  void _animateStats() {
    const steps = 60;
    for (int i = 0; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * 30), () {
        if (mounted) {
          setState(() {
            _duration = (_finalDuration * i / steps).round();
            _sqft = (_finalSqft * i / steps).round();
            _team = (_finalTeam * i / steps).round();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimController.dispose();
    _statsAnimController.dispose();
    super.dispose();
  }

  double get _headerOpacity => (_scrollOffset / 300).clamp(0.0, 1.0);
  double get _heroScale => 1 + (_scrollOffset * 0.0002).clamp(0.0, 0.3);
  double get _parallaxY => _scrollOffset * 0.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 1024;
    final isTablet = size.width > 600 && size.width <= 1024;
    final isMobile = size.width <= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildFloatingParticles(),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeroSection(size)),
              SliverToBoxAdapter(
                child: _buildStatsSection(isWeb, isTablet, isMobile),
              ),
              // SliverToBoxAdapter(child: _buildDescriptionSection()),
              SliverToBoxAdapter(
                child: _buildGallerySection(isWeb, isTablet, isMobile),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          _buildSmartAppBar(),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(20, (index) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 3000 + (index * 100)),
              left: (index * 50.0) % MediaQuery.of(context).size.width,
              top: (index * 30.0) % MediaQuery.of(context).size.height,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF8686AC).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSmartAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Color(0xFF505081).withOpacity(_headerOpacity * 0.95),
          boxShadow: _headerOpacity > 0.5
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: _headerOpacity,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
  }

  Widget _buildProgressBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 56,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        color: Colors.white.withOpacity(0.1),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: (_scrollOffset / 2000).clamp(0.0, 1.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8686AC), Color(0xFF505081)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(Size size) {
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          Transform.scale(
            scale: _heroScale,
            child: Transform.translate(
              offset: Offset(0, -_parallaxY),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.backgroundimage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF505081).withOpacity(0.4),
                  const Color(0xFF1A1A2E).withOpacity(0.9),
                  const Color(0xFF1A1A2E),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF8686AC,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              widget.category,
                              style: const TextStyle(
                                color: Color(0xFF8686AC),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ...widget.title.split(' ').asMap().entries.map((entry) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                    ? 56
                                    : 40,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF8686AC),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.location,
                                  style: const TextStyle(
                                    color: Color(0xFF8686AC),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF8686AC),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.date,
                                  style: const TextStyle(
                                    color: Color(0xFF8686AC),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: (1 - _scrollOffset / 300).clamp(0.0, 1.0),
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isWeb, bool isTablet, bool isMobile) {
    final crossAxisCount = isWeb ? 3 : (isTablet ? 3 : 1);

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 80 : 24,
        vertical: isWeb ? 80 : 48,
      ),
      child: Center(
        // Centers the entire grid
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: isWeb ? 1.2 : 1.1,
          children: [
            _buildStatCard(
              icon: Icons.schedule,
              value: '$_duration',
              unit: ' Months',
              label: 'Duration',
              index: 0,
            ),
            _buildStatCard(
              icon: Icons.home,
              value: _sqft.toString(),
              unit: ' sq ft',
              label: 'Square Footage',
              index: 1,
            ),
            _buildStatCard(
              icon: Icons.people,
              value: '$_team',
              unit: ' People',
              label: 'Team Size',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required int index,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, double animValue, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF505081).withOpacity(0.3),
                    const Color(0xFF505081).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF505081).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8686AC).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: const Color(0xFF8686AC), size: 32),
                  const Spacer(),
                  Text(
                    value + unit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFF8686AC).withOpacity(0.8),
                      fontSize: 14,
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

  // Widget _buildDescriptionSection() {
  //   return Container(
  //     color: const Color(0xFF1A1A2E),
  //     padding: EdgeInsets.symmetric(
  //       horizontal: MediaQuery.of(context).size.width > 1024 ? 80 : 24,
  //       vertical: 32,
  //     ),
  //     child: Text(
  //       'widget.projectData.description',
  //       style: const TextStyle(
  //         color: Color(0xFF8686AC),
  //         fontSize: 16,
  //         height: 1.6,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGallerySection(bool isWeb, bool isTablet, bool isMobile) {
    final crossAxisCount = isWeb ? 4 : (isTablet ? 3 : 2);

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 80 : 24,
        vertical: isWeb ? 60 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Gallery',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: widget.list.length,
            // itemCount: widget.list.length,
            // itemCount: images.length,
            itemBuilder: (context, index) {
              print('the length is ${widget.list.length}');
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 500 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: GestureDetector(
                        // onTap: () => _showImageLightbox(index),
                        child: Container(
                          // height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF505081).withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  widget.list[index],
                                  // cardList[index],
                                  // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
                                  // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
                                  // projectdata.imagePaths[index],
                                  // images[index].url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(
                                              0xFF505081,
                                            ).withOpacity(0.2),
                                            const Color(
                                              0xFF8686AC,
                                            ).withOpacity(0.4),
                                            const Color(
                                              0xFF505081,
                                            ).withOpacity(0.2),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFF505081,
                                        ).withOpacity(0.8),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   bottom: 16,
                                //   left: 16,
                                //   right: 16,
                                //   child: Text(
                                //     images[index].caption,
                                //     style: const TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w600,
                                //     ),
                                //   ),
                                // ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.zoom_in,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
              // return _buildGalleryItem(index, list1.length);
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildGalleryItem(int index, dynamic cardList) {
  //   final heights = [200.0, 250.0, 300.0, 220.0, 280.0];
  //   final height = heights[index % heights.length];
  //
  //   print('the image are ${cardList[0]}\n');
  //   return TweenAnimationBuilder(
  //     tween: Tween<double>(begin: 0, end: 1),
  //     duration: Duration(milliseconds: 500 + (index * 50)),
  //     curve: Curves.easeOut,
  //     builder: (context, double value, child) {
  //       return Opacity(
  //         opacity: value,
  //         child: Transform.translate(
  //           offset: Offset(0, 20 * (1 - value)),
  //           child: GestureDetector(
  //             // onTap: () => _showImageLightbox(index),
  //             child: Container(
  //               height: height,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(16),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: const Color(0xFF505081).withOpacity(0.2),
  //                     blurRadius: 15,
  //                     spreadRadius: 2,
  //                   ),
  //                 ],
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(16),
  //                 child: Stack(
  //                   fit: StackFit.expand,
  //                   children: [
  //                     Image.asset(
  //                       cardList[index],
  //                       // cardList[index],
  //                       // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
  //                       // 'assets/images/Construction of Commishnor House at GOR-1/commissor house  14.jpg',
  //                       // projectdata.imagePaths[index],
  //                       // images[index].url,
  //                       fit: BoxFit.cover,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return Container(
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               begin: Alignment.topLeft,
  //                               end: Alignment.bottomRight,
  //                               colors: [
  //                                 const Color(0xFF505081).withOpacity(0.2),
  //                                 const Color(0xFF8686AC).withOpacity(0.4),
  //                                 const Color(0xFF505081).withOpacity(0.2),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         gradient: LinearGradient(
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                           colors: [
  //                             Colors.transparent,
  //                             const Color(0xFF505081).withOpacity(0.8),
  //                           ],
  //                           stops: const [0.5, 1.0],
  //                         ),
  //                       ),
  //                     ),
  //                     // Positioned(
  //                     //   bottom: 16,
  //                     //   left: 16,
  //                     //   right: 16,
  //                     //   child: Text(
  //                     //     images[index].caption,
  //                     //     style: const TextStyle(
  //                     //       color: Colors.white,
  //                     //       fontSize: 14,
  //                     //       fontWeight: FontWeight.w600,
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                     Positioned(
  //                       top: 12,
  //                       right: 12,
  //                       child: Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white.withOpacity(0.2),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(
  //                           Icons.zoom_in,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showImageLightbox(int index) {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black.withOpacity(0.95),
  //     builder: (context) => _ImageLightbox(images: images, initialIndex: index),
  //   );
  // }
}

// class ProjectImage {
//   final int id;
//   final String url;
//   final String caption;
//
//   ProjectImage({required this.id, required this.url, required this.caption});
// }

// class _ImageLightbox extends StatefulWidget {
//   // final List<ProjectImage> images;
//   final int initialIndex;
//
//   const _ImageLightbox({
//     Key? key,
//     // required this.images,
//     required this.initialIndex,
//   }) : super(key: key);
//
//   @override
//   State<_ImageLightbox> createState() => _ImageLightboxState();
// }
//
// class _ImageLightboxState extends State<_ImageLightbox> {
//   late PageController _pageController;
//   late int _currentIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: widget.images.length,
//             onPageChanged: (index) => setState(() => _currentIndex = index),
//             itemBuilder: (context, index) {
//               return Center(
//                 child: InteractiveViewer(
//                   minScale: 1.0,
//                   maxScale: 4.0,
//                   child: Image.asset(
//                     widget.images[index].url,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               );
//             },
//           ),
//           Positioned(
//             top: 48,
//             right: 16,
//             child: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.close, color: Colors.white),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           Positioned(
//             top: 48,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${_currentIndex + 1} / ${widget.images.length}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

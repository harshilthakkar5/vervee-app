
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vervee_app/domain/model/post/GetPost.dart';
import 'package:vervee_app/presentation/screen/AvatarCustomizationScreen.dart';
import 'package:vervee_app/presentation/screen/FinancialLiteracyScreen.dart';
import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
import 'package:vervee_app/presentation/viewmodal/post/GetPostViewModel.dart';

import '../../domain/model/post/CreatePost.dart';
import '../../utils/AuthService.dart';
import '../../utils/NetworkResult.dart';
import '../../utils/PostCacheService.dart';
import '../../utils/PostCardSkeleton.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../viewmodal/post/CreatePostViewmodel.dart';
import '../widgets/Common_Widgets/SharedBottomNav.dart';
import '../widgets/Common_Widgets/VerveeTopBar.dart';
import '../widgets/HomeScreenWidgets/PostCard.dart';
import 'CreatePostScreen.dart';
import 'LoginScreen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import '../../domain/models/feed_post.dart';
// import '../viewmodels/feed_viewmodel.dart';
// import '../screens/create_post_screen.dart';
// import '../../services/auth_service.dart';
// import '../screens/login_screen.dart';

// ─── NO CHANGES IN CONSTANTS, MODELS, COLORS ─────────────────────────────────
const kBgDark    = Color(0xFF0F0120);
const kBgCard    = Color(0xFF150328);
const kBgDeep    = Color(0xFF0A0118);
const kPurple    = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold      = Color(0xFFD4AF37);
const kGoldLight = Color(0xFFFFD700);
const kBorder    = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted = Color(0xFF888888);
const kRed = Color(0xEF4444FF);

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'gold & commodities':
    case 'gold':      return const Color(0xFFD4AF37);
    case 'oil market':
    case 'oil':       return const Color(0xFF22C55E);
    case 'forex & currency':
    case 'forex':     return const Color(0xFF3B82F6);
    case 'crypto':    return const Color(0xFFF59E0B);
    case 'stocks':    return const Color(0xFF06B6D4);
    case 'economy':
    case 'macro':     return const Color(0xFFEF4444);
    default:          return kPurpleLight;
  }
}

class MarketTicker {
  final String symbol;
  final String change;
  final bool isUp;
  MarketTicker(this.symbol, this.change, this.isUp);
}

// ✅ CHANGE #5 — StoryCategory class aur storyCategories list REMOVE kar di,
//               kyunki ab stories row me sirf Add Post button rakhna hai.

final List<MarketTicker> marketTickers = [
  MarketTicker('GOLD', '+1.2%', true),
  MarketTicker('OIL',  '-0.8%', false),
  MarketTicker('EUR/USD', '+0.3%', true),
  MarketTicker('BTC',  '+2.1%', true),
  MarketTicker('S&P500', '-0.5%', false),
  MarketTicker('GBP/USD', '+0.6%', true),
  MarketTicker('SILVER', '-1.1%', false),
];

const _filterCategories = [
  // 'All', 'Forex & Currency', 'Crypto', 'Stocks',
  // 'Commodities', 'Economy', 'Gold & Commodities', 'Oil Market', 'Other',
  'All',
  'Oil Market',
  'Gold & Commodities',
  'Forex & Currency',
  'Economic Policy',
  'Market Volatility',
  'Vervee Academy',
];


// ═══════════════════════════════════════════════════════════════════════════════
//  HOME SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late AnimationController _tickerCtrl;
  late AnimationController _glowCtrl;
  late ScrollController _scrollCtrl;
  bool _showFab = false;
  double _fabScale = 1;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _tickerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _glowCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _scrollCtrl = ScrollController();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.offset > 200 && !_showFab) {
      setState(() => _showFab = true);
    } else if (_scrollCtrl.offset <= 200 && _showFab) {
      setState(() => _showFab = false);
    }
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      ref.read(getPostViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _tickerCtrl.dispose();
    _glowCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _openprofile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  Future<void> _logout() async {

    // ✅ 1 — Post cache clear karo (SharedPreferences me saved posts)
    await PostCacheService.clearAllCache();

    // ✅ 2 — Image cache clear karo (CachedNetworkImage ka disk cache)
    await CachedNetworkImage.evictFromCache('');
    // ya poora image cache clear karo:
    await DefaultCacheManager().emptyCache();

    await AuthService.instance.logout(keepCredentials: true);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // ✅ ADD — CreatePost success pe auto-refresh
    ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (_, next) {
      if (next is Success<CreatePost>) {
        ref.read(getPostViewModelProvider.notifier).refresh();
      }
    });

    return Scaffold(
      backgroundColor: kBgDark,
      body: Stack(
        children: [
          Column(children: [
           // _buildTopBar(context, isTablet),
            VerveeTopBar(onProfile: _openprofile),
            Expanded(child: _buildFeed(context, isTablet)),
          ]),
          if (_showFab)
            Positioned(
              right: 16, bottom: 80,
              child: GestureDetector(
                onTap: () => _scrollCtrl.animateTo(0,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: kPurple,
                    boxShadow: [BoxShadow(color: kPurple.withOpacity(0.5), blurRadius: 12, spreadRadius: 2)],
                  ),
                  child: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 22),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(currentIndex: 0), //_buildBottomNav(),
    );
  }

  // ── Top App Bar ───────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, bool isTablet) {

    final avatarUrl = ref.watch(avatarViewModelProvider).generatedMascotUrl; // ✅ ADD
    final profileState = ref.watch(profileInfoViewModelProvider);

    return Container(
      color: kBgCard,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16, right: 16, bottom: 10,
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => Text('VERVEE', style: TextStyle(
              color: kGold, fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w900, letterSpacing: 3,
              shadows: [Shadow(
                color: kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
                blurRadius: 8 + 4 * _glowCtrl.value,
              )],
            )),
          ),
          Text('A C A D E M Y', style: TextStyle(
            color: kPurpleLight, fontSize: isTablet ? 9 : 7.5,
            fontWeight: FontWeight.w600, letterSpacing: 3,
          )),
        ]),
        const Spacer(),

        // ✅ CHANGE #6 — Search ab ViewModel ke search() ko call karta hai
        //               jo ApiService se data fetch karta hai (no-internet fix
        //               backend/ApiService level par hona chahiye, lekin yahan
        //               search sheet me error snackbar add kiya hai taaki user
        //               ko proper feedback mile instead of silent fail).
        _TopIconBtn(icon: Icons.search_rounded, onTap: () => _showSearchSheet(context)),
        const SizedBox(width: 8),

        // Stack(clipBehavior: Clip.none, children: [
        //   _TopIconBtn(icon: Icons.notifications_outlined, onTap: () {}),
        //   Positioned(
        //     top: -2, right: -2,
        //     child: Container(
        //       width: 8, height: 8,
        //       decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEA4335)),
        //     ),
        //   ),
        // ]),
       // const SizedBox(width: 8),

// ---- profile icon ----------------------------------------------------------->
        // ✅ NAYA CODE — PopupMenuButton with 3 options
        PopupMenuButton<String>(
          offset: const Offset(0, 44),
          color: kBgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: kBorder, width: 0.8),
          ),
          elevation: 8,
          onSelected: (value) async {
            switch (value) {
              case 'profile':
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
                break;
              case 'avatar':
              // TODO: Avatar screen navigate karo
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AvatarCustomizationScreen()),
              );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Avatar screen coming soon!'),
                //     backgroundColor: kPurple,
                //   ),
                // );
                break;
              case 'logout':
                _logout(); // ✅ Logout logic bilkul waise hi hai jaise pehle tha
                break;
            }
          },
          itemBuilder: (context) => [
            // ── Profile ───────────────────────────────────────
            PopupMenuItem<String>(
              value: 'profile',
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPurple.withOpacity(0.15),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: kPurpleLight, size: 18),
                ),
                const SizedBox(width: 12),
                const Text('Profile', style: TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
              ]),
            ),
            // ── Avatar ────────────────────────────────────────
            PopupMenuItem<String>(
              value: 'avatar',
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kGold.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.face_rounded, color: kGold, size: 18),
                ),
                const SizedBox(width: 12),
                const Text('Avatar', style: TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
              ]),
            ),
            // ── Divider ───────────────────────────────────────
            const PopupMenuDivider(height: 1),
            // ── Logout ────────────────────────────────────────
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEF4444).withOpacity(0.12),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                ),
                const SizedBox(width: 12),
                const Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w500)),
              ]),
            ),
          ],
          // ── Profile Avatar Button ──────────────────────────
          // child: Container(
          //   width: 34, height: 34,
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     gradient: LinearGradient(
          //       colors: [kGold, kPurple],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   child: const Center(
          //     child: Text(
          //       'VA',
          //       style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
          //     ),
          //   ),
          // ),
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ✅ Agar URL hai to gradient hatao, warna rakhao
              gradient: avatarUrl == null
                  ? const LinearGradient(
                colors: [kGold, kPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
            ),
            child: avatarUrl != null
            // ✅ Saved avatar image dikhao
                ? ClipOval(
              child: Image.network(
                avatarUrl,
                width: 34, height: 34,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    // API se naam aaya to initial, warna 'VA'
                    profileState.profile != null
                        ? profileState.profile!.name
                        .substring(0, 1)
                        .toUpperCase()
                        : 'VA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
            // ✅ Default 'VA' text
                : const Center(
              child: Text('VA',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ),

        // Text('VA',
        //     style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),


        // Text(
        //   // API se naam aaya to initial, warna 'VA'
        //   profileState.profile != null
        //       ? profileState.profile!.name
        //       .substring(0, 1)
        //       .toUpperCase()
        //       : 'VA',
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontSize: 13,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),


//         GestureDetector(
//           onTap: _logout,
//           child: Container(
//             width: 34, height: 34,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(colors: [kGold, kPurple],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight),
//             ),
//             child: const Center(child: Text('VA',
//                 style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
//           ),
//         ),

      ]),
    );
  }

  // ── Search Bottom Sheet ───────────────────────────────────────────────────
  // ✅ CHANGE #6 — Error handling add kiya: agar search fail ho toh
  //               ScaffoldMessenger se SnackBar dikhao. Pehle error silently
  //               fail hoti thi aur "no internet" dikhta tha bina explanation ke.
  void _showSearchSheet(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: const BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: kTextMuted, borderRadius: BorderRadius.circular(2)),
            ),
            TextField(
              controller: ctrl,
              autofocus: true,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search posts...',
                hintStyle: const TextStyle(color: kTextMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: kTextMuted),
                filled: true, fillColor: kBgDeep,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPurple)),
              ),
              onSubmitted: (q) async {
                final query = q.trim();
                if (query.isEmpty) return;
                Navigator.pop(context);
                try {
                  // ✅ CHANGE #6 — search() call wrap kiya try/catch me,
                  //               error aane par SnackBar dikhata hai.
                  await ref.read(getPostViewModelProvider.notifier).search(query);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Search failed: ${e.toString()}'),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  // ── Main Feed ─────────────────────────────────────────────────────────────
  Widget _buildFeed(BuildContext context, bool isTablet) {
    final feedState = ref.watch(getPostViewModelProvider);

    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
       // SliverToBoxAdapter(child: _buildStoriesRow(context, isTablet)),
        SliverToBoxAdapter(child: _buildCategoryTabs(feedState.selectedCategory)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(children: [
              Container(width: 3, height: 16,
                  decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              const Text('Latest Market News', style: TextStyle(
                  color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
              const Spacer(),
              GestureDetector(
                onTap: () => ref.read(getPostViewModelProvider.notifier).refresh(),
                child: const Text('Refresh', style: TextStyle(
                    color: kPurpleLight, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ]),
          ),
        ),

        if (feedState.isLoading)
          const SliverToBoxAdapter(child: _FeedShimmer()),

        if (!feedState.isLoading && feedState.errorMessage != null)
          SliverToBoxAdapter(child: _ErrorWidget(
            message: feedState.errorMessage!,
            onRetry: () => ref.read(getPostViewModelProvider.notifier).loadPosts(),
          )),

        if (!feedState.isLoading && feedState.posts.isEmpty && feedState.errorMessage == null)
          const SliverToBoxAdapter(child: _EmptyWidget()),

        if (feedState.posts.isNotEmpty)
          if (isTablet)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12,
                  mainAxisSpacing: 12, childAspectRatio: 0.68, // ✅ CHANGE #2 — thoda chhota ratio image ke liye
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => PostCard(
                      post:     feedState.posts[index],
                      isTablet: false,
                    ),
                  //         _PostCard(
                  //   post: feedState.posts[index],
                  //   isTablet: true,
                  //   onLikeTap: () => ref.read(getPostViewModelProvider.notifier)
                  //       .toggleLike(feedState.posts[index].id),
                  // ),
                  childCount: feedState.posts.length,
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => PostCard(
                      post:     feedState.posts[index],
                      isTablet: false,
                    ),
                //         _PostCard(
                //   post: feedState.posts[index],
                //   isTablet: false,
                //   onLikeTap: () => ref.read(getPostViewModelProvider.notifier)
                //       .toggleLike(feedState.posts[index].id),
                // ),
                childCount: feedState.posts.length,
              ),
            ),

        if (feedState.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(color: kPurple, strokeWidth: 2)),
            ),
          ),

        if (feedState.hasReachedEnd && feedState.posts.isNotEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No more posts',
                  style: TextStyle(color: kTextMuted, fontSize: 12))),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  // ── Category Filter Tabs ──────────────────────────────────────────────────
  Widget _buildCategoryTabs(String selected) {
    return Container(
      height: 38, color: kBgCard,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _filterCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final cat        = _filterCategories[i];
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => ref.read(getPostViewModelProvider.notifier).filterByCategory(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? kPurple : kBgDeep,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? kPurple : kBorder, width: 0.8),
              ),
              child: Text(cat, style: TextStyle(
                color: isSelected ? Colors.white : kTextMuted,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              )),
            ),
          );
        },
      ),
    );
  }

  // ── Stories Row ───────────────────────────────────────────────────────────
  // ✅ CHANGE #5 — StoryCategory items REMOVE kar diye. Ab sirf "Add Post"
  //               button dikhega. Height bhi adjust ki aur ListView ki jagah
  //               simple Container use kiya kyunki scroll ki zaroorat nahi.

  Widget _buildStoriesRow(BuildContext context, bool isTablet) {
    final btnSize = isTablet ? 56.0 : 50.0;
    return Container(
      height: isTablet ? 85 : 76,
      color: kBgCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        // ✅ CHANGE #5 — Sirf Add Post button, story items completely hataaye
        Column(mainAxisSize: MainAxisSize.min, children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
                if (context.mounted) {
                  ref.read(getPostViewModelProvider.notifier).refresh();
                }
              },
              child: Container(
                width: btnSize, height: btnSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: kBgDeep,
                  border: Border.all(color: kPurple.withOpacity(0.5), width: 1.5),
                ),
                child: const Center(child: Icon(Icons.add_rounded, color: kPurpleLight, size: 22)),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text('Add Post', style: TextStyle(color: kTextMuted, fontSize: 9)),
        ]),
      ]),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  // Widget _buildBottomNav() {
  //   final items = [
  //     _NavItem(icon: Icons.home_rounded,           label: 'Home'),
  //     _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Courses'),
  //
  //     // ✅ Center Add Button
  //     _NavItem(icon: Icons.add_rounded, label: 'Add'),
  //
  //    // _NavItem(icon: Icons.add_circle,     label: 'Add'),
  //     _NavItem(icon: Icons.wifi_tethering_rounded, label: 'Signals'),
  //     _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  //   ];
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: kBgCard,
  //       border: Border(top: BorderSide(color: kBorder, width: 0.5)),
  //     ),
  //     child: SafeArea(
  //       top: false,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: List.generate(items.length, (i) => GestureDetector(
  //             onTap: () => setState(() => _currentNavIndex = i),
  //             child: AnimatedContainer(
  //               duration: const Duration(milliseconds: 200),
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: _currentNavIndex == i ? kPurple.withOpacity(0.15) : Colors.transparent,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(mainAxisSize: MainAxisSize.min, children: [
  //                 Icon(items[i].icon, size: 22,
  //                     color: _currentNavIndex == i ? kGold : kTextMuted),
  //                 const SizedBox(height: 3),
  //                 Text(items[i].label, style: TextStyle(
  //                   fontSize: 9.5,
  //                   fontWeight: _currentNavIndex == i ? FontWeight.w600 : FontWeight.w400,
  //                   color: _currentNavIndex == i ? kGold : kTextMuted,
  //                 )),
  //                 if (_currentNavIndex == i)
  //                   Container(
  //                     margin: const EdgeInsets.only(top: 3),
  //                     width: 4, height: 4,
  //                     decoration: const BoxDecoration(shape: BoxShape.circle, color: kGold),
  //                   ),
  //               ]),
  //             ),
  //           )),
  //         ),
  //       ),
  //     ),
  //   );
  // }


  // ── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Financial'),

      // ✅ Center Add Button
      _NavItem(icon: Icons.add_rounded, label: 'Add'),

      _NavItem(icon: Icons.wifi_tethering_rounded, label: 'Courses'),
      _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: kBgCard,
        border: Border(
          top: BorderSide(color: kBorder, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSelected = _currentNavIndex == i;

              // ✅ CENTER ADD BUTTON SPECIAL UI
              // if (i == 2) {
              //   return GestureDetector(
              //     onTap: () async {
              //
              //       // ✅ Navigate To Create Post Screen
              //       await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => const CreatePostScreen(),
              //         ),
              //       );
              //
              //       // ✅ Refresh Feed After Coming Back
              //       if (context.mounted) {
              //         ref
              //             .read(getPostViewModelProvider.notifier)
              //             .refresh();
              //       }
              //     },
              //     child: Container(
              //       width: 58,
              //       height: 58,
              //       margin: const EdgeInsets.only(bottom: 15),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //
              //         // ✅ Attractive Gradient
              //         gradient: const LinearGradient(
              //           colors: [
              //             kGoldLight,
              //             kPurple,
              //             kPurpleLight,
              //           ],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //
              //         // ✅ Glow Effect
              //         boxShadow: [
              //           BoxShadow(
              //             color: kPurple.withOpacity(0.45),
              //             blurRadius: 20,
              //             spreadRadius: 3,
              //           ),
              //           BoxShadow(
              //             color: kGold.withOpacity(0.25),
              //             blurRadius: 25,
              //             spreadRadius: 2,
              //           ),
              //         ],
              //
              //         border: Border.all(
              //           color: Colors.white.withOpacity(0.15),
              //           width: 1.5,
              //         ),
              //       ),
              //
              //       child: Container(
              //         margin: const EdgeInsets.all(4),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: kBgCard,
              //         ),
              //         child: const Center(
              //           child: Icon(
              //             Icons.add_rounded,
              //             color: kGoldLight,
              //             size: 34,
              //           ),
              //         ),
              //       ),
              //     ),
              //   );
              // }


              if (i == 2) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1, end: 1),
                  duration: const Duration(milliseconds: 150),
                  builder: (context, scale, child) {
                    return child!;
                  },
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _fabScale = 0.90;
                      });
                    },

                    onTapUp: (_) {
                      setState(() {
                        _fabScale = 1;
                      });
                    },

                    onTapCancel: () {
                      setState(() {
                        _fabScale = 1;
                      });
                    },

                    onTap: () async {

                      // ✅ Small Bounce Effect
                      setState(() {
                        _fabScale = 0.90;
                      });

                      await Future.delayed(
                        const Duration(milliseconds: 80),
                      );

                      if (mounted) {
                        setState(() {
                          _fabScale = 1;
                        });
                      }

                      // ✅ Navigate
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePostScreen(),
                        ),
                      );

                      // ✅ Refresh
                      if (context.mounted) {
                        ref
                            .read(getPostViewModelProvider.notifier)
                            .refresh();
                      }
                    },

                    child: AnimatedScale(
                      scale: _fabScale,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: const LinearGradient(
                            colors: [
                              kGoldLight,
                              kPurple,
                              kPurpleLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: kPurple.withOpacity(
                                _fabScale < 1 ? 0.25 : 0.45,
                              ),
                              blurRadius: _fabScale < 1 ? 10 : 22,
                              spreadRadius: _fabScale < 1 ? 1 : 3,
                            ),

                            BoxShadow(
                              color: kGold.withOpacity(
                                _fabScale < 1 ? 0.15 : 0.28,
                              ),
                              blurRadius: _fabScale < 1 ? 12 : 26,
                              spreadRadius: 2,
                            ),
                          ],

                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),

                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kBgCard,
                          ),
                          child: AnimatedRotation(
                            turns: _fabScale < 1 ? 0.08 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: const Icon(
                              Icons.add_rounded,
                              color: kGoldLight,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // ✅ NORMAL NAV ITEMS
              // return GestureDetector(
              //   onTap: () {
              //     setState(() => _currentNavIndex = i);
              //   },
              //   child: AnimatedContainer(
              //     duration: const Duration(milliseconds: 200),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 6,
              //     ),
              //     decoration: BoxDecoration(
              //       color: isSelected
              //           ? kPurple.withOpacity(0.15)
              //           : Colors.transparent,
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(
              //           items[i].icon,
              //           size: 22,
              //           color: isSelected
              //               ? kGold
              //               : kTextMuted,
              //         ),
              //
              //         const SizedBox(height: 3),
              //
              //         Text(
              //           items[i].label,
              //           style: TextStyle(
              //             fontSize: 9.5,
              //             fontWeight: isSelected
              //                 ? FontWeight.w600
              //                 : FontWeight.w400,
              //             color: isSelected
              //                 ? kGold
              //                 : kTextMuted,
              //           ),
              //         ),
              //
              //         if (isSelected)
              //           Container(
              //             margin: const EdgeInsets.only(top: 3),
              //             width: 4,
              //             height: 4,
              //             decoration: const BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: kGold,
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // );

              // =========================================================
              // ✅ NORMAL NAV ITEMS
              // =========================================================
              return GestureDetector(

                // ✅ CHANGE 2:
                // Navigation Logic Add Kiya
                onTap: () async {

                  // ============================================
                  // ✅ HOME TAB
                  // ============================================
                  if (i == 0) {

                    setState(() {
                      _currentNavIndex = i;
                    });
                  }

                  // ============================================
                  // ✅ PROFILE TAB NAVIGATION
                  // ============================================
                  else if (i == 4) {

                    // ✅ Selected Index Change
                    setState(() {
                      _currentNavIndex = i;
                    });

                    // ✅ Navigate To Profile Screen
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const ProfileScreen(),
                    //   ),
                    // );

                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProfileScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  }

                  else if (i == 1) {

                    // ✅ Selected Index Change
                    setState(() {
                      _currentNavIndex = i;
                    });

                    // ✅ Navigate To Profile Screen
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const ProfileScreen(),
                    //   ),
                    // );

                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const FinancialLiteracyScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  }

                  // ============================================
                  // ✅ OTHER TABS
                  // ============================================
                  else {

                    setState(() {
                      _currentNavIndex = i;
                    });
                  }
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: isSelected
                        ? kPurple.withOpacity(0.15)
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      // ======================================
                      // ✅ ICON
                      // ======================================
                      Icon(
                        items[i].icon,
                        size: 22,

                        color: isSelected
                            ? kGold
                            : kTextMuted,
                      ),

                      const SizedBox(height: 3),

                      // ======================================
                      // ✅ LABEL
                      // ======================================
                      Text(
                        items[i].label,

                        style: TextStyle(
                          fontSize: 9.5,

                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,

                          color: isSelected
                              ? kGold
                              : kTextMuted,
                        ),
                      ),

                      // ======================================
                      // ✅ SELECTED DOT
                      // ======================================
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 3),

                          width: 4,
                          height: 4,

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  POST CARD
// ═══════════════════════════════════════════════════════════════════════════════
// class _PostCard extends StatefulWidget {
//   final GetPost post;
//   final bool isTablet;
//   final VoidCallback onLikeTap;
//
//   const _PostCard({required this.post, required this.isTablet, required this.onLikeTap});
//
//   @override
//   State<_PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends State<_PostCard> with SingleTickerProviderStateMixin {
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   @override
//   void initState() {
//     super.initState();
//     _likeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   // ✅ CHANGE #3 — Like tap pe animation ke saath ViewModel ka toggleLike()
//   //               call hota hai jo API call karta hai (onLikeTap callback).
//   void _handleLike() {
//     _likeCtrl.forward(from: 0);
//     widget.onLikeTap(); // yeh SliverList me pehle se wired tha, ab animation bhi sahi hai
//   }
//
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours < 24)   return '${diff.inHours}h ago';
//     if (diff.inDays < 7)     return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   String _initial(String name) => name.isNotEmpty ? name[0].toUpperCase() : '?';
//
//   // ✅ CHANGE #4 — "Read more" press par full content bottom sheet me dikhata hai
//   void _showFullContent(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.75,
//         minChildSize: 0.4,
//         maxChildSize: 0.95,
//         builder: (_, scrollCtrl) => Container(
//           decoration: const BoxDecoration(
//             color: kBgCard,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(children: [
//             // Drag handle
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//             ),
//             // Category + title header
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: _categoryColor(widget.post.category).withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: _categoryColor(widget.post.category).withOpacity(0.5)),
//                   ),
//                   child: Text(widget.post.category, style: TextStyle(
//                     color: _categoryColor(widget.post.category),
//                     fontSize: 10, fontWeight: FontWeight.w700,
//                   )),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(widget.post.title, style: const TextStyle(
//                   color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w800, height: 1.4,
//                 )),
//                 const SizedBox(height: 6),
//                 Text(_timeAgo(widget.post.createdAt),
//                     style: const TextStyle(color: kTextMuted, fontSize: 11)),
//               ]),
//             ),
//             const Divider(color: kBorder, height: 1),
//             // ✅ CHANGE #4 — Scrollable full content text
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: scrollCtrl,
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//                 child: Text(
//                   parseHtmlString(widget.post.content),
//                  // widget.post.content,
//                   style: const TextStyle(
//                     color: kTextPrimary, fontSize: 14, height: 1.7,
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final post     = widget.post;
//     final catColor = _categoryColor(post.category);
//
//     return Container(
//       margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
//         border: widget.isTablet
//             ? Border.all(color: kBorder, width: 0.5)
//             : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//         // ── Header ──────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
//           child: Row(children: [
//             Container(
//               width: 36, height: 36,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(colors: [kGold, kPurple],
//                     begin: Alignment.topLeft, end: Alignment.bottomRight),
//               ),
//               child: Center(child: Text(_initial(post.userName),
//                   style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))),
//             ),
//             const SizedBox(width: 10),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(post.userName, style: const TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.w600)),
//               Text(_timeAgo(post.createdAt), style: const TextStyle(color: kTextMuted, fontSize: 10)),
//             ])),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color: catColor.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: catColor.withOpacity(0.5), width: 0.8),
//               ),
//               child: Text(post.category, style: TextStyle(
//                 color: catColor, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.5,
//               )),
//             ),
//             const SizedBox(width: 8),
//             const Icon(Icons.more_horiz_rounded, color: kTextMuted, size: 18),
//           ]),
//         ),
//
//         // ── Image area ───────────────────────────────────────────────────────
//         // ✅ CHANGE #2 — _PostImageArea ab intrinsic height use karta hai
//         //               taaki image crop na ho (neeche detail mein)
//         _PostImageArea(post: post, isTablet: widget.isTablet),
//
//         // ── Title ────────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//           child: Text(post.title, style: const TextStyle(
//             color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w700, height: 1.4,
//           ),
//             maxLines: widget.isTablet ? 3 : 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//
//         // ✅ CHANGE #1 — Title ke niche content snippet add kiya (2 lines preview)
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
//           child: Text(
//             parseHtmlString(post.content),
//             style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.5),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//
//         // ── Actions ──────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
//           child: Row(children: [
//             // ✅ CHANGE #3 — Like button: animation + onLikeTap (API call via ViewModel)
//             GestureDetector(
//               onTap: _handleLike,
//               child: Row(children: [
//                 ScaleTransition(
//                   scale: _likeScale,
//                   child: Icon(
//                     post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                     size: 18,
//                     color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text('${post.likesCount}', style: TextStyle(
//                   fontSize: 11,
//                   color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                 )),
//               ]),
//             ),
//             const SizedBox(width: 16),
//             const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: kTextMuted),
//             const SizedBox(width: 16),
//
//             // ✅ CHANGE #7 — Share icon pe tap karne par Share dialog open hota hai
//             //               share_plus package use kiya: pubspec me add karo —
//             //               share_plus: ^9.0.0
//             GestureDetector(
//               onTap: () {
//                 final shareText = '${post.title}\n\n${post.content}';
//                 Share.share(shareText, subject: post.title);
//               },
//               child: const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
//             ),
//
//             const Spacer(),
//
//             // ✅ CHANGE #4 — "Read more" pe tap karne par full content bottom sheet
//             GestureDetector(
//               onTap: () => _showFullContent(context),
//               child: const Text('Read more', style: TextStyle(
//                 color: kPurpleLight, fontSize: 11, fontWeight: FontWeight.w500,
//               )),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  return document.body?.text ?? '';
}

// ─── Post Image Area ──────────────────────────────────────────────────────────
// ✅ CHANGE #2 — Fixed height hatayi. Ab image apni natural aspect ratio maintain
//               karta hai BoxFit.contain ke saath. Width full hai aur height
//               image ke hisaab se adjust hoti hai. Agar image nahi hai toh
//               chart background ke liye ek fixed height rakhte hain (180).
class _PostImageArea extends StatelessWidget {
  final GetPost post;
  final bool isTablet;

  const _PostImageArea({required this.post, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(post.category);
    final hasImage = post.filePath != null &&
        post.filePath!.isNotEmpty &&
        post.fileType == 'image';

    if (hasImage) {
      return Stack(children: [
        // ✅ CHANGE #2 — Image.network with no fixed height, using AspectRatio
        //               ya natural size. Width full, height image se.
        //               BoxFit.contain ensures image puri dikhti hai, crop nahi hoti.
        Image.network(
          post.filePath!,
          width: double.infinity,
          // ✅ CHANGE #2 — fit: contain instead of cover
          //               contain = poori image visible, cover = crop
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              height: isTablet ? 140 : 160,
              color: const Color(0xFF1A0535),
              child: const Center(child: CircularProgressIndicator(color: kPurple, strokeWidth: 2)),
            );
          },
          errorBuilder: (_, __, ___) => _chartFallback(catColor),
        ),
        // ✅ isOwner badge
        if (post.isOwner)
          Positioned(
            top: 8, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.8), borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('MY POST', style: TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
            ),
          ),
      ]);
    }

    // No image — chart fallback with fixed height
    return _chartFallback(catColor);
  }

  Widget _chartFallback(Color catColor) {
    return SizedBox(
      height: isTablet ? 140 : 160,
      width: double.infinity,
      child: Stack(fit: StackFit.expand, children: [
        _ChartBackground(color: catColor),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: catColor.withOpacity(0.4), width: 0.8),
            ),
            child: Text(post.category.toUpperCase(), style: TextStyle(
              color: catColor, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 3,
            )),
          ),
        ),
        if (post.isOwner)
          Positioned(
            top: 8, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.8), borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('MY POST', style: TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
            ),
          ),
      ]),
    );
  }
}

// ─── Remaining widgets UNCHANGED ─────────────────────────────────────────────
class _ChartBackground extends StatelessWidget {
  final Color color;
  const _ChartBackground({required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _ChartLinePainter(color: color),
    child: const SizedBox.expand(),
  );
}

// class _FeedShimmer extends StatelessWidget {
//   const _FeedShimmer();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(3, (_) => Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         color: kBgCard,
//         child: Column(children: [
//           Container(height: 160, color: const Color(0xFF1A0535)),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Container(height: 12, width: double.infinity, color: kBorder),
//               const SizedBox(height: 8),
//               Container(height: 12, width: 200, color: kBorder),
//             ]),
//           ),
//         ]),
//       )),
//     );
//   }
// }

class _FeedShimmer extends StatelessWidget {
  const _FeedShimmer();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    // ✅ CHANGE 3a — isTablet true hai toh 2-column grid skeleton,
    //               warna simple list of 3 skeletons
    if (isTablet) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap:  true,
          physics:     const NeverScrollableScrollPhysics(),
          itemCount:   4, // ✅ 4 placeholder cards (2x2 grid)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   2,
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (_, __) => const PostCardSkeleton(isTablet: true),
        ),
      );
    }

    // ✅ CHANGE 3b — Mobile: 3 skeleton cards list
    return Column(
      children: List.generate(
        3,
            (_) => const PostCardSkeleton(isTablet: false),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: kTextMuted, fontSize: 13), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: kPurple, borderRadius: BorderRadius.circular(8)),
            child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(children: [
        Icon(Icons.article_outlined, color: kTextMuted, size: 48),
        SizedBox(height: 12),
        Text('No posts found', style: TextStyle(color: kTextMuted, fontSize: 13)),
      ]),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final Color color;
  _ChartLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFF0A0118));
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 0.5;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(0, size.height * i / 4),
          Offset(size.width, size.height * i / 4), gridPaint);
    }
    final rng    = math.Random(color.value);
    final points = <Offset>[];
    for (int i = 0; i <= 10; i++) {
      points.add(Offset(size.width * i / 10,
          size.height * 0.2 + size.height * 0.6 * (rng.nextDouble() * 0.8 + 0.1)));
    }
    final linePaint = Paint()
      ..color      = color.withOpacity(0.7)
      ..strokeWidth = 1.8
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round;
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final cp = Offset((points[i-1].dx + points[i].dx) / 2, (points[i-1].dy + points[i].dy) / 2);
      path.quadraticBezierTo(points[i-1].dx, points[i-1].dy, cp.dx, cp.dy);
    }
    canvas.drawPath(path, linePaint);
    final fillPath = Path()..addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
  }

  @override
  bool shouldRepaint(_ChartLinePainter old) => old.color != color;
}

class _TopIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TopIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 39, height: 39,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: kBgDeep,
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Icon(icon, color: kPurpleLight, size: 25),
    ),
  );
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class _TickerPainter extends CustomPainter {
  final List<MarketTicker> tickers;
  final double progress;
  final double width;
  _TickerPainter({required this.tickers, required this.progress, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    const itemWidth = 110.0;
    final totalWidth = itemWidth * tickers.length;
    final offset     = -(progress * totalWidth) % totalWidth;
    for (int rep = 0; rep < 3; rep++) {
      for (int i = 0; i < tickers.length; i++) {
        final t = tickers[i];
        final x = offset + rep * totalWidth + i * itemWidth;
        if (x > size.width + 20 || x < -itemWidth) continue;
        final symPainter = TextPainter(
          text: TextSpan(text: '${t.symbol}  ',
              style: const TextStyle(color: Color(0xFF888888), fontSize: 10, fontWeight: FontWeight.w500)),
          textDirection: TextDirection.ltr,
        )..layout();
        symPainter.paint(canvas, Offset(x, (size.height - symPainter.height) / 2));
        final chPainter = TextPainter(
          text: TextSpan(text: t.change, style: TextStyle(
            color: t.isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
            fontSize: 10, fontWeight: FontWeight.w600,
          )), textDirection: TextDirection.ltr,
        )..layout();
        chPainter.paint(canvas, Offset(x + symPainter.width, (size.height - chPainter.height) / 2));
      }
    }
  }

  @override
  bool shouldRepaint(_TickerPainter old) => old.progress != progress;
}


// -------------------------------- 5 issue fix karne se pahale ----------------------------------->


// // ─── Colors ───────────────────────────────────────────────────────────────────
// const kBgDark    = Color(0xFF0F0120);
// const kBgCard    = Color(0xFF150328);
// const kBgDeep    = Color(0xFF0A0118);
// const kPurple    = Color(0xFF7C3AED);
// const kPurpleLight = Color(0xFF9333EA);
// const kGold      = Color(0xFFD4AF37);
// const kGoldLight = Color(0xFFFFD700);
// const kBorder    = Color(0xFF2D1050);
// const kTextPrimary = Colors.white;
// const kTextMuted = Color(0xFF888888);
//
// // ─── Category colors map ──────────────────────────────────────────────────────
// Color _categoryColor(String category) {
//   switch (category.toLowerCase()) {
//     case 'gold & commodities':
//     case 'gold':
//       return const Color(0xFFD4AF37);
//     case 'oil market':
//     case 'oil':
//       return const Color(0xFF22C55E);
//     case 'forex & currency':
//     case 'forex':
//       return const Color(0xFF3B82F6);
//     case 'crypto':
//       return const Color(0xFFF59E0B);
//     case 'stocks':
//       return const Color(0xFF06B6D4);
//     case 'economy':
//     case 'macro':
//       return const Color(0xFFEF4444);
//     default:
//       return kPurpleLight;
//   }
// }
//
// // ─── Models ───────────────────────────────────────────────────────────────────
// class MarketTicker {
//   final String symbol;
//   final String change;
//   final bool isUp;
//   MarketTicker(this.symbol, this.change, this.isUp);
// }
//
// class StoryCategory {
//   final String label;
//   final String emoji;
//   StoryCategory(this.label, this.emoji);
// }
//
// final List<MarketTicker> marketTickers = [
//   MarketTicker('GOLD', '+1.2%', true),
//   MarketTicker('OIL', '-0.8%', false),
//   MarketTicker('EUR/USD', '+0.3%', true),
//   MarketTicker('BTC', '+2.1%', true),
//   MarketTicker('S&P500', '-0.5%', false),
//   MarketTicker('GBP/USD', '+0.6%', true),
//   MarketTicker('SILVER', '-1.1%', false),
// ];
//
// final List<StoryCategory> storyCategories = [
//   StoryCategory('Forex', '📈'),
//   StoryCategory('Gold', '🪙'),
//   StoryCategory('Oil', '🛢'),
//   StoryCategory('Stocks', '📊'),
//   StoryCategory('Crypto', '₿'),
// ];
//
// // ─── Category filter tabs ─────────────────────────────────────────────────────
// const _filterCategories = [
//   'All', 'Forex & Currency', 'Crypto', 'Stocks',
//   'Commodities', 'Economy', 'Gold & Commodities', 'Oil Market', 'Other',
// ];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  HOME SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with TickerProviderStateMixin {
//   int _currentNavIndex = 0;
//   late AnimationController _tickerCtrl;
//   late AnimationController _glowCtrl;
//   late ScrollController _scrollCtrl;
//   bool _showFab = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//
//     _tickerCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 20),
//     )..repeat();
//
//     _glowCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _scrollCtrl = ScrollController();
//     _scrollCtrl.addListener(_onScroll);
//   }
//
//   // ✅ Pagination trigger — list ke end pe load more call karo
//   void _onScroll() {
//     if (_scrollCtrl.offset > 200 && !_showFab) {
//       setState(() => _showFab = true);
//     } else if (_scrollCtrl.offset <= 200 && _showFab) {
//       setState(() => _showFab = false);
//     }
//
//     // ✅ Last 200px pe load more trigger karo
//     if (_scrollCtrl.position.pixels >=
//         _scrollCtrl.position.maxScrollExtent - 200) {
//       ref.read(getPostViewModelProvider.notifier).loadMore();
//     }
//   }
//
//   @override
//   void dispose() {
//     _tickerCtrl.dispose();
//     _glowCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _logout() async {
//     await AuthService.instance.logout(keepCredentials: true);
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               _buildTopBar(context, isTablet),
//               Expanded(child: _buildFeed(context, isTablet)),
//             ],
//           ),
//
//           // ── FAB scroll to top ──────────────────────────────────────────────
//           if (_showFab)
//             Positioned(
//               right: 16, bottom: 80,
//               child: GestureDetector(
//                 onTap: () => _scrollCtrl.animateTo(
//                   0,
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.easeOut,
//                 ),
//                 child: Container(
//                   width: 42, height: 42,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: kPurple,
//                     boxShadow: [
//                       BoxShadow(
//                         color: kPurple.withOpacity(0.5),
//                         blurRadius: 12, spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.keyboard_arrow_up_rounded,
//                       color: Colors.white, size: 22),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }
//
//   // ── Top App Bar ──────────────────────────────────────────────────────────────
//   Widget _buildTopBar(BuildContext context, bool isTablet) {
//     return Container(
//       color: kBgCard,
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 8,
//         left: 16, right: 16, bottom: 10,
//       ),
//       child: Row(children: [
//         // Logo
//         Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
//           AnimatedBuilder(
//             animation: _glowCtrl,
//             builder: (_, __) => Text('VERVEE', style: TextStyle(
//               color: kGold, fontSize: isTablet ? 22 : 18,
//               fontWeight: FontWeight.w900, letterSpacing: 3,
//               shadows: [Shadow(
//                 color: kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
//                 blurRadius: 8 + 4 * _glowCtrl.value,
//               )],
//             )),
//           ),
//           Text('A C A D E M Y', style: TextStyle(
//             color: kPurpleLight, fontSize: isTablet ? 9 : 7.5,
//             fontWeight: FontWeight.w600, letterSpacing: 3,
//           )),
//         ]),
//
//         const Spacer(),
//
//         // Search
//         _TopIconBtn(icon: Icons.search_rounded, onTap: () => _showSearchSheet(context)),
//         const SizedBox(width: 8),
//
//         // Notifications
//         Stack(clipBehavior: Clip.none, children: [
//           _TopIconBtn(icon: Icons.notifications_outlined, onTap: () {}),
//           Positioned(
//             top: -2, right: -2,
//             child: Container(
//               width: 8, height: 8,
//               decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEA4335)),
//             ),
//           ),
//         ]),
//         const SizedBox(width: 8),
//
//         // Avatar / Logout
//         GestureDetector(
//           onTap: _logout,
//           child: Container(
//             width: 34, height: 34,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [kGold, kPurple],
//                 begin: Alignment.topLeft, end: Alignment.bottomRight,
//               ),
//             ),
//             child: const Center(
//               child: Text('VA', style: TextStyle(
//                 color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700,
//               )),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── Search Bottom Sheet ───────────────────────────────────────────────────
//   void _showSearchSheet(BuildContext context) {
//     final ctrl = TextEditingController();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//           decoration: const BoxDecoration(
//             color: kBgCard,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//             ),
//             TextField(
//               controller: ctrl,
//               autofocus: true,
//               style: const TextStyle(color: kTextPrimary),
//               decoration: InputDecoration(
//                 hintText: 'Search posts...',
//                 hintStyle: const TextStyle(color: kTextMuted),
//                 prefixIcon: const Icon(Icons.search_rounded, color: kTextMuted),
//                 filled: true,
//                 fillColor: kBgDeep,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kBorder),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kBorder),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: kPurple),
//                 ),
//               ),
//               onSubmitted: (q) {
//                 Navigator.pop(context);
//                 ref.read(getPostViewModelProvider.notifier).search(q.trim());
//               },
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   // ── Main Feed ─────────────────────────────────────────────────────────────
//   Widget _buildFeed(BuildContext context, bool isTablet) {
//     final feedState = ref.watch(getPostViewModelProvider);
//
//     return CustomScrollView(
//       controller: _scrollCtrl,
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         // Stories / Add Post row
//         SliverToBoxAdapter(child: _buildStoriesRow(context, isTablet)),
//
//         // Category filter tabs
//         SliverToBoxAdapter(child: _buildCategoryTabs(feedState.selectedCategory)),
//
//         // Feed header
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//             child: Row(children: [
//               Container(
//                 width: 3, height: 16,
//                 decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2)),
//               ),
//               const SizedBox(width: 8),
//               const Text('Latest Market News', style: TextStyle(
//                 color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.3,
//               )),
//               const Spacer(),
//               // ✅ Refresh button
//               GestureDetector(
//                 onTap: () => ref.read(getPostViewModelProvider.notifier).refresh(),
//                 child: const Text('Refresh', style: TextStyle(
//                   color: kPurpleLight, fontSize: 12, fontWeight: FontWeight.w500,
//                 )),
//               ),
//             ]),
//           ),
//         ),
//
//         // ✅ Loading state — first load
//         if (feedState.isLoading)
//           const SliverToBoxAdapter(child: _FeedShimmer()),
//
//         // ✅ Error state
//         if (!feedState.isLoading && feedState.errorMessage != null)
//           SliverToBoxAdapter(child: _ErrorWidget(
//             message: feedState.errorMessage!,
//             onRetry: () => ref.read(getPostViewModelProvider.notifier).loadPosts(),
//           )),
//
//         // ✅ Empty state
//         if (!feedState.isLoading && feedState.posts.isEmpty && feedState.errorMessage == null)
//           const SliverToBoxAdapter(child: _EmptyWidget()),
//
//         // ✅ Posts list — real API data
//         if (feedState.posts.isNotEmpty)
//           if (isTablet)
//             SliverPadding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               sliver: SliverGrid(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, crossAxisSpacing: 12,
//                   mainAxisSpacing: 12, childAspectRatio: 0.72,
//                 ),
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) => _PostCard(
//                     post: feedState.posts[index],
//                     isTablet: true,
//                     onLikeTap: () => ref.read(getPostViewModelProvider.notifier)
//                         .toggleLike(feedState.posts[index].id),
//                   ),
//                   childCount: feedState.posts.length,
//                 ),
//               ),
//             )
//           else
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) => _PostCard(
//                   post: feedState.posts[index],
//                   isTablet: false,
//                   onLikeTap: () => ref.read(getPostViewModelProvider.notifier)
//                       .toggleLike(feedState.posts[index].id),
//                 ),
//                 childCount: feedState.posts.length,
//               ),
//             ),
//
//         // ✅ Load more indicator
//         if (feedState.isLoadingMore)
//           const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               child: Center(child: CircularProgressIndicator(
//                 color: kPurple, strokeWidth: 2,
//               )),
//             ),
//           ),
//
//         // ✅ End of list
//         if (feedState.hasReachedEnd && feedState.posts.isNotEmpty)
//           const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(child: Text('No more posts', style: TextStyle(
//                 color: kTextMuted, fontSize: 12,
//               ))),
//             ),
//           ),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 16)),
//       ],
//     );
//   }
//
//   // ── Category Filter Tabs ──────────────────────────────────────────────────
//   Widget _buildCategoryTabs(String selected) {
//     return Container(
//       height: 38,
//       color: kBgCard,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         itemCount: _filterCategories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 6),
//         itemBuilder: (_, i) {
//           final cat = _filterCategories[i];
//           final isSelected = cat == selected;
//           return GestureDetector(
//             onTap: () => ref.read(getPostViewModelProvider.notifier).filterByCategory(cat),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: isSelected ? kPurple : kBgDeep,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isSelected ? kPurple : kBorder, width: 0.8,
//                 ),
//               ),
//               child: Text(cat, style: TextStyle(
//                 color: isSelected ? Colors.white : kTextMuted,
//                 fontSize: 11,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//               )),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // ── Stories Row ───────────────────────────────────────────────────────────
//   Widget _buildStoriesRow(BuildContext context, bool isTablet) {
//     return Container(
//       height: isTablet ? 95 : 85,
//       color: kBgCard,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         children: [
//           // Add Post button
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               Material(
//                 color: Colors.transparent,
//                 shape: const CircleBorder(),
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(100),
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const CreatePostScreen()),
//                     );
//                     // ✅ Create post se wapas aane ke baad refresh karo
//                     if (context.mounted) {
//                       ref.read(getPostViewModelProvider.notifier).refresh();
//                     }
//                   },
//                   child: Container(
//                     width: isTablet ? 56 : 50,
//                     height: isTablet ? 56 : 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: kBgDeep,
//                       border: Border.all(color: kPurple.withOpacity(0.5), width: 1.5),
//                     ),
//                     child: const Center(child: Icon(Icons.add_rounded, color: kPurpleLight, size: 22)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 2),
//               const Text('Add', style: TextStyle(color: kTextMuted, fontSize: 9)),
//             ]),
//           ),
//
//           ...storyCategories.map((s) => Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: _StoryItem(story: s, isTablet: isTablet),
//           )),
//         ],
//       ),
//     );
//   }
//
//   // ── Bottom Nav ────────────────────────────────────────────────────────────
//   Widget _buildBottomNav() {
//     final items = [
//       _NavItem(icon: Icons.home_rounded, label: 'Home'),
//       _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Courses'),
//       _NavItem(icon: Icons.show_chart_rounded, label: 'Markets'),
//       _NavItem(icon: Icons.wifi_tethering_rounded, label: 'Signals'),
//       _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
//     ];
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(top: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(items.length, (i) => GestureDetector(
//               onTap: () => setState(() => _currentNavIndex = i),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: _currentNavIndex == i ? kPurple.withOpacity(0.15) : Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(items[i].icon, size: 22,
//                       color: _currentNavIndex == i ? kGold : kTextMuted),
//                   const SizedBox(height: 3),
//                   Text(items[i].label, style: TextStyle(
//                     fontSize: 9.5,
//                     fontWeight: _currentNavIndex == i ? FontWeight.w600 : FontWeight.w400,
//                     color: _currentNavIndex == i ? kGold : kTextMuted,
//                   )),
//                   if (_currentNavIndex == i)
//                     Container(
//                       margin: const EdgeInsets.only(top: 3),
//                       width: 4, height: 4,
//                       decoration: const BoxDecoration(shape: BoxShape.circle, color: kGold),
//                     ),
//                 ]),
//               ),
//             )),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  POST CARD  (Real API data)
// // ═══════════════════════════════════════════════════════════════════════════════
// class _PostCard extends StatefulWidget {
//   final GetPost post;       // ✅ FeedPost — real domain model
//   final bool isTablet;
//   final VoidCallback onLikeTap;
//
//   const _PostCard({required this.post, required this.isTablet, required this.onLikeTap});
//
//   @override
//   State<_PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends State<_PostCard> with SingleTickerProviderStateMixin {
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   @override
//   void initState() {
//     super.initState();
//     _likeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   void _handleLike() {
//     _likeCtrl.forward(from: 0);
//     widget.onLikeTap();
//   }
//
//   // ✅ Time ago helper — createdAt DateTime se human-readable string
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours < 24)   return '${diff.inHours}h ago';
//     if (diff.inDays < 7)     return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   // ✅ Username initial (first letter)
//   String _initial(String name) =>
//       name.isNotEmpty ? name[0].toUpperCase() : '?';
//
//   @override
//   Widget build(BuildContext context) {
//     final post = widget.post;
//     final catColor = _categoryColor(post.category);
//
//     return Container(
//       margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
//         border: widget.isTablet
//             ? Border.all(color: kBorder, width: 0.5)
//             : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // ── Header ──────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
//           child: Row(children: [
//             // ✅ Avatar — user initial
//             Container(
//               width: 36, height: 36,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [kGold, kPurple],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Center(child: Text(_initial(post.userName), style: const TextStyle(
//                 color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700,
//               ))),
//             ),
//             const SizedBox(width: 10),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               // ✅ Real username
//               Text(post.userName, style: const TextStyle(
//                 color: kGold, fontSize: 12, fontWeight: FontWeight.w600,
//               )),
//               // ✅ Real time ago
//               Text(_timeAgo(post.createdAt), style: const TextStyle(
//                 color: kTextMuted, fontSize: 10,
//               )),
//             ])),
//
//             // ✅ Real category tag
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color: catColor.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: catColor.withOpacity(0.5), width: 0.8),
//               ),
//               child: Text(post.category, style: TextStyle(
//                 color: catColor, fontSize: 9.5,
//                 fontWeight: FontWeight.w700, letterSpacing: 0.5,
//               )),
//             ),
//             const SizedBox(width: 8),
//             const Icon(Icons.more_horiz_rounded, color: kTextMuted, size: 18),
//           ]),
//         ),
//
//         // ── Image area ───────────────────────────────────────────────────────
//         _PostImageArea(post: post, isTablet: widget.isTablet),
//
//         // ── Title ────────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//           child: Text(post.title, style: const TextStyle(
//             color: kTextPrimary, fontSize: 13,
//             fontWeight: FontWeight.w700, height: 1.4,
//           ),
//             maxLines: widget.isTablet ? 3 : 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//
//         // ── Actions ──────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
//           child: Row(children: [
//             // ✅ Like — real isLiked + likesCount
//             GestureDetector(
//               onTap: _handleLike,
//               child: Row(children: [
//                 ScaleTransition(
//                   scale: _likeScale,
//                   child: Icon(
//                     post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                     size: 18,
//                     color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text('${post.likesCount}', style: TextStyle(
//                   fontSize: 11,
//                   color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                 )),
//               ]),
//             ),
//             const SizedBox(width: 16),
//             const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: kTextMuted),
//             const SizedBox(width: 16),
//             const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {},
//               child: const Text('Read more', style: TextStyle(
//                 color: kPurpleLight, fontSize: 11, fontWeight: FontWeight.w500,
//               )),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }
//
// // ─── Post Image Area ──────────────────────────────────────────────────────────
// class _PostImageArea extends StatelessWidget {
//   final GetPost post;
//   final bool isTablet;
//
//   const _PostImageArea({required this.post, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final h = isTablet ? 140.0 : 160.0;
//     final catColor = _categoryColor(post.category);
//     final hasImage = post.filePath != null &&
//         post.filePath!.isNotEmpty &&
//         post.fileType == 'image';
//
//     return SizedBox(
//       height: h,
//       width: double.infinity,
//       child: Stack(fit: StackFit.expand, children: [
//         // ✅ Real image — filePath se load karo
//         if (hasImage)
//           Image.network(
//             post.filePath!,
//             fit: BoxFit.cover,
//             // ✅ Loading placeholder
//             loadingBuilder: (_, child, get_progress) {
//               if (get_progress == null) return child;
//               return Container(
//                 color: const Color(0xFF1A0535),
//                 child: const Center(child: CircularProgressIndicator(
//                   color: kPurple, strokeWidth: 2,
//                 )),
//               );
//             },
//             // ✅ Error fallback — chart background dikhao
//             errorBuilder: (_, __, ___) => _ChartBackground(color: catColor),
//           )
//         else
//         // ✅ No image — chart background
//           _ChartBackground(color: catColor),
//
//         // ✅ Category label overlay (sirf no-image case mein)
//         if (!hasImage)
//           Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.45),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: catColor.withOpacity(0.4), width: 0.8),
//               ),
//               child: Text(post.category.toUpperCase(), style: TextStyle(
//                 color: catColor, fontSize: 18,
//                 fontWeight: FontWeight.w900, letterSpacing: 3,
//               )),
//             ),
//           ),
//
//         // ✅ isOwner badge
//         if (post.isOwner)
//           Positioned(
//             top: 8, right: 10,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: kPurple.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               child: const Text('MY POST', style: TextStyle(
//                 color: Colors.white, fontSize: 8,
//                 fontWeight: FontWeight.w700, letterSpacing: 1,
//               )),
//             ),
//           ),
//       ]),
//     );
//   }
// }
//
// // ─── Chart Background (fallback when no image) ───────────────────────────────
// class _ChartBackground extends StatelessWidget {
//   final Color color;
//   const _ChartBackground({required this.color});
//
//   @override
//   Widget build(BuildContext context) => CustomPaint(
//     painter: _ChartLinePainter(color: color),
//     child: const SizedBox.expand(),
//   );
// }
//
// // ─── Shimmer Loading ──────────────────────────────────────────────────────────
// class _FeedShimmer extends StatelessWidget {
//   const _FeedShimmer();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(3, (_) => Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         color: kBgCard,
//         child: Column(children: [
//           Container(height: 160, color: const Color(0xFF1A0535)),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Container(height: 12, width: double.infinity, color: kBorder),
//               const SizedBox(height: 8),
//               Container(height: 12, width: 200, color: kBorder),
//             ]),
//           ),
//         ]),
//       )),
//     );
//   }
// }
//
// // ─── Error Widget ─────────────────────────────────────────────────────────────
// class _ErrorWidget extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorWidget({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(32),
//       child: Column(children: [
//         const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
//         const SizedBox(height: 12),
//         Text(message, style: const TextStyle(color: kTextMuted, fontSize: 13),
//             textAlign: TextAlign.center),
//         const SizedBox(height: 16),
//         GestureDetector(
//           onTap: onRetry,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               color: kPurple, borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// // ─── Empty Widget ─────────────────────────────────────────────────────────────
// class _EmptyWidget extends StatelessWidget {
//   const _EmptyWidget();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.all(32),
//       child: Column(children: [
//         Icon(Icons.article_outlined, color: kTextMuted, size: 48),
//         SizedBox(height: 12),
//         Text('No posts found', style: TextStyle(color: kTextMuted, fontSize: 13)),
//       ]),
//     );
//   }
// }
//
// // ─── Chart Line Painter ───────────────────────────────────────────────────────
// class _ChartLinePainter extends CustomPainter {
//   final Color color;
//   _ChartLinePainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Paint()..color = const Color(0xFF0A0118),
//     );
//     final gridPaint = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 0.5;
//     for (int i = 1; i < 4; i++) {
//       canvas.drawLine(
//         Offset(0, size.height * i / 4),
//         Offset(size.width, size.height * i / 4),
//         gridPaint,
//       );
//     }
//     final rng = math.Random(color.value);
//     final points = <Offset>[];
//     for (int i = 0; i <= 10; i++) {
//       points.add(Offset(
//         size.width * i / 10,
//         size.height * 0.2 + size.height * 0.6 * (rng.nextDouble() * 0.8 + 0.1),
//       ));
//     }
//     final linePaint = Paint()
//       ..color = color.withOpacity(0.7)
//       ..strokeWidth = 1.8
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//     final path = Path();
//     path.moveTo(points[0].dx, points[0].dy);
//     for (int i = 1; i < points.length; i++) {
//       final cp = Offset((points[i-1].dx + points[i].dx) / 2, (points[i-1].dy + points[i].dy) / 2);
//       path.quadraticBezierTo(points[i-1].dx, points[i-1].dy, cp.dx, cp.dy);
//     }
//     canvas.drawPath(path, linePaint);
//     final fillPath = Path()..addPath(path, Offset.zero);
//     fillPath.lineTo(size.width, size.height);
//     fillPath.lineTo(0, size.height);
//     fillPath.close();
//     canvas.drawPath(fillPath, Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.topCenter, end: Alignment.bottomCenter,
//         colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
//   }
//
//   @override
//   bool shouldRepaint(_ChartLinePainter old) => old.color != color;
// }
//
// // ─── Story Item ───────────────────────────────────────────────────────────────
// class _StoryItem extends StatelessWidget {
//   final StoryCategory story;
//   final bool isTablet;
//   const _StoryItem({required this.story, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final sz = isTablet ? 52.0 : 46.0;
//     return GestureDetector(
//       onTap: () {},
//       child: SizedBox(
//         width: sz + 8,
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(
//             width: sz + 4, height: sz + 4,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [kGold, kPurple],
//                 begin: Alignment.topLeft, end: Alignment.bottomRight,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(2),
//               child: Container(
//                 decoration: const BoxDecoration(shape: BoxShape.circle, color: kBgDeep),
//                 child: Center(child: Text(story.emoji,
//                     style: TextStyle(fontSize: isTablet ? 18 : 16))),
//               ),
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(story.label, style: const TextStyle(color: kTextMuted, fontSize: 9),
//               textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
//         ]),
//       ),
//     );
//   }
// }
//
// // ─── Top Icon Button ──────────────────────────────────────────────────────────
// class _TopIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _TopIconBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 34, height: 34,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: kBgDeep,
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Icon(icon, color: kPurpleLight, size: 18),
//     ),
//   );
// }
//
// // ─── Nav Item Model ───────────────────────────────────────────────────────────
// class _NavItem {
//   final IconData icon;
//   final String label;
//   _NavItem({required this.icon, required this.label});
// }
//
// // ─── Ticker Painter ───────────────────────────────────────────────────────────
// class _TickerPainter extends CustomPainter {
//   final List<MarketTicker> tickers;
//   final double get_progress;
//   final double width;
//   _TickerPainter({required this.tickers, required this.get_progress, required this.width});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     const itemWidth = 110.0;
//     final totalWidth = itemWidth * tickers.length;
//     final offset = -(get_progress * totalWidth) % totalWidth;
//     for (int rep = 0; rep < 3; rep++) {
//       for (int i = 0; i < tickers.length; i++) {
//         final t = tickers[i];
//         final x = offset + rep * totalWidth + i * itemWidth;
//         if (x > size.width + 20 || x < -itemWidth) continue;
//         final symPainter = TextPainter(
//           text: TextSpan(text: '${t.symbol}  ', style: const TextStyle(
//             color: Color(0xFF888888), fontSize: 10, fontWeight: FontWeight.w500,
//           )), textDirection: TextDirection.ltr,
//         )..layout();
//         symPainter.paint(canvas, Offset(x, (size.height - symPainter.height) / 2));
//         final chPainter = TextPainter(
//           text: TextSpan(text: t.change, style: TextStyle(
//             color: t.isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
//             fontSize: 10, fontWeight: FontWeight.w600,
//           )), textDirection: TextDirection.ltr,
//         )..layout();
//         chPainter.paint(canvas, Offset(x + symPainter.width, (size.height - chPainter.height) / 2));
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(_TickerPainter old) => old.get_progress != get_progress;
// }






//------------------------------- This Without Api ------------------------------------------------->






// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../utils/AuthService.dart';
// import 'CreatePostScreen.dart';
// import 'LoginScreen.dart';
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  VERVEE ACADEMY — HOME SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
//
// // ─── Data Models ──────────────────────────────────────────────────────────────
// class NewsPost {
//   final String title;
//   final String excerpt;
//   final String category;
//   final String timeAgo;
//   final int likes;
//   final int comments;
//   final Color categoryColor;
//   bool isLiked;
//
//   NewsPost({
//     required this.title,
//     required this.excerpt,
//     required this.category,
//     required this.timeAgo,
//     required this.likes,
//     required this.comments,
//     required this.categoryColor,
//     this.isLiked = false,
//   });
// }
//
// class MarketTicker {
//   final String symbol;
//   final String change;
//   final bool isUp;
//   MarketTicker(this.symbol, this.change, this.isUp);
// }
//
// class StoryCategory {
//   final String label;
//   final String emoji;
//   StoryCategory(this.label, this.emoji);
// }
//
// // ─── Sample Data ───────────────────────────────────────────────────────────────
// final List<MarketTicker> marketTickers = [
//   MarketTicker('GOLD', '+1.2%', true),
//   MarketTicker('OIL', '-0.8%', false),
//   MarketTicker('EUR/USD', '+0.3%', true),
//   MarketTicker('BTC', '+2.1%', true),
//   MarketTicker('S&P500', '-0.5%', false),
//   MarketTicker('GBP/USD', '+0.6%', true),
//   MarketTicker('SILVER', '-1.1%', false),
// ];
//
// final List<StoryCategory> storyCategories = [
//   StoryCategory('Forex', '📈'),
//   StoryCategory('Gold', '🪙'),
//   StoryCategory('Oil', '🛢'),
//   StoryCategory('Stocks', '📊'),
//   StoryCategory('Crypto', '₿'),
// ];
//
// final List<NewsPost> newsFeed = [
//   NewsPost(
//     title: 'Gold Holds Bullish Tone but Faces Strong Resistance Below \$4,000',
//     excerpt:
//     'Global gold markets remain steady as investors eye upcoming Fed decision. Technical analysis suggests key support levels holding strong.',
//     category: 'GOLD',
//     timeAgo: '2 hours ago',
//     likes: 24,
//     comments: 8,
//     categoryColor: const Color(0xFFD4AF37),
//     isLiked: true,
//   ),
//   NewsPost(
//     title: 'Oil Markets on Edge as War Risks and Supply Tightening Drive Volatility',
//     excerpt:
//     'Crude oil prices surge amid geopolitical tensions. WTI climbs past \$82 as OPEC signals further production cuts for Q2.',
//     category: 'OIL',
//     timeAgo: '5 hours ago',
//     likes: 18,
//     comments: 5,
//     categoryColor: const Color(0xFF22C55E),
//   ),
//   NewsPost(
//     title: 'USD/KRW Hits 17-Year High as Korean Won Weakens Sharply',
//     excerpt:
//     'The South Korean won fell to its weakest level in nearly two decades amid global dollar strength and domestic economic concerns.',
//     category: 'FOREX',
//     timeAgo: '8 hours ago',
//     likes: 31,
//     comments: 12,
//     categoryColor: const Color(0xFF3B82F6),
//   ),
//   NewsPost(
//     title: 'Silver Rebounds Above \$73 as Ceasefire Hopes Ease Oil Pressure',
//     excerpt:
//     'Silver futures rallied sharply as diplomatic get_progress in the Middle East reduced safe-haven demand and boosted industrial metal outlook.',
//     category: 'SILVER',
//     timeAgo: '12 hours ago',
//     likes: 15,
//     comments: 3,
//     categoryColor: const Color(0xFF9333EA),
//   ),
//   NewsPost(
//     title: 'ECB Holds Interest Rates Steady as Markets Await Clarity on War-Driven Inflation',
//     excerpt:
//     'The European Central Bank kept its benchmark rate unchanged, citing persistent inflation pressures driven by energy market disruptions.',
//     category: 'MACRO',
//     timeAgo: '1 day ago',
//     likes: 42,
//     comments: 19,
//     categoryColor: const Color(0xFFEF4444),
//   ),
//   NewsPost(
//     title: 'Gold Prices Rise in India as Market Demand Strengthens',
//     excerpt:
//     'Indian gold demand surges ahead of the wedding season. Domestic prices hit new record highs as import duties remain unchanged.',
//     category: 'GOLD',
//     timeAgo: '1 day ago',
//     likes: 27,
//     comments: 7,
//     categoryColor: const Color(0xFFD4AF37),
//   ),
// ];
//
// // ─── Colors ───────────────────────────────────────────────────────────────────
// const kBgDark = Color(0xFF0F0120);
// const kBgCard = Color(0xFF150328);
// const kBgDeep = Color(0xFF0A0118);
// const kPurple = Color(0xFF7C3AED);
// const kPurpleLight = Color(0xFF9333EA);
// const kGold = Color(0xFFD4AF37);
// const kGoldLight = Color(0xFFFFD700);
// const kBorder = Color(0xFF2D1050);
// const kTextPrimary = Colors.white;
// const kTextMuted = Color(0xFF888888);
//
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  HOME SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   int _currentNavIndex = 0;
//   late AnimationController _tickerCtrl;
//   late AnimationController _glowCtrl;
//   late ScrollController _scrollCtrl;
//
//   final List<NewsPost> _posts = List.from(newsFeed);
//   bool _showFab = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     _tickerCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 20),
//     )..repeat();
//
//     _glowCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _scrollCtrl = ScrollController();
//     _scrollCtrl.addListener(() {
//       if (_scrollCtrl.offset > 200 && !_showFab) {
//         setState(() => _showFab = true);
//       } else if (_scrollCtrl.offset <= 200 && _showFab) {
//         setState(() => _showFab = false);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _tickerCtrl.dispose();
//     _glowCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _logout() async {
//     // ── CHANGE: AuthService.logout() — token clear, credentials optional
//     // keepCredentials: true → Remember Me data rakho
//     // Next time login screen pe email/password prefilled milega
//     await AuthService.instance.logout(keepCredentials: true);
//
//     if (!mounted) return;
//
//     // ── Back stack puri tarah clear karo — back press pe login na aaye
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // ── Top App Bar
//               _buildTopBar(context, isTablet),
//
//               // ── Market Ticker
//             //  _buildMarketTicker(),
//
//               // ── Main Feed
//               Expanded(
//                 child: _buildFeed(context, isTablet),
//               ),
//             ],
//           ),
//
//           // ── FAB scroll to top
//           if (_showFab)
//             Positioned(
//               right: 16,
//               bottom: 80,
//               child: GestureDetector(
//                 onTap: () => _scrollCtrl.animateTo(
//                   0,
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.easeOut,
//                 ),
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: kPurple,
//                     boxShadow: [
//                       BoxShadow(
//                         color: kPurple.withOpacity(0.5),
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.keyboard_arrow_up_rounded,
//                       color: Colors.white, size: 22),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }
//
//   // ── Top App Bar ──────────────────────────────────────────────────────────────
//   Widget _buildTopBar(BuildContext context, bool isTablet) {
//     return Container(
//       color: kBgCard,
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 8,
//         left: 16,
//         right: 16,
//         bottom: 10,
//       ),
//       child: Row(
//         children: [
//           // Logo
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedBuilder(
//                 animation: _glowCtrl,
//                 builder: (_, __) => Text(
//                   'VERVEE',
//                   style: TextStyle(
//                     color: kGold,
//                     fontSize: isTablet ? 22 : 18,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: 3,
//                     shadows: [
//                       Shadow(
//                         color: kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
//                         blurRadius: 8 + 4 * _glowCtrl.value,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Text(
//                 'A C A D E M Y',
//                 style: TextStyle(
//                   color: kPurpleLight,
//                   fontSize: isTablet ? 9 : 7.5,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 3,
//                 ),
//               ),
//             ],
//           ),
//
//           const Spacer(),
//
//           // Search
//           _TopIconBtn(
//             icon: Icons.search_rounded,
//             onTap: () {},
//           ),
//           const SizedBox(width: 8),
//
//           // Notifications
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               _TopIconBtn(
//                 icon: Icons.notifications_outlined,
//                 onTap: () {},
//               ),
//               Positioned(
//                 top: -2,
//                 right: -2,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFFEA4335),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 8),
//
//           // Avatar
//           GestureDetector(
//             onTap: (
//                 _logout
//                 ),// {},
//             child: Container(
//               width: 34,
//               height: 34,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [kGold, kPurple],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: const Center(
//                 child: Text(
//                   'VA',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Market Ticker ────────────────────────────────────────────────────────────
//   Widget _buildMarketTicker() {
//     return Container(
//       height: 28,
//       color: kBgDeep,
//       child: AnimatedBuilder(
//         animation: _tickerCtrl,
//         builder: (_, __) {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               return ClipRect(
//                 child: CustomPaint(
//                   painter: _TickerPainter(
//                     tickers: marketTickers,
//                     get_progress: _tickerCtrl.value,
//                     width: constraints.maxWidth,
//                   ),
//                   child: const SizedBox.expand(),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // ── Main Feed ────────────────────────────────────────────────────────────────
//   Widget _buildFeed(BuildContext context, bool isTablet) {
//     return CustomScrollView(
//       controller: _scrollCtrl,
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         // Stories
//        // SliverToBoxAdapter(child: _buildStoriesRow(isTablet)),
//
//
//         SliverToBoxAdapter(child: _buildStoriesRow(context, isTablet),),
//
//         // Pips Widget
//        // SliverToBoxAdapter(child: _buildPipsWidget(isTablet)),
//
//         // News Feed Header
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//             child: Row(
//               children: [
//                 Container(
//                   width: 3,
//                   height: 16,
//                   decoration: BoxDecoration(
//                     color: kGold,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Latest Market News',
//                   style: TextStyle(
//                     color: kTextPrimary,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     'See all',
//                     style: TextStyle(
//                       color: kPurpleLight,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // Post Cards
//         if (isTablet)
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.72,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) => _PostCard(
//                   post: _posts[index],
//                   isTablet: true,
//                   onLikeTap: () => setState(() {
//                     _posts[index].isLiked = !_posts[index].isLiked;
//                   }),
//                 ),
//                 childCount: _posts.length,
//               ),
//             ),
//           )
//         else
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) => _PostCard(
//                 post: _posts[index],
//                 isTablet: false,
//                 onLikeTap: () => setState(() {
//                   _posts[index].isLiked = !_posts[index].isLiked;
//                 }),
//               ),
//               childCount: _posts.length,
//             ),
//           ),
//
//         const SliverToBoxAdapter(child: SizedBox(height: 16)),
//       ],
//     );
//   }
//
//   // ── Stories Row ──────────────────────────────────────────────────────────────
//   Widget _buildStoriesRow(BuildContext context, bool isTablet) {
//     return Container(
//       height: isTablet ? 95 : 85,
//       color: kBgCard,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         children: [
//
//           // ─── Add Story Button ───
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Material(
//                   color: Colors.transparent,
//                   shape: const CircleBorder(),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(100),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CreatePostScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: isTablet ? 56 : 50,
//                       height: isTablet ? 56 : 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: kBgDeep,
//                         border: Border.all(
//                           color: kPurple.withOpacity(0.5),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.add_rounded,
//                           color: kPurpleLight,
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'Add',
//                   style: TextStyle(
//                     color: kTextMuted,
//                     fontSize: 9,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // ─── Other Story Items ───
//           ...storyCategories.map(
//                 (s) => Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: _StoryItem(
//                 story: s,
//                 isTablet: isTablet,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   // Widget _buildStoriesRow(bool isTablet) {
//   //   // Height ko 85-95 rakhein taaki niche se text na kate
//   //   return Container(
//   //     height: isTablet ? 95 : 85,
//   //     color: kBgCard,
//   //     child: ListView(
//   //       scrollDirection: Axis.horizontal,
//   //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//   //       children: [
//   //         // ─── Add Story Button (Aligned with _StoryItem) ───
//   //         Padding(
//   //           padding: const EdgeInsets.only(right: 10),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Container(
//   //                 // Size wahi rakhein jo _StoryItem mein hai (46 + 4 = 50)
//   //                 width: isTablet ? 56 : 50,
//   //                 height: isTablet ? 56 : 50,
//   //                 decoration: BoxDecoration(
//   //                   shape: BoxShape.circle,
//   //                   color: kBgDeep,
//   //                   // Border color kPurple ki jagah kBorder (optional) ya kPurple hi rakhein
//   //                   border: Border.all(color: kPurple.withOpacity(0.5), width: 1.5),
//   //                 ),
//   //                 child: const Center(
//   //                   child: Icon(Icons.add_rounded, color: kPurpleLight, size: 22),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 2), // Gap 4 ki jagah 2 kiya (Same as _StoryItem)
//   //               const Text(
//   //                   'Add',
//   //                   style: TextStyle(color: kTextMuted, fontSize: 9)
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //
//   //         // ─── Other Story Items ───
//   //         ...storyCategories.map((s) => Padding(
//   //           padding: const EdgeInsets.only(right: 10),
//   //           child: _StoryItem(story: s, isTablet: isTablet),
//   //         )),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   // Widget _buildStoriesRow(bool isTablet) {
//   //   return Container(
//   //     height: isTablet ? 95 : 85,
//   //     color: kBgCard,
//   //     child: ListView(
//   //       scrollDirection: Axis.horizontal,
//   //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//   //       children: [
//   //         // Add story
//   //         Padding(
//   //           padding: const EdgeInsets.only(right: 10),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Container(
//   //                 width: isTablet ? 56 : 50,
//   //                 height: isTablet ? 56 : 50,
//   //                 decoration: BoxDecoration(
//   //                   shape: BoxShape.circle,
//   //                   color: kBgDeep,
//   //                   border: Border.all(color: kPurple, width: 1.5, style: BorderStyle.solid),
//   //                 ),
//   //                 child: const Center(
//   //                   child: Icon(Icons.add_rounded, color: kPurpleLight, size: 22),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 4),
//   //               const Text('Add', style: TextStyle(color: kTextMuted, fontSize: 9)),
//   //             ],
//   //           ),
//   //         ),
//   //
//   //         ...storyCategories.map((s) => Padding(
//   //           padding: const EdgeInsets.only(right: 10),
//   //           child: _StoryItem(story: s, isTablet: isTablet),
//   //         )),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//   // ── Pips Widget ──────────────────────────────────────────────────────────────
//   Widget _buildPipsWidget(bool isTablet) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           // Pips box
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: kBgDeep,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: kBorder, width: 0.5),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "TODAY'S PIPS",
//                   style: TextStyle(
//                     color: kTextMuted,
//                     fontSize: 9,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 AnimatedBuilder(
//                   animation: _glowCtrl,
//                   builder: (_, __) => Text(
//                     '+47.5',
//                     style: TextStyle(
//                       color: kGold,
//                       fontSize: isTablet ? 26 : 22,
//                       fontWeight: FontWeight.w900,
//                       shadows: [
//                         Shadow(
//                           color: kGold.withOpacity(0.5 * _glowCtrl.value),
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 14),
//
//           // Mini bar chart
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Weekly Performance',
//                     style: TextStyle(color: kTextMuted, fontSize: 10)),
//                 const SizedBox(height: 6),
//                 _MiniBarChart(isTablet: isTablet),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 10),
//
//           // Live badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A0A2E),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: kPurple, width: 0.8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AnimatedBuilder(
//                   animation: _glowCtrl,
//                   builder: (_, __) => Container(
//                     width: 6,
//                     height: 6,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFF22C55E)
//                           .withOpacity(0.6 + 0.4 * _glowCtrl.value),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Text(
//                   'Live',
//                   style: TextStyle(
//                     color: kPurpleLight,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Bottom Nav ───────────────────────────────────────────────────────────────
//   Widget _buildBottomNav() {
//     final items = [
//       _NavItem(icon: Icons.home_rounded, label: 'Home'),
//       _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Courses'),
//       _NavItem(icon: Icons.show_chart_rounded, label: 'Markets'),
//       _NavItem(icon: Icons.wifi_tethering_rounded, label: 'Signals'),
//       _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
//     ];
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(top: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(
//               items.length,
//                   (i) => GestureDetector(
//                 onTap: () => setState(() => _currentNavIndex = i),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _currentNavIndex == i
//                         ? kPurple.withOpacity(0.15)
//                         : Colors.transparent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         items[i].icon,
//                         size: 22,
//                         color: _currentNavIndex == i ? kGold : kTextMuted,
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         items[i].label,
//                         style: TextStyle(
//                           fontSize: 9.5,
//                           fontWeight: _currentNavIndex == i
//                               ? FontWeight.w600
//                               : FontWeight.w400,
//                           color: _currentNavIndex == i ? kGold : kTextMuted,
//                         ),
//                       ),
//                       if (_currentNavIndex == i)
//                         Container(
//                           margin: const EdgeInsets.only(top: 3),
//                           width: 4,
//                           height: 4,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: kGold,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  POST CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _PostCard extends StatefulWidget {
//   final NewsPost post;
//   final bool isTablet;
//   final VoidCallback onLikeTap;
//
//   const _PostCard({
//     required this.post,
//     required this.isTablet,
//     required this.onLikeTap,
//   });
//
//   @override
//   State<_PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends State<_PostCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   @override
//   void initState() {
//     super.initState();
//     _likeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   void _handleLike() {
//     _likeCtrl.forward(from: 0);
//     widget.onLikeTap();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final post = widget.post;
//
//     return Container(
//       margin: widget.isTablet
//           ? EdgeInsets.zero
//           : const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
//         border: widget.isTablet
//             ? Border.all(color: kBorder, width: 0.5)
//             : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [kGold, kPurple],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: const Center(
//                     child: Text('VA',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Vervee Academy',
//                           style: TextStyle(
//                               color: kGold,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600)),
//                       Text(post.timeAgo,
//                           style: const TextStyle(
//                               color: kTextMuted, fontSize: 10)),
//                     ],
//                   ),
//                 ),
//                 // Category tag
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: post.categoryColor.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                         color: post.categoryColor.withOpacity(0.5), width: 0.8),
//                   ),
//                   child: Text(
//                     post.category,
//                     style: TextStyle(
//                       color: post.categoryColor,
//                       fontSize: 9.5,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Icon(Icons.more_horiz_rounded, color: kTextMuted, size: 18),
//               ],
//             ),
//           ),
//
//           // Image area
//           _PostImageArea(post: post, isTablet: widget.isTablet),
//
//           // Title + Excerpt
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   post.title,
//                   style: const TextStyle(
//                     color: kTextPrimary,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     height: 1.4,
//                   ),
//                   maxLines: widget.isTablet ? 3 : 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   post.excerpt,
//                   style: const TextStyle(
//                     color: kTextMuted,
//                     fontSize: 11,
//                     height: 1.5,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//
//           // Actions
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
//             child: Row(
//               children: [
//                 // Like
//                 GestureDetector(
//                   onTap: _handleLike,
//                   child: Row(
//                     children: [
//                       ScaleTransition(
//                         scale: _likeScale,
//                         child: Icon(
//                           post.isLiked
//                               ? Icons.favorite_rounded
//                               : Icons.favorite_border_rounded,
//                           size: 18,
//                           color: post.isLiked
//                               ? const Color(0xFFEA4335)
//                               : kTextMuted,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${post.likes + (post.isLiked ? 1 : 0)}',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: post.isLiked
//                               ? const Color(0xFFEA4335)
//                               : kTextMuted,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//
//                 // Comment
//                 GestureDetector(
//                   onTap: () {},
//                   child: Row(
//                     children: [
//                       const Icon(Icons.chat_bubble_outline_rounded,
//                           size: 16, color: kTextMuted),
//                       const SizedBox(width: 4),
//                       Text('${post.comments}',
//                           style: const TextStyle(
//                               fontSize: 11, color: kTextMuted)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//
//                 // Share
//                 GestureDetector(
//                   onTap: () {},
//                   child: const Icon(Icons.share_outlined,
//                       size: 16, color: kTextMuted),
//                 ),
//
//                 const Spacer(),
//
//                 // Read more
//                 GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     'Read more',
//                     style: TextStyle(
//                       color: kPurpleLight,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Post Image Area ──────────────────────────────────────────────────────────
// class _PostImageArea extends StatelessWidget {
//   final NewsPost post;
//   final bool isTablet;
//
//   const _PostImageArea({required this.post, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final h = isTablet ? 140.0 : 160.0;
//     return Container(
//       height: h,
//       width: double.infinity,
//       color: const Color(0xFF1A0535),
//       child: Stack(
//         children: [
//           // Chart line background
//           CustomPaint(
//             painter: _ChartLinePainter(color: post.categoryColor),
//             child: const SizedBox.expand(),
//           ),
//
//           // Breaking badge
//           if (post.category == 'GOLD' || post.category == 'OIL')
//             Positioned(
//               top: 8,
//               left: 10,
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEA4335),
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//                 child: const Text(
//                   'BREAKING',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 8,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
//
//           // Center label
//           Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.45),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     color: post.categoryColor.withOpacity(0.4), width: 0.8),
//               ),
//               child: Text(
//                 post.category,
//                 style: TextStyle(
//                   color: post.categoryColor,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 4,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Chart Line Painter ───────────────────────────────────────────────────────
// class _ChartLinePainter extends CustomPainter {
//   final Color color;
//   _ChartLinePainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Background
//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Paint()..color = const Color(0xFF0A0118),
//     );
//
//     // Grid lines
//     final gridPaint = Paint()
//       ..color = Colors.white.withOpacity(0.04)
//       ..strokeWidth = 0.5;
//     for (int i = 1; i < 4; i++) {
//       canvas.drawLine(
//         Offset(0, size.height * i / 4),
//         Offset(size.width, size.height * i / 4),
//         gridPaint,
//       );
//     }
//
//     // Chart line
//     final rng = math.Random(color.value);
//     final points = <Offset>[];
//     for (int i = 0; i <= 10; i++) {
//       final x = size.width * i / 10;
//       final y = size.height * 0.2 +
//           size.height * 0.6 * (rng.nextDouble() * 0.8 + 0.1);
//       points.add(Offset(x, y));
//     }
//
//     final linePaint = Paint()
//       ..color = color.withOpacity(0.7)
//       ..strokeWidth = 1.8
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     final path = Path();
//     path.moveTo(points[0].dx, points[0].dy);
//     for (int i = 1; i < points.length; i++) {
//       final cp = Offset(
//         (points[i - 1].dx + points[i].dx) / 2,
//         (points[i - 1].dy + points[i].dy) / 2,
//       );
//       path.quadraticBezierTo(
//           points[i - 1].dx, points[i - 1].dy, cp.dx, cp.dy);
//     }
//     canvas.drawPath(path, linePaint);
//
//     // Fill under line
//     final fillPath = Path()..addPath(path, Offset.zero);
//     fillPath.lineTo(size.width, size.height);
//     fillPath.lineTo(0, size.height);
//     fillPath.close();
//     canvas.drawPath(
//       fillPath,
//       Paint()
//         ..shader = LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             color.withOpacity(0.25),
//             color.withOpacity(0.0),
//           ],
//         ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
//     );
//   }
//
//   @override
//   bool shouldRepaint(_ChartLinePainter old) => old.color != color;
// }
//
// // ─── Mini Bar Chart ───────────────────────────────────────────────────────────
// class _MiniBarChart extends StatelessWidget {
//   final bool isTablet;
//   const _MiniBarChart({required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final data = [12.0, 20.0, 14.0, 28.0, 18.0, 32.0, 25.0];
//     final maxVal = data.reduce(math.max);
//     final h = isTablet ? 36.0 : 30.0;
//
//     return SizedBox(
//       height: h,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: data.asMap().entries.map((e) {
//           final isLast = e.key == data.length - 1;
//           return Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 3),
//               child: Container(
//                 height: h * (e.value / maxVal),
//                 decoration: BoxDecoration(
//                   color: isLast ? kGold : kPurple.withOpacity(0.7),
//                   borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(2)),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// // ─── Story Item ───────────────────────────────────────────────────────────────
// // ─── Story Item ───────────────────────────────────────────────────────────────
// class _StoryItem extends StatelessWidget {
//   final StoryCategory story;
//   final bool isTablet;
//   const _StoryItem({required this.story, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     // Height ko thoda kam kiya taaki overflow na ho
//     final sz = isTablet ? 52.0 : 46.0;
//
//     return GestureDetector(
//       onTap: () {},
//       child: SizedBox(
//         width: sz + 8, // Width fixed rakhein taaki layout stable rahe
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: sz + 4,
//               height: sz + 4,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [kGold, kPurple],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(2),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: kBgDeep,
//                   ),
//                   child: Center(
//                     child: Text(
//                       story.emoji,
//                       style: TextStyle(fontSize: isTablet ? 18 : 16), // Emoji size thoda kam kiya
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 2), // Gap 4 se kam karke 2 kiya
//             Text(
//               story.label,
//               style: const TextStyle(color: kTextMuted, fontSize: 9),
//               textAlign: TextAlign.center, // Center align zaroori hai
//               maxLines: 1, // Text ko ek hi line mein rakhein
//               overflow: TextOverflow.ellipsis, // Agar bada ho toh dots dikhein
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// // class _StoryItem extends StatelessWidget {
// //   final StoryCategory story;
// //   final bool isTablet;
// //   const _StoryItem({required this.story, required this.isTablet});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final sz = isTablet ? 56.0 : 50.0;
// //     return GestureDetector(
// //       onTap: () {},
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Container(
// //             width: sz + 4,
// //             height: sz + 4,
// //             decoration: const BoxDecoration(
// //               shape: BoxShape.circle,
// //               gradient: LinearGradient(
// //                 colors: [kGold, kPurple],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(2),
// //               child: Container(
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: kBgDeep,
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     story.emoji,
// //                     style: TextStyle(fontSize: isTablet ? 20 : 18),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             story.label,
// //             style: const TextStyle(color: kTextMuted, fontSize: 9),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // ─── Top Icon Button ──────────────────────────────────────────────────────────
// class _TopIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _TopIconBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: kBgDeep,
//           border: Border.all(color: kBorder, width: 0.5),
//         ),
//         child: Icon(icon, color: kPurpleLight, size: 18),
//       ),
//     );
//   }
// }
//
// // ─── Nav Item Model ───────────────────────────────────────────────────────────
// class _NavItem {
//   final IconData icon;
//   final String label;
//   _NavItem({required this.icon, required this.label});
// }
//
// // ─── Ticker Painter ───────────────────────────────────────────────────────────
// class _TickerPainter extends CustomPainter {
//   final List<MarketTicker> tickers;
//   final double get_progress;
//   final double width;
//
//   _TickerPainter({
//     required this.tickers,
//     required this.get_progress,
//     required this.width,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final itemWidth = 110.0;
//     final totalWidth = itemWidth * tickers.length;
//     final offset = -(get_progress * totalWidth) % totalWidth;
//
//     for (int rep = 0; rep < 3; rep++) {
//       for (int i = 0; i < tickers.length; i++) {
//         final t = tickers[i];
//         final x = offset + rep * totalWidth + i * itemWidth;
//         if (x > size.width + 20) continue;
//         if (x < -itemWidth) continue;
//
//         // Symbol
//         final symSpan = TextSpan(
//           text: '${t.symbol}  ',
//           style: const TextStyle(
//             color: Color(0xFF888888),
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         );
//         final symPainter = TextPainter(
//           text: symSpan,
//           textDirection: TextDirection.ltr,
//         )..layout();
//         symPainter.paint(canvas, Offset(x, (size.height - symPainter.height) / 2));
//
//         // Change
//         final chSpan = TextSpan(
//           text: t.change,
//           style: TextStyle(
//             color: t.isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
//             fontSize: 10,
//             fontWeight: FontWeight.w600,
//           ),
//         );
//         final chPainter = TextPainter(
//           text: chSpan,
//           textDirection: TextDirection.ltr,
//         )..layout();
//         chPainter.paint(
//           canvas,
//           Offset(x + symPainter.width, (size.height - chPainter.height) / 2),
//         );
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(_TickerPainter old) => old.get_progress != get_progress;
// }
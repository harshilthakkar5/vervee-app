
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
import '../../main.dart';
import '../../utils/AuthService.dart';
import '../../utils/NetworkResult.dart';
import '../../utils/PostCacheService.dart';
import '../../utils/PostCardSkeleton.dart';
import '../../utils/ReelNavGuard.dart';
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
    with TickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  int _currentNavIndex = 0;
  late AnimationController _tickerCtrl;
  late AnimationController _glowCtrl;
  late ScrollController _scrollCtrl;
  bool _showFab = false;
  double _fabScale = 1;
  late final List<Widget> _screens;

  DateTime? _lastAutoRefresh;

  // ✅ NEW — TopBar scroll direction tracking
  // bool _showTopBar = true;
  // double _lastScrollOffset = 0;

  // ✅ NEW — TopBar smooth show/hide ke liye
  late AnimationController _topBarAnimCtrl;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.amber, // ✅ ab transparent nahi, solid color
    //   statusBarIconBrightness: Brightness.light, // status bar icons white rahenge (dark bg ke liye)
    //   statusBarBrightness: Brightness.dark, // ✅ iOS ke liye zaruri hai
    // ));

    _tickerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _glowCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    // ✅ NEW — value: 1 matlab shuru mein fully visible
    _topBarAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1,
    );
    _scrollCtrl = ScrollController();
    _scrollCtrl.addListener(_onScroll);
  }

  // void _onScroll() {
  //   if (_scrollCtrl.offset > 200 && !_showFab) {
  //     setState(() => _showFab = true);
  //   } else if (_scrollCtrl.offset <= 200 && _showFab) {
  //     setState(() => _showFab = false);
  //   }
  //   if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
  //     ref.read(getPostViewModelProvider.notifier).loadMore();
  //   }
  // }

  // ✅ NEW — hysteresis tracking ke liye
  double _directionChangeAnchor = 0;
  static const double _scrollThreshold = 10.0; // itna scroll hone ke baad hi direction flip hogi

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final delta  = offset - _directionChangeAnchor;

    if (delta > _scrollThreshold && offset > 60) {
      // Neeche scroll — threshold cross hua
      _topBarAnimCtrl.reverse();
      _directionChangeAnchor = offset; // anchor reset karo
    } else if (delta < -_scrollThreshold) {
      // Upar scroll — threshold cross hua
      _topBarAnimCtrl.forward();
      _directionChangeAnchor = offset; // anchor reset karo
    } else if (offset <= 60) {
      // Top ke bahut paas ho toh hamesha show karo
      _topBarAnimCtrl.forward();
      _directionChangeAnchor = offset;
    }

    // Existing FAB logic — unchanged
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
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _tickerCtrl.dispose();
    _glowCtrl.dispose();
    _scrollCtrl.dispose();
    _topBarAnimCtrl.dispose(); // ✅ NEW
    super.dispose();
  }

  void _openprofile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  // Future<void> _logout() async {
  //   // ── 1. Show Loading Dialog taaki user multiple taps na kare ──────────
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const Center(child: CircularProgressIndicator(color: kPurple)),
  //   );
  //
  //   try {
  //     // ── 2. Navigation pehle trigger karo taaki UI dispose ho jaye aur calls ruk jayein ─
  //     // Hum Navigator.pushAndRemoveUntil ko yahan call karenge process ke end mein,
  //     // lekin calls ko avoid karne ke liye AuthService pehle hi handle karein.
  //
  //     // ✅ Cache clear karo
  //     await PostCacheService.clearAllCache();
  //     await DefaultCacheManager().emptyCache();
  //
  //     // ✅ Token clear karo
  //     await AuthService.instance.logout(keepCredentials: true);
  //
  //     if (!mounted) return;
  //     // Close Loading Dialog
  //     Navigator.pop(context);
  //
  //     // Navigate to Login
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const LoginScreen()),
  //           (route) => false,
  //     );
  //   } catch (e) {
  //     if (mounted) Navigator.pop(context);
  //     debugPrint("Logout error: $e");
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  // ✅ Jab koi pushed screen (Profile/Financial) se wapas home pe aaye
  // @override
  // void didPopNext() {
  //   _maybeAutoRefresh();
  // }

  @override
  void didPopNext() {
    // ✅ NEW — agar reel screen se wapas aaye ho, to refresh skip karo
    // taaki scroll position aur exact video jahan click kiya tha waisi hi rahe
    if (ReelNavGuard.skipNextAutoRefresh) {
      ReelNavGuard.skipNextAutoRefresh = false;
      return;
    }
    _maybeAutoRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeAutoRefresh();
    }
  }

  void _maybeAutoRefresh() {
    final now = DateTime.now();
    // ✅ Throttle — pichle 15 sec me refresh hua ho toh skip karo
    if (_lastAutoRefresh != null &&
        now.difference(_lastAutoRefresh!) < const Duration(seconds: 15)) {
      return;
    }
    _lastAutoRefresh = now;
    ref.read(getPostViewModelProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final statusBarHeight = MediaQuery.of(context).padding.top; // ✅ NEW

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
           //  VerveeTopBar(onProfile: _openprofile),
           //  Expanded(child: _buildFeed(context, isTablet)),
            // ✅ NEW — AnimatedSize se smooth collapse hoga, chahe VerveeTopBar ki
            // actual height kuch bhi ho, isko measure karne ki zarurat nahi
            SizeTransition(
              sizeFactor: _topBarAnimCtrl,
              axisAlignment: -1, // top se collapse ho — content upar chipka rahega
              child: VerveeTopBar(onProfile: _openprofile), // ✅ SAME widget hamesha — kabhi swap nahi hota
            ),
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
          // ✅ NEW — status bar ke peeche solid color paint karo
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: statusBarHeight,
              color:  kBgCard, // ya kBgCard, jo bhi VerveeTopBar ka background match kare
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

                break;
              case 'logout':
               // await _logout(); // ✅ Added await to prevent multiple calls
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

    // return CustomScrollView(
    //   controller: _scrollCtrl,
    //   physics: const BouncingScrollPhysics(),
    return RefreshIndicator(
        color: kPurple,
        backgroundColor: kBgCard,
        onRefresh: () => ref.read(getPostViewModelProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollCtrl,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
      slivers: [
       // SliverToBoxAdapter(child: _buildStoriesRow(context, isTablet)),
        SliverToBoxAdapter(child: _buildCategoryTabs(feedState.selectedCategory)),
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        //     child: Row(children: [
        //       Container(width: 3, height: 16,
        //           decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
        //       const SizedBox(width: 8),
        //       const Text('Latest Market News', style: TextStyle(
        //           color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
        //       const Spacer(),
        //       GestureDetector(
        //         onTap: () => ref.read(getPostViewModelProvider.notifier).refresh(),
        //         child: const Text('Refresh', style: TextStyle(
        //             color: kPurpleLight, fontSize: 12, fontWeight: FontWeight.w500)),
        //       ),
        //     ]),
        //   ),
        // ),

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
        ),
    );
   // );
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

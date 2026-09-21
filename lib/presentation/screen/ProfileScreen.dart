
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/screen/FinancialLiteracyScreen.dart';
import 'package:vervee_app/presentation/screen/PremiumMembershipScreen.dart';
// import '../../constants.dart';
// import '../../application/viewmodel/profile_viewmodels.dart';
// import '../../domain/models/profile_domain.dart';
// import '../../widgets/profile_header.dart';
// import '../../widgets/user_feed_grid.dart';
// import '../../widgets/add_feed_sheet.dart';
import '../../utils/AuthService.dart';
import '../../utils/PostCacheService.dart';
import '../../utils/ProfileCacheService.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../widgets/Common_Widgets/SharedBottomNav.dart';
import '../widgets/Common_Widgets/VerveeTopBar.dart';
import '../widgets/HomeScreenWidgets/PostCard.dart';
import '../widgets/ProfileScreenWidgets/ProfileHeader.dart';
import '../widgets/ProfileScreenWidgets/UserFeedGrid.dart';
import 'AvatarCustomizationScreen.dart';
import 'CreatePostScreen.dart';
import 'EditProfileScreen.dart';
import 'LoginScreen.dart';
import 'SettingsScreen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'edit_profile_screen.dart';
// import 'settings_screen.dart';

const Color kBgDark      = Color(0xFF0F0120);
const Color kBgCard      = Color(0xFF150328);
const Color kBgDeep      = Color(0xFF0A0118);
const Color kPurple      = Color(0xFF7C3AED);
const Color kPurpleLight = Color(0xFF9333EA);
const Color kGold        = Color(0xFFD4AF37);
const Color kGoldLight   = Color(0xFFFFD700);
const Color kBorder      = Color(0xFF2D1050);
const Color kTextPrimary = Colors.white;
const Color kTextMuted   = Color(0xFF888888);
const Color kRed         = Color(0xFFEF4444);
const Color kGreen       = Color(0xFF22C55E);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _activeTab = 0;

  // void _openAddFeed() {
  //   // Note: AddFeedSheet abhi local add karta hai (API nahi)
  //   // Jab CreatePost API add karoge tab wire karna
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => AddFeedSheet(
  //       onAdd: (_) {
  //         // Refresh feed from API after add
  //         ref.read(userFeedViewModelProvider.notifier).refresh();
  //       },
  //     ),
  //   );
  // }

  void _openAddFeed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    ).then((_) {
      // Post create hone ke baad feed refresh karo
      ref.read(userFeedViewModelProvider.notifier).refresh();
    });
  }

  // Future<void> _logout() async {
  //
  //   // ✅ 1 — Post cache clear karo (SharedPreferences me saved posts)
  //   await PostCacheService.clearAllCache();
  //
  //   // ✅ Profile cache clear karo (Hive) — naya/dusra user login kare to purana data na dikhe
  //   await ProfileCacheService.instance.clearAll();
  //
  //   // ✅ 2 — Image cache clear karo (CachedNetworkImage ka disk cache)
  //   await CachedNetworkImage.evictFromCache('');
  //   // ya poora image cache clear karo:
  //   await DefaultCacheManager().emptyCache();
  //
  //   await AuthService.instance.logout(keepCredentials: true);
  //
  //   // ✅ NAYA — Riverpod providers invalidate karo taaki in-memory state bhi clear ho jaye
  //   // Warna keepAlive() ki wajah se purana profile/feed/subscription state
  //   // memory me hi reh jaata he aur naya login pe wahi purana data dikhta he
  //   ref.invalidate(profileInfoViewModelProvider);
  //   ref.invalidate(userFeedViewModelProvider);
  //   ref.invalidate(subscriptionViewModelProvider);
  //   ref.invalidate(avatarViewModelProvider); // agar avatar bhi user-specific he
  //
  //   if (!mounted) return;
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const LoginScreen()),
  //         (route) => false,
  //   );
  // }

  // bool _isLoggingOut = false; // ← class field me add karo
  //
  // Future<void> _logout() async {
  //   if (_isLoggingOut || !mounted) return;   // ← double-tap / re-entry guard
  //   _isLoggingOut = true;
  //
  //   // 1) Navigate FIRST — ProfileScreen turant unmount ho jayega,
  //   //    isliye ab invalidate se koi naya rebuild/refetch nahi hoga
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const LoginScreen()),
  //         (route) => false,
  //   );
  //
  //   // 2) Ab cleanup — screen already gone hai
  //   await PostCacheService.clearAllCache();
  //   await ProfileCacheService.instance.clearAll();
  //   await CachedNetworkImage.evictFromCache('');
  //   await DefaultCacheManager().emptyCache();
  //   await AuthService.instance.logout(keepCredentials: true);
  //
  //   // 3) Providers ko sirf "read" karke invalidate karo, "watch" wale ref se nahi
  //   //    (widget already disposed ho sakta hai isliye guard zaroori)
  //   if (mounted) {
  //     ref.invalidate(profileInfoViewModelProvider);
  //     ref.invalidate(userFeedViewModelProvider);
  //     ref.invalidate(subscriptionViewModelProvider);
  //     ref.invalidate(avatarViewModelProvider);
  //   }
  // }

  Future<void> _logout() async {
    // ── 1. Show Loading Dialog taaki user multiple taps na kare ──────────
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: kPurple)),
    );

    try {
      // ── 2. Navigation pehle trigger karo taaki UI dispose ho jaye aur calls ruk jayein ─
      // Hum Navigator.pushAndRemoveUntil ko yahan call karenge process ke end mein,
      // lekin calls ko avoid karne ke liye AuthService pehle hi handle karein.

      // ✅ Cache clear karo
      await PostCacheService.clearAllCache();
      await DefaultCacheManager().emptyCache();

      // ✅ Token clear karo
      await AuthService.instance.logout(keepCredentials: true);

      if (!mounted) return;
      // Close Loading Dialog
      Navigator.pop(context);

      // Navigate to Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Logout error: $e");
    }
  }

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    ).then((_) {
      // Edit screen se wapas aao to profile refresh karo
      ref.read(profileInfoViewModelProvider.notifier).loadProfile();
    });
  }

  void _openfinancialLiteracy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
    );
  }

  void _openprofile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _opensetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // ── Watch both ViewModels ─────────────────────────────────────
    final profileState = ref.watch(profileInfoViewModelProvider);
    final feedState    = ref.watch(userFeedViewModelProvider);
    final avatarUrl = ref.watch(avatarViewModelProvider).generatedMascotUrl; // ✅ ADD
    final subState     = ref.watch(subscriptionViewModelProvider); // ← ADD

    return Scaffold(
      backgroundColor: kBgDark,
      //appBar: AppBar(VerveeTopBar(onProfile: _openprofile)),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: VerveeTopBar(onProfile: _openprofile),
      ),

      body: RefreshIndicator(
        color: kPurple,
        backgroundColor: kBgCard,
        onRefresh: () async {
          await Future.wait([
            ref.read(profileInfoViewModelProvider.notifier).loadProfile(),
            ref.read(userFeedViewModelProvider.notifier).refresh(),
          ]);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ─────────────────────────────────────────
            //SliverToBoxAdapter(child: VerveeTopBar(onProfile: _openprofile),),
            // SliverAppBar(
            //   backgroundColor: kBgCard,
            //   pinned: true,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   title: _buildAppBarTitle(),
            //   actions: [
            //     IconButton(
            //       icon: const Icon(Icons.search_rounded,
            //           color: kPurpleLight, size: 22),
            //       onPressed: () {},
            //     ),
            //     // Avatar — profile name ki initial dikhao
            //     GestureDetector(
            //       onTap: () {},
            //       child: Container(
            //       width: 34, height: 34,
            //       margin: const EdgeInsets.only(right: 12),
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         // ✅ Agar URL hai to gradient hatao, warna rakhao
            //         gradient: avatarUrl == null
            //             ? const LinearGradient(
            //           colors: [kGold, kPurple],
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //         )
            //             : null,
            //       ),
            //       child: avatarUrl != null
            //       // ✅ Saved avatar image dikhao
            //           ? ClipOval(
            //         child: Image.network(
            //           avatarUrl,
            //           width: 34, height: 34,
            //           fit: BoxFit.cover,
            //           errorBuilder: (_, __, ___) => Center(
            //             child: Text(
            //               // API se naam aaya to initial, warna 'VA'
            //               profileState.profile != null
            //                   ? profileState.profile!.name
            //                   .substring(0, 1)
            //                   .toUpperCase()
            //                   : 'VA',
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 13,
            //                 fontWeight: FontWeight.w700,
            //               ),
            //             ),
            //           ),
            //         ),
            //       )
            //       // ✅ Default 'VA' text
            //           : const Center(
            //         child: Text('VA',
            //             style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
            //       ),
            //     ),
            //
            //       // Container(
            //       //   width: 34,
            //       //   height: 34,
            //       //   margin: const EdgeInsets.only(right: 12),
            //       //   decoration: const BoxDecoration(
            //       //     shape: BoxShape.circle,
            //       //     gradient: LinearGradient(
            //       //       colors: [kGold, kPurple],
            //       //       begin: Alignment.topLeft,
            //       //       end: Alignment.bottomRight,
            //       //     ),
            //       //   ),
            //       //   child: Center(
            //       //     child: Text(
            //       //       // API se naam aaya to initial, warna 'VA'
            //       //       profileState.profile != null
            //       //           ? profileState.profile!.name
            //       //           .substring(0, 1)
            //       //           .toUpperCase()
            //       //           : 'VA',
            //       //       style: const TextStyle(
            //       //         color: Colors.white,
            //       //         fontSize: 13,
            //       //         fontWeight: FontWeight.w700,
            //       //       ),
            //       //     ),
            //       //   ),
            //       // ),
            //     ),
            //   ],
            //   bottom: PreferredSize(
            //     preferredSize: const Size.fromHeight(0.5),
            //     child: Container(height: 0.5, color: kBorder),
            //   ),
            // ),

            // ── Profile Loading State ────────────────────────────
            if (profileState.isLoading)
              const SliverToBoxAdapter(child: _ProfileShimmer()),

            // ── Profile Error State ──────────────────────────────
            if (!profileState.isLoading && profileState.errorMessage != null)
              SliverToBoxAdapter(
                child: _ProfileError(
                  message: profileState.errorMessage!,
                  onRetry: () => ref
                      .read(profileInfoViewModelProvider.notifier)
                      .loadProfile(),
                ),
              ),

            // ── Profile Header ───────────────────────────────────
            if (!profileState.isLoading && profileState.profile != null)
              SliverToBoxAdapter(
                child: ProfileHeader(
                  // API data pass karo
                  avatarUrl: avatarUrl,
                  profile: profileState.profile!,
                  onEdit: _openEditProfile,
                  onSettings: _opensetting, //_opensetting
                  onlogout: _logout,
                  onFinancialLiteracy: _openfinancialLiteracy,
                  activeTab: _activeTab,
                  onTabChange: (i) => setState(() => _activeTab = i),
                  postsCount: feedState.posts.length, // ✅ ADD KARO
                  subscription: subState.subscription, // ← ADD
                  onAvatarTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AvatarCustomizationScreen(),
                      ),
                    );
                  },
                ),
              ),

            // ── Feed Grid ────────────────────────────────────────
            // SliverToBoxAdapter(
            //   child: UserFeedGrid(
            //     feedState: feedState,
            //     onAdd: _openAddFeed,
            //     onRetry: () =>
            //         ref.read(userFeedViewModelProvider.notifier).refresh(),
            //   ),
            // ),

            // ── Feed Empty State ──────────────────────────────────────────
            if (!feedState.isLoading &&
                feedState.errorMessage == null &&
                feedState.posts.isEmpty)
              SliverToBoxAdapter(
                child: EmptyFeedView(onAdd: _openAddFeed),
              ),


            // ── Feed Grid ────────────────────────────────────────
            if (!feedState.isLoading &&
                feedState.errorMessage == null &&
                feedState.posts.isNotEmpty)

              SliverPadding(
                padding: const EdgeInsets.only(top: 5),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (_, i) => FeedTile(post: feedState.posts[i]),
                    childCount: feedState.posts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                ),
              ),


            // ── Feed Error ────────────────────────────────────────────────
            if (feedState.errorMessage != null && !feedState.isLoading)
              SliverToBoxAdapter(
                child: FeedGridError(
                  message: feedState.errorMessage!,
                  onRetry: () => ref.read(userFeedViewModelProvider.notifier).refresh(),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),

      bottomNavigationBar: SharedBottomNav(currentIndex: 4, popOnHome: true),
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
    Row(
    children: [
        // Back arrow
        // IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded,
        //       color: Colors.white, size: 18),
        //   onPressed: () => Navigator.pop(context),
        //   padding: EdgeInsets.zero,                        // ✅ yeh add karo
        //   visualDensity: VisualDensity.compact,
        // ),
    Column(
    children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [kGold, kGoldLight],
          ).createShader(bounds),
          child: const Text(
            'VERVEE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ),
        const Text(
          'A C A D E M Y',
          style: TextStyle(
            color: kPurpleLight,
            fontSize: 7,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
    ],
    ),
      ],
    ),
    ],
    );
  }
}

// class AddFeedSheet {
// }

class AddFeedSheet extends StatefulWidget {
  final Function(String) onAdd; // sirf refresh ke liye callback

  const AddFeedSheet({super.key, required this.onAdd});

  @override
  State<AddFeedSheet> createState() => _AddFeedSheetState();
}

class _AddFeedSheetState extends State<AddFeedSheet> {
  final _titleCtrl = TextEditingController();
  String _selectedCategory = 'Stock Market';

  final List<String> _categories = [
    'Stock Market', 'Forex', 'Crypto', 'Gold', 'Oil', 'Economy',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top:   BorderSide(color: kBorder, width: 0.5),
          left:  BorderSide(color: kBorder, width: 0.5),
          right: BorderSide(color: kBorder, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: kTextMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text('Add New Feed Post', style: TextStyle(
            color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700,
          )),
          const SizedBox(height: 16),

          const Text('Title', style: TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(color: kTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter post title...',
              hintStyle: const TextStyle(color: kTextMuted),
              filled: true, fillColor: kBgDeep,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPurple)),
            ),
          ),
          const SizedBox(height: 14),

          const Text('Category', style: TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = cat == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? kPurple : kBgDeep,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? kPurple : kBorder),
                  ),
                  child: Text(cat, style: TextStyle(
                    color: isSelected ? Colors.white : kTextMuted,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: kBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Cancel', style: TextStyle(color: kTextMuted, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  widget.onAdd(title); // refresh trigger karo
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Post Feed', style: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600,
                )),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────
class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Cover shimmer
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: kBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 40),
          // Name shimmer
          Container(height: 14, width: 120, color: kBorder),
          const SizedBox(height: 8),
          Container(height: 11, width: 200, color: kBorder),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: kTextMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: kPurple),
            child: const Text('Retry',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


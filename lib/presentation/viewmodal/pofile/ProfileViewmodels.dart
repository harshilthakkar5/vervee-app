
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
//import '../state/profile_state.dart';
//import '../../domain/models/profile_domain.dart';
//import '../../di/profile_module.dart';
import '../../../di/PostModule.dart';
import '../../../di/ProfileModule.dart';
import '../../../domain/model/post/CreatePost.dart';
import '../../../utils/AuthService.dart';
import '../../../utils/NetworkResult.dart';
import '../../../utils/ProfileCacheService.dart';
import '../post/CreatePostViewmodel.dart';
import '../post/GetPostViewModel.dart';
import 'ProfileState.dart';

part 'ProfileViewmodels.g.dart';

// ════════════════════════════════════════════════════════════════════
//  1. ProfileInfoViewModel
//     - Screen open hote hi profile load karta hai
//     - Edit Profile screen mein updateProfile() call hota hai
// ════════════════════════════════════════════════════════════════════
@riverpod
class ProfileInfoViewModel extends _$ProfileInfoViewModel {

  @override
  ProfileInfoState build() {
    ref.keepAlive();   // ✅ ADD KARO
    // ✅ Hive cache se turant load — offline pe bhi ye instantly dikhega
    final cached = ProfileCacheService.instance.getProfile();
    Future.microtask(() => loadProfile());
    return ProfileInfoState(profile: cached);
  }

  // ── Load profile ───────────────────────────────────────────────
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    // ✅ Cache se data already hai to shimmer mat dikhao
    final hasCachedData = state.profile != null;
    if (!hasCachedData) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result = await ref.read(profileRepositoryProvider).getMyInfo();

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (profile) {
        // ✅ freezed equality — sirf actual change pe UI update + cache write
        if (state.profile != profile) {
          state = state.copyWith(profile: profile, isLoading: false);
          ProfileCacheService.instance.saveProfile(profile);
        } else if (state.isLoading) {
          state = state.copyWith(isLoading: false);
        }
      },
      error: (message, _) {
        // ✅ Cache se data dikh raha hai to internet error silently ignore karo
        state = state.copyWith(
          isLoading: false,
          errorMessage: hasCachedData ? null : message,
        );
      },
    );
  }

  // @override
  // ProfileInfoState build() {
  //   // GetPostViewModel ki tarah — screen open hote hi load karo
  //
  //   Future.microtask(() => loadProfile());
  //   return const ProfileInfoState();
  // }
  //
  // // ── Load profile ───────────────────────────────────────────────
  // Future<void> loadProfile() async {
  //   if (state.isLoading) return;
  //
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //
  //   final result = await ref.read(profileRepositoryProvider).getMyInfo();
  //
  //   result.when(
  //     initial: () {},
  //     loading: () {},
  //     success: (profile) {
  //       state = state.copyWith(
  //         profile: profile,
  //         isLoading: false,
  //       );
  //     },
  //     error: (message, _) {
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: message,
  //       );
  //     },
  //   );
  // }

  // ── Update profile (Edit Profile screen → Save button) ────────
  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    if (state.isUpdating) return;

    state = state.copyWith(
      isUpdating: true,
      errorMessage: null,
      successMessage: null,
    );

    final result = await ref.read(profileRepositoryProvider).updateProfile(
      name: name,
      email: email,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (updatedProfile) {
        state = state.copyWith(
          profile: updatedProfile,
          isUpdating: false,
          successMessage: 'Profile updated successfully!',
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: message,
        );
      },
    );
  }

  /// Success message clear karo (snackbar dikhane ke baad)
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  2. ChangePasswordViewModel
//     - Settings screen → Account Management tab → Change Password
// ════════════════════════════════════════════════════════════════════
@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {

  @override
  ChangePasswordState build() => const ChangePasswordState();

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.isLoading) return;

    // Client-side validation
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please fill all password fields.',
      );
      return;
    }
    if (newPassword.length < 6) {
      state = state.copyWith(
        errorMessage: 'New password must be at least 6 characters.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final result = await ref
        .read(profileRepositoryProvider)
        .changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (res) {
        state = state.copyWith(
          isLoading: false,
          successMessage: res.message, // "Password updated successfully!"
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  3. UserFeedViewModel
//     - Profile screen ke grid mein user ke apne posts dikhata hai
// ════════════════════════════════════════════════════════════════════
@riverpod
class UserFeedViewModel extends _$UserFeedViewModel {

  @override
  UserFeedState build() {
    ref.keepAlive();   // ✅ ADD KARO
    // ✅ Hive cache se turant posts load karo
    final cached = ProfileCacheService.instance.getFeed();
    Future.microtask(() => loadUserFeed());

    ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (previous, next) {
      if (next is Success<CreatePost>) {
        loadUserFeed();
      }
    });

    return UserFeedState(posts: cached);
  }

  Future<void> loadUserFeed() async {
    if (state.isLoading) return;

    final hasCachedData = state.posts.isNotEmpty;
    if (!hasCachedData) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result =
    await ref.read(profileRepositoryProvider).getUserFeedPosts();

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (posts) {
        // ✅ List compare (freezed equality element-wise) — change pe hi update
        if (!listEquals(state.posts, posts)) {
          state = state.copyWith(posts: posts, isLoading: false);
          ProfileCacheService.instance.saveFeed(posts);
        } else if (state.isLoading) {
          state = state.copyWith(isLoading: false);
        }
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: hasCachedData ? null : message,
        );
      },
    );
  }

  // @override
  // UserFeedState build() {
  //   Future.microtask(() => loadUserFeed());
  //   return const UserFeedState();
  // }
  //
  // Future<void> loadUserFeed() async {
  //   if (state.isLoading) return;
  //
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //
  //   final result =
  //   await ref.read(profileRepositoryProvider).getUserFeedPosts();
  //
  //   result.when(
  //     initial: () {},
  //     loading: () {},
  //     success: (posts) {
  //       state = state.copyWith(
  //         posts: posts,
  //         isLoading: false,
  //       );
  //     },
  //     error: (message, _) {
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: message,
  //       );
  //     },
  //   );
  // }

  Future<void> refresh() => loadUserFeed();

  // UserFeedViewModel mein add karo — bas itna

  Future<String?> toggleLike(int postId) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return 'Post not found';

    final oldPost = state.posts[index];

    // Optimistic update
    final updated = [...state.posts];
    updated[index] = oldPost.copyWith(
      isLiked:    !oldPost.isLiked,
      likesCount: oldPost.isLiked
          ? oldPost.likesCount - 1
          : oldPost.likesCount + 1,
    );
    state = state.copyWith(posts: updated);

    // Same repository call jo GetPostViewModel karta hai
    final userId = await AuthService.instance.getUserId();
    if (userId == null) {
      state = state.copyWith(posts: [...state.posts]..[index] = oldPost);
      return 'Login required';
    }

    final result = oldPost.isLiked
        ? await ref.read(postRepositoryProvider).unlikePost(postId: postId, userId: userId)
        : await ref.read(postRepositoryProvider).likePost(postId: postId, userId: userId);

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (likeResult) {
        final synced = [...state.posts];
        synced[index] = synced[index].copyWith(
          isLiked:    likeResult.liked,
          likesCount: likeResult.likesCount,
        );
        state = state.copyWith(posts: synced);
        return null;
      },
      error: (message, _) {
        // Rollback
        final rolled = [...state.posts];
        rolled[index] = oldPost;
        state = state.copyWith(posts: rolled);
        return message;
      },
    );
  }

  // ✅ NEW — Profile posts ke liye dedicated deletePost, GetPostViewModel se independent
  Future<String?> deletePost(int postId) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return 'Post not found';

    final postToDelete = state.posts[index];

    // Optimistic remove
    final updatedPosts = state.posts.where((p) => p.id != postId).toList();
    state = state.copyWith(posts: updatedPosts);

    final result = await ref.read(postRepositoryProvider).deletePost(postId);

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (_) => null, // ✅ success — local list already updated
      error: (message, _) {
        // Rollback — post wapas original position pe daalo
        final restored = List.of(state.posts);
        restored.insert(index.clamp(0, restored.length), postToDelete);
        state = state.copyWith(posts: restored);
        return message;
      },
    );
  }


  // ✅ NEW — Profile posts ke liye dedicated updatePost, GetPostViewModel se independent
  Future<String?> updatePost({
    required int postId,
    String? title,
    String? content,
    String? category,
    File?   file,
  }) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return 'Post not found';

    final oldPost = state.posts[index];

    // Optimistic update
    final optimistic = [...state.posts];
    optimistic[index] = oldPost.copyWith(
      title:    title    ?? oldPost.title,
      content:  content  ?? oldPost.content,
      category: category ?? oldPost.category,
    );
    state = state.copyWith(posts: optimistic);

    final result = await ref.read(postRepositoryProvider).updatePost(
      postId:   postId,
      title:    title,
      content:  content,
      category: category,
      file:     file,
    );

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (createdPost) {
        final synced = [...state.posts];
        final i = synced.indexWhere((p) => p.id == postId);
        if (i != -1) {
          synced[i] = synced[i].copyWith(
            title:      createdPost.title,
            content:    createdPost.content ?? synced[i].content,
            category:   createdPost.category,
            filePath:   createdPost.filePath,
            fileType:   createdPost.fileType,
            likesCount: createdPost.likesCount,
          );
          state = state.copyWith(posts: synced);
        }
        // ✅ Home feed bhi sync karo taaki HomeScreen pe bhi updated dikhe
        ref.read(getPostViewModelProvider.notifier).refresh();
        return null;
      },
      error: (message, _) {
        final rolled = [...state.posts];
        final i = rolled.indexWhere((p) => p.id == postId);
        if (i != -1) rolled[i] = oldPost;
        state = state.copyWith(posts: rolled);
        return message;
      },
    );
  }
}


// ════════════════════════════════════════════════════════════════════
//  3. For Subscription
//     // "Manage Subscription" button press pe call karo
//   // URL milne ke baad url_launcher se browser mein open karo
// ════════════════════════════════════════════════════════════════════


@riverpod
class SubscriptionViewModel extends _$SubscriptionViewModel {

  @override
  SubscriptionState build() {
    ref.keepAlive();
    // ✅ Hive cache se turant load karo
    final cached = ProfileCacheService.instance.getSubscription();
    Future.microtask(() => loadSubscription());
    return SubscriptionState(subscription: cached);
  }

  // ── GET /subscription/my-subscription ──────────────────────────────
  Future<void> loadSubscription() async {
    if (state.isLoading) return;

    final hasCachedData = state.subscription != null;
    if (!hasCachedData) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    final result =
    await ref.read(profileRepositoryProvider).getMySubscription();

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (subscription) {
        // ⚠️ SubscriptionInfo freezed nahi hai, isliye manual field-compare
        final old = state.subscription;
        final isSame = old != null &&
            old.status == subscription.status &&
            old.trialEnd == subscription.trialEnd &&
            old.cancelAtPeriodEnd == subscription.cancelAtPeriodEnd;

        if (!isSame) {
          state = state.copyWith(subscription: subscription, isLoading: false);
          ProfileCacheService.instance.saveSubscription(subscription);
        } else if (state.isLoading) {
          state = state.copyWith(isLoading: false);
        }
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: hasCachedData ? null : message,
        );
      },
    );
  }

  // @override
  // SubscriptionState build() {
  //   // Tab open hote hi subscription load karo
  //   // Exactly same pattern jaise ProfileInfoViewModel aur UserFeedViewModel karte hain
  //   ref.keepAlive();
  //   Future.microtask(() => loadSubscription());
  //   return const SubscriptionState();
  // }
  //
  // // ── GET /subscription/my-subscription ──────────────────────────────
  // Future<void> loadSubscription() async {
  //   if (state.isLoading) return;
  //
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //
  //   final result =
  //   await ref.read(profileRepositoryProvider).getMySubscription();
  //
  //   result.when(
  //     initial: () {},
  //     loading: () {},
  //     success: (subscription) {
  //       state = state.copyWith(
  //         subscription: subscription,
  //         isLoading: false,
  //       );
  //     },
  //     error: (message, _) {
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: message,
  //       );
  //     },
  //   );
  // }

  // ── POST /subscription/customer-portal ─────────────────────────────
  // "Manage Subscription" button press pe call karo
  // URL milne ke baad url_launcher se browser mein open karo
  // Future<void> openCustomerPortal() async {
  //   if (state.isPortalLoading) return;
  //
  //   state = state.copyWith(isPortalLoading: true, portalErrorMessage: null);
  //
  //   final result =
  //   await ref.read(profileRepositoryProvider).getCustomerPortalUrl();
  //
  //   result.when(
  //     initial: () {},
  //     loading: () {},
  //     success: (portal) async {
  //       state = state.copyWith(isPortalLoading: false);
  //
  //       // Stripe portal URL browser mein open karo
  //       final uri = Uri.parse(portal.url);
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       } else {
  //         state = state.copyWith(
  //           portalErrorMessage: 'Could not open subscription portal.',
  //         );
  //       }
  //     },
  //     error: (message, _) {
  //       state = state.copyWith(
  //         isPortalLoading: false,
  //         portalErrorMessage: message,
  //       );
  //     },
  //   );
  // }

  // ProfileViewmodels.dart - SubscriptionViewModel

//   Future<void> openCustomerPortal() async {
//     if (state.isPortalLoading) return;
//
//     state = state.copyWith(isPortalLoading: true, portalErrorMessage: null);
//
//     final result =
//     await ref.read(profileRepositoryProvider).getCustomerPortalUrl();
//
//     result.when(
//       initial: () {},
//       loading: () {},
//       success: (portal) async {
//         state = state.copyWith(isPortalLoading: false);
//
//         final uri = Uri.parse(portal.url);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(
//             uri,
//             mode: LaunchMode.inAppWebView, // ← bas yahi badlo
//           );
//         } else {
//           state = state.copyWith(
//             portalErrorMessage: 'Could not open subscription portal.',
//           );
//         }
//       },
//       error: (message, _) {
//         state = state.copyWith(
//           isPortalLoading: false,
//           portalErrorMessage: message,
//         );
//       },
//     );
//   }
//
//   void clearPortalError() {
//     state = state.copyWith(portalErrorMessage: null);
//   }
// }

  Future<void> openCustomerPortal() async {
    if (state.isPortalLoading) return;

    state = state.copyWith(isPortalLoading: true, portalErrorMessage: null);

    final result =
    await ref.read(profileRepositoryProvider).getCustomerPortalUrl();

    result.when(
      initial: () {},
      loading: () {},
      success: (portal) {
        // ← URL launch nahi karo, state mein store karo
        // UI (SettingsScreen) khud navigate karega
        state = state.copyWith(
          isPortalLoading: false,
          portalUrl: portal.url,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isPortalLoading: false,
          portalErrorMessage: message,
        );
      },
    );
  }

  void clearPortalUrl() {
    state = state.copyWith(portalUrl: null);
  }

  void clearPortalError() {
    state = state.copyWith(portalErrorMessage: null);
  }


  // ── POST /subscription/create-checkout-session ──────────────────────
  Future<void> openCheckout() async {
    if (state.isCheckoutLoading) return;

    state = state.copyWith(
      isCheckoutLoading: true,
      checkoutErrorMessage: null,
      checkoutUrl: null,
    );

    final result =
    await ref.read(profileRepositoryProvider).getCustomerCheckoutUrl();

    result.when(
      initial: () {},
      loading: () {},
      success: (portal) {
        state = state.copyWith(
          isCheckoutLoading: false,
          checkoutUrl: portal.url,   // UI yahan se URL uthayega
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isCheckoutLoading: false,
          checkoutErrorMessage: message,
        );
      },
    );
  }

  void clearCheckoutUrl() {
    state = state.copyWith(checkoutUrl: null);
  }

  void clearCheckoutError() {
    state = state.copyWith(checkoutErrorMessage: null);
  }


  // ── POST /subscription/create-checkout-session-promo ──────────────────────
  Future<void> openCheckoutWithPromo(String promoCode) async {
    if (state.isPromoCheckoutLoading) return;

    final trimmed = promoCode.trim();
    if (trimmed.isEmpty) return; // UI already validate karega

    state = state.copyWith(
      isPromoCheckoutLoading: true,
      promoCheckoutErrorMessage: null,
      promoCheckoutUrl: null,
    );

    final result = await ref
        .read(profileRepositoryProvider)
        .getCustomerCheckoutWithPromoUrl(trimmed);

    result.when(
      initial: () {},
      loading: () {},
      success: (portal) {
        state = state.copyWith(
          isPromoCheckoutLoading: false,
          promoCheckoutUrl: portal.url,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isPromoCheckoutLoading: false,
          promoCheckoutErrorMessage: message,
        );
      },
    );
  }

  void clearPromoCheckoutUrl() {
    state = state.copyWith(promoCheckoutUrl: null);
  }

  void clearPromoCheckoutError() {
    state = state.copyWith(promoCheckoutErrorMessage: null);
  }

}


// ════════════════════════════════════════════════════════════════════
//  Delete Account ViewModel
//     - SettingsScreen ke "Yes, Delete" button pe call hota hai
// ════════════════════════════════════════════════════════════════════
@riverpod
class DeleteAccountViewModel extends _$DeleteAccountViewModel {

  @override
  DeleteAccountState build() => const DeleteAccountState();

  Future<void> deleteAccount() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    final result = await ref.read(profileRepositoryProvider).deleteAccount();

    result.when(
      initial: () {},
      loading: () {},
      success: (res) {
        state = state.copyWith(
          isLoading: false,
          successMessage: res.message, // "Account deactivated successfully"
          isDeleted: true,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}































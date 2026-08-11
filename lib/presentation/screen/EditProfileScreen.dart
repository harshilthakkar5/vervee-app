
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';        // ✅ ADD
import '../viewmodal/pofile/ProfileViewmodels.dart';
import 'AvatarCustomizationScreen.dart';
//import 'ProfileScreen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController();
    _emailCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _openAvatarScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AvatarCustomizationScreen()),
    );
  }

  void _initControllers(String name, String email) {
    if (!_initialized) {
      _nameCtrl.text  = name;
      _emailCtrl.text = email;
      _initialized    = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileInfoViewModelProvider);
    final avatarUrl    = ref.watch(avatarViewModelProvider).generatedMascotUrl; // ✅ ADD

    if (profileState.profile != null) {
      _initControllers(
        profileState.profile!.name,
        profileState.profile!.email,
      );
    }

    // Name initial
    final initial = profileState.profile?.name.isNotEmpty == true
        ? profileState.profile!.name[0].toUpperCase()
        : '?';

    ref.listen(profileInfoViewModelProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: kGreen),
        );
        ref.read(profileInfoViewModelProvider.notifier).clearMessages();
        Navigator.pop(context);
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: kRed),
        );
        ref.read(profileInfoViewModelProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: kBgCard,
      appBar: AppBar(
        backgroundColor: kBgCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPurpleLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Avatar ──────────────────────────────────────────────────
            Center(
              child: SizedBox(
                width: 86,
                height: 86,
                child: Stack(
                  children: [
                    // ✅ Avatar circle — same logic as ProfileHeader
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: avatarUrl == null
                            ? const LinearGradient(
                          colors: [kGold, kPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        border: Border.all(color: kBgCard, width: 3),
                      ),
                      child: avatarUrl != null
                      // ✅ Saved avatar image dikhao
                          ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
                      // ✅ Default initial text
                          : Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                    // ✅ Edit badge — bottom right
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _openAvatarScreen,                          // ✅ ADD
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: kPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBgCard, width: 2),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Change Photo',
              style: TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // ── Personal Info Card ───────────────────────────────────────
            _Card(
              title: 'PERSONAL INFORMATION',
              child: Column(
                children: [
                  _LabeledField(
                    label: 'Name',
                    child: _StyledInput(controller: _nameCtrl, hint: 'Your name'),
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'Email',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                      decoration: BoxDecoration(
                        color: kBgDeep,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline, color: kTextMuted, size: 15),
                          const SizedBox(width: 8),
                          Text(
                            _emailCtrl.text,
                            style: const TextStyle(color: kTextMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Save Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: profileState.isUpdating
                    ? null
                    : () {
                  ref
                      .read(profileInfoViewModelProvider.notifier)
                      .updateProfile(
                    name: _nameCtrl.text.trim(),
                    email: profileState.profile?.email ?? '',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  disabledBackgroundColor: kPurple.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: profileState.isUpdating
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets (unchanged) ──────────────────────────────────────────

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: kPurpleLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 12)),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class _StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  const _StyledInput(
      {required this.controller, required this.hint, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: kTextPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextMuted),
        filled: true,
        fillColor: kBgDeep,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kPurple)),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../../constants.dart';
// // import '../../application/viewmodel/profile_viewmodels.dart';
// import '../viewmodal/pofile/ProfileViewmodels.dart';
// //import '../widgets/HomeScreenWidgets/PostCard.dart';
// import 'ProfileScreen.dart';
//
// class EditProfileScreen extends ConsumerStatefulWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   ConsumerState<EditProfileScreen> createState() =>
//       _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
//   late TextEditingController _nameCtrl;
//   late TextEditingController _emailCtrl;
//   bool _initialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameCtrl  = TextEditingController();
//     _emailCtrl = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     super.dispose();
//   }
//
//   // Profile data ko controllers mein ek baar load karo
//   void _initControllers(String name, String email) {
//     if (!_initialized) {
//       _nameCtrl.text  = name;
//       _emailCtrl.text = email;
//       _initialized    = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(profileInfoViewModelProvider);
//
//     // API se data aaya to fields fill karo (sirf ek baar)
//     if (profileState.profile != null) {
//       _initControllers(
//         profileState.profile!.name,
//         profileState.profile!.email,
//       );
//     }
//
//     // Success message → snackbar dikhao aur screen se wapas jao
//     ref.listen(profileInfoViewModelProvider, (_, next) {
//       if (next.successMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.successMessage!),
//             backgroundColor: kGreen,
//           ),
//         );
//         ref.read(profileInfoViewModelProvider.notifier).clearMessages();
//         Navigator.pop(context);
//       }
//       if (next.errorMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.errorMessage!),
//             backgroundColor: kRed,
//           ),
//         );
//         ref.read(profileInfoViewModelProvider.notifier).clearMessages();
//       }
//     });
//
//     return Scaffold(
//       backgroundColor: kBgCard,
//       appBar: AppBar(
//         backgroundColor: kBgCard,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: kPurpleLight, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(
//               color: kTextPrimary,
//               fontSize: 16,
//               fontWeight: FontWeight.w600),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(0.5),
//           child: Container(height: 0.5, color: kBorder),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//
//             // ── Avatar ──────────────────────────────────────────
//             Center(
//               child: Stack(
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: const LinearGradient(
//                         colors: [kPurple, Color(0xFFa855f7)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       border: Border.all(color: kBgCard, width: 3),
//                     ),
//                     child: Center(
//                       child: Text(
//                         // API se initial
//                         profileState.profile?.name.isNotEmpty == true
//                             ? profileState.profile!.name[0].toUpperCase()
//                             : '?',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 26,
//                       height: 26,
//                       decoration: BoxDecoration(
//                         color: kPurple,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: kBgCard, width: 2),
//                       ),
//                       child: const Icon(Icons.edit,
//                           color: Colors.white, size: 13),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Note: Avatar upload API nahi hai abhi — disabled
//             const Text(
//               'Change Photo',
//               style: TextStyle(color: kTextMuted, fontSize: 12),
//             ),
//             const SizedBox(height: 24),
//
//             // ── Personal Info Card ───────────────────────────────
//             _Card(
//               title: 'PERSONAL INFORMATION',
//               child: Column(
//                 children: [
//                   _LabeledField(
//                     label: 'Name',
//                     child: _StyledInput(
//                         controller: _nameCtrl, hint: 'Your name'),
//                   ),
//                   const SizedBox(height: 12),
//                   _LabeledField(
//                     label: 'Email',
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 11),
//                       decoration: BoxDecoration(
//                         color: kBgDeep,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: kBorder),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.mail_outline,
//                               color: kTextMuted, size: 15),
//                           const SizedBox(width: 8),
//                           Text(
//                             _emailCtrl.text,
//                             style: const TextStyle(
//                                 color: kTextMuted, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // ── Save Button ──────────────────────────────────────
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 // isUpdating true hote hi button disable
//                 onPressed: profileState.isUpdating
//                     ? null
//                     : () {
//                   ref
//                       .read(profileInfoViewModelProvider.notifier)
//                       .updateProfile(
//                     name: _nameCtrl.text.trim(),
//                     email: profileState.profile?.email ?? '',
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kPurple,
//                   disabledBackgroundColor: kPurple.withOpacity(0.5),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: profileState.isUpdating
//                     ? const SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//                     : const Text(
//                   'Save Profile',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Reusable sub-widgets (same as before) ─────────────────────────────
//
// class _Card extends StatelessWidget {
//   final String title;
//   final Widget child;
//   const _Card({required this.title, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: kPurpleLight,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.6)),
//           const SizedBox(height: 14),
//           child,
//         ],
//       ),
//     );
//   }
// }
//
// class _LabeledField extends StatelessWidget {
//   final String label;
//   final Widget child;
//   const _LabeledField({required this.label, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(color: kTextMuted, fontSize: 12)),
//         const SizedBox(height: 5),
//         child,
//       ],
//     );
//   }
// }
//
// class _StyledInput extends StatelessWidget {
//   final TextEditingController controller;
//   final String hint;
//   final bool obscure;
//   const _StyledInput(
//       {required this.controller, required this.hint, this.obscure = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       style: const TextStyle(color: kTextPrimary, fontSize: 13),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: kTextMuted),
//         filled: true,
//         fillColor: kBgDeep,
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: kBorder)),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: kBorder)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: kPurple)),
//       ),
//     );
//   }
// }
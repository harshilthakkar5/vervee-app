
import 'dart:io';
import 'package:dio/dio.dart';

import '../../utils/NetworkResult.dart';
import '../model/avatar/AvatarResult.dart';
import '../model/avatar/AvatarUserInfo.dart';
// import '../../data/api/AvatarApi.dart';
// import '../../domain/models/avatar/AvatarDomain.dart';
// import '../network/NetworkResult.dart'; // apna existing NetworkResult

// ══════════════════════════════════════════════════════════════════════════════
//  ABSTRACT INTERFACE  (domain/repository/AvatarRepository.dart)
// ══════════════════════════════════════════════════════════════════════════════

abstract interface class AvatarRepository {

  // Screen load pe user ki current avatar info
  Future<NetworkResult<AvatarUserInfo>> getUserInfo({
    required int userId,
  });

  // Mascot select karo (avatar image + mascotId)
  Future<NetworkResult<AvatarResult>> selectMascot({
    required int    userId,
    required String mascotId,   // e.g. "21", "22" — list index se map karo
    required File   avatarFile, // local PNG file
  });

  // Gear + custom prompt se new look generate karo
  Future<NetworkResult<AvatarResult>> customizeAvatar({
    required int          userId,
    required List<String> selectedItems,
    String                customPrompt = '',
  });
}
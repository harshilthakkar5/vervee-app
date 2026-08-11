
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/material.dart';

class UpdateService {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {

        // Agar app store ne "Immediate" update allow kiya hai
        if (updateInfo.immediateUpdateAllowed) {
          await _performImmediateUpdate(context);
        }
        // Warna Flexible update try karo
        else if (updateInfo.flexibleUpdateAllowed) {
          await _performFlexibleUpdate(context);
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  // IMMEDIATE UPDATE — Full screen, user ko force update karna padta hai
  static Future<void> _performImmediateUpdate(BuildContext context) async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('Immediate update failed: $e');
    }
  }

  // FLEXIBLE UPDATE — Background me download hota hai, phir prompt karta hai
  static Future<void> _performFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();

      // Download complete hone ke baad snackbar dikhao
      InAppUpdate.completeFlexibleUpdate().then((_) {
        // Update install ho jayega
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Update downloaded successfully'),
            action: SnackBarAction(
              label: 'Restart',
              onPressed: () => InAppUpdate.completeFlexibleUpdate(),
            ),
            duration: const Duration(days: 1), // User khud dismiss kare
          ),
        );
      }
    } catch (e) {
      debugPrint('Flexible update failed: $e');
    }
  }
}
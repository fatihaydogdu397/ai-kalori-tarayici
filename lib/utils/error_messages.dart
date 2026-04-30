import 'package:flutter/widgets.dart';
import '../generated/app_localizations.dart';
import '../services/api/api_exception.dart';

/// EAT-179: Backend `extensions.code` (49-code catalog, see
/// `eatiq_backend/docs/frontend-guide/error-codes.md`) → localized user-facing
/// string. Unknown / non-`ApiException` errors fall back to `errorGeneric`.
String localizedError(BuildContext context, Object error) {
  final l = AppLocalizations.of(context);
  if (error is! ApiException) return l.errorGeneric;
  switch (error.code) {
    // auth
    case 'auth.invalid_credentials':
      return l.errorAuthInvalidCredentials;
    case 'auth.invalid_token':
    case 'auth.token_expired':
    case 'auth.invalid_refresh_token':
    case 'auth.unauthenticated':
    case 'common.unauthorized':
    case 'UNAUTHENTICATED':
      return l.errorAuthSignInAgain;
    case 'auth.invalid_google_token':
    case 'auth.invalid_google_payload':
    case 'auth.invalid_facebook_token':
    case 'auth.invalid_apple_token':
      return l.errorAuthOauthFailed;
    case 'auth.email_already_in_use':
      return l.errorAuthEmailInUse;
    case 'auth.email_provider_conflict':
      return l.errorAuthEmailProviderConflict;
    case 'auth.invalid_otp':
    case 'auth.invalid_reset_code':
      return l.errorAuthInvalidOtp;
    case 'auth.too_many_otp_attempts':
      return l.errorAuthTooManyAttempts;
    // premium
    case 'premium.required':
    case 'premium.authentication_required':
      return l.errorPremiumRequired;
    // food
    case 'food.daily_scan_limit_reached':
      return l.errorFoodScanLimit;
    case 'food.not_found':
    case 'food.analysis_not_found':
      return l.errorFoodNotFound;
    case 'food.not_owner':
    case 'diet_plan.meal_not_owner':
      return l.errorNotOwner;
    case 'food.delete_only_today':
      return l.errorFoodDeleteOnlyToday;
    case 'food.invalid_barcode':
      return l.errorFoodInvalidBarcode;
    case 'food.macro_limit_exceeded':
      return l.errorFoodMacroLimit;
    // diet plan
    case 'diet_plan.weekly_limit_exceeded':
      return l.errorDietPlanWeeklyLimit;
    case 'diet_plan.macros_not_set':
      return l.errorDietPlanMacrosNotSet;
    case 'diet_plan.not_active':
    case 'diet_plan.day_not_found':
      return l.errorDietPlanNotActive;
    case 'diet_plan.meal_not_found':
      return l.errorDietPlanMealNotFound;
    // blood test
    case 'blood_test.invalid_file':
      return l.errorBloodTestInvalidFile;
    case 'blood_test.file_too_large':
      return l.errorBloodTestTooLarge;
    case 'blood_test.mime_mismatch':
      return l.errorBloodTestMimeMismatch;
    case 'blood_test.not_found':
      return l.errorBloodTestNotFound;
    // nutrition
    case 'nutrition.food_not_found':
      return l.errorFoodNotFound;
    case 'nutrition.no_candidates':
      return l.errorNutritionNoCandidates;
    // water / weight
    case 'water.invalid_amount':
      return l.errorWaterInvalid;
    case 'weight.invalid_amount':
      return l.errorWeightInvalid;
    // common
    case 'common.rate_limited':
    case 'RATE_LIMITED':
      return l.errorRateLimited;
    case 'common.invalid_input':
    case 'BAD_USER_INPUT':
      return l.errorInvalidInput;
    case 'NETWORK_ERROR':
      return l.errorNetwork;
    default:
      return l.errorGeneric;
  }
}


// ═════════════════════════════════════════════════════════════════════════════
//  FeedMediaConfig
//  ✅ CHANGED — Ab feed ek SINGLE fixed ratio (jaise 4:5) use nahi karta.
//  Har post apni ASLI aspect ratio (jo bhi ho — portrait, landscape, square)
//  me dikhta he, bilkul Instagram jaisa:
//    • Normal range (4:5 portrait se lekar 1.91:1 landscape tak) — as-is,
//      exact ratio, koi crop nahi.
//    • Extreme range (jaise story jaisi 9:16 ya bahut wide panorama) — us
//      range ke boundary (4:5 ya 1.91:1) tak clamp karke BoxFit.cover se
//      center-crop hota he. Isse box kabhi empty/black nahi rehta — bas
//      thoda edges se crop hota he, jo Instagram khud bhi karta he.
//
//  Yahi helper GalleryPickerScreen (crop preview), CreatePostScreen (media
//  strip / preview) aur PostCard (feed) — teeno jagah use hota he, isliye
//  jo upload ke time dikhega wahi feed me bhi dikhega (WYSIWYG) aur kabhi
//  bhi upar-neeche ya left-right black space nahi aayega.
// ═════════════════════════════════════════════════════════════════════════════

/// Sabse "lamba" (portrait) ratio jo feed allow karta he — Instagram ka
/// standard portrait cap. Isse zyada tall media is ratio tak crop hoga.
const double kFeedMinAspectRatio = 4 / 5; // 0.8

/// Sabse "chauda" (landscape) ratio jo feed allow karta he — Instagram ka
/// standard landscape cap. Isse zyada wide media is ratio tak crop hoga.
const double kFeedMaxAspectRatio = 1.91;

/// Jab tak asli media ka ratio pata na chale (loading state) tab tak
/// dikhaya jaane wala neutral placeholder ratio.
const double kFeedFallbackAspectRatio = 1.0;

// const double kVideoMinAspectRatio = 9 / 16;   // 0.5625
// const double kVideoMaxAspectRatio = 1.91;

const double kVideoMinAspectRatio = 2 / 3;   // 0.75
const double kVideoMaxAspectRatio = 1.91;

/// Kisi bhi raw aspect ratio (width / height) ko feed ke displayable range
/// (kFeedMinAspectRatio se kFeedMaxAspectRatio) ke andar clamp karta he.
/// Normal photo/video ratios (portrait phone shots, square, landscape,
/// widescreen tak) is range ke andar hi aate he — isliye unke liye ye
/// bilkul unchanged (exact) rehta he. Sirf extreme cases clamp hote he.
double clampFeedAspectRatio(double ratio) {
  if (ratio.isNaN || ratio.isInfinite || ratio <= 0) {
    return kFeedFallbackAspectRatio;
  }
  return ratio.clamp(kFeedMinAspectRatio, kFeedMaxAspectRatio);
}


// double clampFeedVideoAspectRatio(double ratio) {
//   if (ratio.isNaN || ratio.isInfinite || ratio <= 0) {
//     return kFeedFallbackAspectRatio;
//   }
//   return ratio.clamp(kVideoMinAspectRatio, kVideoMaxAspectRatio);
// }

double clampFeedVideoAspectRatio(double ratio) {
  if (ratio.isNaN || ratio.isInfinite || ratio <= 0) {
    return kFeedFallbackAspectRatio;
  }
  return ratio.clamp(kVideoMinAspectRatio, kVideoMaxAspectRatio);
}

















// /// Shared aspect-ratio rules so that GalleryPickerScreen (crop),
// /// CreatePostScreen (preview) and PostCard (feed) always agree on
// /// exactly the same height for a given image/video — no black bars,
// /// no re-cropping surprises.
// ///
// /// Mirrors Instagram's portrait/landscape clamp:
// ///   - most portrait allowed  : 4:5   (ratio 0.8)
// ///   - most landscape allowed : 1.91:1 (ratio 1.91)
// class MediaAspectUtils {
//   static const double minRatio = 0.8;  // 4:5 portrait
//   static const double maxRatio = 1.91; // landscape
//
//   /// Height for [width] given the media's natural
//   /// [naturalWidth] x [naturalHeight], clamped to the bounds above.
//   /// If the natural size isn't known yet, falls back to a square box.
//   static double clampedHeight({
//     required double width,
//     required double naturalWidth,
//     required double naturalHeight,
//   }) {
//     if (naturalWidth <= 0 || naturalHeight <= 0) {
//       return width; // square fallback until real size is known
//     }
//     final naturalH = width * naturalHeight / naturalWidth;
//     return naturalH.clamp(minHeight(width), maxHeight(width));
//   }
//
//   static double minHeight(double width) => width / maxRatio;
//   static double maxHeight(double width) => width / minRatio;
// }
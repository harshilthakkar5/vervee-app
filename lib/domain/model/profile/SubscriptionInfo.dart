
class SubscriptionInfo {
  final String status;          // "trialing" | "active" | "canceled" | "past_due"
  final DateTime? trialEnd;
  final bool cancelAtPeriodEnd;

  const SubscriptionInfo({
    required this.status,
    this.trialEnd,
    required this.cancelAtPeriodEnd,
  });

  // ── Helper getters ────────────────────────────────────────────────
  bool get isActive     => status == 'active';
  bool get isTrialing   => status == 'trialing';
  bool get isCanceled   => status == 'canceled' || cancelAtPeriodEnd;
  bool get isPastDue    => status == 'past_due';
  bool get hasNoSub     => status == 'none' || status == 'no_subscription';

  /// Human-readable status badge text
  String get statusLabel {
    if (cancelAtPeriodEnd) return 'Cancelled';
    switch (status) {
      case 'active':   return 'Active';
      case 'trialing': return 'Trial';
      case 'past_due': return 'Past Due';
      case 'canceled': return 'Cancelled';
      default:         return 'Inactive';
    }
  }
}
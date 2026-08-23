/// Neutral hook so [ApiClient] can signal subscription lock without importing auth.
void Function()? onSubscriptionLockDetected;

void notifySubscriptionLockDetected() {
  onSubscriptionLockDetected?.call();
}

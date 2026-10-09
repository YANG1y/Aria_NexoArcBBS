import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'accounts_notifier_provider.dart';
import 'timeline_tabs_notifier_provider.dart';
import 'tokens_notifier_provider.dart';

part 'boot_state_provider.g.dart';

@riverpod
class BootState extends _$BootState {
  @override
  FutureOr<bool?> build() {
    return null;
  }

  Future<void> boot() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.wait(
        ref
            .read(accountsNotifierProvider)
            .map(
              (account) =>
                  ref.read(tokensNotifierProvider.notifier).load(account),
            ),
      );
      final accounts = ref.read(accountsNotifierProvider);
      final tokens = ref.read(tokensNotifierProvider);
      final account = accounts.where(tokens.containsKey).firstOrNull;
      if (account == null) {
        return false;
      }
      await ref
          .read(timelineTabsNotifierProvider.notifier)
          .ensureDefaultGlobalTab(account);
      return true;
    });
  }
}

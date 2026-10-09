import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart' hide launchUrl;

import '../../constant/app_server.dart';
import '../../constant/max_content_width.dart';
import '../../i18n/strings.g.dart';
import '../../provider/miauth_notifier_provider.dart';
import '../../util/future_with_dialog.dart';
import '../../util/launch_url.dart';
import '../widget/misskey_server_background.dart';

class const LoginPage({super.key, final String? query})
    extends HookConsumerWidget {
  Future<void> _launchMiAuth(WidgetRef ref) async {
    final serverUrl = Uri.parse(appServerUrl);

    if (!ref.context.mounted) return;
    final url = ref
        .read(miAuthNotifierProvider.notifier)
        .buildMiAuthUrl(serverUrl);
    unawaited(
      launchUrl(
        ref,
        url,
        mode: switch (defaultTargetPlatform) {
          TargetPlatform.iOS => LaunchMode.inAppWebView,
          _ => null,
        },
      ),
    );
    unawaited(ref.context.push('/login/authenticate'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: appServerHost);

    return Scaffold(
      body: MisskeyServerBackground(
        controller: controller,
        child: Column(
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: AppBar(
                  title: Text(t.misskey.login),
                  actions: [
                    PopupMenuButton<void>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () =>
                              context.push('/login/token?query=$appServerHost'),
                          child: Text(t.aria.loginWithAccessToken),
                        ),
                      ],
                    ),
                  ],
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: maxContentWidth,
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox.square(
                            dimension: 64.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xffdddddd),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(Icons.forum, size: 32.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'NexoArcBBS',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            onPressed: () =>
                                futureWithDialog(context, _launchMiAuth(ref)),
                            icon: const Icon(Icons.open_in_browser),
                            label: Text(t.aria.authenticate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

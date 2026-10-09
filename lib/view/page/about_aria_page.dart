import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constant/max_content_width.dart';
import '../../gen/assets.gen.dart';
import '../../i18n/strings.g.dart';
import '../../provider/misskey_colors_provider.dart';
import '../../util/copy_text.dart';
import '../../util/future_with_dialog.dart';
import '../../util/launch_url.dart';
import '../widget/url_sheet.dart';

class const AboutAriaPage({super.key}) extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = useMemoized(PackageInfo.fromPlatform);
    final (version, buildNumber) = switch (useFuture(packageInfo).data) {
      PackageInfo(:final version, :final buildNumber) => (
        version,
        defaultTargetPlatform == TargetPlatform.android && kReleaseMode
            ? buildNumber.substring(0, buildNumber.length - 1)
            : buildNumber,
      ),
      _ => (null, null),
    };
    final deviceInfo = useMemoized(() => DeviceInfoPlugin().deviceInfo);
    final scrollController = useScrollController();
    final colors = ref.watch(
      misskeyColorsProvider(Theme.of(context).brightness),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('关于NexoArcBBS')),
      body: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: maxContentWidth,
              child: Card.filled(
                color: colors.panel,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Assets.icons.aria.image(
                          width: 80.0,
                          height: 80.0,
                        ),
                      ),
                    ),
                    const Text('NexoArcBBS'),
                    if (version != null && buildNumber != null)
                      Text(
                        '$version+$buildNumber',
                        style: TextStyle(
                          color: colors.fg.withValues(alpha: 0.7),
                        ),
                      ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: maxContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text('NexoArcBBS是基于Aria的二次开发项目。'),
            ),
          ),
          const Divider(),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: maxContentWidth,
              child: ListTile(
                leading: const Icon(Icons.code),
                title: Text(t.misskey.aboutMisskey_.source),
                onTap: () => launchUrl(
                  ref,
                  Uri.parse('https://github.com/YANG1y/Aria_NexoArcBBS'),
                ),
                onLongPress: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => const UrlSheet(
                    url: 'https://github.com/YANG1y/Aria_NexoArcBBS',
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: maxContentWidth,
              child: ListTile(
                leading: const Icon(Icons.alternate_email),
                title: Text(t.misskey.contact),
                onTap: () => launchUrl(ref, Uri.parse('https://home.ccoz.top')),
                onLongPress: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (context) =>
                      const UrlSheet(url: 'https://home.ccoz.top'),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: maxContentWidth,
              child: ListTile(
                leading: const Icon(Icons.list),
                title: Text(t.misskey.license),
                onTap: () async {
                  final version = (await packageInfo).version;
                  if (!context.mounted) return;
                  showLicensePage(
                    context: context,
                    applicationVersion: version,
                    applicationIcon: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Assets.icons.aria.image(width: 80.0, height: 80.0),
                    ),
                    applicationLegalese: 'Licensed under AGPL v3',
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: maxContentWidth,
              child: ListTile(
                leading: const Icon(Icons.devices),
                title: Text(t.aria.clientInfo),
                onTap: () async {
                  final result = await futureWithDialog(
                    context,
                    (deviceInfo, packageInfo).wait,
                  );
                  if (!context.mounted) return;
                  if (result != null) {
                    final deviceInfo = switch (result.$1) {
                      AndroidDeviceInfo(:final model, :final version) =>
                        '$model (Android ${version.release})',
                      IosDeviceInfo(
                        :final modelName,
                        :final systemName,
                        :final systemVersion,
                      ) =>
                        '$modelName ($systemName $systemVersion)',
                      LinuxDeviceInfo(:final prettyName) => prettyName,
                      MacOsDeviceInfo(:final modelName, :final osRelease) =>
                        '$modelName (macOS $osRelease)',
                      WindowsDeviceInfo(:final productName) => productName,
                      _ => '',
                    };
                    final packageInfo = [
                      version,
                      '+',
                      buildNumber,
                      if (result.$2.installerStore case final store?)
                        ' ($store)',
                    ].join();
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(t.aria.clientInfo),
                        content: SizedBox(
                          width: maxContentWidth,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: Text(t.aria.device),
                                subtitle: Text(deviceInfo),
                              ),
                              ListTile(
                                title: const Text('NexoArcBBS'),
                                subtitle: Text(packageInfo),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => copyToClipboard(
                              context,
                              'Device: $deviceInfo\nNexoArcBBS: $packageInfo',
                            ),
                            child: Text(t.misskey.copy),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

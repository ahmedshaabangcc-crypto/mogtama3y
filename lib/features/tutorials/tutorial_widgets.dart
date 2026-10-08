import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/tutorials/tutorial_service.dart';
import '../../core/tutorials/youtube_embed.dart';

/// Plays a tutorial Short: in-app 9:16 iframe on the web, the YouTube
/// app/site elsewhere.
Future<void> showTutorialPlayer(BuildContext context, TutorialVideo video) async {
  if (!youtubeEmbedSupported) {
    await launchUrl(Uri.parse(youtubeWatchUrl(video.youtubeId)), mode: LaunchMode.externalApplication);
    return;
  }
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black,
    builder: (_) => _TutorialPlayerDialog(video: video),
  );
}

class _TutorialPlayerDialog extends StatelessWidget {
  const _TutorialPlayerDialog({required this.video});
  final TutorialVideo video;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(children: [
          // Kept above the video (not on top of it): the iframe would
          // swallow taps over its area.
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(children: [
              Expanded(
                child: Text(video.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              IconButton(
                tooltip: 'إغلاق',
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ]),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              // The largest portrait 9:16 box that fits.
              final h = math.min(c.maxHeight, c.maxWidth * 16 / 9);
              final w = h * 9 / 16;
              return Center(
                child: SizedBox(
                  width: w,
                  height: h,
                  child: ClipRRect(borderRadius: BorderRadius.circular(12), child: youtubeEmbed(video.youtubeId)),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

/// «▶ شوف الشرح» for one screen. Renders nothing unless this app has an
/// active video with [screenKey].
class TutorialButton extends StatelessWidget {
  const TutorialButton({super.key, required this.screenKey});
  final String screenKey;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TutorialVideo?>(
      future: TutorialService.forScreen(screenKey),
      builder: (context, snap) {
        final video = snap.data;
        if (video == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 6),
          child: Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              onPressed: () => showTutorialPlayer(context, video),
              icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
              label: const Text('شوف الشرح'),
            ),
          ),
        );
      },
    );
  }
}

/// «فيديوهات الشرح» for the more/menu screens: this app's active videos
/// as a horizontal strip. Hidden entirely when there are none.
class TutorialVideosSection extends StatelessWidget {
  const TutorialVideosSection({super.key, this.padding = const EdgeInsets.only(top: 18)});
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TutorialVideo>>(
      future: TutorialService.activeForApp(),
      builder: (context, snap) {
        final videos = snap.data ?? const <TutorialVideo>[];
        if (videos.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: padding,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('فيديوهات الشرح', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.inkSecondary)),
            ),
            SizedBox(
              height: 152,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) => TutorialVideoCard(video: videos[i]),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class TutorialVideoCard extends StatelessWidget {
  const TutorialVideoCard({super.key, required this.video, this.width = 150});
  final TutorialVideo video;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        child: InkWell(
          onTap: () => showTutorialPlayer(context, video),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AspectRatio(aspectRatio: 16 / 10, child: TutorialThumbnail(youtubeId: video.youtubeId)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3)),
            ),
          ]),
        ),
      ),
    );
  }
}

/// YouTube's thumbnail with a play badge.
class TutorialThumbnail extends StatelessWidget {
  const TutorialThumbnail({super.key, required this.youtubeId});
  final String youtubeId;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      ColoredBox(
        color: Colors.black,
        child: Image.network(
          youtubeThumbnail(youtubeId),
          fit: BoxFit.cover,
          cacheWidth: 480,
          webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
          errorBuilder: (_, _, _) => const Center(child: Icon(Icons.ondemand_video_rounded, color: Colors.white54)),
        ),
      ),
      const Center(child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 36, shadows: [Shadow(blurRadius: 8)])),
    ]);
  }
}

/// Full list of this app's videos (used where there is no more-menu
/// list to host the section, e.g. the tajer account menu).
class TutorialVideosScreen extends StatelessWidget {
  const TutorialVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('فيديوهات الشرح')),
      body: FutureBuilder<List<TutorialVideo>>(
        future: TutorialService.activeForApp(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          final videos = snap.data ?? const <TutorialVideo>[];
          if (videos.isEmpty) {
            return const Center(child: Text('مفيش فيديوهات شرح لسه', style: TextStyle(color: AppColors.inkMuted)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 220, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.95),
            itemCount: videos.length,
            itemBuilder: (_, i) => TutorialVideoCard(video: videos[i], width: double.infinity),
          );
        },
      ),
    );
  }
}

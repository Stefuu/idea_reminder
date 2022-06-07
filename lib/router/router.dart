import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/video_gallery/views/video_player.dart';
import '../features/video_recording/views/videos_recording.dart';

class Router {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const CustomVideoPlayer(),
      ),
      GoRoute(
        path: '/record',
        builder: (BuildContext context, GoRouterState state) =>
            const VideoRecording(),
      ),
      GoRoute(
        path: '/play',
        builder: (BuildContext context, GoRouterState state) =>
            const CustomVideoPlayer(),
      ),
    ],
  );
}

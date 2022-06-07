import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/video_recording/views/videos_recording.dart';
import '../features/videos_listing/views/videos_listing.dart';

class Router {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const VideoRecording(),
      ),
      GoRoute(
        path: '/record',
        builder: (BuildContext context, GoRouterState state) =>
            const VideoRecording(),
      ),
    ],
  );
}

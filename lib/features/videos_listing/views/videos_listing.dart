import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_reminder/controllers/application_controller/application_controller_bloc.dart';

import '../../../controllers/application_controller/application_controller_events.dart';
import '../../../controllers/application_controller/application_controller_state.dart';
import '../../../shared/components/navigation_bar.dart';
import '../components/video_player.dart';

class VideosListing extends StatefulWidget {
  const VideosListing({Key? key}) : super(key: key);

  @override
  State<VideosListing> createState() => _VideosListingState();
}

class _VideosListingState extends State<VideosListing> {
  late ApplicationControllerBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<ApplicationControllerBloc>();
    _bloc.add(ApplicationControllerEventsLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idea reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Idea reminder'),
          ),
        ),
        body:
            BlocBuilder<ApplicationControllerBloc, ApplicationControllerState>(
          builder: (context, state) {
            print('state');
            print(state);
            if (state is ApplicationControllerStateLoaded &&
                state.videoPathList.isNotEmpty) {
              return ListView.builder(
                itemCount: state.videoPathList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      _bloc.add(
                        ApplicationControllerEventsRemoveVideo(index),
                      );
                    },
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Tap the image to play the video'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Idea #${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomVideoPlayer(
                            videoPath: state.videoPathList[index],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text(
                  'You don\'t have any ideas yet, try recording one.');
            }
          },
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

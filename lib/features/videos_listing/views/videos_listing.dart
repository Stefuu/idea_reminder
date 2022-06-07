import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../video_gallery/views/video_player.dart';
import '../../video_recording/bloc/video_recording_bloc.dart';
import '../../video_recording/bloc/video_recording_state.dart';
import '../bloc/idea_reminder_bloc.dart';
import '../bloc/idea_reminder_events.dart';
import '../bloc/idea_reminder_state.dart';

class VideosListing extends StatefulWidget {
  const VideosListing({Key? key}) : super(key: key);

  @override
  State<VideosListing> createState() => _VideosListingState();
}

class _VideosListingState extends State<VideosListing> {
  late IdeaReminderBloc _bloc;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _bloc = context.read<IdeaReminderBloc>();
    _bloc.add(IdeaReminderEventsLoad());
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
        body: BlocBuilder<IdeaReminderBloc, IdeaReminderState>(
          builder: (context, state) {
            if (state is IdeaReminderStateLoaded &&
                state.videoPathList.isNotEmpty) {
              return ListView.builder(
                itemCount: state.videoPathList.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
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
                    );
                  }
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          'Idea #${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomVideoPlayer(
                          videoPath: state.videoPathList[index],
                        ),
                      ],
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Home',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Record',
              backgroundColor: Colors.blueGrey,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/record');
                break;
              default:
                context.go('/');
            }

            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/app/localization/resources.dart';
import 'package:movies_app/presentation/home/presentation/manager/home_bloc.dart';
import 'package:movies_app/presentation/home/presentation/screens/movie_details.dart';

import '../../actions/presentation/actions_page.dart';
import '../../home/presentation/screens/movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context)
        .add(SearchMoviesEvent(keyword: "batman"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Resources.of(context)
            .getResource("presentation.home.moviesHeader")),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    const ActionsPage(action: ActionName.settings),
              ),
            ),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ShowMovieDetails) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetails(
                  movie: state.movie,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onBackground,
            ));
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        BlocProvider.of<HomeBloc>(context)
                            .add(SearchMoviesEvent(keyword: value));
                        _controller.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: Resources.of(context)
                          .getResource("presentation.home.moviesSearch"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Expanded(child: MovieList())
              ],
            ),
          );
        },
      ),
    );
  }
}

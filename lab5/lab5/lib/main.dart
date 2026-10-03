import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

// =====================
// MOVIE MODEL
// =====================

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

class Trailer {
  final String title;
  final String duration;

  Trailer({
    required this.title,
    required this.duration,
  });
}

// =====================
// SAMPLE DATA
// =====================

final List<Movie> movies = [
  Movie(
    id: 1,
    title: 'Inception',
    posterUrl: 'https://picsum.photos/600/900?random=1',
    overview:
        'A skilled thief who steals secrets through dream-sharing technology is given a chance to erase his past by performing an impossible mission.',
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    rating: 8.8,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:30',
      ),
      Trailer(
        title: 'Final Trailer',
        duration: '1:45',
      ),
    ],
  ),
  Movie(
    id: 2,
    title: 'Interstellar',
    posterUrl: 'https://picsum.photos/600/900?random=2',
    overview:
        'A group of explorers travel through a wormhole in space in an attempt to ensure humanity has a future.',
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    rating: 8.7,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:40',
      ),
      Trailer(
        title: 'IMAX Trailer',
        duration: '2:10',
      ),
    ],
  ),
  Movie(
    id: 3,
    title: 'The Dark Knight',
    posterUrl: 'https://picsum.photos/600/900?random=3',
    overview:
        'Batman faces a dangerous criminal mastermind who creates chaos throughout Gotham City.',
    genres: ['Action', 'Crime', 'Drama'],
    rating: 9.0,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:25',
      ),
      Trailer(
        title: 'Final Trailer',
        duration: '2:00',
      ),
    ],
  ),
];

// =====================
// APP
// =====================

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// =====================
// HOME SCREEN
// =====================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MovieDetailScreen(movie: movie);
                    },
                  ),
                );
              },
              child: SizedBox(
                height: 180,
                child: Row(
                  children: [
                    Hero(
                      tag: 'movie-${movie.id}',
                      child: Image.network(
                        movie.posterUrl,
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.movie,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  movie.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 5,
                              children: movie.genres
                                  .take(2)
                                  .map(
                                    (genre) => Chip(
                                      label: Text(genre),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================
// DETAIL SCREEN
// =====================

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() =>
      _MovieDetailScreenState();
}

class _MovieDetailScreenState
    extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // HERO BANNER
            SizedBox(
              height: 360,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'movie-${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TITLE + RATING
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    movie.rating.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // GENRES
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: movie.genres
                    .map(
                      (genre) => Chip(
                        label: Text(genre),
                      ),
                    )
                    .toList(),
              ),
            ),

            // OVERVIEW
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : null,
                  ),
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Rating selected',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star),
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Share selected',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),

            // TRAILERS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trailers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      final trailer =
                          movie.trailers[index];

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.play_arrow,
                            ),
                          ),
                          title: Text(trailer.title),
                          subtitle:
                              Text(trailer.duration),
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Playing ${trailer.title}',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
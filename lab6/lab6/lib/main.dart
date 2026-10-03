import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// =====================
// MOVIE MODEL
// =====================

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// =====================
// SAMPLE MOVIES
// =====================

const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl:
        'https://picsum.photos/500/700?random=10',
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl:
        'https://picsum.photos/500/700?random=11',
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl:
        'https://picsum.photos/500/700?random=12',
    rating: 9.0,
  ),
  Movie(
    title: 'Avengers',
    year: 2012,
    genres: ['Action', 'Adventure'],
    posterUrl:
        'https://picsum.photos/500/700?random=13',
    rating: 8.0,
  ),
  Movie(
    title: 'Toy Story',
    year: 1995,
    genres: ['Comedy', 'Adventure'],
    posterUrl:
        'https://picsum.photos/500/700?random=14',
    rating: 8.3,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl:
        'https://picsum.photos/500/700?random=15',
    rating: 7.7,
  ),
];

// =====================
// APP
// =====================

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find a Movie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

// =====================
// GENRE SCREEN
// =====================

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() =>
      _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Adventure',
    'Sci-Fi',
    'Thriller',
    'Crime',
  ];

  final Set<String> selectedGenres = {};

  String selectedSort = 'A-Z';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =====================
  // FILTER + SORT
  // =====================

  List<Movie> get visibleMovies {
    List<Movie> result = allMovies.where((movie) {
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any(
            (genre) => selectedGenres.contains(genre),
          );

      return matchesSearch && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        result.sort(
          (a, b) => a.title.compareTo(b.title),
        );
        break;

      case 'Z-A':
        result.sort(
          (a, b) => b.title.compareTo(a.title),
        );
        break;

      case 'Year':
        result.sort(
          (a, b) => b.year.compareTo(a.year),
        );
        break;

      case 'Rating':
        result.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
        break;
    }

    return result;
  }

  // =====================
  // CLEAR FILTER
  // =====================

  void clearFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Browser'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: clearFilters,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear filters',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Find a Movie',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // =====================
              // SEARCH BAR
              // =====================

              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search movie...',
                  prefixIcon:
                      const Icon(Icons.search),
                  suffixIcon:
                      searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                  searchController.clear();
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =====================
              // GENRES
              // =====================

              const Text(
                'Genres',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((genre) {
                  final isSelected =
                      selectedGenres.contains(genre);

                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // =====================
              // SORT
              // =====================

              Row(
                children: [
                  const Text(
                    'Sort:',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: 'A-Z',
                        child: Text('A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'Z-A',
                        child: Text('Z-A'),
                      ),
                      DropdownMenuItem(
                        value: 'Year',
                        child: Text('Year'),
                      ),
                      DropdownMenuItem(
                        value: 'Rating',
                        child: Text('Rating'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                  const Spacer(),
                  Text(
                    '${visibleMovies.length} movies',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // =====================
              // RESPONSIVE MOVIE LIST
              // =====================

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: visibleMovies[index],
                          );
                        },
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.3,
                      children: visibleMovies
                          .map(
                            (movie) => MovieCard(
                              movie: movie,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// MOVIE CARD
// =====================

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth =
              constraints.maxWidth < 350
                  ? 90.0
                  : 120.0;

          return Row(
            children: [
              Image.network(
                movie.posterUrl,
                width: posterWidth,
                height: 170,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    width: posterWidth,
                    height: 170,
                    color: Colors.grey,
                    child: const Icon(
                      Icons.movie,
                      size: 45,
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Year: ${movie.year}',
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: movie.genres
                            .take(2)
                            .map(
                              (genre) => Chip(
                                label: Text(
                                  genre,
                                ),
                                visualDensity:
                                    VisualDensity
                                        .compact,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
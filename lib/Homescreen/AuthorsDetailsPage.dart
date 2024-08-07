import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthorsDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> authors;

  AuthorsDetailsPage({required this.authors});

  @override
  _AuthorsDetailsPageState createState() => _AuthorsDetailsPageState();
}

class _AuthorsDetailsPageState extends State<AuthorsDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState(); // Call the super class's initState

    // Initialize the AnimationController and the SlideTransition
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addStatusListener((status) {
        print('Animation Status: $status');
      });

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Slide from bottom
      end: Offset(0, 0), // To the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the AnimationController to free resources
    super.dispose(); // Call the super class's dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Authors Details',
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 18)),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemCount: widget.authors
                .length, // Use widget.authors to access the authors list
            itemBuilder: (context, index) {
              final author = widget.authors[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(author['image']!),
                      ),
                    ),
                    SizedBox(height: 8),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          author['authorName']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ReadNow extends StatelessWidget {
  final Map<String, dynamic> book;

  ReadNow({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 174, 128, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text("Continue Reading"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover (Centered with Margin)
              SizedBox(
                height: 300, // Adjust height as needed
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Hero(
                      tag: book['title'],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          book['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Book Title (Centered)
              Center(
                child: Text(
                  book['title'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Book Author (Centered)
              Center(
                child: Text(
                  'by ${book['author']}',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 16),

              // Chapter (Centered)
              Center(
                child: Text(
                  'Chapter 1',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 20),

              // Text Excerpt (Scrollable)
              Container(
                child: Text(
                  'The two hide behind a shower wall while gunfire rings out around them. They overhear three sicarios looking for a man and a child (Sebastián and Luca). One of the killers takes a picture of a dead thinking hola it is Luca, but it is his nine-year-old cousin, Adrián. The three men search the house. Lydia notices a drop of Luca\'s blood on the three\nThe two hide behind a shower wall while gunfire rings out around them. They overhear three sicarios looking for a man and a child (Sebastián and Luca). One of the killers takes a picture of a dead thinking hola it is Luca, but it is his nine-year-old cousin, Adrián. The three men search the house. Lydia notices a drop of Luca\'s blood on the thre ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

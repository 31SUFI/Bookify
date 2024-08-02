import 'package:flutter/material.dart';
import 'package:bookify/Homescreen/BookDetails.dart'; // Assuming BookDetailsScreen is imported correctly
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  DetailPage({required this.title, required this.items});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<Map<String, dynamic>> filteredItems;
  String searchQuery = '';
  bool showFreeBooksOnly = false;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      filteredItems = widget.items.where((value) {
        final bookName =
            value['bookName']?.toLowerCase() ?? ''; // handle null book names
        final matchesQuery = bookName.contains(searchQuery);

        if (showFreeBooksOnly) {
          return matchesQuery && value['Price'] == 'Free';
        } else {
          return matchesQuery;
        }
      }).toList();
    });
  }

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Show Free Books Only'),
                trailing: Checkbox(
                  value: showFreeBooksOnly,
                  onChanged: (value) {
                    setState(() {
                      showFreeBooksOnly = value ?? false;
                      applyFilters();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Show All Books'),
                onTap: () {
                  setState(() {
                    showFreeBooksOnly = false;
                    applyFilters();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        ),
        //backgroundColor: const Color.fromARGB(255, 174, 128, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            SearchBar(
              onSearch: updateSearchQuery,
              onFilter: showFilterSheet,
            ),
            SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(
                            book: item,
                          ),
                        ),
                      );
                      print('Tapped on item: ${item['bookName']}');
                      print('PdfUrl is: ${item['pdfUrl']}');
                    },
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag:
                                  'bookImage$index', // Unique tag for each hero widget
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(item['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['bookName'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.containsKey('author'))
                                  Text(
                                    item['author']!,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback onFilter;

  SearchBar({required this.onSearch, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Find Books',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15.0), // Adjusted padding
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(Icons.tune, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

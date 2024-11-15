import 'dart:async'; // For debounce
import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/screens/profile/designer_profile.dart';
import 'package:stylesyncapp/services/search_services.dart';
import 'package:stylesyncapp/widgets/designer_card.dart';

class SearchDesignerScreen extends StatefulWidget {
  const SearchDesignerScreen({super.key});

  @override
  State<SearchDesignerScreen> createState() => _SearchDesignerScreenState();
}

class _SearchDesignerScreenState extends State<SearchDesignerScreen> {
  List<Designer>? designersList;
  final SearchServices searchServices = SearchServices();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel(); // Cancel debounce timer
    super.dispose();
  }

  void fetchDesigners(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        designersList = null;
      });
      return;
    }

    designersList = await searchServices.fetchDesigners(
      context: context,
      searchQuery: searchQuery,
    );
    setState(() {});
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchDesigners(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: Material(
                  borderRadius: BorderRadius.circular(7),
                  elevation: 1,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.black),
                              onPressed: () {
                                searchController.clear();
                                fetchDesigners('');
                              },
                            )
                          : null,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.only(top: 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1,
                        ),
                      ),
                      hintText: 'Search Designers',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: designersList == null
          ? const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Search StyleSync to know more",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "about your favourite Designers",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : designersList!.isEmpty
              ? const Center(
                  child: Text(
                    "No Designers Found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: designersList!.length,
                  itemBuilder: (context, index) {
                    final designerData = designersList![index];
                    return DesignerCard(
                      designerData: designerData.toMap(),
                      onTap: () {
                        final designer = Designer.fromMap(designerData.toMap());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DesignerProfileScreen(designer: designer),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

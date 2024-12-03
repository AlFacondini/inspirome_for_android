import 'package:flutter/material.dart';
import 'package:inspirome_for_android/pages/favourites_page.dart';
import 'package:inspirome_for_android/pages/search_by_tag_page.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Building $this.");

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            child: Text("Navigation"),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text("Homepage"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Favourites"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FavouritesPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Search by Tag"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SearchByTagPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

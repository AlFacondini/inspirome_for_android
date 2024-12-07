import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class SearchByTagPage extends ConsumerStatefulWidget {
  const SearchByTagPage({super.key});

  @override
  ConsumerState<SearchByTagPage> createState() => _SearchByTagPageState();
}

class _SearchByTagPageState extends ConsumerState<SearchByTagPage> {
  TextEditingController? _tagSelectorCtrl;
  String? selectedTag;

  @override
  void initState() {
    super.initState();

    _tagSelectorCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _tagSelectorCtrl!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building $this.");

    final imageListCount = ref.watch(imagesWithTagCountProvider(selectedTag));

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? buildPortrait(context, ref, imageListCount)
            : buildLandscape(context, ref, imageListCount);
      },
    );
  }

  Widget buildPortrait(
      BuildContext context, WidgetRef ref, int imageListCount) {
    debugPrint("Building as portrait.");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Search by Tag"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            DropdownMenu(
              controller: _tagSelectorCtrl,
              requestFocusOnTap: true,
              enableFilter: false,
              expandedInsets: EdgeInsets.zero,
              label: const Text("Choose a tag:"),
              onSelected: (String? value) {
                setState(() {
                  selectedTag = value;
                });
              },
              dropdownMenuEntries: ref.watch(tagsListProvider).map(
                (e) {
                  return DropdownMenuEntry(
                    value: e,
                    label: e,
                  );
                },
              ).toList(),
            ),
            SizedBox.fromSize(
              size: const Size(double.infinity, 8),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: imageListCount,
                itemBuilder: (context, index) {
                  if (selectedTag != null) {
                    return InspiringImageViewer(
                        ref
                            .watch(specificImageWithTagProvider(
                                (index: index, tag: selectedTag!)))
                            ?.guid,
                        true);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLandscape(
      BuildContext context, WidgetRef ref, int imageListCount) {
    debugPrint("Building as landscape.");

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: false,
                      ),
                      SliverList.builder(
                        itemCount: ref.watch(tagsListProvider).length,
                        itemBuilder: (context, index) {
                          final tag = ref.watch(tagsListProvider)[index];
                          return ElevatedButton(
                            style: selectedTag != tag
                                ? ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    elevation: 0)
                                : ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onInverseSurface,
                                    elevation: 0),
                            onPressed: () {
                              _tagSelectorCtrl!.text = tag;
                              setState(() {
                                selectedTag = tag;
                              });
                            },
                            child: Text(tag),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: double.infinity,
                  width: 8,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                    itemCount: imageListCount,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (selectedTag != null) {
                        return InspiringImageViewer(
                            ref
                                .watch(specificImageWithTagProvider(
                                    (index: index, tag: selectedTag!)))
                                ?.guid,
                            true);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Builder(builder: (context) {
                return _backFloatingActionButton(context)!;
              }),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton? _backFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      tooltip: 'Go to previous screen',
      heroTag: "backButton",
      child: const Icon(Icons.arrow_back),
    );
  }
}

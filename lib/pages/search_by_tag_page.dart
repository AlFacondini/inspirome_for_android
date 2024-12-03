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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagsTextfield extends ConsumerStatefulWidget {
  final String? _selectedGuid;

  const TagsTextfield(this._selectedGuid, {super.key});

  @override
  ConsumerState<TagsTextfield> createState() => _TagsTextfieldState();
}

class _TagsTextfieldState extends ConsumerState<TagsTextfield> {
  late double _distanceToField;
  late StringTagController _stringTagController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    _stringTagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building $this.");

    if (widget._selectedGuid == null) {
      throw Exception("Passed wrong guid to TagsTextfield.");
    }
    final initialTags = ref.read(
      inspiringImageWithGuidProvider(widget._selectedGuid!).select(
        (value) {
          return value?.tags.toList();
        },
      ),
    );

    return TextFieldTags<String>(
      textfieldTagsController: _stringTagController,
      initialTags: initialTags ?? [],
      textSeparators: const [','],
      validator: (tag) {
        if (tag.isEmpty) {
          return 'Empty tag not allowed.';
        } else if (tag.length > 15) {
          return 'Tag too long.';
        } else if (_stringTagController.getTags!.contains(tag)) {
          return 'Tag already entered.';
        } else if (tag.contains(' ')) {
          return 'Spaces are not allowed.';
        }
        return null;
      },
      inputFieldBuilder: (context, textFieldTagValues) {
        return TextField(
          onTap: () {
            _stringTagController.getFocusNode?.requestFocus();
          },
          controller: textFieldTagValues.textEditingController,
          focusNode: textFieldTagValues.focusNode,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1.0,
              ),
            ),
            hintText: textFieldTagValues.tags.isNotEmpty ? '' : "Enter tags...",
            errorText: textFieldTagValues.error,
            prefixIconConstraints:
                BoxConstraints(maxWidth: _distanceToField * 0.8),
            prefixIcon: textFieldTagValues.tags.isNotEmpty
                ? SingleChildScrollView(
                    controller: textFieldTagValues.tagScrollController,
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 8,
                      ),
                      child: Wrap(
                        runSpacing: 4.0,
                        spacing: 4.0,
                        children: textFieldTagValues.tags.map(
                          (String tag) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                    onTap: () {
                                      // Maybe adding tag page in the future.
                                    },
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: Icon(
                                      Icons.cancel,
                                      size: 16.0,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    onTap: () {
                                      textFieldTagValues.onTagRemoved(tag);
                                      if (widget._selectedGuid != null) {
                                        ref
                                            .read(inspiringImageListProvider
                                                .notifier)
                                            .replaceTags(widget._selectedGuid!,
                                                textFieldTagValues.tags);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  )
                : null,
          ),
          onChanged: textFieldTagValues.onTagChanged,
          onSubmitted: (value) {
            textFieldTagValues.onTagSubmitted(value);
            if (widget._selectedGuid != null) {
              ref
                  .read(inspiringImageListProvider.notifier)
                  .replaceTags(widget._selectedGuid!, textFieldTagValues.tags);
            }
          },
        );
      },
    );
  }
}

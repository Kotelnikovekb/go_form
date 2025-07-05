import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:image_picker/image_picker.dart';

String formatFileSize(int bytes) {
  const suffixes = ['Б', 'КБ', 'МБ', 'ГБ', 'ТБ'];
  double size = bytes.toDouble();
  int i = 0;

  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }

  return '${size.toStringAsFixed(1)} ${suffixes[i]}';
}

class GoFormFiles extends FormFieldModelBase<List<File>> {
  GoFormFiles({
    required super.name,
    super.initialValue = const [],
    super.validator,
  });

  @override
  Widget build(BuildContext context, FieldController<List<File>> controller) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Выбрать фото'),
                          onTap: () async {
                            Navigator.of(context).pop();
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            print(pickedFile!=null);
                            if (pickedFile != null) {
                              final image = File(pickedFile.path);
                              controller.onChange([...controller.value ?? [], image]);
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.cancel),
                          title: Text('Отмена'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text('Выбрать фото'),
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            final item = controller.value?[index];
            final file = item!;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.file(file),
              title: Text(file.path.split('/').last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(formatFileSize(file.lengthSync())),
              trailing: IconButton(
                onPressed: () {
                  controller.onChange(List.from(controller.value ?? [])..remove(item));
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
          shrinkWrap: true,
          itemCount: controller.value?.length ?? 0,
        ),
        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(color: Colors.red),
          )
      ],
    );
  }
}
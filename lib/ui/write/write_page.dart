import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerWidget {
  WritePage(this.post, {Key? key}) : super(key: key);

  final Post? post;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(writeViewModelProvider(post).notifier);
    final state = ref.watch(writeViewModelProvider(post));

    return Scaffold(
      appBar: AppBar(title: Text('게시글 작성')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
              onChanged: (value) => viewModel.updateTitle(value),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: 5,
              onChanged: (value) => viewModel.updateContent(value),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await viewModel.uploadImage(image);
                }
              },
              child: Text('사진 선택'),
            ),
            if (state.imageUrl != null)
              Image.network(state.imageUrl!, height: 100, width: 100),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: state.isWriting
                  ? null
                  : () async {
                      final result = await viewModel.insert(writer: '작성자');
                      if (result && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}

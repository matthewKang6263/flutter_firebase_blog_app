import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerWidget {
  final Post? post;

  WritePage(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(writeViewModelProvider(post));

    return Scaffold(
      appBar: AppBar(title: Text('게시글 작성')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 제목 입력 필드
            TextField(onChanged:(value) => viewModel.title = value),
            SizedBox(height: 10),
            // 내용 입력 필드
            TextField(onChanged:(value) => viewModel.content = value),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed() async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await viewModel.uploadImage(image);
                }
              },
              child: Text('사진 선택'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed() async {
                final result = await viewModel.insert(writer:'작성자');
                if (result) {
                  Navigator.pop(context); // 성공적으로 등록 후 돌아가기
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
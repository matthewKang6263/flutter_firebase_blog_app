import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/detail/detail_view_model.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  DetailPage(this.post, {Key? key}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DetailViewModel의 상태를 관찰합니다.
    final state = ref.watch(detailViewModelProvider(post));

    return Scaffold(
      appBar: AppBar(actions: [
        iconButton(Icons.delete, () async {
          // 게시물 삭제 기능
          final vm = ref.read(detailViewModelProvider(post).notifier);
          final result = await vm.deletePost();
          if (context.mounted && result) {
            Navigator.pop(context);
          }
        }),
        iconButton(Icons.edit, () {
          // 게시물 수정 페이지로 이동
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WritePage(post);
          }));
        }),
      ]),
      body: ListView(
        padding: EdgeInsets.only(bottom: 500),
        children: [
          Image.network(
            state.imageUrl,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 14),
                Text(state.writer),
                Text(
                  state.createdAt.toIso8601String(),
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  state.content,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 아이콘 버튼 위젯
  Widget iconButton(IconData icon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
        child: Icon(icon),
      ),
    );
  }
}

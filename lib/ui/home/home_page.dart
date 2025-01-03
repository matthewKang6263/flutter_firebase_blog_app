import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/detail/detail_page.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firebase_blog_app/ui/home/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HomeViewModel의 상태를 관찰합니다.
    final posts = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('BLOG'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 게시물 작성 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage(null)),
          );
        },
        child: Icon(Icons.edit),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최근글',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: posts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return item(context, post);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 게시물 아이템 위젯
  Widget item(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지로 이동
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(post);
        }));
      },
      child: Container(
        width: double.infinity,
        height: 120,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(right: 100),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(post.content, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text(post.createdAt.toIso8601String()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

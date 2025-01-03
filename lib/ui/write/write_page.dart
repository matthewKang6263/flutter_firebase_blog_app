import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerStatefulWidget {
  WritePage(this.post, {Key? key}) : super(key: key);
  final Post? post;

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  late TextEditingController writeController;
  late TextEditingController titleController;
  late TextEditingController contentController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    writeController = TextEditingController(text: widget.post?.writer ?? '');
    titleController = TextEditingController(text: widget.post?.title ?? '');
    contentController = TextEditingController(text: widget.post?.content ?? '');
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    writeController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final writeState = ref.watch(writeViewModelProvider(widget.post));
    final vm = ref.read(writeViewModelProvider(widget.post).notifier);

    // 글 작성 중일 때 로딩 표시
    if (writeState.isWriting) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () async {
                final result = formKey.currentState?.validate() ?? false;
                if (result) {
                  final insertResult = await vm.insert(
                    writer: writeController.text,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  if (insertResult && context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text('완료',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              // 작성자 입력 필드
              TextFormField(
                controller: writeController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: '작성자'),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return '작성자를 입력해주세요';
                  }
                  return null;
                },
              ),
              // 제목 입력 필드
              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: '제목'),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              // 내용 입력 필드
              SizedBox(
                height: 200,
                child: TextFormField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(hintText: '내용'),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return '내용을 입력해주세요';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              // 이미지 선택 및 표시
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (xFile != null) {
                      await vm.uploadImage(xFile);
                    }
                  },
                  child: writeState.imageUrl == null
                      ? Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: Icon(Icons.image),
                        )
                      : SizedBox(
                          height: 100,
                          child: Image.network(writeState.imageUrl!),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

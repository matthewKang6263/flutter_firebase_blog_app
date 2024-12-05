import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/write/wirte_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerStatefulWidget {
  WritePage(this.post);
  Post? post;

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  late TextEditingController writeController = TextEditingController(
    text: widget.post?.writer ?? '',
  );
  late TextEditingController titleController = TextEditingController(
    text: widget.post?.title ?? '',
  );
  late TextEditingController contentController = TextEditingController(
    text: widget.post?.content ?? '',
  );

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    writeController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final writeState = ref.watch(writeViewModelProvider(widget.post));
    final vm = ref.read(writeViewModelProvider(widget.post).notifier);
    if (writeState.isWriting) {
      return Scaffold(
          appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: () async {
                  print('object');
                  final result = formKey.currentState?.validate() ?? false;
                  if (result) {
                    final insertResult = await vm.insert(
                      writer: writeController.text,
                      title: titleController.text,
                      content: contentController.text,
                    );
                    if (insertResult) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (xFile != null) {
                      vm.uploadImage(xFile);
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      '완료',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
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
                  TextFormField(
                      controller: titleController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(hintText: '제목'),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return '제목을 입력해주세요';
                        }
                        return null;
                      }),
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
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: writeState.imageUrl == null
                        ? Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey,
                            child: Icon(Icons.image),
                          )
                        : SizedBox(
                            height: 100,
                            child: Image.network(writeState.imageUrl!)),
                  )
                ],
              )),
        ));
  }
}

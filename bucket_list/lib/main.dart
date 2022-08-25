import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Bucket {
  String job;
  bool isDone;

  Bucket({
    required this.job,
    required this.isDone,
  });
}

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bucket> bucketList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷 리스트"),
      ),
      body: bucketList.isEmpty
          ? const Center(child: Text("버킷 리스트를 작성해 주세요."))
          : ListView.builder(
              itemCount: bucketList.length,
              itemBuilder: (BuildContext context, int index) {
                Bucket bucket = bucketList[index];
                return ListTile(
                  title: Text(
                    bucket.job,
                    style: TextStyle(
                      fontSize: 24,
                      color: bucket.isDone ? Colors.grey : Colors.black,
                      decoration: bucket.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // 삭제 클릭
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("삭제하시겠습니까?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: const Text("취소")),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    // index에 해당하는 항목 삭제
                                    bucketList.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "삭제",
                                  style: TextStyle(
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(CupertinoIcons.delete),
                  ),
                  onTap: () {
                    // 수정
                    setState(() {
                      bucket.isDone = !bucket.isDone;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // + 버튼 클릭시 버킷 생성 페이지로 이동
          String? job = await Navigator.push<String?>(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (job != null) {
            setState(() {
              Bucket buc = Bucket(job: job, isDone: false);
              bucketList.add(buc);
            });
          }
        },
      ),
    );
  }
}

/// 버킷 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController controller = TextEditingController();
  String? errorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷리스트 작성"),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "하고 싶은 일을 입력하세요",
                errorText: errorText,
              ),
            ),
            SizedBox(height: 32),
            // 추가하기 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭시
                  String job = controller.text;

                  if (job.isEmpty) {
                    setState(() {
                      errorText = "입력값이 없습니다.";
                    });
                  } else {
                    setState(() {
                      errorText = null;
                    });
                    Navigator.pop(context, job);
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

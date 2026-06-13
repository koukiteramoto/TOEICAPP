import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  final String mode;
  final int groupNo;
  const QuizPage({super.key, required this.mode, required this.groupNo});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

    List<Map<String, dynamic>> words = [];

  final Map<String, String> wordData = {
    "apple": "りんご",
    "book": "本",
    "car": "車",
    "dog": "犬",
    "run": "走る",
    "eat": "食べる",
    "happy": "幸せ",
    "big": "大きい",
    "small": "小さい",
    "fast": "速い",
  };

  // late String question;
  String questionNum = "";
  String answer = "";
  String question = "";
  late List<String> choices = [];
  String result = "";

  @override
  void initState() {
    super.initState();
    getWordsFromFirestore();
    // generateQuestion();
  }

  Future<void> getWordsFromFirestore() async{

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
                                      .collection('words')
                                      .where('level', isEqualTo: widget.mode)
                                      .where('groupNo', isEqualTo: widget.groupNo)
                                      .get();

      final datas = snapshot.docs.map((doc) => doc.data() as Map<String,dynamic>).toList();
      final rand = Random();
      List<Map<String, dynamic>> questionData = [];
      choices = [];

      questionNum = rand.nextInt(datas.length).toString();

      questionData.add(datas[int.parse(questionNum)]);
      question = questionData.first['english'];
      answer = questionData.first['answer'];

      for(final choice in questionData.first['choices']){
          choices.add(choice);
      }

      choices.shuffle();

      setState(() {
        words = datas;
      });

    } catch (e) {
      print(e);
    }
  }

//   Future<void> initWordDataToFirestore() async {
//     final firestore = FirebaseFirestore.instance;

//     for (var entry in wordData.entries) {
//       await firestore.collection('words').doc(entry.key).set({
//         'english': entry.key,
//         'japanese': entry.value,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Firebaseに初期データ登録完了！")),
//     );
//   }

  // void generateQuestion() {
  //   final rand = Random();
  //   final keys = wordData.keys.toList();

  //   question = keys[rand.nextInt(keys.length)];
  //   String correct = wordData[question]!;

  //   choices = [correct];

  //   while (choices.length < 4) {
  //     String randomValue = wordData[keys[rand.nextInt(keys.length)]]!;
  //     if (!choices.contains(randomValue)) {
  //       choices.add(randomValue);
  //     }
  //   }

  //   choices.shuffle();
  //   result = "";
  // }

  void checkAnswer(String selected) {
    setState(() {
      if (selected == answer) {
        result = "正解！";
      } else {
        result = "不正解...";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("モード: ${widget.mode}"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),

            ...choices.map((c) => ElevatedButton(
                  onPressed: () => checkAnswer(c),
                  child: Text(c),
                )),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(fontSize: 24),
            ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                getWordsFromFirestore();
              });
            },
            child: const Text("次の問題"),
          ),

        //   const SizedBox(height: 20),

        //   ElevatedButton(
        //     onPressed: initWordDataToFirestore,
        //     child: const Text("初期データをFirebaseに登録"),
        //   ),
        ],
      ),
    ));
  }
}
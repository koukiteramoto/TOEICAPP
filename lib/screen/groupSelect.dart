import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../quiz/quiz.dart';

class GroupSelectPage extends StatelessWidget{
    const GroupSelectPage({super.key, required this.mode});

    final String mode;
    final String prefix = "group";

    @override
    Widget build(BuildContext context){

        return Scaffold(
            appBar: AppBar(title : const Text("グループ選択")),
            body: FutureBuilder<int>(
              future: getMaxGroupNumber(mode) as Future<int>,
              builder:(context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final maxGroupNo = snapshot.data ?? 0;

                // return Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //         ElevatedButton(
                //             onPressed: () => startQuiz(context, "600", 1),
                //             child: const Text("600点モード"),
                //         ),
                //     ],
                //   ),
                // );

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      maxGroupNo,
                      (index) => ElevatedButton(
                        onPressed: () => startQuiz(context, mode, index + 1),
                        child: Text("$prefix ${index + 1}"),
                      ),
                    ),
                  ),
                );
              }
            )
        );
    }

    void startQuiz(BuildContext context, String mode,int groupNo) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => QuizPage(mode: mode,groupNo: groupNo),
            ),
        );
    }

    // 最大のグループ番号を取得する処理
    Future<int> getMaxGroupNumber(String mode) async{

      try{
        int maxGroupNo = 0;

        QuerySnapshot snapshot = await FirebaseFirestore.instance
                                      .collection('words')
                                      .where('level', isEqualTo: mode)
                                      .orderBy('groupNo',descending: true)
                                      .limit(1)
                                      .get();

        final datas = snapshot.docs.map((doc) => doc.data() as Map<String,dynamic>).toList();

        // スナップショットの中身がから出ないか確認
        if(snapshot.docs.isNotEmpty){
            maxGroupNo = snapshot.docs.first['groupNo'] as int;
        }
        else{
          return 999;
        }

        return maxGroupNo;
      }
      catch(e){
        // エラー処理
        print("Error fetching max group number: $e");
        return 999; // エラーコードとして999を返却
      }
    }
}
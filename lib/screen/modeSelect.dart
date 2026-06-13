import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'groupSelect.dart';

class ModeSelectPage extends StatelessWidget{
    const ModeSelectPage({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(title: const Text("モード選択")),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ElevatedButton(
                            onPressed: () => selectGroup(context, "600"),
                            child: const Text("600点モード"),
                        ),
                        ElevatedButton(
                            onPressed: () => selectGroup(context, "800"),
                            child: const Text("800点モード"),
                        ),
                        ElevatedButton(
                            onPressed: () => selectGroup(context, "full"),
                            child: const Text("満点モード"),
                        ),
                    ],
                ),
            ),
        );
    }

    void selectGroup(BuildContext context,String mode){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GroupSelectPage(mode:mode),
        )
      );
    }
}
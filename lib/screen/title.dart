import 'package:flutter/material.dart';
import 'modeSelect.dart';

class TitlePage extends StatelessWidget{
    const TitlePage({super.key});
    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Center(
                child: ElevatedButton(
                    onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ModeSelectPage(),
                            ),
                        );
                    },
                    child: const Text('スタート')
                ),
            ),
        );
    }
}
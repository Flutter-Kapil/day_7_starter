import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'question_brain.dart';

void main() {
  runApp(Quizlr());
}

class Quizlr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: QuizPage(),
        ),
      ),
    ));
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  QuizBrain brain = QuizBrain();
  void checkAnswer(bool userAnswer) {
    setState(() {
      brain.getCurrentQuestion();
      if (brain.checkAnswer(userAnswer)) {
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
        brain.right++;
      } else {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
      }
      brain.nextQuestion();

      if (brain.questionNumber > brain.questions.length - 1) {
        Alert(
          context: context,
          title: "Quiz Completed",
          desc: "You scored ${brain.right}/${brain.questions.length}",
          buttons: [
            DialogButton(
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                scoreKeeper.clear();
                brain.reset();
                setState(() {});
                return Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
        brain.questionNumber = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                brain.getCurrentQuestion().que,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: FlatButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text(
                  'True',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  checkAnswer(true);
                }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
                if (brain.questionNumber == brain.questions.length) {
                  brain.questionNumber = 0;
                  scoreKeeper.clear();
                }
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

// Sample Questions and Answers
// Q.1 Amartya Sen was awarded the Nobel prize for his contribution to Welfare Economics., true
// Q.2 The Headquarters of the Southern Naval Command of the India Navy is located at Thiruvananthapuram., false
// Q.3 There are 4 sessions of the Parliament each year: Spring, Summer, Autumn and Winter., false

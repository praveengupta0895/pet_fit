

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_fit/view/screens/feedback_screen.dart';

void main(){
  Widget makeTestableWidget({required Widget child}){
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets("", (WidgetTester tester)async{
    FeedbackPage feedback = const FeedbackPage();
    await tester.pumpWidget(makeTestableWidget(child: feedback));
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    var elevatedButton = find.byType(ElevatedButton);
    await tester.enterText(textField, "Hello");
    expect(find.text("Welcome New User"),findsOneWidget);
    expect(elevatedButton, findsOneWidget);
    await tester.dragUntilVisible(elevatedButton,find.byType(SingleChildScrollView),const Offset(400, 1390)
    );

  });
}
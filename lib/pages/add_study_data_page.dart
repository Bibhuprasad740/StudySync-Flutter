import 'package:flutter/material.dart';

import '../components/auth/auth_heading.dart';
import '../components/auth/input_box.dart';
import '../components/auth/submit_button.dart';
import '../controllers/study_controller.dart';
import '../errors/api_response.dart';
import '../utils/utils.dart';

class AddStudyDataPage extends StatelessWidget {
  AddStudyDataPage({super.key});

  final topicController = TextEditingController();
  final subjectController = TextEditingController();
  final additionalInfoController = TextEditingController();

  void addStudyData(BuildContext context) async {
    final topic = topicController.text.trim();
    final subject = subjectController.text.trim();
    final additionalInfo = additionalInfoController.text.trim();

    if (topic.isEmpty || subject.isEmpty || additionalInfo.isEmpty) {
      showSnackBar(context, 'All fields are required!');
      return;
    }

    final studyController = StudyController();

    ApiResponse response = await studyController.addStudyData(
      topic,
      subject,
      additionalInfo,
    );

    if (response.statusCode == 200) {
      topicController.clear();
      subjectController.clear();
      additionalInfoController.clear();
    }

    showSnackBar(context, response.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Study Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[100],
              elevation: 4, // Adds elevation for a shadow effect
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Heading
                    const AuthHeading(heading: 'ADD STUDY DATA'),

                    const SizedBox(height: 20),

                    // Topic Name text field
                    InputBox(
                      controller: topicController,
                      labelText: 'Topic Name',
                    ),

                    const SizedBox(height: 15),

                    // Subject Name text field
                    InputBox(
                      controller: subjectController,
                      labelText: 'Subject Name',
                    ),

                    const SizedBox(height: 15),

                    // Additional Info text field
                    InputBox(
                      controller: additionalInfoController,
                      labelText: 'Additional Info',
                    ),

                    const SizedBox(height: 25),

                    // Add Study Data button
                    SubmitButton(
                      label: 'Add Study Data',
                      onTap: () => addStudyData(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

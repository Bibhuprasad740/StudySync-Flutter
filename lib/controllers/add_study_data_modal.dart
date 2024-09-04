import 'package:flutter/material.dart';

import '../components/auth/auth_heading.dart';
import '../components/auth/input_box.dart';
import '../components/auth/submit_button.dart';
import '../errors/api_response.dart';
import '../utils/utils.dart';
import 'study_controller.dart';

class AddStudyDataModal extends StatefulWidget {
  @override
  _AddStudyDataModalState createState() => _AddStudyDataModalState();
}

class _AddStudyDataModalState extends State<AddStudyDataModal> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

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

      Navigator.of(context).pop(); // Close the modal on success
    }

    showSnackBar(context, response.message);
  }

  @override
  void dispose() {
    topicController.dispose();
    subjectController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthHeading(heading: 'ADD STUDY DATA'),
            const SizedBox(height: 20),
            InputBox(
              controller: topicController,
              labelText: 'Topic Name',
            ),
            const SizedBox(height: 15),
            InputBox(
              controller: subjectController,
              labelText: 'Subject Name',
            ),
            const SizedBox(height: 15),
            InputBox(
              controller: additionalInfoController,
              labelText: 'Additional Info',
            ),
            const SizedBox(height: 25),
            SubmitButton(
              label: 'Add Study Data',
              onTap: () => addStudyData(context),
            ),
          ],
        ),
      ),
    );
  }
}

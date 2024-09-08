import 'package:flutter/material.dart';
import '../controllers/add_study_data_modal.dart';
import '../controllers/study_controller.dart';
import '../utils/utils.dart';

class StudiesPage extends StatefulWidget {
  const StudiesPage({super.key});

  @override
  State<StudiesPage> createState() => _StudiesPageState();
}

class _StudiesPageState extends State<StudiesPage> {
  final studyController = StudyController();

  Map<String, List<Map<String, dynamic>>> groupedStudies = {};

  @override
  void initState() {
    super.initState();
    fetchStudies();
  }

  void fetchStudies() async {
    final response = await studyController.fetchStudyData();
    if (response.statusCode == 200) {
      setState(() {
        groupedStudies = _groupBySubject(response.data);
      });
    }

    if (response.statusCode != 200) {
      showSnackBar(context, response.message);
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupBySubject(
      List<dynamic> studies) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var study in studies) {
      final subject = study['subject'];
      if (grouped.containsKey(subject)) {
        grouped[subject]!.add(study);
      } else {
        grouped[subject] = [study];
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groupedStudies.keys.length,
        itemBuilder: (context, index) {
          final subject = groupedStudies.keys.elementAt(index);
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            child: ListTile(
              title: Text(subject),
              onTap: () {
                _showSubjectModal(context, subject);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.amber,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const AddStudyDataModal(),
              );
            },
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSubjectModal(BuildContext context, String subject) {
    final topics = groupedStudies[subject]!;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return ListTile(
              title: Text(topic['topic']),
              subtitle:
                  Text('Last Revised: ${topic['lastRevisedOn'] ?? 'Never'}'),
              onTap: () {
                _showTopicDetailsDialog(context, topic);
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditModal(context, topic);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Edit'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice.toLowerCase(),
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showTopicDetailsDialog(
      BuildContext context, Map<String, dynamic> topic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(topic['topic']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${topic['subject']}'),
              Text('Last Revised: ${topic['lastRevisedOn'] ?? 'Never'}'),
              Text('Revision Count: ${topic['revisionCount'] ?? 0}'),
              Text('Additional Info: ${topic['additionalInfo'] ?? 'N/A'}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, Map<String, dynamic> study) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the modal to resize when the keyboard appears
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjusts padding based on the keyboard height
          ),
          child: SingleChildScrollView(
            child: AddStudyDataModal(
              initialData: study,
            ),
          ),
        );
      },
    );
  }
}

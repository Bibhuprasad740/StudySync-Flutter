import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:study_sync/controllers/revision_controller.dart';

import '../errors/api_response.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? revisionData;
  final revisionController = RevisionController();

  @override
  void initState() {
    super.initState();
    _getRevisions();
  }

  // Fetch revisions from API
  void _getRevisions() async {
    final apiEndpoint = dotenv.env['BACKEND_BASE_URL']! +
        dotenv.env['getAllRevisionsEndpoint']!;
    ApiResponse response = await fetchData(apiEndpoint);
    if (response.statusCode == 200) {
      setState(() {
        revisionData = response.data;
      });
    } else {
      showSnackBar(context, response.message);
    }
  }

  // Revise a topic
  void revise(BuildContext context, String topicId, String subject) async {
    // Show a confirmation dialog before the API call
    bool confirmRevise = await showReviseConfirmationDialog(context);

    if (confirmRevise) {
      ApiResponse response = await revisionController.updateRevision(topicId);

      if (response.statusCode == 200) {
        // Remove the topic from the list if the API call is successful
        setState(() {
          final topics = revisionData![subject] as List<dynamic>;
          topics.removeWhere((topic) => topic['id'] == topicId);

          // If there are no more topics for the subject, remove the subject key
          if (topics.isEmpty) {
            revisionData!.remove(subject);
          }
        });
      }

      showSnackBar(context, response.message);
    }
  }

  Future<bool> showReviseConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Revise'),
          content: const Text('Finished revising this topic?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Revisions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: revisionData == null
          ? const Center(child: CircularProgressIndicator())
          : revisionData!.isEmpty
              ? const Center(
                  child: Text(
                    'No revision data available.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: revisionData!.keys.length,
                  itemBuilder: (context, index) {
                    // Get the subject name
                    final subject = revisionData!.keys.elementAt(index);
                    // Get the list of topics for the subject
                    final topics = revisionData![subject] as List<dynamic>;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.topic,
                          size: 40,
                          color: Colors.black,
                        ),
                        title: Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: topics.map<Widget>(
                          (topic) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                  topic['topic'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      'Last Revised: ${topic['lastRevised']}',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Additional Info: ${topic['additionalInfo']}',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          revise(context, topic['id'], subject),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.teal,
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text('Revise'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                ),
    );
  }
}

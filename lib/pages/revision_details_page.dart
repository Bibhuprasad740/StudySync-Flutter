import 'package:flutter/material.dart';

class RevisionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> topic;

  const RevisionDetailsPage({super.key, required this.topic});

  void _reviseTopic(BuildContext context) async {
    // Uncomment and complete API call for revising the topic
    // final apiEndpoint =
    //     dotenv.env['BACKEND_BASE_URL']! + dotenv.env['reviseTopicEndpoint']!;
    // final ApiResponse response =
    //     await fetchData(apiEndpoint, method: 'POST', data: {
    //   'topicId': topic['id'],
    // });

    // if (response.statusCode == 200) {
    //   showSnackBar(context, 'Topic revised successfully!');
    // } else {
    //   showSnackBar(context, response.message);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Topic Name
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.teal[50],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.topic, size: 40, color: Colors.teal),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          topic['topic'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Card for Last Revised Date
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.teal),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Last Revised: ${topic['lastRevised']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card for Additional Information
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.teal),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Additional Info: ${topic['additionalInfo']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Revise Topic Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => _reviseTopic(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 8),
                        Text('Revise This Topic'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

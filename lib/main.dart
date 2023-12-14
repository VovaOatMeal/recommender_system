import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Destination Recommender',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const RecommendationScreen(),
    );
  }
}

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String selectedDestination = '';

  Map<String, Map<String, String>> recommendations = {
    'Beach': {'Warm': 'Miami', 'Cold': 'Los Angeles', 'Mild': 'San Diego'},
    'Mountain': {'Warm': 'Denver', 'Cold': 'Aspen', 'Mild': 'Salt Lake City'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Destination Recommender'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Answer the following questions to get a travel recommendation:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                QuestionCard(
                  question: 'What type of climate do you prefer?',
                  options: const ['Warm', 'Cold', 'Mild'],
                  onAnswerSelected: (answer) {
                    selectedDestination = answer;
                  },
                ),
                QuestionCard(
                  question: 'Do you prefer a beach or mountain destination?',
                  options: const ['Beach', 'Mountain'],
                  onAnswerSelected: (answer) {
                    selectedDestination =
                        recommendations[answer]?[selectedDestination] ?? '';
                  },
                ),
                QuestionCard(
                  question: 'What is your preferred mode of transportation?',
                  options: const ['Car', 'Plane', 'Train'],
                  onAnswerSelected: (answer) {
                    selectedDestination += ' by $answer';
                  },
                ),
                QuestionCard(
                  question: 'How many days do you plan to spend on vacation?',
                  options: const ['1-3 days', '4-7 days', 'More than 7 days'],
                  onAnswerSelected: (answer) {
                    selectedDestination += ' for $answer';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Display the recommendation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Your Recommended Destination:'),
                        content: Text(selectedDestination.isNotEmpty
                            ? selectedDestination
                            : 'No recommendation'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Get Recommendation'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final String question;
  final List<String> options;
  final Function(String) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.onAnswerSelected,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String selectedAnswer = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: widget.options.map((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value.toString();
                    });
                    widget.onAnswerSelected(value.toString());
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

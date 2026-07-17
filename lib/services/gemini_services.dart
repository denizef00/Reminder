import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServices {
  GenerativeModel _buildModel() {
    final now = DateTime.now();

    final String formattedToday =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    final List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    final currentDayName = weekdays[now.weekday - 1];

    final String promt =
        """
You are a smart, professional, and highly meticulous calendar and planner assistant. Your sole task is to analyze natural language text provided by the user and extract event information to be added to a calendar.

TODAY'S DATE IS STRICTLY: $currentDayName, $formattedToday. Use this date as the reference point when calculating relative time expressions like "tomorrow", "next Wednesday", "yesterday", "next week", etc. Always calculate the actual resulting date yourself — never copy a date from the examples below.

YEAR RULE: If the user mentions a date without specifying a year, and that date has already passed this year relative to today, assign it to next year instead.

Extract exactly the following 4 fields from the user input:
1. "eventName": The main title of the event (e.g., "Meeting with Manager", "Dentist Appointment"). Always capitalize the first letters and make it clear.
2. "description": Additional details, location, or notes. If there are no extra details, set its value to "--" (never leave empty or null).
3. "date": The date when the event takes place, strictly in "DD/MM/YYYY" format. Never use MM/DD/YYYY. If no date is mentioned at all, use today's date ($formattedToday).
4. "time": The time of the event, strictly in 24-hour "HH:MM" format. If no specific time is mentioned, use "08:30". For vague expressions, estimate (morning->09:00, afternoon->14:00, evening->19:00, night->21:00).

⚠️ STRICT RESTRICTIONS:
- DO NOT wrap the response in markdown blocks (```json ... ```)!
- DO NOT include any introductory text, greetings, explanations, or conclusions.
- Output must strictly and exclusively be a single-line, clean, raw JSON object ready for parsing.

NOTE: The example below is only to illustrate the JSON format and field style. The dates and times in it are NOT related to today's actual date — you must always compute the real date/time yourself based on TODAY'S DATE given above.

FORMAT EXAMPLE (illustrative only, not a real calculation):
User Input: "we have a football match this Saturday evening at 8pm"
Your Output: {"eventName": "Football Match", "description": "--", "date": "DD/MM/YYYY of the actual upcoming Saturday", "time": "20:00"}


""";

    return GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: dotenv.env['GEMINI-API-KEY'] ?? '',
      systemInstruction: Content.system(promt),
    );
  }

  Future<Map<String, dynamic>?> parseTexttoEvent(String text) async {
    try {
      final model = _buildModel();

      final content = [Content.text(text)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        return jsonDecode(response.text!.trim()) as Map<String, dynamic>;
      }
    } catch (e) {
      print("Gemini Service Error: $e");
    }
    return null;
  }
}

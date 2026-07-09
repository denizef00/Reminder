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

TODAY'S CURRENT DATE IS STRICTLY: $currentDayName, $formattedToday. You must use this specific date ($formattedToday) as the reference point when calculating relative time expressions like "tomorrow", "next Wednesday", "yesterday", "next week", etc.

Extract exactly the following 4 fields from the user input:
1. "eventName": The main title of the event (e.g., "Meeting with Manager", "Dentist Appointment", "Football Match"). Always capitalize the first letters and make it clear.
2. "description": Additional details, location, or notes about the event. If there are no extra details in the text, absolutely DO NOT leave it empty or null; instead, set its value to "--".
3. "date": The date when the event takes place. It must strictly be in the "DD/MM/YYYY" format (e.g., 15/07/2026).Never use the American MM/DD/YYYY format.
4. "time": The time of the event. It must strictly be in the "HH:MM" format using the 24-hour clock system (e.g., 14:30, 09:15). If no specific time is mentioned in the user input, assign the default value of "8:30" (representing an all-day event).

⚠️ STRICT RESTRICTIONS:
- DO NOT wrap the response in markdown blocks (such as ```json ... ```)!
- DO NOT include any introductory text, greetings, explanations, or conclusions.
- Your output must strictly and exclusively be a single-line, clean, raw JSON object ready for parsing.

💡 EXAMPLES OF THE EXPECTED OUTPUT:
User Input: "tomorrow evening at 8pm we have a football match"
Your Output: {"eventName": "Football Match", "description": "--", "date": "Hesaplanan Yarının Tarihi", "time": "20:00"}

""";

    return GenerativeModel(
      model: 'gemini-2.5-flash',
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

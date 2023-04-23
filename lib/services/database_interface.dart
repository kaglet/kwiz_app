import 'package:kwiz_v2/models/quizzes.dart';

abstract class DatabaseService {
  Future<List?> getCategories();
  Future<void> addQuizWithQuestions(Quiz quizInstance);
}

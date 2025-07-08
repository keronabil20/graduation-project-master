// Project imports:
import 'package:graduation_project/domain/entities/analytics.dart';

abstract class AnalyticsRepository {
  Future<void> saveAnalytics(String restaurantId, Analytics analytics);
  Future<List<Analytics>> getAnalytics(String restaurantId);
}

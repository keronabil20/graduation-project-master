// Project imports:
import 'package:graduation_project/domain/entities/analytics.dart';
import 'package:graduation_project/domain/repo/analytics/analytics_repository.dart';

class SaveAnalytics {
  final AnalyticsRepository repository;
  SaveAnalytics(this.repository);

  Future<void> call(String restaurantId, Analytics analytics) {
    return repository.saveAnalytics(restaurantId, analytics);
  }
}

class GetAnalytics {
  final AnalyticsRepository repository;
  GetAnalytics(this.repository);

  Future<List<Analytics>> call(String restaurantId) {
    return repository.getAnalytics(restaurantId);
  }
}

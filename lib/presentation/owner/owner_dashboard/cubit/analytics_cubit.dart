// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:graduation_project/domain/entities/analytics.dart';
import 'package:graduation_project/domain/usecases/analytics_usecases.dart';

// Define Analytics States
abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<Analytics> analyticsList;

  AnalyticsLoaded(this.analyticsList);
}

class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError(this.message);
}

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  // Fixed constructor: Only one parameter needed
  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> fetchAnalytics(String restaurantId) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await getAnalytics.call(restaurantId);
      emit(AnalyticsLoaded(analytics));
    } catch (e) {
      emit(AnalyticsError('Failed to fetch analytics: ${e.toString()}'));
    }
  }
}

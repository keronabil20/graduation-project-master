// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:graduation_project/domain/entities/analytics.dart';
import 'package:graduation_project/domain/usecases/analytics_usecases.dart';

// Define Analytics States with Equatable
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<Analytics> analyticsList;

  const AnalyticsLoaded(this.analyticsList);

  @override
  List<Object?> get props => [analyticsList];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> fetchAnalytics(String restaurantId) async {
    try {
      emit(AnalyticsLoading());
      final analytics = await getAnalytics(restaurantId);
      emit(AnalyticsLoaded(analytics));
    } catch (e, stackTrace) {
      log('Analytics fetch error',
          error: e, stackTrace: stackTrace, name: 'AnalyticsCubit');
      emit(AnalyticsError('Failed to load analytics data'));
    }
  }

  Future<void> refresh(String restaurantId) async {
    if (state is! AnalyticsLoading) {
      await fetchAnalytics(restaurantId);
    }
  }
}

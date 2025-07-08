part of 'language_cubit.dart';

@immutable
sealed class LanguageState {}

final class LanguageInitial extends LanguageState {}

final class LanguageLoading extends LanguageState {}

final class LanguageLoaded extends LanguageState {
  final Locale locale;

  LanguageLoaded({required this.locale});
}

final class LanguageError extends LanguageState {
  final String message;

  LanguageError({required this.message});
}

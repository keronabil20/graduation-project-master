part of 'upload_post_cubit.dart';

abstract class UploadPostState extends Equatable {
  @override
  List<Object> get props => [];
}

class UploadPostInitial extends UploadPostState {}

class UploadPostLoading extends UploadPostState {}

class UploadPostSuccess extends UploadPostState {}

class UploadPostError extends UploadPostState {
  final String message;

  UploadPostError(this.message);

  @override
  List<Object> get props => [message];
}

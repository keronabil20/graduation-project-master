// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/analytics/analytics_repository.dart';
import 'package:graduation_project/domain/repo/analytics/analytics_repository_implementation.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_item_implment.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/domain/repo/order/order_remoteDataSource.dart';
import 'package:graduation_project/domain/repo/order/order_repository.dart';
import 'package:graduation_project/domain/repo/order/order_repository_impl.dart';
import 'package:graduation_project/domain/repo/owner/owner_repository.dart';
import 'package:graduation_project/domain/repo/owner/owner_repository_impl.dart';
import 'package:graduation_project/domain/repo/post/post_remote_datasource.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/domain/repo/post/post_repository_implemntation.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository_implentation.dart';
import 'package:graduation_project/domain/repo/user/firebase_user_data_source.dart';
import 'package:graduation_project/domain/repo/user/user_remote_data_source.dart';
import 'package:graduation_project/domain/repo/user/user_repository.dart';
import 'package:graduation_project/domain/repo/user/user_repository_implentation.dart';
import 'package:graduation_project/domain/usecases/analytics_usecases.dart';
import 'package:graduation_project/domain/usecases/order_usecases.dart';
import 'package:graduation_project/domain/usecases/owner/upload_owner_image_usecase.dart';
import 'package:graduation_project/domain/usecases/post_usecase.dart';
import 'package:graduation_project/presentation/auth/sign_up/cubit/auth_cubit.dart';
import 'package:graduation_project/presentation/menu_item/order/cubit/order_cubit.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_bloc.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_bloc.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/analytics_cubit.dart';
import 'package:graduation_project/presentation/posts/cubit/posts_cubit.dart';
import 'package:graduation_project/utils/services/cubit/language_cubit.dart';
import 'package:graduation_project/utils/services/image_upload_service.dart';
import 'package:graduation_project/utils/themes/custom/theme_cubit.dart';

import 'package:graduation_project/presentation/posts/cubit/upload_post_cubit.dart'; // Your UploadPostCubit import


final getIt = GetIt.instance;

Future<void> init() async {
  // Firebase Services
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Remote Data Sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => FirebaseUserDataSource(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: getIt<UserRemoteDataSource>()),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt<OrderRemoteDataSource>(),
      analyticsRepository: getIt<AnalyticsRepository>(),
    ),
  );

  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: getIt<PostRemoteDataSource>()),
  );

  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ImageUploadService>(() => ImageUploadService());

  getIt.registerLazySingleton(() => UploadOwnerImageUseCase(
        getIt<OwnerRepository>(),
        getIt<ImageUploadService>(),
      ));

  // Use Cases
  getIt.registerLazySingleton(() => CreateOrder(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => GetOrders(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => GetOrdersCount(getIt<OrderRepository>()));
  getIt
      .registerLazySingleton(() => UpdateOrderStatus(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() =>
      GetOrdersTotalSum(getIt<OrderRepository>())); // This line was missing

  getIt.registerLazySingleton(() => AddPost(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => UpdatePost(getIt<PostRepository>()));

  getIt.registerLazySingleton(() => GetAnalytics(getIt<AnalyticsRepository>()));

  // Cubits / Blocs
  getIt.registerFactory(() => ThemeCubit());
  getIt.registerFactory(() => AuthCubit());
  getIt.registerFactory(() => LocaleCubit());
  getIt.registerFactoryParam<MenuBloc, String, void>(
    (restaurantId, _) => MenuBloc(
      menuRepository: getIt<MenuRepository>(),
      restaurantId: restaurantId,
    ),
  );

  getIt.registerFactoryParam<MenuItemFormBloc, String, MenuItem?>(
    (restaurantId, item) => MenuItemFormBloc(
      menuRepository: getIt<MenuRepository>(),
      restaurantId: restaurantId,
      initialItem: item,
    ),
  );
  getIt.registerFactory(
      () => PostsCubit(postRepository: getIt<PostRepository>()));

  getIt.registerFactory(() => UploadPostCubit(
        postRepository: getIt<PostRepository>(),
      ));

  getIt.registerFactory(() => OrderCubit(
        createOrder: getIt<CreateOrder>(),
        getOrders: getIt<GetOrders>(),
        updateOrderStatus: getIt<UpdateOrderStatus>(),
      ));

  getIt.registerFactory(
      () => AnalyticsCubit(getAnalytics: getIt<GetAnalytics>()));
}

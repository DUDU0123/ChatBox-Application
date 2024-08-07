import 'package:chatbox/features/data/data_sources/broadcast_data/broadcast_data.dart';
import 'package:chatbox/features/data/data_sources/chat_data/chat_data.dart';
import 'package:chatbox/features/data/data_sources/contact_data/contact_data.dart';
import 'package:chatbox/features/data/data_sources/group_data/group_data.dart';
import 'package:chatbox/features/data/data_sources/message_data/message_data.dart';
import 'package:chatbox/features/data/data_sources/status_data/status_data.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/repositories/auth_repo_impl/authentication_repo_impl.dart';
import 'package:chatbox/features/data/repositories/broadcast_repo_impl/brocast_repository_impl.dart';
import 'package:chatbox/features/data/repositories/chat_repository_impl/chat_repo_impl.dart';
import 'package:chatbox/features/data/repositories/contact_repository_impl/contact_repo_impl.dart';
import 'package:chatbox/features/data/repositories/group_repo_impl/group_repo_impl.dart';
import 'package:chatbox/features/data/repositories/message_repo_impl/message_repo_impl.dart';
import 'package:chatbox/features/data/repositories/status_repository_impl/status_repository_impl.dart';
import 'package:chatbox/features/data/repositories/user_repository_impl/user_repository_impl.dart';
import 'package:chatbox/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:chatbox/features/presentation/bloc/broadcast/broadcast_bloc.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

// final getItInstance = GetIt.instance;
// void initializeServiceLocator() {
//   getItInstance.registerSingleton(() => FirebaseAuth.instance);
//   getItInstance.registerSingleton(() => FirebaseStorage.instance);
//   getItInstance.registerSingleton(() => FirebaseFirestore.instance);

//   getItInstance.registerLazySingleton(
//     () => ContactData(),
//   );
//   getItInstance.registerLazySingleton(
//     () => AuthenticationRepoImpl(firebaseAuth: getItInstance<FirebaseAuth>()),
//   );
//   getItInstance.registerLazySingleton(
//     () => ContactRepoImpl(
//       contactData: getItInstance<ContactData>(),
//       firebaseFirestore: getItInstance<FirebaseFirestore>(),
//     ),
//   );
//   getItInstance.registerLazySingleton(
//     () => UserData(
//       firestore: getItInstance<FirebaseFirestore>(),
//       firebaseStorage: getItInstance<FirebaseStorage>(),
//       firebaseAuth: getItInstance<FirebaseAuth>(),
//     ),
//   );
//   getItInstance.registerLazySingleton(
//     () => UserRepositoryImpl(
//       userData: getItInstance<UserData>(),
//     ),
//   );
//   getItInstance.registerFactory(() => UserModel());
// }

// class AppBlocProvider {
//   static List<SingleChildWidget> allBlocProviders = [
//     BlocProvider(
//       create: (context) => BottomNavBloc(),
//     ),
//     BlocProvider(
//       create: (context) => AuthenticationBloc(
//         userRepository: getItInstance<UserRepositoryImpl>(),
//         authenticationRepo:getItInstance<AuthenticationRepoImpl>(),
//       )..add(CheckUserLoggedInEvent()),
//     ),
//     BlocProvider(
//       create: (context) => ContactBloc(
//         contactRepository: getItInstance<ContactRepoImpl>(),
//       ),
//     ),
//     BlocProvider(
//       create: (context) => MessageBloc(),
//     ),
//     BlocProvider(
//       create: (context) => UserBloc(
//         firebaseAuth: getItInstance<FirebaseAuth>(),
//         userRepository: getItInstance<UserRepositoryImpl>(),
//       )..add(GetCurrentUserData()),
//     ),
//   ];
// }

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class AppBlocProvider {
  static List<SingleChildWidget> allBlocProviders = [
    BlocProvider(
      create: (context) => BottomNavBloc(),
    ),
    BlocProvider(
      create: (context) => AuthenticationBloc(
        firebaseAuth: firebaseAuth,
        userRepository: UserRepositoryImpl(
          userData: UserData(
            authenticationRepo:
                AuthenticationRepoImpl(firebaseAuth: firebaseAuth),
            fireBaseAuth: firebaseAuth,
            firestore: fireStore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        authenticationRepo: AuthenticationRepoImpl(
          firebaseAuth: FirebaseAuth.instance,
        ),
      )..add(CheckUserLoggedInEvent()),
    ),
    BlocProvider(
      create: (context) => ContactBloc(
        contactRepository: ContactRepoImpl(
          contactData: ContactData(),
          firebaseFirestore: FirebaseFirestore.instance,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => MessageBloc(
        messageRepository: MessageRepoImpl(
          messageData: MessageData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
        ),
        chatRepo: ChatRepoImpl(
          chatData: ChatData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
          firebaseAuth: firebaseAuth,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => UserBloc(
        firebaseAuth: FirebaseAuth.instance,
        userRepository: UserRepositoryImpl(
          userData: UserData(
            authenticationRepo: AuthenticationRepoImpl(
              firebaseAuth: firebaseAuth,
            ),
            fireBaseAuth: firebaseAuth,
            firestore: fireStore,
            firebaseStorage: firebaseStorage,
          ),
        ),
      )..add(GetCurrentUserData()),
    ),
    BlocProvider(
      create: (context) => ChatBloc(
        chatRepo: ChatRepoImpl(
          chatData: ChatData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
          firebaseAuth: firebaseAuth,
        ),
      )..add(GetAllChatsEvent()),
    ),
    BlocProvider(
      create: (context) => GroupBloc(
        groupRepository: GroupRepoImpl(
          groupData: GroupData(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: fireStore,
          ),
        ),
      )..add(GetAllGroupsEvent()),
    ),
    BlocProvider(
      create: (context) => StatusBloc(
        statusRepository: StatusRepositoryImpl(
          statusData: StatusData(
            firebaseFireStore: fireStore,
            fireBaseAuth: firebaseAuth,
            fireBaseStorage: firebaseStorage,
          ),
        ),
      )..add(StatusLoadEvent()),
    ),
    BlocProvider(
      create: (context) => BroadcastBloc(
        broadcastRepository: BrocastRepositoryImpl(
          broadcastData: BroadcastData(
            firebaseAuthentication: firebaseAuth,
            firebaseFireStore: fireStore,
          ),
        ),
      ),
    ),
  ];
}

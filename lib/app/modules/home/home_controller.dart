import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_routes.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/call_model.dart';
import '../../data/models/status_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/status_repository.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final AuthRepository _authRepository = AuthRepository();
  final ChatRepository _chatRepository = ChatRepository();
  final UserRepository _userRepository = UserRepository();
  final CallRepository _callRepository = CallRepository();
  final StatusRepository _statusRepository = StatusRepository();

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxList<ChatModel> chatsList = <ChatModel>[].obs;
  RxList<CallModel> callHistory = <CallModel>[].obs;
  RxList<UserStatusModel> activeStatuses = <UserStatusModel>[].obs;
  RxList<UserModel> allContacts = <UserModel>[].obs;

  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    _initCurrentUser();
    _listenToStreams();
  }

  void _initCurrentUser() {
    final uid = _authRepository.currentUser?.uid;
    if (uid != null) {
      _userRepository.streamUser(uid).listen((user) {
        currentUser.value = user;
      });
      _userRepository.getAllUsersExcept(uid).listen((users) {
        allContacts.value = users;
      });
    }
  }

  void _listenToStreams() {
    final uid = _authRepository.currentUser?.uid;
    if (uid != null) {
      _chatRepository.getUserChats(uid).listen((chats) {
        chatsList.value = chats;
      });
      _callRepository.getCallHistory(uid).listen((calls) {
        callHistory.value = calls;
      });
      _statusRepository.getActiveStatuses().listen((statuses) {
        activeStatuses.value = statuses;
      });

      // Listen for incoming call events
      _callRepository.listenForIncomingCalls(uid).listen((incomingCall) {
        if (incomingCall != null) {
          if (incomingCall.callType == 'AUDIO') {
            Get.toNamed(AppRoutes.INCOMING_AUDIO_CALL, arguments: incomingCall);
          } else {
            Get.toNamed(AppRoutes.INCOMING_VIDEO_CALL, arguments: incomingCall);
          }
        }
      });
    }
  }

  void startNewChat(UserModel user) async {
    final uid = _authRepository.currentUser!.uid;
    final chatId = await _chatRepository.getOrCreateIndividualChat(uid, user.uid);
    Get.toNamed(AppRoutes.INDIVIDUAL_CHAT, arguments: {
      'chatId': chatId,
      'peerUser': user,
    });
  }

  void logout() async {
    await _authRepository.signOut();
    Get.offAllNamed(AppRoutes.WELCOME);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

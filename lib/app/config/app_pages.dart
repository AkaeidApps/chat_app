import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/views/create_profile_view.dart';
import '../modules/auth/views/email_login_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/auth/views/phone_login_view.dart';
import '../modules/auth/views/profile_photo_upload_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/welcome/welcome_binding.dart';
import '../modules/auth/welcome/welcome_view.dart';
import '../modules/call/call_binding.dart';
import '../modules/call/views/active_audio_call_view.dart';
import '../modules/call/views/active_video_call_view.dart';
import '../modules/call/views/call_history_details_view.dart';
import '../modules/call/views/group_video_call_view.dart';
import '../modules/call/views/incoming_audio_call_view.dart';
import '../modules/call/views/incoming_video_call_view.dart';
import '../modules/call/views/outgoing_audio_call_view.dart';
import '../modules/call/views/outgoing_video_call_view.dart';
import '../modules/chat/chat_binding.dart';
import '../modules/chat/views/create_group_view.dart';
import '../modules/chat/views/forward_message_view.dart';
import '../modules/chat/views/group_chat_view.dart';
import '../modules/chat/views/group_info_view.dart';
import '../modules/chat/views/individual_chat_view.dart';
import '../modules/chat/views/message_search_view.dart';
import '../modules/chat/views/shared_media_view.dart';
import '../modules/chat/views/starred_messages_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/views/calls_tab_view.dart';
import '../modules/home/views/contacts_view.dart';
import '../modules/home/views/home_dashboard_view.dart';
import '../modules/home/views/new_conversation_view.dart';
import '../modules/home/views/search_users_view.dart';
import '../modules/home/views/profile_view.dart';
import '../modules/media/views/camera_view.dart';
import '../modules/media/views/document_picker_view.dart';
import '../modules/media/views/file_details_view.dart';
import '../modules/media/views/image_preview_view.dart';
import '../modules/media/views/media_gallery_view.dart';
import '../modules/media/views/video_preview_view.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/status/status_binding.dart';
import '../modules/status/views/create_media_status_view.dart';
import '../modules/status/views/create_text_status_view.dart';
import '../modules/status/views/my_status_view.dart';
import '../modules/status/views/status_viewer_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.SPLASH;

  static final routes = <GetPage<dynamic>>[
    GetPage(
        name: AppRoutes.SPLASH,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(name: AppRoutes.ONBOARDING, page: () => const OnboardingView()),
    GetPage(
        name: AppRoutes.WELCOME,
        page: () => const WelcomeView(),
        binding: WelcomeBinding()),
    GetPage(
        name: AppRoutes.PHONE_LOGIN,
        page: () => const PhoneLoginView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.EMAIL_LOGIN,
        page: () => const EmailLoginView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.REGISTER,
        page: () => const RegisterView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.OTP_VERIFICATION,
        page: () => const OtpVerificationView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.FORGOT_PASSWORD,
        page: () => const ForgotPasswordView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.CREATE_PROFILE,
        page: () => const CreateProfileView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.PROFILE_PHOTO_UPLOAD,
        page: () => const ProfilePhotoUploadView(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.HOME,
        page: () => const HomeDashboardView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.CONTACTS,
        page: () => const ContactsView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.SEARCH_USERS,
        page: () => const SearchUsersView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.NEW_CONVERSATION,
        page: () => const NewConversationView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.INDIVIDUAL_CHAT,
        page: () => const IndividualChatView(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.GROUP_CHAT,
        page: () => const GroupChatView(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.CREATE_GROUP,
        page: () => const CreateGroupView(),
        binding: HomeBinding()),
    GetPage(name: AppRoutes.GROUP_INFO, page: () => const GroupInfoView()),
    GetPage(
        name: AppRoutes.FORWARD_MESSAGE,
        page: () => const ForwardMessageView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.MESSAGE_SEARCH,
        page: () => const MessageSearchView(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.SHARED_MEDIA,
        page: () => const SharedMediaView(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.STARRED_MESSAGES,
        page: () => const StarredMessagesView(),
        binding: HomeBinding()),
    GetPage(name: AppRoutes.CAMERA, page: () => const CameraView()),
    GetPage(
        name: AppRoutes.IMAGE_PREVIEW, page: () => const ImagePreviewView()),
    GetPage(
        name: AppRoutes.VIDEO_PREVIEW, page: () => const VideoPreviewView()),
    GetPage(
        name: AppRoutes.DOCUMENT_PICKER,
        page: () => const DocumentPickerView()),
    GetPage(
        name: AppRoutes.MEDIA_GALLERY, page: () => const MediaGalleryView()),
    GetPage(name: AppRoutes.FILE_DETAILS, page: () => const FileDetailsView()),
    GetPage(
        name: AppRoutes.INCOMING_AUDIO_CALL,
        page: () => const IncomingAudioCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.OUTGOING_AUDIO_CALL,
        page: () => const OutgoingAudioCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.ACTIVE_AUDIO_CALL,
        page: () => const ActiveAudioCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.INCOMING_VIDEO_CALL,
        page: () => const IncomingVideoCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.OUTGOING_VIDEO_CALL,
        page: () => const OutgoingVideoCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.ACTIVE_VIDEO_CALL,
        page: () => const ActiveVideoCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.GROUP_VIDEO_CALL,
        page: () => const GroupVideoCallView(),
        binding: CallBinding()),
    GetPage(
        name: AppRoutes.CALL_HISTORY_DETAILS,
        page: () => const CallHistoryDetailsView()),
    GetPage(
        name: AppRoutes.CALLS,
        page: () => const CallsTabView(),
        binding: HomeBinding()),
    GetPage(name: AppRoutes.MY_STATUS, page: () => const MyStatusView()),
    GetPage(
        name: AppRoutes.CREATE_TEXT_STATUS,
        page: () => const CreateTextStatusView(),
        binding: StatusBinding()),
    GetPage(
        name: AppRoutes.CREATE_IMAGE_STATUS,
        page: () => const CreateMediaStatusView(),
        binding: StatusBinding()),
    GetPage(
        name: AppRoutes.CREATE_VIDEO_STATUS,
        page: () => const CreateMediaStatusView(isVideo: true),
        binding: StatusBinding()),
    GetPage(
        name: AppRoutes.STATUS_VIEWER,
        page: () => const StatusViewerView(),
        binding: StatusBinding()),
    GetPage(
        name: AppRoutes.MY_PROFILE,
        page: () => const ProfileView(),
        binding: HomeBinding()),
  ];
}

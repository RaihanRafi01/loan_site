class Api {
  /// base url
  static const baseUrl = "http://206.162.244.150:7100";
  static const baseUrlApi = "$baseUrl/api/v1";
  static const baseUrlPicture = baseUrl;
  static const deepLink = '$baseUrl/deeplink/post/view';

  static String getBaseUrlWithoutProtocol() {
    return baseUrl.replaceFirst('http://', '');
  }

  static String wsBaseUrl() => 'ws://${getBaseUrlWithoutProtocol()}';


  //static const socket = "https://socket.thirdshotslot.co.uk/";    /// https://a82e3d99df4f.ngrok-free.app   /// http://10.10.13.73:7000/api/v1


  ///auth
  static const signup = "$baseUrlApi/accounts/signup/";     //done
  static const login = "$baseUrlApi/accounts/login/";    //done
  static const socialAuth = "$baseUrlApi/accounts/social-signup-signin/";
  static const logout = "$baseUrlApi/accounts/logout/";    // done
  static const verifyOtp = "$baseUrlApi/accounts/activate/";    //done
  static const resendOtp = "$baseUrlApi/accounts/resend-otp/";    //done
  static const resetPasswordRequest = "$baseUrlApi/accounts/pass-reset-request/";    //done
  static const resetPasswordActivate = "$baseUrlApi/accounts/reset-request-activate/";     //done
  static const resetPassword = "$baseUrlApi/accounts/reset-password/";     //done
  static const createToken = "$baseUrlApi/accounts/custom-token-refresh/";   // done
  static const profileChangePassword = "$baseUrlApi/accounts/profile/change-password/";   // done
  static const profileUpdate = "$baseUrlApi/accounts/profile/update/";   // done
  static const getProfile = "$baseUrlApi/accounts/profile/";   // done

  static const sendHelp = "$baseUrlApi/setting/get-post-put/support/";   // done
  /// Project

  static const createProject = "$baseUrlApi/project/create/";   // done
  static  setProjectMilestone(project_id) => "$baseUrlApi/project/set-milestone/$project_id/";   // done
  static const getAllProject = "$baseUrlApi/project/list/all/";   // done
  static  projectDetails(project_id) => "$baseUrlApi/project/details/$project_id/";   // done

  static  startMilestone(project_id) => "$baseUrlApi/project/milestone/get-post/$project_id/";

  static uploadMilestonePhoto(project_id,milestone_id) => "$baseUrlApi/project/milestone-complete-chatbot/$project_id/$milestone_id/";

  static  getContractors(milestone_id) => "$baseUrlApi/project/get_contractors/?milestone_id=$milestone_id";

  /// lender project

  static const getLenderDashboardData = "$baseUrlApi/dashboard/data/";  //done
  static const getLenderProjects = "$baseUrlApi/dashboard/projects/";  //done

  /// community
  static const createPost = "$baseUrlApi/community/posts/";  //done

  static const myPosts = "$baseUrlApi/community/posts/my/"; //done
  static const allPosts = "$baseUrlApi/community/posts/"; //done

  static likePost(post_id) => "$baseUrlApi/community/posts/$post_id/like/"; // done

  static likeComment(comment_id) => "$baseUrlApi/community/comments/$comment_id/like/"; // working

  static createComment(post_id) => "$baseUrlApi/community/posts/$post_id/comments/";  // done
  static commentReplies(comment_id) => "$baseUrlApi/community/comments/$comment_id/reply/"; // done

  static fetchPost(post_id) => "$baseUrlApi/community/posts/$post_id/"; // done

  static String notInterestedPost(String postId) => '$baseUrlApi/community/posts/$postId/not-interested/';

  static updatePost(postId) => '$baseUrlApi/community/posts/$postId/';



  /// chat

  static const chatAssistant = '$baseUrlApi/project/ai-assistant/';
  static const chatHistory = '$baseUrlApi/project/ai-assistant/';
  static const createChatRoom = '$baseUrlApi/chat/direct-message/';




  static const getAllUsers = '$baseUrlApi/chat/all-users/';
  static const createGroup = '$baseUrlApi/chat/rooms/';

  static const getChatRooms = '$baseUrlApi/chat/rooms/';
  static setChatRoomRead(room_id) => '$baseUrlApi/chat/rooms/$room_id/mark-read/';

  /// notification

  static const registerDeviceToken = '$baseUrlApi/notification/register_unregister_device_token/';
  static const updateNotificationPreference = '$baseUrlApi/notification/notification_settings/update/';

  static const getNotifications = '$baseUrlApi/notification/get_notification/';
  static markNotificationRead(notification_id) => '$baseUrlApi/notification/mark_notification_as_read/$notification_id/';
  static deleteNotification(notification_id) => '$baseUrlApi/notification/delete_notification/$notification_id/';
  static const deleteAllNotifications = '$baseUrlApi/notification/delete_all_notifications/';
  /// chat

  static const getActiveUsers = '$baseUrlApi/chat/active-users/';
  static getMessages(room_id) => '$baseUrlApi/chat/rooms/$room_id/messages/';

}
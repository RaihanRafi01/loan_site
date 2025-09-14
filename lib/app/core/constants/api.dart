class Api {
  /// base url

  static const baseUrl = "http://10.10.13.73:7000/api/v1";
  static const baseUrlPicture = "http://10.10.13.73:7000";
  //static const socket = "https://socket.thirdshotslot.co.uk/";


  ///auth
  static const signup = "$baseUrl/accounts/signup/";     //done
  static const login = "$baseUrl/accounts/login/";    //done
  static const socialAuth = "$baseUrl/accounts/social-signup-signin/";
  static const logout = "$baseUrl/accounts/logout/";    // done
  static const verifyOtp = "$baseUrl/accounts/activate/";    //done
  static const resendOtp = "$baseUrl/accounts/resend-otp/";    //done
  static const resetPasswordRequest = "$baseUrl/accounts/pass-reset-request/";    //done
  static const resetPasswordActivate = "$baseUrl/accounts/reset-request-activate/";     //done
  static const resetPassword = "$baseUrl/accounts/reset-password/";     //done
  static const createToken = "$baseUrl/accounts/custom-token-refresh/";   // done
  static const profileChangePassword = "$baseUrl/accounts/profile/change-password/";   // done
  static const profileUpdate = "$baseUrl/accounts/profile/update/";   // done
  static const getProfile = "$baseUrl/accounts/profile/";   // done

  /// Project

  static const createProject = "$baseUrl/project/create/";   // done
  static  setProjectMilestone(project_id) => "$baseUrl/project/set-milestone/$project_id/";   // done
  static const getAllProject = "$baseUrl/project/list/all/";   // done
  static  projectDetails(project_id) => "$baseUrl/project/details/$project_id/";   // done

  static  startMilestone(project_id) => "$baseUrl/project/milestone/get-post/$project_id/";

  static uploadMilestonePhoto(project_id,milestone_id) => "$baseUrl/project/milestone-complete-chatbot/$project_id/$milestone_id/";

  static  getContractors(milestone_id) => "$baseUrl/project/get_contractors/?milestone_id=$milestone_id";

  /// lender project

  static const getLenderDashboardData = "$baseUrl/dashboard/data/";  //done
  static const getLenderProjects = "$baseUrl/dashboard/projects/";  //done

  /// community
  static const createPost = "$baseUrl/community/posts/";  //done

  static const myPosts = "$baseUrl/community/posts/my/"; //done
  static const allPosts = "$baseUrl/community/posts/"; //done

  static likePost(post_id) => "$baseUrl/community/posts/$post_id/like/"; // done

  static likeComment(comment_id) => "$baseUrl/community/comments/$comment_id/like/"; // working

  static createComment(post_id) => "$baseUrl/community/posts/$post_id/comments/";  // done
  static commentReplies(comment_id) => "$baseUrl/community/comments/$comment_id/reply/"; // done

  /// chat

  static const chatAssistant = '$baseUrl/project/ai-assistant/';
  static const chatHistory = '$baseUrl/project/ai-assistant/';

  /// notification

  static const registerDeviceToken = '$baseUrl/notification/register_unregister_device_token/';
}
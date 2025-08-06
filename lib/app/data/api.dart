class Api {
  /// base url

  static const baseUrl = "http://10.10.13.73:7000/api/v1";
  //static const socket = "https://socket.thirdshotslot.co.uk/";


  ///auth
  static const signup = "$baseUrl/accounts/signup/";//done
  static const login = "$baseUrl/accounts/login/";
  static const socialAuth = "$baseUrl/accounts/social-signup-signin/";
  static const logout = "$baseUrl/logout/";
  static const verifyOtp = "$baseUrl/accounts/activate/"; //done
  static const resendOtp = "$baseUrl/accounts/resend-otp/"; //done
  static const resetPasswordRequest = "$baseUrl/accounts/pass-reset-request/"; //done
  static const resetPasswordActivate = "$baseUrl/accounts/reset-request-activate/"; //done
  static const resetPassword = "$baseUrl/accounts/reset-password/"; //done
  static const createToken = "$baseUrl/accounts/custom-token-refresh/"; // working



  /// posts
  static String categoryPosts(categoryId) => "$baseUrl/posts/category/$categoryId"; //done

}
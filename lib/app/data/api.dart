class Api {
  /// base url

  static const baseUrl = "http://10.10.13.73:7000/api/v1";
  //static const socket = "https://socket.thirdshotslot.co.uk/";


  ///auth
  static const signup = "$baseUrl/accounts/signup/";//done
  static const login = "$baseUrl/accounts/login/";



  /// posts
  static String categoryPosts(categoryId) => "$baseUrl/posts/category/$categoryId"; //done

}
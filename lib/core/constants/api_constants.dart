class ApiConstants {
  static const String baseUrl = "https://501wk9nr-8086.asse.devtunnels.ms/api/v1";
  static const String imageBaseUrl = "https://501wk9nr-8086.asse.devtunnels.ms/uploads/";

  // static const String baseUrl = "http://10.10.11.90:8085/api/v1";
  // static const String imageBaseUrl = "http://10.10.11.90:8086/uploads/";

  static const String signInEndPoint = "/auth/login";
  static const String forgotPasswordPoint = "/auth/forgot-password";
  static const String verifyEmailEndPoint = "/auth/verify-email";
  static const String resendOtpEndPoint = "/auth/resend-otp";
  static const String setPasswordEndPoint = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String logoutEndPoint = "/auth/logout";
  static const String updateProfileEndPoint = "/user/me";

  static const String merchandiserVisits = "/visit/merchandiser";
  static const String productEndPoint = "/product";
  static const String orderEndPoint = "/order";
  static const String storeReportQuestions = "/store-report-question?limit=1000";
  static const String uploadMultiple = "/upload/multiple";
  static const String notificationEndPoint = "/notification";
  static String settingContent(String key) => "/setting/$key";
  static const String warehouseDashboard = "/dashboard/wa";
  static const String driverDashboard = "/dashboard/driver";
  static String getOrderById(String orderId) => "/order/$orderId";
  static String manageReturns(String orderId) => "/order/$orderId/manage-returns";
  static String packOrder(String orderId) => "/order/$orderId/pack";
  static String deliverOrder(String orderId) => "/order/$orderId/deliver";
  static String completeOrder(String orderId) => "/order/$orderId/complete";
  static String submitReport(String visitId) => "/visit/$visitId/submit-report";
  static String visitClockIn(String visitId) => "/visit/$visitId/clock-in";
  static String visitClockOut(String visitId) => "/visit/$visitId/clock-out";
  static String visitReschedule(String visitId) => "/visit/$visitId/submit-reschedule";
}

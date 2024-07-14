class Constants {
  static const String accessToken = "access_token";
  static const String idToken = "id_token";
  static const String refreshToken = "refresh_token";
  static const String refreshTokenExpiresIn = "refresh_token_expires_in";
  static const String expiresIn = "expires_in";
  static const String authCode = "code";

  static const String tokenUrl =
      'https://login.microsoftonline.com/tenant.onmicrosoft.com/oauth2/v2.0/token';
  static const String policyTokenUrl =
      'https://login.microsoftonline.com/tenant.onmicrosoft.com/oauth2/v2.0/token?p=';

  static const String defaultGrantType = "authorization_code";
  static const String defaultCodeChallengeCode = "S256";
  static const defaultResponseType = "code";
  static const String redirectUrl = "customscheme://login";
  static const String clientId = "852c72f6-693f-4017-a1c6-4127502a1b17";
  static const String tenantId = "8200d982-c551-4dd5-8dc7-2d649035f4f3";
  static const String tenantUrl = "https://login.microsoftonline.com/$tenantId";
  static const String userFlowUrlEnding = "oauth2/v2.0/authorize";
  static const String userGetTokenUrlEnding = "oauth2/v2.0/token";
  static const String defaultScopes =
      '852c72f6-693f-4017-a1c6-4127502a1b17/.default offline_access'; //'openid profile offline_access';
  static const String errorToken = "error acquiring token";
  static const String blankEncodedHtml = "%20";

  static const baseUriDev = "http://10.0.2.2:8080";
  static const baseUri = "https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443";
  static const databaseName = "mianddes_database";

  static const String ACTIVITY_PARENT_BEFORE = "BEFORE";
  static const String ACTIVITY_PARENT_FIRST_DAY = "FIRST_DAY";
  static const String ACTIVITY_PARENT_FIRST_WEEK = "FIRST_WEEK";

  static const String ACTIVITY_CEO_PRESENTATION = "CEO_PRESENTATION";
  static const String ACTIVITY_COMPLETE_PROFILE = "COMPLETE_PROFILE";
  static const String ACTIVITY_FIRST_DAY_INFORMATION = "FIRST_DAY_INFORMATION";
  static const String ACTIVITY_KNOW_YOUR_TEAM = "KNOW_YOUR_TEAM";
  static const String ACTIVITY_ON_SITE_INDUCTION = "ON_SITE_INDUCTION";
  static const String ACTIVITY_REMOTE_INDUCTION = "REMOTE_INDUCTION";
  static const String ACTIVITY_INDUCTION_ELEARNING = "INDUCTION_ELEARNING";

  static const String ELEARNING_CONTENT_CARD_TYPE_QUESTION="QUESTION";
  static const String ELEARNING_CONTENT_CARD_TYPE_TEXT="TEXT";
}

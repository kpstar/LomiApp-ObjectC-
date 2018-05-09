//
//  CConstant.h
//
//  Created by apple on 9/7/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AVATAR_WIDTH                    200
#define AVATAR_HEIGHT                   200

#define LUNIT_CENTIMETRS                0
#define LUNIT_INCHES                    1
#define LUNIT_FEETS                     2

#define WUNIT_POUNDS                    0
#define WUNIT_KILOGRAMS                 1

#define UNIT_IMPERAIL                   0
#define UNIT_CENTIMETER                 1

#define LAN_ENGLISH                     0
#define LAN_ARABIC                      1

#define MEALTYPE_BREAKFAST              1
#define MEALTYPE_LUNCH                  2
#define MEALTYPE_DINNER                 3
#define MEALTYPE_MORNINGSNACK           4
#define MEALTYPE_AFTERNOONSNACK         5
#define MEALTYPE_EVENINGSNACK           6

#define APP_VERSION                     2.6

//--------------------------------  CometChat  ------------------------------------------------

#define COMETCHAT_SITEURL               @"http://test.lomi-app.com/cometchat/"
#define COMETCHAT_LICENCEKEY            @"S2RCC-I5EWU-CX4MN-QGND2-PA2NL"
#define COMETCHAT_APIKEY                @"224900d7c89dff0233b863fbb175b1a5"

//--------------------------------  NOTIFICATIONS  ---------------------------------------------


#define NOTIFICATION_MESSAGENEW         @"message_new"
#define NOTIFICATION_PHOTOAPPROVED      @"nutritionist_photo_approved"
#define NOTIFICATION_PHOTOCOMMENT       @"nutritionist_photo_comment"
#define NOTIFICATION_SHCEDULECREATED    @"schedule_created"
#define NOTIFICATION_SCHEDULEEDITED     @"schedule_edited"
#define NOTIFICATION_EXPIRATIONNOTICE   @"expiration_notice"
#define NOTIFICATION_MEASUREMENTSWEEKLYNOTICE   @"measurements_weekly_notice"
#define NOTIFICATION_QUESTIONNAIRE      @"questionnaire_notice"

//--------------------------------  PREFERENCE  ---------------------------------------------

#define PREF_ISFIRSTRUN                 @"PREF_ISFIRTSRUN"
#define PREF_CURSTATE                   @"PREF_CURSTATE"
#define PREF_LANGUAGE                   @"PREF_LANGUAGE"
#define PREF_EMAIL                      @"PREF_EMAIL"
#define PREF_PASSWORD                   @"PREF_PASSWORD"
#define PREF_USERMODEL                  @"PREF_USERMODEL"
#define PREF_TIMEZONE                   @"PREF_TIMEZONE"
#define PREF_EXTENDEDMESSAGETIME        @"PREF_EXTENDEDMESSAGETIME"

//-----------------------------------   API ---------------------------------------------

//#define API_NOR_APIKEY                  @"Jc,$?7SXAzFU"
//#define API_NOR_SECRETKEY               @"B][UkP0[)o8T"
#define API_NOR_APIKEY                  @"9hfHau$Vg6ry"
#define API_NOR_SECRETKEY               @"2(!eDNvflmBV"
#define API_NOR_FBTYPE                  @"facebook"
#define API_NOR_TWTYPE                  @"twitter"
#define API_URL_BASE                    @"https://test2.lomi-app.com/socialapi/"
//#define API_URL_BASE                    @"https://www.lomi-app.com/socialapi/"
//Auth
#define API_URL_LOGIN                   @"auth/post/login"
#define API_URL_LOGOUT                  @"auth/get/logout"
#define API_URL_SIGNUP                  @"auth/post/signup"
#define API_URL_CHECKEMAIL              @"auth/get/checkEmail"
#define API_URL_CHECKSOCIALEXIST        @"auth/get/socialExist"
#define API_URL_FORGOTPASS              @"auth/get/forgetPassword"
#define API_URL_GETCOUNTRIES            @"auth/get/countries"
#define API_URL_SOCIALSIGNIN            @"auth/post/socialLogin" //Facebook, Twitter Signin
#define API_URL_SOCIALSYNC              @"auth/post/socialSync"  //Facebook, Twitter SignUp+Sync

//Questioners
#define API_URL_QUESTIONERS             @"member/post/profile"
//User Profile
#define API_URL_PROFILETYPES            @"auth/get/profileTypes"
#define API_URL_PROFILEFIELDS           @"auth/get/profileFields"
#define API_URL_PROFILEADDRESS          @"auth/get/profileAddress"
#define API_URL_EDITPROFILE             @"member/post/profile"
#define API_URL_USERPROFILE             @"member/get/profile"
#define API_URL_GETUSERPROFILEPHOTO     @"auth/get/defaultPhoto"
#define API_URL_SETUSERPROFILEPHOTO     @"member/post/profilePhoto"
#define API_URL_REMOVEUSERPROFILEPHOTO  @"member/put/removePhoto"
//Mobile Settings
#define API_URL_GETMOBILESETTINGS       @"settings/get/mobile"
#define API_URL_EDITMOBILESETTINGS      @"settings/post/mobile"
//User Language Settings
#define API_URL_GETLANBYTYPE            @"settings/get/languageTypes"
#define API_URL_GETUSERLAN              @"settings/get/language"
#define API_URL_EDITUSERLAN             @"settings/post/language"
//Nutritionists
#define API_URL_GETALLNUTRITIONISTS     @"nutritionists/get/listsNew"
#define API_URL_GETNUTRITIONISTMEMBERS  @"nutritionists/get/members"
#define API_URL_GETUSERNUTRITIONIST     @"nutritionists/get/user-nutritionist"
#define API_URL_NUTRITIONISTMEMBERSHIP  @"nutritionists/post/membership"
#define API_URL_RATENUTRITIONIST        @"nutritionists/post/rate"
#define API_URL_GETNUTCOUNTRIES         @"nutritionists/get/countries"

//Measurement
#define API_URL_GETUSERMEASUREMENTS     @"measurements/get/lists"
#define API_URL_ADDNEWMEASUREMENT       @"measurements/post/add"
#define API_URL_EDITMEASUREMENT         @"measurements/put/edit"
#define API_URL_DELETEMEASUREMENT       @"measurements/delete/del"
#define API_URL_GETLASTMEASUREMENT      @"measurements/get/last"
#define API_URL_GETWEIGHTS              @"measurements/get/weights"
//Diet Plans
#define API_URL_GETDIETPLANS            @"nutritionists/get/dietplans"
//Journal
#define API_URL_GETUSERPHOTOS           @"nutritionists/get/user-photos"
#define API_URL_GETAPPROVEDPHOTOS       @"nutritionists/get/approved-photos"
#define API_URL_POSTPHOTO               @"nutritionists/post/photo"
#define API_URL_GETCOMMENTS             @"nutritionists/get/comments"
#define API_URL_POSTCOMMENT             @"nutritionists/post/comment"
#define API_URL_DELETECOMMENT           @"nutritionists/delete/comment"
//Messages
#define API_URL_POSTMESSAGE             @"nutritionists/post/compose"
#define API_URL_GETCONVERSATIONS        @"nutritionists/get/conversation"
//Notifications
#define API_URL_GETNOTIFICATIONS        @"notifications/get/notifications"
#define API_URL_GETNOTIFICATIONTYPES    @"notifications/get/types"
#define API_URL_SETREADNOTIFICATION     @"notifications/post/read"
//Subscriptions
#define API_URL_GETUSERPLAN             @"subscriptions/get/userPlan/"
#define API_URL_GETSUBSCRIPTIONPLANS    @"subscriptions/get/plans"
#define API_URL_ADDUSERPAYMENT          @"subscriptions/post/addPayment"
#define API_URL_PROMOTIONCODECHECKING   @"subscriptions/get/checkCoupon"
#define API_URL_STARTPAYMENTPROCESS     @"subscriptions/post/paymentProcess"
#define API_URL_ADDNEWPAYMENT           @"subscriptions/post/addNewPayment"
//TimeZone
#define API_URL_GETUSERTIMEZONE         @"member/get/timezone"
#define API_URL_SETUSERTIMEZONE         @"member/post/timezone"
//Contact
#define API_URL_POSTCONTACT             @"member/post/contact"
//Coupon
#define API_URL_POSTCOUPON              @"member/post/couponCode"
//WirePayment
#define API_URL_POSTWIREPAYMENT         @"subscriptions/post/wirePayment"
//LastLogin
#define API_URL_POSTLASTLOGIN           @"member/post/lastLogin"

//StoreURL
#define API_URL_GETSTOREURL             @"settings/get/stores"

@interface CConstant : NSCoder


@end

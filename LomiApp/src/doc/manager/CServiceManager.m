//
//  CServiceManager.m
//
//  Created by apple on 9/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CServiceManager.h"
#import "AFNetworking.h"
#import "Appdelegate.h"
#import "CNutritionistModel.h"
#import "CGoalWeightModel.h"
#import "CDietPlanModel.h"
#import "CMessageModel.h"
#import "CJournalSearchModel.h"
#import "CProfileFieldModel.h"
#import "CNotificationModel.h"
#import "CPaymentPlanModel.h"
#import "CVCMessageViewController.h"

@implementation CServiceManager

+ (void) onGetStoreURL
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETSTOREURL];
    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSDictionary* dicStores = [responseObject objectForKey:@"stores"];
         NSString* strURL = [dicStores objectForKey:@"apple"];
         g_strStoreURL = strURL;
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         g_strStoreURL = @"https://itunes.apple.com/us/app/lomiapp/id1190919287?ls=1&mt=8";
     }];
}

+ (void) onGetUserCountryList
{
    NSString *strLan = [CPreferenceManager loadLanguage];
    if (strLan == nil)
        strLan = @"en";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"language":strLan};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETCOUNTRIES];
    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         
         NSArray *keys = [[responseObject allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
         NSArray *values = [responseObject objectsForKeys:keys notFoundMarker:@""];
         
         g_arrCountryCode = [NSMutableArray arrayWithArray:keys];
         g_arrCountryFullName = [NSMutableArray arrayWithArray:values];
         
         [g_arrCountryCode removeObjectAtIndex:0];
         [g_arrCountryFullName removeObjectAtIndex:0];
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         
     }];

}

+ (void) onGetNutCountryList
{
    NSString *strLan = [CPreferenceManager loadLanguage];
    if (strLan == nil)
        strLan = @"en";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"language":strLan};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETNUTCOUNTRIES];
    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSArray *keys = [[responseObject allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
         NSArray *values = [responseObject objectsForKeys:keys notFoundMarker:@""];
         
         g_arrNutCountryCode = [NSMutableArray arrayWithArray:keys];
         g_arrNutCountryFullName = [NSMutableArray arrayWithArray:values];
         
         [g_arrNutCountryCode removeObjectAtIndex:0];
         [g_arrNutCountryFullName removeObjectAtIndex:0];
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         
     }];
}


+ (void) onLoginUser:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"language":strLan,
                                @"deviceType":@"ios",
                                @"deviceToken":g_strDeviceToken};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_LOGIN];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {

        if ([responseObject objectForKey:@"maintenanceMode"])
        {
            g_strMaintainance = [responseObject objectForKey:@"message"];
            [CGlobal goMaintainance:mVCPage];
            return;
        }
    
        NSString* status = [responseObject objectForKey:@"status"];
     
        if (status == nil || [status isEqual:[NSNull null]])
        {
            g_bIsPackageIdle = true;

//            if (g_pUserModel != nil)
//                [g_pUserModel deleteAll];
//            g_pUserModel = nil;

            if (g_pUserModel == nil)
                g_pUserModel = [[CUserModel alloc] init];
            
            g_pUserModel.strEmail = g_strEmail;
            g_pUserModel.strPassword = g_strPassword;

            [mVCPage onAPISuccess:type result:nil];
            return;
        }
     
        BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
        NSString *message = [responseObject objectForKey:@"message"];

        if(bStatus == true)
        {
//            if (g_pUserModel != nil)
//                [g_pUserModel deleteAll];
//            g_pUserModel = nil;

            if (g_pUserModel == nil)
                g_pUserModel = [[CUserModel alloc] init];
     
            g_pUserModel.strEmail = g_strEmail;
            g_pUserModel.strPassword = g_strPassword;
            
            NSDictionary* user = [responseObject objectForKey:@"user"];
            g_pUserModel.nUserID = [[user objectForKey:@"userId"] integerValue];
            g_pUserModel.strUserName = [user objectForKey:@"username"];
            g_pUserModel.strThumbnail = [user objectForKey:@"thumbnail"];
            g_pUserModel.strUserToken = [user objectForKey:@"userToken"];
            
            [mVCPage onAPISuccess:type result:message];
        }
        else
        {
            [mVCPage onAPIFail:type result:message];
        }
        
    } failure:^(NSURLSessionTask * task, NSError * error)
    {
        [mVCPage onAPIFail:type result:nil];
    }];
}

+ (void) onLogout:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_LOGOUT];

    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         
         if(bStatus == true)
         {
             if (mVCPage != nil)
                 [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             if (mVCPage != nil)
                 [mVCPage onAPIFail:type result:message];
         }

    
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onSignup:(const CUIViewController*) mVCPage  type:(int)type
{

    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"29e450ad-e196-f9b5-0a2a-0a34810457dd" };
    
    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    NSString*   email = [NSString stringWithFormat:@"&email=%@", g_pUserModel.strEmail];
    NSString*   profileAddress = [NSString stringWithFormat:@"&profileAddress=%@", g_pUserModel.strProfileAddress];
    NSString*   password = [NSString stringWithFormat:@"&password=%@", g_pUserModel.strPassword];
    NSString*   profileType = [NSString stringWithFormat:@"&profileType=%@", g_pUserModel.strProfileType];
    NSString*   profileFields1_410_95 = [NSString stringWithFormat:@"&profileFields[1_410_95]=%@", g_pUserModel.strFirstName];
    NSString*   profileFields1_410_96 = [NSString stringWithFormat:@"&profileFields[1_410_96]=%@", g_pUserModel.strLastName];
    NSString*   profileFields1_410_97 = [NSString stringWithFormat:@"&profileFields[1_410_97]=%@", g_pUserModel.strGenderMale];
    NSString*   profileFields1_410_110 = [NSString stringWithFormat:@"&profileFields[1_410_110]=%@", g_pUserModel.strBirthday];
    NSString*   profileFields1_410_111 = [NSString stringWithFormat:@"&profileFields[1_410_111]=%@", g_pUserModel.strCountryCode];
    NSString*   profileFields1_410_120 = [NSString stringWithFormat:@"&profileFields[1_410_120]=%@", g_pUserModel.strTelephone];
    NSString*   deviceType = [NSString stringWithFormat:@"&deviceType=%@", @"ios"];
    NSString*   deviceToken = [NSString stringWithFormat:@"&deviceToken=%@", g_strDeviceToken];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileAddress dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_95 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_96 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_97 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_110 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_111 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_120 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SIGNUP];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        if ([json objectForKey:@"maintenanceMode"])
                                                        {
                                                            g_strMaintainance = [json objectForKey:@"message"];
                                                            [CGlobal goMaintainance:mVCPage];
                                                            return;
                                                        }
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
                                                        NSString *message = [json objectForKey:@"message"];
                                                        if(bStatus == true)
                                                        {
                                                            //g_pUserModel.strUserID = [responseObject objectForKey:@"userId"];
                                                            
                                                            NSDictionary * pUser = [json objectForKey:@"user"];
                                                            g_pUserModel.strSubPackageDescription = [pUser objectForKey:@"subscriptionPackageDescription"];
                                                            g_pUserModel.strSubPackageExpDate = [pUser objectForKey:@"subscriptionPackageExpirationDate"];
                                                            g_pUserModel.nSubPackageID = [[pUser objectForKey:@"subscriptionPackageID"] integerValue];
                                                            g_pUserModel.strSubPackageTitle = [pUser objectForKey:@"subscriptionPackageTitle"];
                                                            g_pUserModel.strThumbnail = [pUser objectForKey:@"thumbnail"];
                                                            g_pUserModel.nUserID = [[pUser objectForKey:@"userId"] integerValue];
                                                            g_pUserModel.strUserToken = [pUser objectForKey:@"userToken"];
                                                            g_pUserModel.strUserName = [pUser objectForKey:@"username"];
                                                            [mVCPage onAPISuccess:type result:message];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:message];
                                                        }
                                                    }
                                                }];
    [dataTask resume];

/*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
     manager.securityPolicy.allowInvalidCertificates = YES;
     manager.securityPolicy.validatesDomainName = NO;
     
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_pUserModel.strEmail,
                                @"password":g_pUserModel.strPassword,
                                @"profileAddress":g_pUserModel.strProfileAddress,
                                @"profileType":g_pUserModel.strProfileType,
                                @"profileFields['1_410_95']":g_pUserModel.strFirstName,
                                @"profileFields['1_410_96']":g_pUserModel.strLastName,
                                @"profileFields['1_410_97']":g_pUserModel.strGenderMale,
                                @"profileFields['1_410_110']":g_pUserModel.strBirthday,
                                @"profileFields['1_410_111']":g_pUserModel.strCountryCode};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SIGNUP];
 
//    NSString *strURL = [NSString stringWithFormat:@"%@%@?apiKey=%@&secretKey=%@&email=%@&profileAddress=%@&password=%@&profileType=%@&profileFields['1_410_95']=%@&profileFields['1_410_96']=%@&profileFields['1_410_97']=%@&profileFields['1_410_110']=%@&profileFields['1_410_111']=%@", API_URL_BASE, API_URL_SIGNUP, API_NOR_APIKEY, API_NOR_SECRETKEY, g_pUserModel.strEmail, g_pUserModel.strProfileAddress, g_pUserModel.strPassword, g_pUserModel.strProfileType, g_pUserModel.strFirstName, g_pUserModel.strLastName, g_pUserModel.strGenderMale, g_pUserModel.strBirthday, g_pUserModel.strCountryCode];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
 
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//
//        
//        return parameters;
//    }];


//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
//                                                            diskCapacity:0
//                                                                diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
    
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary* json = responseObject;
 
         if(json != nil)
         {
             BOOL bStatus = [[json objectForKey:@"status"] boolValue];
             NSString *message = [json objectForKey:@"message"];

             if(bStatus == true)
             {
                 //g_pUserModel.strUserID = [responseObject objectForKey:@"userId"];

                 NSDictionary * pUser = [json objectForKey:@"user"];
                 g_pUserModel.strSubPackageDescription = [pUser objectForKey:@"subscriptionPackageDescription"];
                 g_pUserModel.strSubPackageExpDate = [pUser objectForKey:@"subscriptionPackageExpirationDate"];
                 g_pUserModel.nSubPackageID = [[pUser objectForKey:@"subscriptionPackageID"] integerValue];
                 g_pUserModel.strSubPackageTitle = [pUser objectForKey:@"subscriptionPackageTitle"];
                 g_pUserModel.strThumbnail = [pUser objectForKey:@"thumbnail"];
                 g_pUserModel.nUserID = [[pUser objectForKey:@"userId"] integerValue];
                 g_pUserModel.strUserToken = [pUser objectForKey:@"userToken"];
                 g_pUserModel.strUserName = [pUser objectForKey:@"username"];
                 
                 [mVCPage onAPISuccess:type result:message];
             }
             else
             {
                 [mVCPage onAPIFail:type result:message];
             }
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
//         NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//         NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
         
         [mVCPage onAPIFail:type result:nil];
     }];
 */
}

+ (void) onSocialSignup:(const CUIViewController*) mVCPage  type:(int)type fb_uid:(NSString *)fb_uid
{
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"29e450ad-e196-f9b5-0a2a-0a34810457dd" };
    
    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    NSString*   email = [NSString stringWithFormat:@"&email=%@", g_pUserModel.strEmail];
    NSString*   profileAddress = [NSString stringWithFormat:@"&profileAddress=%@", g_pUserModel.strProfileAddress];
    NSString*   password = [NSString stringWithFormat:@"&password=%@", g_pUserModel.strPassword];
    NSString*   profileType = [NSString stringWithFormat:@"&profileType=%@", g_pUserModel.strProfileType];
    NSString*   profileFields1_410_95 = [NSString stringWithFormat:@"&profileFields[1_410_95]=%@", g_pUserModel.strFirstName];
    NSString*   profileFields1_410_96 = [NSString stringWithFormat:@"&profileFields[1_410_96]=%@", g_pUserModel.strLastName];
    NSString*   profileFields1_410_97 = [NSString stringWithFormat:@"&profileFields[1_410_97]=%@", g_pUserModel.strGenderMale];
    NSString*   profileFields1_410_110 = [NSString stringWithFormat:@"&profileFields[1_410_110]=%@", g_pUserModel.strBirthday];
    NSString*   profileFields1_410_111 = [NSString stringWithFormat:@"&profileFields[1_410_111]=%@", g_pUserModel.strCountryCode];
    NSString*   profileFields1_410_120 = [NSString stringWithFormat:@"&profileFields[1_410_120]=%@", g_pUserModel.strTelephone];
    NSString*   deviceType = [NSString stringWithFormat:@"&deviceType=%@", @"ios"];
    NSString*   deviceToken = [NSString stringWithFormat:@"&deviceToken=%@", g_strDeviceToken];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileAddress dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_95 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_96 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_97 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_110 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_111 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[profileFields1_410_120 dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SIGNUP];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
 
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        if ([json objectForKey:@"maintenanceMode"])
                                                        {
                                                            g_strMaintainance = [json objectForKey:@"message"];
                                                            [CGlobal goMaintainance:mVCPage];
                                                            return;
                                                        }
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
                                                        NSString *message = [json objectForKey:@"message"];
                                                        if(bStatus == true)
                                                        {
                                                            //g_pUserModel.strUserID = [responseObject objectForKey:@"userId"];
                                                            
                                                            NSDictionary * pUser = [json objectForKey:@"user"];
                                                            g_pUserModel.strSubPackageDescription = [pUser objectForKey:@"subscriptionPackageDescription"];
                                                            g_pUserModel.strSubPackageExpDate = [pUser objectForKey:@"subscriptionPackageExpirationDate"];
                                                            g_pUserModel.nSubPackageID = [[pUser objectForKey:@"subscriptionPackageID"] integerValue];
                                                            g_pUserModel.strSubPackageTitle = [pUser objectForKey:@"subscriptionPackageTitle"];
                                                            g_pUserModel.strThumbnail = [pUser objectForKey:@"thumbnail"];
                                                            g_pUserModel.nUserID = [[pUser objectForKey:@"userId"] integerValue];
                                                            g_pUserModel.strUserToken = [pUser objectForKey:@"userToken"];
                                                            g_pUserModel.strUserName = [pUser objectForKey:@"username"];
                                                            
                                                            NSString *nUserIDStr = [NSString stringWithFormat:@"%ld", [[pUser objectForKey:@"userId"] integerValue]];
                                                            [self onSocialSync:mVCPage type:type fbid:fb_uid userid:nUserIDStr];
                                                            
//                                                            [mVCPage onAPISuccess:type result:message];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:message];
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    
}

+ (void) onSocialSync:(const CUIViewController*) mVCPage  type:(int)type fbid:(NSString *)fb_uid userid:(NSString *)uid
{
    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"29e450ad-e196-f9b5-0a2a-0a34810457dd" };
    
    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    NSString*   facebook_uid = @"", *twitter_uid = @"", *twitter_token = @"", *twitter_secret = @"", *stype = @"";
    if (g_socialTypeFB == true) {
        stype = [NSString stringWithFormat:@"&type=%@", API_NOR_FBTYPE];
        facebook_uid = [NSString stringWithFormat:@"&facebook_uid=%@", fb_uid];
    } else {
        stype = [NSString stringWithFormat:@"&type=%@", API_NOR_TWTYPE];
        twitter_uid = [NSString stringWithFormat:@"&twitter_uid=%@", [g_twUserDic objectForKey:@"userID"]];
        twitter_token= [NSString stringWithFormat:@"&twitter_token=%@", [g_twUserDic objectForKey:@"authToken"]];
        twitter_secret = [NSString stringWithFormat:@"&twitter_secret=%@", [g_twUserDic objectForKey:@"authTokenSecret"]];
    }

    NSString*   deviceType = [NSString stringWithFormat:@"&deviceType=%@", @"ios"];
    NSString*   deviceToken = [NSString stringWithFormat:@"&deviceToken=%@", g_strDeviceToken];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];
//    [postData appendData:[uid dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[stype dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (g_socialTypeFB == true) {
        [postData appendData:[facebook_uid dataUsingEncoding:NSUTF8StringEncoding]];
    }else {
        [postData appendData:[twitter_uid dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[twitter_token dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[twitter_secret dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [postData appendData:[deviceType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SOCIALSYNC];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        if ([json objectForKey:@"maintenanceMode"])
                                                        {
                                                            g_strMaintainance = [json objectForKey:@"message"];
                                                            [CGlobal goMaintainance:mVCPage];
                                                            return;
                                                        }
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
                                                        NSString *message = [json objectForKey:@"message"];
                                                        if(bStatus == true)
                                                        {
                                                            NSDictionary * pUser = [json objectForKey:@"user"];
                                                            g_pUserModel.strThumbnail = [pUser objectForKey:@"thumbnail"];
                                                            g_pUserModel.nUserID = [[pUser objectForKey:@"userId"] integerValue];
                                                            g_pUserModel.strUserName = [pUser objectForKey:@"username"];
                                                            [mVCPage onAPISuccess:type result:message];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:message];
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

+ (void) onSocialSignin:(const CUIViewController*) mVCPage  type:(int)type id:(NSString *)fb_uid
{
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"29e450ad-e196-f9b5-0a2a-0a34810457dd" };
    
    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    
    NSString*   facebook_uid = @"", *twitter_uid = @"", *twitter_token = @"", *twitter_secret = @"", *stype = @"";
    if (g_socialTypeFB == true) {
        stype = [NSString stringWithFormat:@"&type=%@", API_NOR_FBTYPE];
        facebook_uid = [NSString stringWithFormat:@"&facebook_uid=%@", fb_uid];
    }else {
        stype = [NSString stringWithFormat:@"&type=%@", API_NOR_TWTYPE];
        twitter_uid = [NSString stringWithFormat:@"&twitter_uid=%@", [g_twUserDic objectForKey:@"userID"]];
        twitter_token= [NSString stringWithFormat:@"&twitter_token=%@", [g_twUserDic objectForKey:@"authToken"]];
        twitter_secret = [NSString stringWithFormat:@"&twitter_secret=%@", [g_twUserDic objectForKey:@"authTokenSecret"]];
    }

    NSString*   deviceType = [NSString stringWithFormat:@"&deviceType=%@", @"ios"];
    NSString*   deviceToken = [NSString stringWithFormat:@"&deviceToken=%@", g_strDeviceToken];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];

    [postData appendData:[stype dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (g_socialTypeFB == true) {
        [postData appendData:[facebook_uid dataUsingEncoding:NSUTF8StringEncoding]];
    }else {
        [postData appendData:[twitter_uid dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[twitter_token dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[twitter_secret dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [postData appendData:[deviceType dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SOCIALSIGNIN];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        if ([json objectForKey:@"maintenanceMode"])
                                                        {
                                                            g_strMaintainance = [json objectForKey:@"message"];
                                                            [CGlobal goMaintainance:mVCPage];
                                                            return;
                                                        }
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
                                                        NSString *message = [json objectForKey:@"message"];
                                                        if(bStatus == true)
                                                        {
                                                            //            if (g_pUserModel != nil)
                                                            //                [g_pUserModel deleteAll];
                                                            //            g_pUserModel = nil;
                                                            
                                                            if (g_pUserModel == nil)
                                                                g_pUserModel = [[CUserModel alloc] init];
                                                            
                                                            
                                                            
                                                            NSDictionary* user = [json objectForKey:@"user"];
                                                            g_pUserModel.strEmail = [user objectForKey:@"email"];;
                                                            g_pUserModel.strPassword = @"";
                                                            g_pUserModel.nUserID = [[user objectForKey:@"userId"] integerValue];
                                                            g_pUserModel.strUserName = [user objectForKey:@"username"];
                                                            g_pUserModel.strThumbnail = [user objectForKey:@"thumbnail"];
                                                            g_pUserModel.strUserToken = [user objectForKey:@"userToken"];
                                                            
                                                            [mVCPage onAPISuccess:type result:message];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:message];
                                                        }
//                                                        if(bStatus == true)
//                                                        {
//                                                            //g_pUserModel.strUserID = [responseObject objectForKey:@"userId"];
//
//                                                            NSDictionary * pUser = [json objectForKey:@"user"];
//                                                            g_pUserModel.strSubPackageDescription = [pUser objectForKey:@"subscriptionPackageDescription"];
//                                                            g_pUserModel.strSubPackageExpDate = [pUser objectForKey:@"subscriptionPackageExpirationDate"];
//                                                            g_pUserModel.nSubPackageID = [[pUser objectForKey:@"subscriptionPackageID"] integerValue];
//                                                            g_pUserModel.strSubPackageTitle = [pUser objectForKey:@"subscriptionPackageTitle"];
//                                                            g_pUserModel.strThumbnail = [pUser objectForKey:@"thumbnail"];
//                                                            g_pUserModel.nUserID = [[pUser objectForKey:@"userId"] integerValue];
//                                                            g_pUserModel.strUserToken = [pUser objectForKey:@"userToken"];
//                                                            g_pUserModel.strUserName = [pUser objectForKey:@"username"];
//                                                            [mVCPage onAPISuccess:type result:message];
//                                                        }
//                                                        else
//                                                        {
//                                                            [mVCPage onAPIFail:type result:message];
//                                                        }
                                                    }
                                                }];
    [dataTask resume];
}



+ (void) onEmailCheck:(const CUIViewController*) mVCPage
{
    NSString *strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"language":strLan};
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_CHECKEMAIL];
    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];

         if(bStatus == true)
         {
             [mVCPage onAPISuccess:0 result:message];
         }
         else
         {
             [mVCPage onAPIFail:0 result:message];
         }
         
     } failure:^(NSURLSessionTask * task, NSError * error)
     {

         [mVCPage onAPIFail:0 result:nil];
     }];

}

+ (void) onSocialExistCheck:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *socialType = @"facebook";
    if (g_socialTypeFB == true) {
        socialType = @"facebook";
    } else {
        socialType = @"twitter";
    }
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"type":socialType,
                                @"email":g_strEmail};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_CHECKSOCIALEXIST];
    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if (g_pUserModel == nil)
             g_pUserModel = [[CUserModel alloc] init];

         g_pUserModel.strEmail = [responseObject objectForKey:@"email"];
         g_pUserModel.nUserID = [[responseObject objectForKey:@"userId"] integerValue];
         
         if(bStatus == true)
         {
             if (g_socialTypeFB == true) {
                 [mVCPage onAPISuccess:30 result:message];
             }else {
                 [mVCPage onAPISuccess:30 result:message];
             }
             
         }
         else
         {
             [mVCPage onAPIFail:30 result:message];
         }
         
     } failure:^(NSURLSessionTask * task, NSError * error)
     {
         
         [mVCPage onAPIFail:30 result:nil];
     }];
    
}

+ (void) onForgotPass:(const CUIViewController *)mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];

    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"language":strLan};

    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_FORGOTPASS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:0 result:message];
         }
         else
         {
             [mVCPage onAPIFail:0 result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:0 result:nil];
     }];
    
}

//+ (void) onQuestioners:(const CUIViewController*) mVCPage type:(int)type
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
////    NSMutableArray *DietReasons = [NSMutableArray array];
////    for (int i = 0; i < g_pUserModel.arrDietReasons.count; i++)
////    {
////        if ([g_pUserModel.arrDietReasons[i] boolValue] == YES)
////        {
////            [DietReasons addObject:g_arrDietReasonsValue[i]];
////        }
////    }
////    NSString* strTempDietReasons = [DietReasons componentsJoinedByString:@","];
////    NSString* strDietReasons = [NSString stringWithFormat:@"[%@]", strTempDietReasons];
////    if (g_pUserModel.arrDietReasons.count == 0)
////        strDietReasons = @"";
//
//    NSString* strDiet = @"";
//    for (int i = 0; i < g_pUserModel.arrDietReasons.count; i++)
//    {
//        if ([g_pUserModel.arrDietReasons[i] boolValue] == YES)
//        {
//            strDiet = g_arrDietReasonsValue[i];
//        }
//    }
//
//
//    NSString* strSport = @"";
//    for (int i = 0; i < g_pUserModel.arrSport.count; i++)
//    {
//        if ([g_pUserModel.arrSport[i] boolValue] == YES)
//        {
//            strSport = g_arrSportValue[i];
//        }
//    }
//
//    NSMutableArray *FoodKind = [NSMutableArray array];
//    for (int i = 0; i < g_pUserModel.arrFoodKind.count; i++)
//    {
//        if ([g_pUserModel.arrFoodKind[i] boolValue] == YES)
//        {
//            [FoodKind addObject:g_arrFoodKindValue[i]];
//        }
//    }
////    NSString* strTempFoodKind = [FoodKind componentsJoinedByString:@","];
////    NSString* strFoodKind = [NSString stringWithFormat:@"[%@]", strTempFoodKind];
////    if (g_pUserModel.arrFoodKind.count == 0)
////        strFoodKind = @"";
//
//    NSString* strWork = @"";
//    for (int i = 0; i < g_pUserModel.arrWork.count; i++)
//    {
//        if ([g_pUserModel.arrWork[i] boolValue] == YES)
//        {
//            strWork = g_arrWorkValue[i];
//        }
//    }
//
//    NSString* strWeight = [NSString stringWithFormat:@"%.1f", g_pUserModel.fWeight];
//
//
////    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
////                                @"secretKey":API_NOR_SECRETKEY,
////                                @"email":g_pUserModel.strEmail,
////                                @"password":g_pUserModel.strPassword,
////                                @"profileFields['1_410_100'][]":strDietReasons,
////                                @"profileFields['1_410_102']":strSport,
////                                @"profileFields['1_410_104']":strWork,
////                                @"profileFields['1_410_107'][]":strFoodKind,
////                                @"profileFields['1_410_108']":g_pUserModel.strDiseases,
////                                @"profileFields['1_410_109']":strWeight};
//
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:API_NOR_APIKEY forKey:@"apiKey"];
//    [dictParam setObject:API_NOR_SECRETKEY forKey:@"secretKey"];
//    [dictParam setObject:g_pUserModel.strEmail forKey:@"email"];
//    [dictParam setObject:g_pUserModel.strPassword forKey:@"password"];
//    [dictParam setObject:strSport forKey:@"profileFields[1_410_102]"];
//    [dictParam setObject:strWork forKey:@"profileFields[1_410_104]"];
//    [dictParam setObject:strDiet forKey:@"profileFields[1_410_100]"];
//
//    if ([strDiet isEqualToString:@"515"])
//    {
//        if (g_pUserModel.strDiseases == nil)
//            [dictParam setObject:@"" forKey:@"profileFields[100_515_127]"];
//        else
//            [dictParam setObject:g_pUserModel.strDiseases forKey:@"profileFields[100_515_127]"];
//    }
////    [dictParam setObject:strWeight forKey:@"profileFields['1_410_109']"];
//
////    for (int i = 0; i < DietReasons.count; i++)
////    {
////        NSString *strKey = [NSString stringWithFormat:@"profileFields['1_410_100'][%d]", i];
////        [dictParam setObject:DietReasons[i] forKey:strKey];
////    }
//
////    for (int i = 0; i < FoodKind.count; i++)
////    {
////        NSString *strKey = [NSString stringWithFormat:@"profileFields[1_410_107][%d]", i];
////        [dictParam setObject:FoodKind[i] forKey:strKey];
////    }
//    if (FoodKind.count > 0)
//    {
//        NSString *strComponents = [FoodKind componentsJoinedByString:@","];
//        NSString *strFoods = [NSString stringWithFormat:@"[%@]", strComponents];
//        [dictParam setObject:strFoods forKey:@"profileFields[1_410_107][]"];
//    }
//
//    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_QUESTIONERS];
//
//    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
//     {
//         if ([responseObject objectForKey:@"maintenanceMode"])
//         {
//             g_strMaintainance = [responseObject objectForKey:@"message"];
//             [CGlobal goMaintainance:mVCPage];
//             return;
//         }
//
//         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
//         NSString *message = [responseObject objectForKey:@"message"];
//
//         if(bStatus == true)
//         {
//             [mVCPage onAPISuccess:type result:message];
//         }
//         else
//         {
//             [mVCPage onAPIFail:type result:message];
//         }
//
//
//     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
//     {
//         [mVCPage onAPIFail:type result:nil];
//     }];
//
//
//}

+ (void) onQuestioners:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSMutableArray *DietReasons = [NSMutableArray array];
    //    for (int i = 0; i < g_pUserModel.arrDietReasons.count; i++)
    //    {
    //        if ([g_pUserModel.arrDietReasons[i] boolValue] == YES)
    //        {
    //            [DietReasons addObject:g_arrDietReasonsValue[i]];
    //        }
    //    }
    //    NSString* strTempDietReasons = [DietReasons componentsJoinedByString:@","];
    //    NSString* strDietReasons = [NSString stringWithFormat:@"[%@]", strTempDietReasons];
    //    if (g_pUserModel.arrDietReasons.count == 0)
    //        strDietReasons = @"";
    
    NSString* strDiet = @"";
    for (int i = 0; i < g_pUserModel.arrDietReasons.count; i++)
    {
        if ([g_pUserModel.arrDietReasons[i] boolValue] == YES)
        {
            strDiet = g_arrDietReasonsValue[i];
        }
    }
    
    
    NSString* strSport = @"";
    
    NSString* strWork = @"";
    for (int i = 0; i < g_pUserModel.arrWork.count; i++)
    {
        if ([g_pUserModel.arrWork[i] boolValue] == YES)
        {
            strWork = g_arrWorkValue[i];
        }
    }
    
    NSString* strWeight = [NSString stringWithFormat:@"%.1f", g_pUserModel.fWeight];

    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:API_NOR_APIKEY forKey:@"apiKey"];
    [dictParam setObject:API_NOR_SECRETKEY forKey:@"secretKey"];
    [dictParam setObject:g_pUserModel.strEmail forKey:@"email"];
    [dictParam setObject:g_pUserModel.strPassword forKey:@"password"];
    [dictParam setObject:strSport forKey:@"profileFields[1_410_102]"];
    [dictParam setObject:strWork forKey:@"profileFields[1_410_104]"];
    [dictParam setObject:strDiet forKey:@"profileFields[1_410_100]"];
    
    if ([strDiet isEqualToString:@"515"])
    {
        if (g_pUserModel.strDiseases == nil)
            [dictParam setObject:@"" forKey:@"profileFields[100_515_127]"];
        else
            [dictParam setObject:g_pUserModel.strDiseases forKey:@"profileFields[100_515_127]"];
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_QUESTIONERS];
    
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
    
    
}

+ (void) onProfileTypes:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY};
    
    [manager GET:API_URL_PROFILETYPES parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSArray* arrTypes = [responseObject objectForKey:@"profileTypes"];
             
             NSInteger nCount = arrTypes.count;
             
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTypes objectAtIndex:i];
                 
                 int nId = [[pDic objectForKey:@"optionId"] intValue];
                 //NSString* strLabel = [pDic objectForKey:@"label"];
                 
             }
         }
         else
         {
         }
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onProfileFields:(const CUIViewController*) mVCPage
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"profileType":@"410"};
    
    [manager GET:API_URL_PROFILEFIELDS parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSArray* arrFields = [responseObject objectForKey:@"profileFields"];
             NSInteger nCount = arrFields.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pField = (NSDictionary *)[arrFields objectAtIndex:i];
                 NSString* strFieldId = [pField objectForKey:@"fieldId"];
                 NSString* strType = [pField objectForKey:@"type"];
                 NSString* strLabel = [pField objectForKey:@"label"];
                 int nRequired = [[pField objectForKey:@"required"] intValue];
                 
                 NSArray* arrOptions = [pField objectForKey:@"options"];
                 NSInteger nOptionCount = arrOptions.count;
                 for (int j = 0; j < nOptionCount; j++)
                 {
                     NSDictionary *pOption = (NSDictionary*)[arrOptions objectAtIndex:j];
                     int nOptionId = [[pOption objectForKey:@"optionId"] intValue];
                     NSString* strOptionLabel = [pOption objectForKey:@"optionLabel"];
                 }
             }
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onProfileAddress:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"profileAddress":@""};
    
    [manager GET:API_URL_PROFILEADDRESS parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onEditProfile:(const CUIViewController*) mVCPage type:(int)type model:(CProfileFieldModel*)model
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"profileFields[1_410_95]":model.strFName,
                                @"profileFields[1_410_96]":model.strLName,
                                @"profileFields[1_410_97]":model.strGender,
                                @"profileFields[1_410_110]":model.strBirthday,
                                @"profileFields[1_410_111]":model.strCountryCode,
                                @"profileFields[1_410_120]":model.strTelephone};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_EDITPROFILE];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             g_pUserModel.strFirstName = model.strFName;
             g_pUserModel.strLastName = model.strLName;
             g_pUserModel.strGenderMale = model.strGender;
             g_pUserModel.strBirthday = model.strBirthday;
             g_pUserModel.strCountryCode = model.strCountryCode;
             g_pUserModel.strTelephone = model.strTelephone;
             
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onEditTelephone:(const CUIViewController*) mVCPage type:(int)type model:(NSString*)telephone
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"profileFields[1_410_120]":telephone};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_EDITPROFILE];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             g_pUserModel.strTelephone = telephone;
             
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}


+ (void) onUserProfile:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* strID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.nUserID];

    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"userId":strID};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_USERPROFILE];

    
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         

         NSDictionary *userMetadata = [responseObject objectForKey:@"userMetadata"];
         NSArray *arrFields = [userMetadata objectForKey:@"fields"];
         for (int i = 0; i < arrFields.count; i++)
         {
             NSDictionary *field = [arrFields objectAtIndex:i];
             NSString* fieldId = [field objectForKey:@"fieldId"];
             
             if ([fieldId isEqualToString:@"1_410_1"])
             {
                 g_pUserModel.strProfileType = [field objectForKey:@"value"];
             }
             if ([fieldId isEqualToString:@"1_410_95"])
             {
                 g_pUserModel.strFirstName = [field objectForKey:@"value"];
             }
             if ([fieldId isEqualToString:@"1_410_96"])
             {
                 g_pUserModel.strLastName = [field objectForKey:@"value"];
             }
             if ([fieldId isEqualToString:@"1_410_97"])
             {
//                 NSString* strValue = [field objectForKey:@"value"];
//                 if ([strValue isEqualToString:@"Male"])
//                     g_pUserModel.strGenderMale = @"411";
//                 else
//                     g_pUserModel.strGenderMale = @"412";
                 NSInteger nValueID = [[field objectForKey:@"valueID"] integerValue];
                 g_pUserModel.strGenderMale = [NSString stringWithFormat:@"%ld", (long)nValueID];
             }
             if ([fieldId isEqualToString:@"1_410_110"])
             {
                 g_pUserModel.strBirthday = [field objectForKey:@"value"];
             }
             if ([fieldId isEqualToString:@"1_410_111"])
             {
                 NSInteger nValueID = [[field objectForKey:@"valueID"] integerValue];
                 g_pUserModel.strCountryCode = [NSString stringWithFormat:@"%ld", (long)nValueID];
             }
             if ([fieldId isEqualToString:@"1_410_100"])
             {
                 NSString* dietReasons = [field objectForKey:@"value"];
                 
                 [g_pUserModel.arrDietReasons removeAllObjects];
                 for (int i = 0; i < g_arrDietReasonsValue.count; i++)
                 {
                     [g_pUserModel.arrDietReasons addObject:@NO];
                     if ([g_arrDietReasonsValue[i] isEqualToString:dietReasons])
                         g_pUserModel.arrDietReasons[i] = @YES;
                 }
                 
                 if ([dietReasons isEqualToString:@"515"])
                 {
                     g_pUserModel.strDiseases = [field objectForKey:@"specify"];
                 }

             }
             
             if ([fieldId isEqualToString:@"1_410_102"])
             {
                 NSString* Sport = [field objectForKey:@"value"];
                 
                 [g_pUserModel.arrSport removeAllObjects];
                 for (int i = 0; i < g_arrSportValue.count; i++)
                 {
                     [g_pUserModel.arrSport addObject:@NO];
                     if ([g_arrSportValue[i] isEqualToString:Sport])
                         g_pUserModel.arrSport[i] = @YES;
                 }
                 
             }
             if ([fieldId isEqualToString:@"1_410_104"])
             {
                 NSString* Work = [field objectForKey:@"value"];
                 
                 [g_pUserModel.arrWork removeAllObjects];
                 for (int i = 0; i < g_arrWorkValue.count; i++)
                 {
                     [g_pUserModel.arrWork addObject:@NO];
                     if ([g_arrWorkValue[i] isEqualToString:Work])
                         g_pUserModel.arrWork[i] = @YES;
                 }
                 
             }
             if ([fieldId isEqualToString:@"1_410_107"])
             {
                 NSString* FoodKind = [field objectForKey:@"value"];
                 
                 if (FoodKind.length != 0)
                 {
                     //FoodKind = [FoodKind substringFromIndex:1];
                     //FoodKind = [FoodKind substringToIndex:[FoodKind length] - 1];
                     
                     NSArray* components = [FoodKind componentsSeparatedByString:@","];
                     
                     [g_pUserModel.arrFoodKind removeAllObjects];
                     for (int i = 0; i < g_arrFoodKindValue.count; i++)
                         [g_pUserModel.arrFoodKind addObject:@NO];
                     
                     for (int i = 0; i < components.count; i++)
                     {
                         for (int j = 0; j < g_arrFoodKindValue.count; j++)
                         {
                             if ([components[i] isEqualToString:g_arrFoodKindValue[j]])
                                 g_pUserModel.arrFoodKind[j] = @YES;
                         }
                     }
                 }

             }
             /*
             if ([fieldId isEqualToString:@"1_410_108"])
             {
                 g_pUserModel.strDiseases = [field objectForKey:@"value"];
             }
              */
             if ([fieldId isEqualToString:@"1_410_120"])
             {
                 g_pUserModel.strTelephone = [field objectForKey:@"value"];
             }
             if ([fieldId isEqualToString:@"1_410_109"])
             {
                 g_pUserModel.fWeight = [[field objectForKey:@"value"] floatValue];
             }
         }
         
         /*
         NSDictionary *userData = [userMetadata objectForKey:@"userData"];
         g_pUserModel.pNutModel.nNutritionistId = [[userData objectForKey:@"nutritionistId"] integerValue];
         g_pUserModel.pNutModel.strTitle = [userData objectForKey:@"nutritionistName"];
         g_pUserModel.pNutModel.nOwnerId = [[userData objectForKey:@"nutritionistOwnerId"] integerValue];
         g_pUserModel.pNutModel.strOwnerName = [userData objectForKey:@"nutritionistOwnerName"];
         */
         NSDictionary *userData = [userMetadata objectForKey:@"userData"];
         g_pUserModel.strThumbnail = [userData objectForKey:@"thumbnail"];
         [mVCPage onAPISuccess:type result:nil];
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetUserProfilePhoto:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@"" /*,
                                                 @"userId":@"" */};
    
    [manager GET:API_URL_GETUSERPROFILEPHOTO parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         
         if(bStatus == true)
         {
             NSString *strPhotoURL = [responseObject objectForKey:@"photoUrl"];

         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];

}

+ (void) onSetUserProfilePhoto:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* strBase64 = [CUtility encodeToBase64String:g_pUserModel.imgAvatar];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"data":strBase64}; //data: "" => base64_encode(IMAGE);
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SETUSERPROFILEPHOTO];

    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         
         if(bStatus == true)
         {
             g_pUserModel.strThumbnail = [responseObject objectForKey:@"url"];
             [mVCPage onAPISuccess:type result:nil];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onRemoveUserProfilePhoto:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@"",
                                @"data":@""}; //data: "" => base64_encode(IMAGE);
    
    [manager PUT:API_URL_REMOVEUSERPROFILEPHOTO parameters:dictParam success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onGetMobileSettings:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETMOBILESETTINGS];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
              g_pUserModel.pMobileSettingModel.bMusic = [[responseObject objectForKey:@"general_music"] boolValue];
              g_pUserModel.pMobileSettingModel.bPrivacyMode = [[responseObject objectForKey:@"general_privacymode"] intValue];
              g_pUserModel.pMobileSettingModel.bSoundEffect = [[responseObject objectForKey:@"general_soundeffects"] intValue];
              g_pUserModel.pMobileSettingModel.bVibration = [[responseObject objectForKey:@"general_vibration"] intValue];
              g_pUserModel.pMobileSettingModel.bChallengeNotification = [[responseObject objectForKey:@"push_challanege_notification"] intValue];
              g_pUserModel.pMobileSettingModel.bChatNotification = [[responseObject objectForKey:@"push_chat_notification"] intValue];
             
             g_pUserModel.pMobileSettingModel.strHeightUnit = [responseObject objectForKey:@"unit_length"];
             g_pUserModel.pMobileSettingModel.strWeightUnit = [responseObject objectForKey:@"unit_weight"];
          
             if (mVCPage != nil)
                 [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             if (mVCPage != nil)
                 [mVCPage onAPIFail:type result:message];

         }
 
    
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onEditMobileSettings:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* strMusc = (g_pUserModel.pMobileSettingModel.bMusic) ? @"1" : @"0";
    NSString* strPrivacymode = (g_pUserModel.pMobileSettingModel.bPrivacyMode) ? @"1" : @"0";
    NSString* strSoundeffects = (g_pUserModel.pMobileSettingModel.bSoundEffect) ? @"1" : @"0";
    NSString* strVibration = (g_pUserModel.pMobileSettingModel.bVibration) ? @"1" : @"0";
    NSString* strChallanege = (g_pUserModel.pMobileSettingModel.bChallengeNotification) ? @"1" : @"0";
    NSString* strChat = (g_pUserModel.pMobileSettingModel.bChatNotification) ? @"1" : @"0";
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"general_music":strMusc,
                                @"general_privacymode":strPrivacymode,
                                @"general_soundeffects":strSoundeffects,
                                @"general_vibration":strVibration,
                                @"push_challanege_notification":strChallanege,
                                @"push_chat_notification":strChat,
                                @"unit_length":g_pUserModel.pMobileSettingModel.strHeightUnit,
                                @"unit_weight":g_pUserModel.pMobileSettingModel.strWeightUnit};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_EDITMOBILESETTINGS];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true) {
             [mVCPage onAPISuccess:type result:message];
         }
         else {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onGetLanByType:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@""};
    
    [manager GET:API_URL_EDITMOBILESETTINGS parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSArray* arrLan = [responseObject objectForKey:@"types"];
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];

}

+ (void) onGetUserLan:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERLAN];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
           
             g_pUserModel.pMobileSettingModel.strLanguage = [responseObject objectForKey:@"userLanguage"];
             [mVCPage onAPISuccess:type result:nil];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onEditUserLan:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];

    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"userLanguage":strLan};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_EDITUSERLAN];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetAllNutritionists:(const CUIViewController*) mVCPage type:(int)type model:(CNutSearchModel*)model
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"offset":model.offset,
                                @"pageId":model.pageID,
                                @"itemPerPage":model.itemPerPage,
                                @"search_text":model.search_text,
                                @"countryValue":model.countryValue,
                                @"languages":model.language,
                                @"specialities":model.specialities,
                                @"order":model.order};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETALLNUTRITIONISTS];

    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
 
         if(bStatus == true)
         {
             NSArray *arrDic = [responseObject objectForKey:@"nutritionists"];
             NSMutableArray *arrNut = [[NSMutableArray alloc] init];
             
             for (int i = 0; i < arrDic.count; i++)
             {
                 NSDictionary* pNut = [arrDic objectAtIndex:i];
                 
                 CNutritionistModel *model = [[CNutritionistModel alloc] init];
                 
                 model.strGender            = [pNut objectForKey:@"gender"];
                 model.strCountryFullName   = [pNut objectForKey:@"countryFullName"];
                 model.strCountryValue      = [pNut objectForKey:@"countryValue"];
                 model.strBirthday          = [pNut objectForKey:@"birthdate"];
                 model.fRateAVG             = [[pNut objectForKey:@"rateAVG"] floatValue];
                 model.nCountVoters         = [[pNut objectForKey:@"countVoters"] intValue];
                 model.fullybooked          = [[pNut objectForKey:@"fullybooked"] boolValue];
                 model.recommended          = [[pNut objectForKey:@"recommended"] boolValue];
                 model.nNutritionistId      = [[pNut objectForKey:@"nutritionistId"] intValue];
                 model.strTitle             = [pNut objectForKey:@"title"];
                 model.strDescription       = [pNut objectForKey:@"description"];
                 model.strOwnerName         = [pNut objectForKey:@"ownerName"];
                 model.nOwnerId             = [[pNut objectForKey:@"ownerId"] intValue];
                 model.nMemberCount         = [[pNut objectForKey:@"memberCount"] intValue];
                 model.strThumbnail         = [pNut objectForKey:@"thumbnail"];
                 model.strMobile            = [pNut objectForKey:@"mobile"];
                 
                 NSDictionary *dicLan = [pNut objectForKey:@"languages"];
                 NSMutableArray *arrLan = [NSMutableArray array];
                 
                 for (NSString *avalue in [dicLan allValues])
                 {
                     [arrLan addObject:avalue];
                 }
                 model.strLanguage = [arrLan componentsJoinedByString:@","];
                 
                 [arrLan removeAllObjects];
                 arrLan = nil;

                 [arrNut addObject:model];
             }
             
             [mVCPage onAPISuccess:type result:arrNut];
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetNutritionistMemebers:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"nutritionistId":@"",
                                @"offset":@"",
                                @"pageId":@"",
                                @"itemPerPage":@""};
    
    [manager GET:API_URL_GETNUTRITIONISTMEMBERS parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onGetUserNutritionist:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERNUTRITIONIST];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSDictionary* nutritionist = [responseObject objectForKey:@"nutritionist"];
             g_pUserModel.pNutModel.strBirthday = [nutritionist objectForKey:@"birthdate"];
             g_pUserModel.pNutModel.nCountVoters = [[nutritionist objectForKey:@"countVoters"] integerValue];
             g_pUserModel.pNutModel.strCountryFullName = [nutritionist objectForKey:@"countryFullName"];
             g_pUserModel.pNutModel.strCountryValue = [nutritionist objectForKey:@"countVoters"];
             g_pUserModel.pNutModel.strDescription = [nutritionist objectForKey:@"description"];
             g_pUserModel.pNutModel.strGender = [nutritionist objectForKey:@"gender"];
             g_pUserModel.pNutModel.nMemberCount = [[nutritionist objectForKey:@"memberCount"] integerValue];
             g_pUserModel.pNutModel.nNutritionistId = [[nutritionist objectForKey:@"nutritionistId"] integerValue];
             g_pUserModel.pNutModel.nOwnerId = [[nutritionist objectForKey:@"ownerId"] integerValue];
             g_pUserModel.pNutModel.strOwnerName = [nutritionist objectForKey:@"ownerName"];
             g_pUserModel.pNutModel.fRateAVG = [[nutritionist objectForKey:@"rateAVG"] floatValue];
             g_pUserModel.pNutModel.strThumbnail = [nutritionist objectForKey:@"thumbnail"];
             g_pUserModel.pNutModel.strTitle = [nutritionist objectForKey:@"title"];
             g_pUserModel.pNutModel.fullybooked  = [[nutritionist objectForKey:@"fullybooked"] boolValue];

             NSDictionary *dicLan = [nutritionist objectForKey:@"languages"];
             NSMutableArray *arrLan = [NSMutableArray array];
             
             for (NSString *avalue in [dicLan allValues])
             {
                 [arrLan addObject:avalue];
             }
             g_pUserModel.pNutModel.strLanguage = [arrLan componentsJoinedByString:@","];
             
             [arrLan removeAllObjects];
             arrLan = nil;

             
             [mVCPage onAPISuccess:type result:message];
             
         }
         else
         {
             [mVCPage onAPIFail:type result:message];

         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onNutritionistMembership:(const CUIViewController*) mVCPage  type:(int)type model:(CNutritionistModel*)model isSelect:(BOOL)select
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *strId = [NSString stringWithFormat:@"%ld", (long)model.nNutritionistId];
    NSString *strMembership = @"select";
    if (select == NO)
        strMembership = @"leave";
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_pUserModel.strEmail,
                                @"password":g_pUserModel.strPassword,
                                @"nutritionistId":strId,
                                @"membership":strMembership};
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_NUTRITIONISTMEMBERSHIP];

    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onRateNutritionist:(const CUIViewController*) mVCPage type:(int)type rate:(NSInteger)rate
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* strRate = [NSString stringWithFormat:@"%ld", (long)rate];
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"rate":strRate};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_RATENUTRITIONIST];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             
             g_pUserModel.pNutModel.fRateAVG = [[responseObject objectForKey:@"rateAVG"] doubleValue];
             //int nCountVoters = [[responseObject objectForKey:@"countVoters"] intValue];
             
             [mVCPage onAPISuccess:type result:message];

         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetUserMeasurements:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"offset":@"",
                                @"pageId":@"",
                                @"itemPerPage":@""};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERMEASUREMENTS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSString* unitLength = [responseObject objectForKey:@"unitLength"];
             NSString* unitWeight = [responseObject objectForKey:@"unitWeight"];
             
             int nWUnit = WUNIT_KILOGRAMS, nLUnit = LUNIT_CENTIMETRS;
             
             for (int i = 0; i < g_arrWUnitValue.count; i++)
             {
                 if ([unitWeight isEqualToString:g_arrWUnitValue[i]])
                 {
                     //g_pUserModel.pStartBodyMeasurementModel.nWUnit = i;
                     nWUnit = i;
                     break;
                 }
             }
             for (int i = 0; i < g_arrLUnitValue.count; i++)
             {
                 if ([unitLength isEqualToString:g_arrLUnitValue[i]])
                 {
                     //g_pUserModel.pStartBodyMeasurementModel.nLUnit = i;
                     nLUnit = i;
                     break;
                 }
             }
//
//             NSDictionary *lastMeasurement = [responseObject objectForKey:@"lastMeasurement"];
//             g_pUserModel.pStartBodyMeasurementModel.fWeight = [[lastMeasurement objectForKey:@"weight"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fHeight = [[lastMeasurement objectForKey:@"height"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fChest = [[lastMeasurement objectForKey:@"chest"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fHips = [[lastMeasurement objectForKey:@"hips"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fThigh = [[lastMeasurement objectForKey:@"thigh"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fUpperarm = [[lastMeasurement objectForKey:@"upperArm"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.fWaist = [[lastMeasurement objectForKey:@"waist"] floatValue];
//             g_pUserModel.pStartBodyMeasurementModel.strDisplayName = [lastMeasurement objectForKey:@"displayname"];
//             g_pUserModel.pStartBodyMeasurementModel.strCreationDate = [lastMeasurement objectForKey:@"creationDate"];
//             g_pUserModel.pStartBodyMeasurementModel.strModifiedDate = [lastMeasurement objectForKey:@"modifiedDate"];
             
             NSMutableArray* arrMeasurement = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"measurements"];
             
             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CBodyMeasurementModel* model = [[CBodyMeasurementModel alloc] init];
                 
                 model.nWUnit = nWUnit;
                 model.nLUnit = nLUnit;
                 model.nMeasurementId = [[pDic objectForKey:@"measurementId"] integerValue];
                 model.fWeight = [[pDic objectForKey:@"weight"] doubleValue];
                 model.fHeight = [[pDic objectForKey:@"height"] doubleValue];
                 model.fUpperarm = [[pDic objectForKey:@"upperArm"] doubleValue];
                 model.fChest = [[pDic objectForKey:@"chest"] doubleValue];
                 model.fWaist = [[pDic objectForKey:@"waist"] doubleValue];
                 model.fHips = [[pDic objectForKey:@"hips"] doubleValue];
                 model.fThigh = [[pDic objectForKey:@"thigh"] doubleValue];
                 model.strCreationDate = [pDic objectForKey:@"creationDate"];
                 model.strModifiedDate = [pDic objectForKey:@"modifiedDate"];
                 
                 [arrMeasurement addObject:model];
             }
             
             [mVCPage onAPISuccess:type result:arrMeasurement];
             
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
         
     }];
}

+ (void) onAddNewMeasurement:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString* strWeight = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fWeight];
    NSString* strHeight = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fHeight];
    NSString* strUpperarm = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fUpperarm];
    NSString* strChest = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fChest];
    NSString* strWaist = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fWaist];
    NSString* strHips = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fHips];
    NSString* strThigh = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fThigh];

    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_pUserModel.strEmail,
                                @"password":g_pUserModel.strPassword,
                                @"weight":strWeight,
                                @"height":strHeight,
                                @"upperArm":strUpperarm,
                                @"chest":strChest,
                                @"waist":strWaist,
                                @"hips":strHips,
                                @"thigh":strThigh};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_ADDNEWMEASUREMENT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];

         }
         
      
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:0 result:nil];
     }];

}

+ (void) onEditMeasurement:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@"",
                                @"measurementId":@"",
                                @"weight":@"",
                                @"height":@"",
                                @"upperArm":@"",
                                @"chest":@"",
                                @"waist":@"",
                                @"hips":@"",
                                @"thigh":@""};
    [manager PUT:API_URL_EDITMEASUREMENT parameters:dictParam success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];

}

+ (void) onDeleteMeasurement:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@"",
                                @"measurementId":@""};
    [manager DELETE:API_URL_DELETEMEASUREMENT parameters:dictParam success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             
         }
         else
         {
         }
         

     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];

}

+ (void) onGetLastMeasurement:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETLASTMEASUREMENT];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSString* unitLength = [responseObject objectForKey:@"unitLength"];
             NSString* unitWeight = [responseObject objectForKey:@"unitWeight"];
             
             for (int i = 0; i < g_arrWUnitValue.count; i++)
             {
                 if ([unitWeight isEqualToString:g_arrWUnitValue[i]])
                 {
                     g_pUserModel.pBodyMeasurementModel.nWUnit = i;
                     break;
                 }
             }
             for (int i = 0; i < g_arrLUnitValue.count; i++)
             {
                 if ([unitLength isEqualToString:g_arrLUnitValue[i]])
                 {
                     g_pUserModel.pBodyMeasurementModel.nLUnit = i;
                     break;
                 }
             }
             NSDictionary *lastMeasurement = [responseObject objectForKey:@"lastMeasurement"];
             g_pUserModel.pBodyMeasurementModel.fWeight = [[lastMeasurement objectForKey:@"weight"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fHeight = [[lastMeasurement objectForKey:@"height"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fChest = [[lastMeasurement objectForKey:@"chest"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fHips = [[lastMeasurement objectForKey:@"hips"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fThigh = [[lastMeasurement objectForKey:@"thigh"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fUpperarm = [[lastMeasurement objectForKey:@"upperArm"] floatValue];
             g_pUserModel.pBodyMeasurementModel.fWaist = [[lastMeasurement objectForKey:@"waist"] floatValue];
             g_pUserModel.pBodyMeasurementModel.strDisplayName = [lastMeasurement objectForKey:@"displayname"];
             g_pUserModel.pBodyMeasurementModel.strCreationDate = [lastMeasurement objectForKey:@"creationDate"];
             g_pUserModel.pBodyMeasurementModel.strModifiedDate = [lastMeasurement objectForKey:@"modifiedDate"];

             if (mVCPage != nil)
                 [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             if (mVCPage != nil)
                 [mVCPage onAPIFail:type result:message];

         }
 
    
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetWeights:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETWEIGHTS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSDictionary* bmi = [responseObject objectForKey:@"bmi"];
             g_pUserModel.pWeightModel.fBMI = [[bmi objectForKey:@"bmi"] doubleValue];
             g_pUserModel.pWeightModel.strMeaning = [bmi objectForKey:@"meaning"];
             
             g_pUserModel.pWeightModel.fChangeWeight = [[responseObject objectForKey:@"changeWeight"] doubleValue];
             g_pUserModel.pWeightModel.fCurrentWeight = [[responseObject objectForKey:@"currentWeight"] doubleValue];
             g_pUserModel.pWeightModel.fStartingWeight = [[responseObject objectForKey:@"startingWeight"] doubleValue];
             
             NSDictionary* goalWeights = [responseObject objectForKey:@"goalWeight"];
             if (goalWeights != nil && ![goalWeights isEqual:[NSNull null]])
             {
                 g_pUserModel.pWeightModel.pGoalWeight.fWeight = [[goalWeights objectForKey:@"weight"] doubleValue];
                 g_pUserModel.pWeightModel.pGoalWeight.strDate = [goalWeights objectForKey:@"date"];
             }
             NSString* unitWeight = [responseObject objectForKey:@"unitWeight"];
             for (int i = 0; i < g_arrWUnitValue.count; i++)
             {
                 if ([unitWeight isEqualToString:g_arrWUnitValue[i]])
                 {
                     g_pUserModel.pWeightModel.unitWeight = i;
                     break;
                 }
             }
             
             if (mVCPage != nil)
                 [mVCPage onAPISuccess:type result:nil];
         }
         else
         {
             if (mVCPage != nil)
                 [mVCPage onAPIFail:type result:nil];
         }
         
 
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onGetDietPlans:(const CUIViewController*) mVCPage type:(int)type date:(NSString*)date
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"date":date};
 
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETDIETPLANS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrDietPlan = [[NSMutableArray alloc] init];
             NSArray* arrSchedule = [responseObject objectForKey:@"schedule"];
             
             NSInteger nCount = arrSchedule.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrSchedule objectAtIndex:i];
                 
                 CDietPlanModel* model = [[CDietPlanModel alloc] init];
                 model.category_id = [[pDic objectForKey:@"category_id"] integerValue];
                 model.date = [pDic objectForKey:@"date"];
                 model.strDescription = [pDic objectForKey:@"description"];
                 model.end_time = [pDic objectForKey:@"end_time"];
                 model.owner_type = [pDic objectForKey:@"owner_type"];
                 model.parent_type = [pDic objectForKey:@"parent_type"];
                 model.start_time = [pDic objectForKey:@"start_time"];
                 model.title = [pDic objectForKey:@"title"];
                 model.owner_id = [[pDic objectForKey:@"owner_id"] integerValue];
                 model.parent_id = [[pDic objectForKey:@"parent_id"] integerValue];
                 model.schedule_id = [[pDic objectForKey:@"schedule_id"] integerValue];

                 [arrDietPlan addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrDietPlan];

         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onGetUserPhotos:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model
{
    NSString* nutID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.pNutModel.nNutritionistId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"nutritionistId":nutID,
                                @"mealTypeId":model.mealTypeId,
                                //@"offset":model.offset,
                                //@"pageId":model.pageID,
                                //@"itemPerPage":model.itemPerPage,
                                //@"approval":model.approval,
                                @"date":model.date};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERPHOTOS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
      
         if(bStatus == true)
         {
             NSMutableArray* arrPhotos = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"photos"];
             
             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CMessageModel* model = [[CMessageModel alloc] init];
                 model.isImage = YES;
                 model.date = [pDic objectForKey:@"date"];
                 model.mealTypeName = [pDic objectForKey:@"mealTypeName"];
                 model.photoStatus = [pDic objectForKey:@"photoStatus"];
                 model.url = [pDic objectForKey:@"url"];
                 model.username = [pDic objectForKey:@"username"];
                 model.fileId = [[pDic objectForKey:@"fileId"] integerValue];
                 model.photoId = [[pDic objectForKey:@"photoId"] integerValue];
                 model.userId = [[pDic objectForKey:@"userId"] integerValue];
                 model.mealTypeId = [[pDic objectForKey:@"mealTypeId"] integerValue];
                 [arrPhotos addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrPhotos];

         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
 
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onGetApprovedPhotos:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model
{
    NSString* nutID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.pNutModel.nNutritionistId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"nutritionistId":nutID,
                                @"mealTypeId":model.mealTypeId,
                                //@"offset":model.offset,
                                //@"pageId":model.pageID,
                                //@"itemPerPage":model.itemPerPage,
                                //@"approval":model.approval,
                                @"date":model.date};

    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETAPPROVEDPHOTOS];

    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrPhotos = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"photos"];

             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
 
                 CMessageModel* model = [[CMessageModel alloc] init];
                 model.isImage = YES;
                 model.date = [pDic objectForKey:@"date"];
                 model.mealTypeName = [pDic objectForKey:@"mealTypeName"];
                 model.photoStatus = [pDic objectForKey:@"photoStatus"];
                 model.url = [pDic objectForKey:@"url"];
                 model.username = [pDic objectForKey:@"username"];
                 model.fileId = [[pDic objectForKey:@"fileId"] integerValue];
                 model.photoId = [[pDic objectForKey:@"photoId"] integerValue];
                 model.userId = [[pDic objectForKey:@"userId"] integerValue];
                 model.mealTypeId = [[pDic objectForKey:@"mealTypeId"] integerValue];
                 model.bIsLiked = [[pDic objectForKey:@"nutritionistApproved"] boolValue];
                 [arrPhotos addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrPhotos];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];

         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onPostPhoto:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model
{
     NSString* nutID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.pNutModel.nNutritionistId];
    NSString* strBase64 = [CUtility encodeToBase64String:model.photo];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"nutritionistId":nutID,
                                @"mealTypeId":model.mealTypeId,
                                @"creationDate":model.creationDate,
                                @"data":strBase64};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTPHOTO];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         model.strMessage = message;

         if(bStatus == true)
         {
             model.url = [responseObject objectForKey:@"url"];
             model.nPhotoId = [[responseObject objectForKey:@"photoId"] integerValue];
             model.photoId = [NSString stringWithFormat:@"%ld", (long)model.nPhotoId];
             [mVCPage onAPISuccess:type result:model];
         }
         else
         {
             [mVCPage onAPIFail:type result:model];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         model.strMessage = nil;
         [mVCPage onAPIFail:type result:model];

     }];

}

+ (void) onGetComments:(const CUIViewController*) mVCPage type:(int)type  model:(CJournalSearchModel*)model
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"photoId":model.photoId};
                                //@"offset":model.offset,
                                //@"pageId":model.pageID,
                                //@"itemPerPage":model.itemPerPage};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETCOMMENTS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrComments = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"comments"];

             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CMessageModel* model = [[CMessageModel alloc] init];
                 model.isForMessage = NO;
                 model.commentDate = [pDic objectForKey:@"commentDate"];
                 model.bodyText = [pDic objectForKey:@"bodyText"];
                 model.commentImage = [pDic objectForKey:@"commentImage"];
                 model.username = [pDic objectForKey:@"username"];
                 model.commentId = [[pDic objectForKey:@"commentId"] integerValue];
                 model.likeCount = [[pDic objectForKey:@"likeCount"] integerValue];
                 [arrComments addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrComments];

         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
        
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];

}

+ (void) onPostComments:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"photoId":model.photoId,
                                @"body":model.body};
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTCOMMENT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         model.strMessage = message;
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:model];
         }
         else
         {
             [mVCPage onAPIFail:type result:model];
         }
         
 
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         model.strMessage = nil;
         [mVCPage onAPIFail:type result:model];

     }];

}

+ (void) onDeleteComments:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@"",
                                @"photoId":@"",
                                @"commentId":@""};
    [manager DELETE:API_URL_DELETECOMMENT parameters:dictParam success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:nil];

         }
         else
         {
             
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];

     }];
}

+ (void) onPostMessage:(const CUIViewController*) mVCPage type:(int)type model:(CMessageModel*)model
{
    NSString* nutID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.pNutModel.nNutritionistId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"nutritionistId":nutID,
                                @"body":model.body};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTMESSAGE];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];

         if(bStatus == true)
         {
             BOOL bHasExtendedPackage = false;

             if ([responseObject objectForKey:@"hasExtendedPackage"])
             {
                 BOOL bExtended = [[responseObject objectForKey:@"hasExtendedPackage"] boolValue];
                 
                 if (bExtended == true)
                     bHasExtendedPackage = true;
             }
             
             if (bHasExtendedPackage == true)
             {
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                 [dateFormat setLocale:indianLocale];
                 [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 
                 CMessageModel* modelExtend = [[CMessageModel alloc] init];
                 modelExtend.isNutritionist = YES;
                 modelExtend.isImage = NO;
                 modelExtend.body = message;
                 modelExtend.date = [dateFormat stringFromDate:[NSDate date]];
                 modelExtend.thumbnail = g_pUserModel.pNutModel.strThumbnail;
                 
                 CVCMessageViewController *mVCMessage = mVCPage;
                 [mVCMessage onAPISuccessExtend:type result:model extend:modelExtend];
             }
             else
                 [mVCPage onAPISuccess:type result:model];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
      
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onGetConversations:(const CUIViewController*) mVCPage type:(int)type
{
    NSString* nutID = [NSString stringWithFormat:@"%ld", (long)g_pUserModel.pNutModel.nNutritionistId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"nutritionistId":nutID,
                                @"offset":@"",
                                @"pageId":@"",
                                @"itemPerPage":@""};

    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETCONVERSATIONS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrMessage = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"messages"];
             
             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CMessageModel* model = [[CMessageModel alloc] init];
                 model.body = [pDic objectForKey:@"body"];
                 model.date = [pDic objectForKey:@"date"];
                 model.sendername = [pDic objectForKey:@"sendername"];
                 model.thumbnail = [pDic objectForKey:@"thumbnail"];
                 model.username = [pDic objectForKey:@"username"];
                 model.senderId = [[pDic objectForKey:@"senderId"] integerValue];
                 model.userId = [[pDic objectForKey:@"userId"] integerValue];
                 model.isNutritionist = [[pDic objectForKey:@"isNutritionist"] boolValue];
                 
                 [arrMessage addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrMessage];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
      
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onGetNotifications:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
//                                @"offset":@"",
//                                @"pageId":@"",
//                                @"itemPerPage":@""};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETNOTIFICATIONS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }

         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];

         if(bStatus == true)
         {
             NSArray* arrNot = [responseObject objectForKey:@"notifications"];

//             [g_arrNotificationForDietPlan removeAllObjects];
//             [g_arrNotificationForJournal removeAllObjects];
//             [g_arrNotificationForMessage removeAllObjects];
             
             for (int i = 0; i < arrNot.count; i++)
             {
                 NSDictionary* dic = (NSDictionary *)[arrNot objectAtIndex:i];;
                 CNotificationModel* model = [[CNotificationModel alloc] init];
                 model.body = [dic objectForKey:@"body"];
                 model.date = [dic objectForKey:@"date"];
                 model.objectType = [dic objectForKey:@"objectType"];
                 model.subjectType = [dic objectForKey:@"subjectType"];
                 model.type = [dic objectForKey:@"type"];
                 model.notificationId = [[dic objectForKey:@"notificationId"] integerValue];
                 model.objectId = [[dic objectForKey:@"objectId"] integerValue];
                 model.subjectId = [[dic objectForKey:@"subjectId"] integerValue];
                 model.read = [[dic objectForKey:@"read"] integerValue];

                 if ([model.type isEqualToString:NOTIFICATION_MESSAGENEW])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForMessage model:model ])
                         [g_arrNotificationForMessage addObject:model];
                 }
                 else if ([model.type isEqualToString:NOTIFICATION_PHOTOAPPROVED] || [model.type isEqualToString:NOTIFICATION_PHOTOCOMMENT])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForJournal model:model ])
                     {
                         NSDictionary* params = (NSDictionary *)[dic objectForKey:@"params"];
                         model.photoDate = [params objectForKey:@"photoDate"];
                         [g_arrNotificationForJournal addObject:model];
                     }
                 }
                 else if ([model.type isEqualToString:NOTIFICATION_SHCEDULECREATED] || [model.type isEqualToString:NOTIFICATION_SCHEDULEEDITED])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForDietPlan model:model ])
                         [g_arrNotificationForDietPlan addObject:model];
                 }
                 else if ([model.type isEqualToString:NOTIFICATION_EXPIRATIONNOTICE])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForExpiration model:model ])
                         [g_arrNotificationForExpiration addObject:model];
                 }
                 else if ([model.type isEqualToString:NOTIFICATION_MEASUREMENTSWEEKLYNOTICE])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForMeasurement model:model ])
                         [g_arrNotificationForMeasurement addObject:model];
                 }
                 else if ([model.type isEqualToString:NOTIFICATION_QUESTIONNAIRE])
                 {
                     if (![CGlobal isInNotificationArray:g_arrNotificationForQuestionnaire model:model ])
                         [g_arrNotificationForQuestionnaire addObject:model];
                 }
             }
             
             for (int i = 0; i < g_arrNotificationForJournal.count; i++)
             {
                 CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
                 
                 if (model.bIsNew == false)
                 {
                     [g_arrNotificationForJournal removeObjectAtIndex:i];
                     i--;
                 }
             }
             for (int i = 0; i < g_arrNotificationForMessage.count; i++)
             {
                 CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMessage objectAtIndex:i];
                 
                 if (model.bIsNew == false)
                 {
                     [g_arrNotificationForMessage removeObjectAtIndex:i];
                     i--;
                 }
             }
             for (int i = 0; i < g_arrNotificationForDietPlan.count; i++)
             {
                 CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForDietPlan objectAtIndex:i];
                 
                 if (model.bIsNew == false)
                 {
                     [g_arrNotificationForDietPlan removeObjectAtIndex:i];
                     i--;
                 }
             }
             for (int i = 0; i < g_arrNotificationForQuestionnaire.count; i++)
             {
                 CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForQuestionnaire objectAtIndex:i];
                 
                 if (model.bIsNew == false)
                 {
                     [g_arrNotificationForQuestionnaire removeObjectAtIndex:i];
                     i--;
                 }
             }

        
             if (g_vcTabHome != nil)
                 [g_vcTabHome onAPISuccess:type result:nil];
         }
         else
         {
             if (g_vcTabHome != nil)
                 [g_vcTabHome onAPIFail:type result:nil];
         }
         
 
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (g_vcTabHome != nil)
             [g_vcTabHome onAPIFail:type result:nil];
     }];
}

+ (void) onGetNotificationTypes:(const CUIViewController*) mVCPage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":@"",
                                @"password":@""};
    
    [manager GET:API_URL_GETNOTIFICATIONTYPES parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
    
         if(bStatus == true)
         {
        
         }
         else
         {
             
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

+ (void) onSetReadNotification:(const CUIViewController*) mVCPage type:(int)type notificationId:(NSInteger)value
{
    NSString* notId = [NSString stringWithFormat:@"%ld", (long)value];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"notificationId":notId};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SETREADNOTIFICATION];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             //[mVCPage onAPISuccess:type result:message];
         }
         else
         {
             //[mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         //[mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onGetUserPlan:(const CUIViewController*) mVCPage  type:(int)type
{
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"29e450ad-e196-f9b5-0a2a-0a34810457dd" };
    
    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    NSString*   email = [NSString stringWithFormat:@"&email=%@", g_pUserModel.strEmail];
    NSString*   password = [NSString stringWithFormat:@"&password=%@", g_pUserModel.strPassword];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERPLAN];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
             
                                                        if(bStatus == true)
                                                        {
                                                            CPaymentPlanModel* model = [[CPaymentPlanModel alloc] init];
                                                            model.packageTitle = [json objectForKey:@"packageTitle"];
                                                            model.packageDescription = [json objectForKey:@"packageDescription"];
                                                            //model.packageDurationType = [json objectForKey:@"packageDurationType"];
                                                            model.packageID = [[json objectForKey:@"packageID"] integerValue];
                                                            //model.packageDuration = [[json objectForKey:@"packageDuration"] integerValue];
                                                            model.packageExpirationDate = [json objectForKey:@"packageExpirationDate"];
                                                            model.packagePrice = [[json objectForKey:@"packageAmount"] floatValue];
                                                            
                                                            [mVCPage onAPISuccess:type result:model];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:@""];
                                                        }
                                                    }
                                                }];
    [dataTask resume];

    
    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERPLAN];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             CPaymentPlanModel* model = [[CPaymentPlanModel alloc] init];
             model.packageTitle = [responseObject objectForKey:@"packageTitle"];
             model.packageDescription = [responseObject objectForKey:@"packageDescription"];
             model.packageDurationType = [responseObject objectForKey:@"packageDurationType"];
             model.packageID = [[responseObject objectForKey:@"packageID"] integerValue];
             model.packageDuration = [[responseObject objectForKey:@"packageDuration"] integerValue];
             model.packagePrice = [[responseObject objectForKey:@"packagePrice"] floatValue];
     
             [mVCPage onAPISuccess:type result:model];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
     */
}

+ (void) onGetSubscriptionPlans:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETSUBSCRIPTIONPLANS];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrPlans = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"plans"];
             
             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CPaymentPlanModel* model = [[CPaymentPlanModel alloc] init];
                 model.packageTitle = [pDic objectForKey:@"packageTitle"];
                 model.packageDescription = [pDic objectForKey:@"packageDescription"];
                 model.packageDurationType = [pDic objectForKey:@"packageDurationType"];
                 model.packageID = [[pDic objectForKey:@"packageID"] integerValue];
                 model.packageDuration = [[pDic objectForKey:@"packageDuration"] integerValue];
                 model.packagePrice = [[pDic objectForKey:@"packagePrice"] floatValue];
                 
                 if ([model.packageTitle isEqualToString:@"Free Trial"])
                     continue;
                 [arrPlans addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrPlans];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onAddUserPayment:(const CUIViewController*) mVCPage type:(int)type model:(CPromotionModel*)model
{
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache" };

    NSString*   apiKey = [NSString stringWithFormat:@"apiKey=%@", API_NOR_APIKEY];
    NSString*   secretKey = [NSString stringWithFormat:@"&secretKey=%@", API_NOR_SECRETKEY];
    NSString*   email = [NSString stringWithFormat:@"&email=%@", g_strEmail];
    NSString*   password = [NSString stringWithFormat:@"&password=%@", g_strPassword];
    NSString*   packageID = [NSString stringWithFormat:@"&packageID=%@", model.packageID];
    NSString*   identificationUniqeID = [NSString stringWithFormat:@"&identificationUniqeID=%@", model.identificationUniqID];
    NSString*   presentationAmount = [NSString stringWithFormat:@"&presentationAmount=%@", model.presentationAmount];
    NSString*   gatewayName = [NSString stringWithFormat:@"&gatewayName=%@", model.gatewayName];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[secretKey dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[packageID dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[identificationUniqeID dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[presentationAmount dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[gatewayName dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_ADDUSERPAYMENT];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        
                                                        [mVCPage onAPIFail:type result:nil];
                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSError* error1;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error1];
                                                        BOOL bStatus = [[json objectForKey:@"status"] boolValue];
                                                        NSString *message = [json objectForKey:@"message"];
                                                        if(bStatus == true)
                                                        {
                                                            [mVCPage onAPISuccess:type result:message];
                                                        }
                                                        else
                                                        {
                                                            [mVCPage onAPIFail:type result:message];
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"packageID":model.packageID,
                                @"identificationUniqeID":model.identificationUniqID,
                                @"presentationAmount":model.presentationAmount,
                                @"gatewayName":model.gatewayName};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_ADDUSERPAYMENT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
     */
}

+ (void) onGetPromotionCodeCheck:(const CUIViewController *)mVCPage type:(int)type code:(NSString*)code
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"code":code
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_PROMOTIONCODECHECKING];
    [manager GET:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         //NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSMutableArray* arrPlans = [[NSMutableArray alloc] init];
             NSArray* arrTemp = [responseObject objectForKey:@"plans"];
             
             NSInteger nCount = arrTemp.count;
             for (int i = 0; i < nCount; i++)
             {
                 NSDictionary * pDic = (NSDictionary *)[arrTemp objectAtIndex:i];
                 
                 CPromotionInfoModel* model = [[CPromotionInfoModel alloc] init];
                 model.packageTitle = [pDic objectForKey:@"packageTitle"];
                 model.packageDescription = [pDic objectForKey:@"packageDescription"];
                 model.packageDurationType = [pDic objectForKey:@"packageDurationType"];
                 model.packageID = [[pDic objectForKey:@"packageID"] integerValue];
                 model.packageDuration = [[pDic objectForKey:@"packageDuration"] integerValue];
                 model.packagePrice = [[pDic objectForKey:@"packagePrice"] floatValue];
                 model.promotionStatus = [pDic objectForKey:@"promotionStatus"];
                 
                 model.promotionCode = [responseObject objectForKey:@"code"];
                 model.totalPromotionStatus = [responseObject objectForKey:@"totalPromotionStatus"];
                 model.message = [responseObject objectForKey:@"message"];

                 [arrPlans addObject:model];
             }
             [mVCPage onAPISuccess:type result:arrPlans];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onStartPaymentProcess:(const CUIViewController*) mVCPage type:(int)type  gateway:(NSString*)gateway
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"packageID":[NSString stringWithFormat:@"%ld", (long)g_pUserModel.pSelectedPaymentModel.packageID],
                                @"gatewayName":gateway,
                                };
    NSLog(@"GateWay");
    if ( [g_pUserModel.pSelectedPaymentModel.promotionStatus isEqualToString:@"valid"])
    {
        dictParam = @{@"apiKey":API_NOR_APIKEY,
                      @"secretKey":API_NOR_SECRETKEY,
                      @"email":g_strEmail,
                      @"password":g_strPassword,
                      @"packageID":[NSString stringWithFormat:@"%ld", (long)g_pUserModel.pSelectedPaymentModel.packageID],
                      @"gatewayName":gateway,
                      @"code":g_pUserModel.pSelectedPaymentModel.promotionCode
                      };
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_STARTPAYMENTPROCESS];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             NSInteger orderId = [[responseObject objectForKey:@"orderId"] integerValue];
             
             g_pUserModel.pSelectedPaymentModel.orderId = orderId;
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onAddNewPayment:(const CUIViewController*) mVCPage type:(int)type identificationID:(NSString*)identificationID amount:(NSDecimalNumber*)amount status:(NSString*)status
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"orderID":[NSString stringWithFormat:@"%ld", (long)g_pUserModel.pSelectedPaymentModel.orderId],
                                @"status":@"okey",
                                @"identificationUniqeID": identificationID,
                                @"presentationAmount":amount
                                };
    if (g_pUserModel.pSelectedPaymentModel.promotionCode) {
        if ([g_pUserModel.pSelectedPaymentModel.promotionStatus isEqualToString:@"valid"]) {
            dictParam = @{@"apiKey":API_NOR_APIKEY,
                           @"secretKey":API_NOR_SECRETKEY,
                           @"email":g_strEmail,
                           @"password":g_strPassword,
                           @"orderID":[NSString stringWithFormat:@"%ld", (long)g_pUserModel.pSelectedPaymentModel.orderId],
                           @"status":@"okey",
                           @"identificationUniqeID": identificationID,
                           @"presentationAmount":amount,
                           @"code":g_pUserModel.pSelectedPaymentModel.promotionCode
                           };
        }
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_ADDNEWPAYMENT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         NSString* returnCode = [responseObject objectForKey:@"returnCode"];//{active, fail, cancelled}
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onGetUserTimezone:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_GETUSERTIMEZONE];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         
         if(bStatus == true)
         {
             if  (g_pTimeZoneModel== nil)
                 g_pTimeZoneModel = [[CTimeZoneModel alloc] init];
             
             g_pTimeZoneModel.date = [responseObject objectForKey:@"date"];
             g_pTimeZoneModel.time = [responseObject objectForKey:@"time"];
             g_pTimeZoneModel.timezoneDescription = [responseObject objectForKey:@"timezoneDescription"];
             g_pTimeZoneModel.timezone = [responseObject objectForKey:@"timezone"];
             g_pTimeZoneModel.UTC = [responseObject objectForKey:@"UTC"];


//             [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:g_pTimeZoneModel.timezone]];
             [mVCPage onAPISuccess:type result:g_pTimeZoneModel];
         }
         else
         {
             [mVCPage onAPIFail:type result:nil];
         }
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
}

+ (void) onSetUserTimezone:(const CUIViewController*) mVCPage type:(int)type
{
    NSString *utcOffsetName = [CUtility getDeviceUTCOffset];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"type":@"time",
                                @"offset":utcOffsetName
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_SETUSERTIMEZONE];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if (mVCPage != nil)
             [mVCPage onAPISuccess:type result:nil];
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onPostContact:(const CUIViewController*) mVCPage type:(int)type body:(NSString*)body meta:(NSString*)meta
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"body":body,
                                @"os":@"IOS",
                                @"meta":meta};
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTCONTACT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
         
     }];
}

+ (void) onPostCouponCode:(const CUIViewController*) mVCPage type:(int)type code:(NSString*)code
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"coupon":code
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTCOUPON];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }

     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];
    
}

+ (void) onPostWirePayment:(const CUIViewController*) mVCPage type:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTWIREPAYMENT];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         if ([responseObject objectForKey:@"maintenanceMode"])
         {
             g_strMaintainance = [responseObject objectForKey:@"message"];
             [CGlobal goMaintainance:mVCPage];
             return;
         }
         
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         NSString *message = [responseObject objectForKey:@"message"];
         
         if(bStatus == true)
         {
             [mVCPage onAPISuccess:type result:message];
         }
         else
         {
             [mVCPage onAPIFail:type result:message];
         }
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         [mVCPage onAPIFail:type result:nil];
     }];

}

+ (void) onSendOSVersion:(const CUIViewController*) mVCPage type:(int)type
{
    NSString* strVersion = [NSString stringWithFormat:@"%.1f", APP_VERSION];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"os":@"ios",
                                @"version":strVersion
                                };
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTLASTLOGIN];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];

         if(bStatus == true)
         {
             NSString* strVersion = [responseObject objectForKey:@"latestIosVersion"];
         
             double fServerVersion = [strVersion doubleValue];
             NSString* currentVersion = [NSString stringWithFormat:@"%.1f", APP_VERSION];
             double fDiff = fServerVersion - APP_VERSION;
             
             if (![strVersion isEqualToString:currentVersion])
             {
                 if (fDiff >= 0.1)
                 {
                     if (mVCPage != nil)
                         [mVCPage onAPISuccess:type result:strVersion];
                 } else {
                     if (mVCPage != nil)
                         [mVCPage onAPISuccess:type result:nil];
                 }
             }
             else {
                 if (mVCPage != nil)
                    [mVCPage onAPISuccess:type result:nil];
             }
         }
         else
         {
             if (mVCPage != nil)
                 [mVCPage onAPISuccess:type result:nil];
         }

     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
             [mVCPage onAPISuccess:type result:nil];
     }];
    
}

+ (void) onSetLastLogin:(const CUIViewController*) mVCPage type:(int)type
{
    NSString* strVersion = [NSString stringWithFormat:@"%.1f", APP_VERSION];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dictParam = @{@"apiKey":API_NOR_APIKEY,
                                @"secretKey":API_NOR_SECRETKEY,
                                @"email":g_strEmail,
                                @"password":g_strPassword,
                                @"os":@"ios",
                                @"version":strVersion
                                };
    NSString *strURL = [NSString stringWithFormat:@"%@%@", API_URL_BASE, API_URL_POSTLASTLOGIN];
    [manager POST:strURL parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         BOOL bStatus = [[responseObject objectForKey:@"status"] boolValue];
         
         if(bStatus == true)
         {
             NSString* strVersion = [responseObject objectForKey:@"latestIosVersion"];
             double fServerVersion = [strVersion doubleValue];
             NSString* current = [NSString stringWithFormat:@"%.1f", APP_VERSION];
             
             double fDiff = fServerVersion - APP_VERSION;
             
             //             if (fServerVersion > APP_VERSION)
             
             if (![strVersion isEqualToString:current])
             {
                 if (fDiff >= 0.1)
                 {
                     if (mVCPage != nil)
                     [mVCPage onAPISuccess:type result:strVersion];
                 }
                 else
                 {
                     if (mVCPage != nil)
                     [mVCPage onAPISuccess:type result:nil];
                 }
             }
             else
             if (mVCPage != nil)
             [mVCPage onAPISuccess:type result:nil];
         }
         else
         {
             if (mVCPage != nil)
             [mVCPage onAPISuccess:type result:nil];
         }
         
     } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error)
     {
         if (mVCPage != nil)
         [mVCPage onAPISuccess:type result:nil];
     }];
    
}
@end

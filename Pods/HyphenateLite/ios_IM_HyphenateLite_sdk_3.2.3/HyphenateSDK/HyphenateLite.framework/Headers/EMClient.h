/*!
 *  @header EMClient.h
 *  @abstract SDK Client
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMClientDelegate.h"
#import "EMOptions.h"
#import "EMPushOptions.h"
#import "EMError.h"

#import "IEMChatManager.h"
#import "IEMContactManager.h"
#import "IEMGroupManager.h"
#import "IEMChatroomManager.h"

/*!
 *  SDK Client
 */
@interface EMClient : NSObject
{
    EMPushOptions *_pushOptions;
}

/*!
 *  SDK version
 */
@property (nonatomic, strong, readonly) NSString *version;

/*!
 *  Current logged in user's username
 */
@property (nonatomic, strong, readonly) NSString *currentUsername;

/*!
 *  SDK setting options
 */
@property (nonatomic, strong, readonly) EMOptions *options;

/*!
 *  Apple Push Notification Service setting
 */
@property (nonatomic, strong, readonly) EMPushOptions *pushOptions;

/*!
 *  Chat Management
 */
@property (nonatomic, strong, readonly) id<IEMChatManager> chatManager;

/*!
 *  Contact Management
 */
@property (nonatomic, strong, readonly) id<IEMContactManager> contactManager;

/*!
 *  Group Management
 */
@property (nonatomic, strong, readonly) id<IEMGroupManager> groupManager;

/*!
 *  Chat room Management
 */
@property (nonatomic, strong, readonly) id<IEMChatroomManager> roomManager;

/*!
 *  If SDK will automatically log into with previously logged in session
 */
@property (nonatomic, readonly) BOOL isAutoLogin;

/*!
 *  If a user logged in
 */
@property (nonatomic, readonly) BOOL isLoggedIn;

/*!
 *  Connection status to Hyphenate IM server
 */
@property (nonatomic, readonly) BOOL isConnected;

/*!
 *  Get SDK singleton instance
 */
+ (instancetype)sharedClient;

#pragma mark - Delegate

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of calling delegate methods
 */
- (void)addDelegate:(id<EMClientDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  Remove delegate
 *  
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id)aDelegate;

#pragma mark - Initialize SDK

/*!
 *  Initialize the SDK
 *  
 *  @param aOptions  SDK setting options
 *
 *  @result Error
 */
- (EMError *)initializeSDKWithOptions:(EMOptions *)aOptions;

#pragma mark - Sync method

#pragma mark - Register

/*!
 *  Register a new IM user
 *
 *  To enhance the reliability, registering new IM user through REST API from backend is highly recommended
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)registerWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword;

#pragma mark - Login

/*!
 *  Login
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)loginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword;

#pragma makr - Logout

/*!
 *  Logout
 *
 *  @param aIsUnbindDeviceToken Unbind device token to disable Apple Push Notification Service
 *
 *  @result Error
 */
- (EMError *)logout:(BOOL)aIsUnbindDeviceToken;

#pragma mark - Apns

/*!
 *  Device token binding is required for enabling Apple Push Notification Service
 *
 *  @param aDeviceToken  Device token to bind
 *
 *  @result Error
 */
- (EMError *)bindDeviceToken:(NSData *)aDeviceToken;

/*!
 *  Set display name for Apple Push Notification message
 *
 *  @param aNickname  Display name
 *
 *  @result Error
 */
- (EMError *)setApnsNickname:(NSString *)aNickname;

/*!
 *  Get Apple Push Notification Service options from the server
 *
 *  @param pError  Error
 *
 *  @result Apple Push Notification Service options
 */
- (EMPushOptions *)getPushOptionsFromServerWithError:(EMError **)pError;

/*!
 *  Update Apple Push Notification Service options to the server
 *
 *  @result Error
 */
- (EMError *)updatePushOptionsToServer;

/*!
 *  Upload debugging log to server
 *
 *  @result Error
 */
- (EMError *)uploadLogToServer;

#pragma mark - Async method

/*!
 *  Register a new IM user
 *
 *  To enhance the reliability, registering new IM user through REST API from backend is highly recommended
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)registerWithUsername:(NSString *)aUsername
                    password:(NSString *)aPassword
                  completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Login
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loginWithUsername:(NSString *)aUsername
                 password:(NSString *)aPassword
               completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Logout
 *
 *  @param aIsUnbindDeviceToken Unbind device token to disable the Apple Push Notification Service
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)logout:(BOOL)aIsUnbindDeviceToken
    completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  Device token binding is required to enable Apple push notification service
 *
 *  @param aDeviceToken     Device token to bind
 *  @param aCompletionBlock The callback block of completion
 */
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)aDeviceToken
                                           completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  Set display name for the push notification
 *
 *  @param aDisplayName     Display name of push
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updatePushNotifiationDisplayName:(NSString *)aDisplayName
                              completion:(void (^)(NSString *aDisplayName, EMError *aError))aCompletionBlock;
/*!
 *  Get Apple Push Notification Service options from the server
 *
 *  @param aCompletionBlock The callback block of completion
 */
- (void)getPushNotificationOptionsFromServerWithCompletion:(void (^)(EMPushOptions *aOptions, EMError *aError))aCompletionBlock;

/*!
 *  Update Apple Push Notification Service options to the server
 *
 *  @param aCompletionBlock The callback block of completion
 */
- (void)updatePushNotificationOptionsToServerWithCompletion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  Upload log to server
 *
 *  @param aCompletionBlock The callback block of completion
 */
- (void)uploadDebugLogToServerWithCompletion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - iOS

/*!
 *  Migrate the IM database to the latest SDK version
 *
 *  @result Return YES for success
 */
- (BOOL)migrateDatabaseToLatestSDK;

/*!
 *  Disconnect from server when app enters background
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationDidEnterBackground:(id)aApplication;

/*!
 *  Re-connect to server when app enters foreground
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationWillEnterForeground:(id)aApplication;

/*!
 *  Need to call this method when APP receive APNs in foreground
 *
 *  @param application  UIApplication
 *  @param userInfo     Push content
 */
- (void)application:(id)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMClientDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMCallManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  Register a new user
 *
 *  To enhance the reliability, registering new IM user through REST API from backend is highly recommended
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                          success:(void (^)())aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -registerWithUsername:password:completion:");

/*!
 *  Login
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                       success:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -loginWithUsername:password:completion");

/*!
 *  Logout
 *
 *  @param aIsUnbindDeviceToken Unbind device token to disable the Apple Push Notification Service
 *
 *  @result Error
 */
- (void)asyncLogout:(BOOL)aIsUnbindDeviceToken
            success:(void (^)())aSuccessBlock
            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -logout:completion:");

/*!
 *  Bind device token
 *
 *  @param aDeviceToken     Device token to bind
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncBindDeviceToken:(NSData *)aDeviceToken
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -registerForRemoteNotificationsWithDeviceToken:completion:");

/*!
 *  Set display name for push notification
 *
 *  @param aDisplayName        Push Notification display name
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSetApnsNickname:(NSString *)aNickname
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushNotifiationDisplayName:copletion");

/*!
 *  Get apns options from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncGetPushOptionsFromServer:(void (^)(EMPushOptions *aOptions))aSuccessBlock
                              failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getPushOptionsFromServerWithCompletion:");

/*!
 *  Update APNS options to the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUpdatePushOptionsToServer:(void (^)())aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushNotificationOptionsToServerWithCompletion:");

/*!
 *  Upload log to server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncUploadLogToServer:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -uploadDebugLogToServerWithCompletion:");

/*!
 *  iOS-specific, data migration to SDK3.0
 *
 *  Synchronization method will block the current thread
 *
 *  It's needed to call this method when update to SDK3.0, developers need to wait this method complete before DB related operations
 *
 *  @result Whether migration successful
 */
- (BOOL)dataMigrationTo3 __deprecated_msg("Use -migrateDatabaseToLatestSDK");

@end

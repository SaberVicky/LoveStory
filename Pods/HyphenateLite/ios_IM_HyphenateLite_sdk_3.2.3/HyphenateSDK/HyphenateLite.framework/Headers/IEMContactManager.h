/*!
 *  @header IEMContactManager.h
 *  @abstract The protocol defines the operations of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMContactManagerDelegate.h"

@class EMError;

/*!
 *  Contact Management
 */
@protocol IEMContactManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id)aDelegate;

/*!
 *  Get all contacts
 *
 *  @result Contact list<EMGroup>
 */
- (NSArray *)getContacts;

/*!
 *  Get the blacklist of blocked users
 *
 *  @result Blacklist<EMGroup>
 */
- (NSArray *)getBlackList;

#pragma mark - Sync method

/*!
 *  Get all the contacts from the server
 *
 *  @param pError Error
 *
 *  @return Contact list<NSString>
 */
- (NSArray *)getContactsFromServerWithError:(EMError **)pError;

/*!
 *  Add a contact with invitation message
 *
 *  @param aUsername  The user to add
 *  @param aMessage   Invitation message
 *
 *  @return Error
 */
- (EMError *)addContact:(NSString *)aUsername
                message:(NSString *)aMessage;

/*!
 *  Delete a contact
 *
 *  @param aUsername The user to delete
 *  @param aIsDeleteConversation Delete the conversation or not
 *
 *  @return Error
 */
- (EMError *)deleteContact:(NSString *)aUsername
          isDeleteConversation:(BOOL)aIsDeleteConversation;

/*!
 *  Get the blacklist from the server
 *
 *  @param pError Error
 *
 *  @return Blacklist<NSString>
 */
- (NSArray *)getBlackListFromServerWithError:(EMError **)pError;

/*!
 *  Add a user to blacklist
 *
 *  @param aUsername Block user
 *  @param aBoth     if aBoth is YES, then hide user and block messages from blocked user; if NO, then hide user from blocked user
 *
 *  @return Error
 */
- (EMError *)addUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth;

/*!
 *  Remove user out of blacklist
 *
 *  @param aUsername Unblock user
 *
 *  @return Error
 */
- (EMError *)removeUserFromBlackList:(NSString *)aUsername;

/*!
 *  Accept a friend request
 *
 *  @param aUsername User who initiated the friend request
 *
 *  @return Error
 */
- (EMError *)acceptInvitationForUsername:(NSString *)aUsername;

/*!
 *  Decline a friend request
 *
 *  @param aUsername User who initiated the friend request
 *
 *  @return Error
 *
 * Please use the new method 
 * - (void)declineFriendRequestFromUser:(NSString *)aUsername
 *                           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;
 */
- (EMError *)declineInvitationForUsername:(NSString *)aUsername;

#pragma mark - Async method

/*!
 *  Get all contacts from the server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getContactsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  Add a contact
 *
 *  @param aUsername        The user to be added
 *  @param aMessage         Friend request message
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addContact:(NSString *)aUsername
           message:(NSString *)aMessage
        completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Delete a contact
 *
 *  @param aUsername                The user to be deleted
 *  @param aIsDeleteConversation    Delete the conversation or not
 *  @param aCompletionBlock         The callback block of completion
 *
 */
- (void)deleteContact:(NSString *)aUsername
     isDeleteConversation:(BOOL)aIsDeleteConversation
           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Get the blacklist from the server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getBlackListFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  Add a user to blacklist
 *
 *  @param aUsername        Block user
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addUserToBlackList:(NSString *)aUsername
                completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Remove a user from blacklist
 *
 *  @param aUsername        Unblock user
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeUserFromBlackList:(NSString *)aUsername
                     completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Apporove a friend request
 *
 *  @param aUsername        User who initiated the friend request
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)approveFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  Decline a friend request
 *
 *  @param aUsername        User who initiated the friend request
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMContactManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  Get all the friends from the DB
 *
 *  @return Contact list<NSString>
 */
- (NSArray *)getContactsFromDB __deprecated_msg("Use -getContacts");

/*!
 *  Get the blacklist from the DB
 *
 *  @return Blacklist<NSString>
 */
- (NSArray *)getBlackListFromDB __deprecated_msg("Use -getBlackList");

/*!
 *  Get all the friends from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetContactsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getContactsFromServerWithCompletion:");

/*!
 *  Add a contact
 *
 *  @param aUsername        The user to add
 *  @param aMessage         Friend invitation message
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddContact:(NSString *)aUsername
                message:(NSString *)aMessage
                success:(void (^)())aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addContact:message:completion:");

/*!
 *  Delete a contact
 *
 *  @param aUsername The user to delete
 *
 *  @return Error
 */
- (EMError *)deleteContact:(NSString *)aUsername __deprecated_msg("Use -deleteContact:username:isDeleteConversation:");


/*!
 *  Delete a contact
 *
 *  @param aUsername        The user to be deleted
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)deleteContact:(NSString *)aUsername
           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock __deprecated_msg("Use -deleteContact:username:isDeleteConversation:");

/*!
 *  Delete friend
 *
 *  @param aUsername        The user to delete
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeleteContact:(NSString *)aUsername
                   success:(void (^)())aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -deleteContact:completion:");

/*!
 *  Get the blacklist from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetBlackListFromServer:(void (^)(NSArray *aList))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getBlackListFromServerWithCompletion:");

/*!
 *  Add user to blacklist
 *
 *  @param aUsername        The user to add
 *  @param aBoth            Whether block messages from me to the user which is added to the black list
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth
                        success:(void (^)())aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addUserToBlackList:completion:");

/*!
 *  Remove user from blacklist
 *
 *  @param aUsername        The user to remove from blacklist
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRemoveUserFromBlackList:(NSString *)aUsername
                             success:(void (^)())aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeUserFromBlackList:completion:");

/*!
 *  Agree invitation
 *
 *  @param aUsername        Applicants
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptInvitationForUsername:(NSString *)aUsername
                                 success:(void (^)())aSuccessBlock
                                 failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveFriendRequestFromUser:completion:");

/*!
 *  Decline invitation
 *
 *  @param aUsername        Applicants
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineInvitationForUsername:(NSString *)aUsername
                                  success:(void (^)())aSuccessBlock
                                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineFriendRequestFromUser:completion:");
@end

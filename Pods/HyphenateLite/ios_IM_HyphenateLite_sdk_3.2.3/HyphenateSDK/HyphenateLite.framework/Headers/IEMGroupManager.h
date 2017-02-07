/*!
 *  @header IEMGroupManager.h
 *  @abstract This protocol defines the group operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMGroupManagerDelegate.h"
#import "EMGroup.h"
#import "EMGroupOptions.h"
#import "EMCursorResult.h"

/*!
 *  Group operations
 */
@protocol IEMGroupManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id)aDelegate;

#pragma mark - Get Group

/*!
 *  Get all groups
 *
 *  @result Group list<EMGroup>
 *
 */
- (NSArray *)getJoinedGroups;

/*!
 *  Get the list of groups which have disabled Apple Push Notification Service
 *
 *  @param pError  Error
 */
- (NSArray *)getGroupsWithoutPushNotification:(EMError **)pError;

#pragma mark - Sync method

/**
 *  Get all of user's groups from server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getMyGroupsFromServerWithError:(EMError **)pError;

/*!
 *  Get public groups with the specified range from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param aCursor   Cursor, input nil the first time
 *  @param aPageSize Expect result count, return all results if count is less than zero
 *  @param pError    Error
 *
 *  @return    The result
 */
- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                               pageSize:(NSInteger)aPageSize
                                                  error:(EMError **)pError;

/*!
 *  Search a public group with the id
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroundId   Group id
 *  @param pError      Error
 *
 *  @return The group with the id
 */
- (EMGroup *)searchPublicGroupWithId:(NSString *)aGroundId
                               error:(EMError **)pError;

#pragma mark - Create

/*!
 *  Create a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject        Group subject
 *  @param aDescription    Group description
 *  @param aInvitees       Group members, without creater
 *  @param aMessage        Invitation message
 *  @param aSetting        Group options
 *  @param pError          Error
 *
 *  @return    Created group
 */
- (EMGroup *)createGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                              error:(EMError **)pError;

#pragma mark - Fetch Info

/*!
 *  Fetch group info
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether to get member list
 *  @param pError                Error
 *
 *  @return    Group instance
 */
- (EMGroup *)fetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                      error:(EMError **)pError;

/*!
 *  Get group‘s blacklist, required owner’s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @return    Group blacklist<NSString>
 */
- (NSArray *)fetchGroupBansList:(NSString *)aGroupId
                          error:(EMError **)pError;

#pragma mark - Edit Group

/*!
 *  Invite User to join a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants      Invited users
 *  @param aGroupId        Group id
 *  @param aWelcomeMessage Welcome message
 *  @param pError          Error
 *
 *  @result    Group instance, return nil if fail
 */
- (EMGroup *)addOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                    error:(EMError **)pError;

/*!
 *  Remove members from a group, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)removeOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  Add users to group blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be added
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                      error:(EMError **)pError;


/*!
 *  Remove users from group blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                        error:(EMError **)pError;

/*!
 *  Change group subject, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject  New group subject
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Group instance
 */
- (EMGroup *)changeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                          error:(EMError **)pError;

/*!
 *  Change group description, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDescription New group description
 *  @param aGroupId     Group id
 *  @param pError       Error
 *
 *  @result    Group
 */
- (EMGroup *)changeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                         error:(EMError **)pError;

/*!
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Leaved group, return nil if fail
 */
- (EMGroup *)leaveGroup:(NSString *)aGroupId
                 error:(EMError **)pError;

/*!
 *  Destroy a group, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Destroyed group, return nil if failed
 */
- (EMGroup *)destroyGroup:(NSString *)aGroupId
                    error:(EMError **)pError;


/*!
 *  Block group messages, server will blocks the messages from the group, owner can't block the group's message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockGroup:(NSString *)aGroupId
                  error:(EMError **)pError;

/*!
 *  Unblock group messages
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockGroup:(NSString *)aGroupId
                    error:(EMError **)pError;

#pragma mark - Edit Public Group

/*!
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId Public group id
 *  @param pError   Error
 *
 *  @result    Joined public group
 */
- (EMGroup *)joinPublicGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  Request to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId    Public group id
 *  @param aMessage    Request info
 *  @param pError      Error
 *
 *  @result    Group instance
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                            error:(EMError **)pError;

#pragma mark - Application

/*!
 *  Accept a group request, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param aUsername  The applicant
 *
 *  @result Error
 */
- (EMError *)acceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername;

/*!
 *  Decline a group request, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername Group request sender
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason;

/*!
 *  Accept a group invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param groupId     Group id
 *  @param aUsername   Inviter
 *  @param pError      Error
 *
 *  @result Joined group instance
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                                 error:(EMError **)pError;

/*!
 *  Decline a group invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername Inviter
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason;

#pragma mark - Apns

/*!
 *  Block / unblock group message‘s push notification
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId    Group id
 *  @param aIgnore     Whether block
 *
 *  @result Error
 */
- (EMError *)ignoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore;

#pragma mark - Async method

/**
 *  Get all of user's groups from server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getJoinedGroupsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  Get public groups with the specified range from the server
 *
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Expect result count, return all results if count is less than zero
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  Search public group with group id
 *
 *  @param aGroundId        Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)searchPublicGroupWithId:(NSString *)aGroundId
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Create a group
 *
 *  @param aSubject         Group subject
 *  @param aDescription     Group description
 *  @param aInvitees        Group members, without creater
 *  @param aMessage         Invitation message
 *  @param aSetting         Group options
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)createGroupWithSubject:(NSString *)aSubject
                   description:(NSString *)aDescription
                      invitees:(NSArray *)aInvitees
                       message:(NSString *)aMessage
                       setting:(EMGroupOptions *)aSetting
                    completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Fetch group specification
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether to get member list
 *  @param aCompletionBlock      The callback block of completion
 *
 */
- (void)getGroupSpecificationFromServerByID:(NSString *)aGroupID
                         includeMembersList:(BOOL)aIncludeMembersList
                                 completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Get group's blacklist, owner’s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupBlackListFromServerByID:(NSString *)aGroupId
                             completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  Invite User to join a group
 *
 *  @param aUsers           Invited users
 *  @param aGroupId         Group id
 *  @param aMessage         Welcome message
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addMembers:(NSArray *)aUsers
           toGroup:(NSString *)aGroupId
           message:(NSString *)aMessage
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Remove members from a group, owner‘s authority is required
 *
 *  @param aUsers           Users to be removed
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeMembers:(NSArray *)aUsers
            fromGroup:(NSString *)aGroupId
           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Add users to group blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be added
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)blockMembers:(NSArray *)aMembers
           fromGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Remove users out of group blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be removed
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unblockMembers:(NSArray *)aMembers
             fromGroup:(NSString *)aGroupId
            completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Change the group subject, owner‘s authority is required
 *
 *  @param aSubject         New group‘s subject
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateGroupSubject:(NSString *)aSubject
                  forGroup:(NSString *)aGroupId
                completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Change the group description, owner‘s authority is required
 *
 *  @param aDescription     New group‘s description
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateDescription:(NSString *)aDescription
                 forGroup:(NSString *)aGroupId
               completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)leaveGroup:(NSString *)aGroupId
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Destroy a group, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)destroyGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Block group messages, server blocks the messages from the group, owner can't block the group's messages
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)blockGroup:(NSString *)aGroupId
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Unblock group message
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unblockGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         Public group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)joinPublicGroup:(NSString *)aGroupId
            completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Request to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         Public group id
 *  @param aMessage         Apply info
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)requestToJoinPublicGroup:(NSString *)aGroupId
                         message:(NSString *)aMessage
                      completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Approve a group request, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Group request sender
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)approveJoinGroupRequest:(NSString *)aGroupId
                         sender:(NSString *)aUsername
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Decline a group request, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Group request sender
 *  @param aReason          Decline reason
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineJoinGroupRequest:(NSString *)aGroupId
                        sender:(NSString *)aUsername
                        reason:(NSString *)aReason
                    completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Accept a group invitation
 *
 *  @param groupId          Group id
 *  @param aUsername        Inviter
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)acceptInvitationFromGroup:(NSString *)aGroupId
                           inviter:(NSString *)aUsername
                        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  Decline a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aInviter         Inviter
 *  @param aReason          Decline reason
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineGroupInvitation:(NSString *)aGroupId
                       inviter:(NSString *)aInviter
                        reason:(NSString *)aReason
                    completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  Block / unblock group message‘s push notification
 *
 *  @param aGroupId          Group id
 *  @param aIsEnable         Whether enable
 *  @param aCompletionBlock  The callback block of completion
 *
 */
- (void)updatePushServiceForGroup:(NSString *)aGroupID
                    isPushEnabled:(BOOL)aIsEnable
                       completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMGroupManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  Get all groups, will load from DB if not exist in memory
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getAllGroups __deprecated_msg("Use -getJoinedGroups");

/*!
 *  Load all groups from DB, will update group list in memory after loading
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)loadAllMyGroupsFromDB __deprecated_msg("Use -getJoinedGroups");

/*!
 *  Get ID list of groups which block push from memory
 *
 *  @result Group id list<NSString>
 */
- (NSArray *)getAllIgnoredGroupIds __deprecated_msg("Use -getGroupsWithoutPushNotification");

/**
 *  Get all of user's groups from server, will update group list in memory and DB after success
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetMyGroupsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getJoinedGroupsFromServerWithCompletion:");

/*!
 *  Get public groups in the specified range from the server
 *
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Expect result count, will return all results if < 0
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                        pageSize:(NSInteger)aPageSize
                                         success:(void (^)(EMCursorResult *aCursor))aSuccessBlock
                                         failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getPublicGroupsFromServerWithCursor:pageSize:completion:");

/*!
 *  Search public group with the id
 *
 *  @param aGroundId        Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSearchPublicGroupWithId:(NSString *)aGroundId
                             success:(void (^)(EMGroup *aGroup))aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -searchPublicGroupWithId:completion:");

/*!
 *  Create a group
 *
 *  @param aSubject         Group subject
 *  @param aDescription     Group description
 *  @param aInvitees        Group members, without creater
 *  @param aMessage         Invitation message
 *  @param aSetting         Group options
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncCreateGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                            success:(void (^)(EMGroup *aGroup))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -createGroupWithSubject:description:invitees:message:setting:completion");

/*!
 *  Fetch group info
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether get member list
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncFetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getGroupSpecificationFromServerByID:includeMembersList:completion:");

/*!
 *  Get group‘s blacklist, need owner’s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncFetchGroupBansList:(NSString *)aGroupId
                        success:(void (^)(NSArray *aList))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock  __deprecated_msg("Use -getGroupBlackListFromServerByID:completion:");

/*!
 *  Invite User to join a group
 *
 *  @param aOccupants       Invited users
 *  @param aGroupId         Group id
 *  @param aWelcomeMessage  Welcome message
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addMembers:toGroup:message:completion:");

/*!
 *  Remove members from group, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRemoveOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeMembers:fromGroup:completion:");

/*!
 *  Add users to group’s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be added
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockMembers:fromGroup:completion:");

/*!
 *  Remove users from group‘s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                      success:(void (^)(EMGroup *aGroup))aSuccessBlock
                      failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockMembers:fromGroup:completion:");

/*!
 *  Change group’s subject, need owner‘s authority
 *
 *  @param aSubject         New group‘s subject
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                        success:(void (^)(EMGroup *aGroup))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateGroupSubject:forGroup:completion");

/*!
 *  Change group’s description, need owner‘s authority
 *
 *  @param aDescription     New group‘s description
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                       success:(void (^)(EMGroup *aGroup))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateDescription:forGroup:completion");

/*!
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLeaveGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -leaveGroup:completion");

/*!
 *  Destroy a group, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDestroyGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -destroyGroup:completion");

/*!
 *  Block group’s message, server will blocks the messages of the group to user, owner can't block the group's message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockGroup:completion:");

/*!
 *  Unblock group message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockGroup:completion");

/*!
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         Public group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncJoinPublicGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -joinPublicGroup:completion");

/*!
 *  Apply to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         Public group id
 *  @param aMessage         Apply info
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                          success:(void (^)(EMGroup *aGroup))aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -requestToJoinPublicGroup:message:completion:");

/*!
 *  Accept user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername
                           success:(void (^)())aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveJoinGroupRequest:sender:completion:");

/*!
 *  Decline user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason
                            success:(void (^)())aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineJoinGroupRequest:sender:reason:completion:");

/*!
 *  Accept group's invitation
 *
 *  @param groupId          Group id
 *  @param aUsername        Inviter
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                               success:(void (^)(EMGroup *aGroup))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -acceptInvitationFromGroup:inviter:completion");

/*!
 *  Decline a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Inviter
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason
                                success:(void (^)())aSuccessBlock
                                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineGroupInvitation:inviter:reason:completion:");

/*!
 *  Block / unblock group message‘s push notification
 *
 *  @param aGroupId          Group id
 *  @param aIgnore           Whether block
 *  @param aSuccessBlock     The callback block of success
 *  @param aFailureBlock     The callback block of failure
 *
 */
- (void)asyncIgnoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushServiceForGroup:isPushEnabled:completion:");

@end

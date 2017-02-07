/*!
 *  @header EMGroupManagerDelegate.h
 *  @abstract This protocol defined the callbacks of group
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  The reason of user leaving the group
 */
typedef enum{
    EMGroupLeaveReasonBeRemoved = 0,    /*!  Removed by owner */
    EMGroupLeaveReasonUserLeave,        /*!  User leave the group */
    EMGroupLeaveReasonDestroyed,        /*!  Group has been destroyed */
}EMGroupLeaveReason;

@class EMGroup;

/*!
 *  Delegate
 */
@protocol EMGroupManagerDelegate <NSObject>

@optional

/*!
 *  Delegate method will be invoked when receiving a group invitation
 *
 *  After user A invites user B into the group, user B will receive this callback
 *
 *  @param aGroupId    The group ID
 *  @param aInviter    Inviter
 *  @param aMessage    Invitation message
 */
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage;

/*!
 *  Delegate method will be invoked when the group invitation is accepted
 *
 *  After user B accepted user A‘s group invitation, user A will receive this callback
 *
 *  @param aGroup    User joined group
 *  @param aInvitee  Invitee
 */
- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee;

/*!
 *  Delegate method will be invoked when the group invitation is decliend.
 *
 *  After user B declined user A's group invitation, user A will receive the callback
 *
 *  @param aGroup    Group instance
 *  @param aInvitee  Invitee
 *  @param aReason   Decline reason
 */
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason;

/*!
 *  Delegate method will be invoked after SDK automatically accepted the group invitation
 *
 *  User B will receive this callback after SDK automatically accept user A's group invitation, need set EMOptions's isAutoAcceptGroupInvitation property to YES
 *
 *  @param aGroup    Group instance
 *  @param aInviter  Inviter
 *  @param aMessage  Invite message
 */
- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage;

/*!
 *  Delegate method will be invoked when user leaves a group
 *
 *  @param aGroup    Group instance
 *  @param aReason   Leave reason
 */
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason;

/*!
 *  Delegate method will be invoked when the group owner receives a group request and group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     Group instance
 *  @param aUsername  The user initialized the group join request
 *  @param aReason    The user's message
 */
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason;

/*!
 *  Delegate method will be invoked when the group owner declines a join group request
 *
 *  User A will receive this callback after group's owner declined the group request, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    Group id
 *  @param aReason     Decline reason
 */
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason;

/*!
 *  Delegate method will be invoked when the group owner approves a join group request
 *
 *  User A will receive this callback after group's owner approve the group request, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   Group instance
 */
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup;

/*!
 *  Group List updated
 *
 *  @param aGroupList  Group list<EMGroup>
 */
- (void)groupListDidUpdate:(NSArray *)aGroupList;

#pragma mark - Deprecated methods

/*!
 *  Delegate method will be invoked when user receives a group invitation
 *
 *  After user A invites user B into the group, user B will receive this callback
 *
 *  @param aGroupId    The group ID
 *  @param aInviter    Inviter
 *  @param aMessage    Invite message
 */
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage __deprecated_msg("Use -groupInvitationDidReceive:inviter:message:");

/*!
 *  Delegate method will be invoked when a group invitation is accepted
 *
 *  After user B accepted user A‘s group invitation, user A will receive this callback
 *
 *  @param aGroup    Group to join
 *  @param aInvitee  Invitee
 */
- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee __deprecated_msg("Use -groupInvitationDidApprove:invitee:");

/*!
 *  Delegate method will be invoked when a group invitation is declined
 *
 *  After user B declined user A's group invitation, user A will receive the callback
 *
 *  @param aGroup    Group instance
 *  @param aInvitee  Invitee
 *  @param aReason   Decline reason
 */
- (void)didReceiveDeclinedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
                                   reason:(NSString *)aReason __deprecated_msg("Use -groupInvitationDidDecline:invitee:reason:");

/*!
 *  User B will receive this callback after SDK automatically accept user A's group invitation.
 *  Set EMOptions's isAutoAcceptGroupInvitation property to YES for this delegate method
 *
 *  @param aGroup    Group instance
 *  @param aInviter  Inviter
 *  @param aMessage  Invite message
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage __deprecated_msg("Use -didJoinGroup:inviter:message:");

/*!
 *  Callback of leave group
 *
 *  @param aGroup    Group instance
 *  @param aReason   Leave reason
 */
- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason __deprecated_msg("Use -didLeaveGroup:reason:");

/*!
 *  Group's owner receive user's applicaton of joining group, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     Group
 *  @param aApplicant The applicant
 *  @param aReason    The applicant's message
 */
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidReceive:user:reason:");

/*!
 *  User A will receive this callback after group's owner declined the join group request
 *
 *  @param aGroupId    Group id
 *  @param aReason     Decline reason
 */
- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidDecline:reason:");

/*!
 *  User A will receive this callback after group's owner accepted it's application, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   Group instance
 */
- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup __deprecated_msg("Use -joinGroupRequestDidApprove:");

/*!
 *  Group List changed
 *
 *  @param aGroupList  Group list<EMGroup>
 */
- (void)didUpdateGroupList:(NSArray *)aGroupList __deprecated_msg("Use -groupListDidUpdate:");

@end

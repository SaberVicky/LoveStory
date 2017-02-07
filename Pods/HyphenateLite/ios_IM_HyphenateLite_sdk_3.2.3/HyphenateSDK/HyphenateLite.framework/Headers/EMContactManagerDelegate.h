/*!
 *  @header EMContactManagerDelegate.h
 *  @abstract This protocol defined the callbacks of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class EMError;

/*!
 *  Callbacks of contact
 */
@protocol EMContactManagerDelegate <NSObject>

@optional

/*!
 *  Delegate method will be invoked is a friend request is approved.
 *   
 *  User A will receive this callback after user B approved user A's friend request
 *  @param aUsername   User who approves the friend's request
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername;

/*!
 *  Delegate method will be invoked if a friend request is declined.
 *
 *  User A will receive this callback after user B declined user A's friend request
 *
 *  @param aUsername   User who declined the friend's request
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername;

/*!
 
 *  Delegate method will be invoked if user is removed as a contact by another user
 *
 *  User A，B will receive this callback after User B unfriended with user A
 *
 *  @param aUsername   User who unfriended the cureent user
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername;

/*!
 *  Delegate method will be invoked id the user is added as a contact by another user.
 *
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername;

/*!
 *  Delegate method will be invoked when user receives a friend request
 *
 *  User A will receive this callback when receiving a friend request from user B
 *
 *  @param aUsername   Friend request sender
 *  @param aMessage    Friend request message
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage;

#pragma mark - Deprecated methods

/*!
 *  User A will receive this callback after user B agreed user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidApproveByUser:");

/*!
 *  User A will receive this callback after user B declined user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidDeclineByUser:");

/*!
 *  User A will receive this callback after User B delete the friend relationship between user A
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidRemoveByUser:");

/*!
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidAddByUser:");

/*!
 *  User A will receive this callback after user B requested to add user A as a friend
 *
 *  @param aUsername   User B
 *  @param aMessage    Friend invitation message
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage __deprecated_msg("Use -friendRequestDidReceiveFromUser:message:");


@end

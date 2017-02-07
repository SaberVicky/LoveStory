/*!
 *  @header EMClientDelegate.h
 *  @abstract This protocol provides a number of utility classes callback
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  Network Connection Status
 */
typedef enum{
    EMConnectionConnected = 0,  /*! * Connected */
    EMConnectionDisconnected,   /*! * Not connected */
}EMConnectionState;

@class EMError;

/*!
 *  @abstract This protocol provides a number of utility classes callback
 */
@protocol EMClientDelegate <NSObject>

@optional

/*!
 *  Delegate method will be invoked when server connection state has changed
 *
 *  @param aConnectionState Current state
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState;

/*!
 *  Delegate method will be invoked when auto login is completed
 *
 *  @param aError Error
 */
- (void)autoLoginDidCompleteWithError:(EMError *)aError;

/*!
 *  Delegate method will be invoked when current IM account logged into another device
 */
- (void)userAccountDidLoginFromOtherDevice;

/*!
 *  Delegate method will be invoked when current IM account is removed from server
 */
- (void)userAccountDidRemoveFromServer;

/*!
 *  User is forbidden
 */
- (void)userDidForbidByServer;

#pragma mark - Deprecated methods

/*!
 *  Connection to the server status changes will receive the callback
 *  
 *  calling the method causes:
 *  1. After successful login, the phone can not access
 *  2. After a successful login, network status change
 *  
 *  @param aConnectionState Current state
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState __deprecated_msg("Use -connectionStateDidChange:");

/*!
 *  Callback Automatic login fails
 *
 *  @param aError Error
 */
- (void)didAutoLoginWithError:(EMError *)aError __deprecated_msg("Use -autoLoginDidCompleteWithError:");

/*!
 *  Will receive this callback when current account login from other device
 */
- (void)didLoginFromOtherDevice __deprecated_msg("Use -userAccountDidLoginFromOtherDevice");

/*!
 *  Current login account will receive the callback is deleted from the server
 */
- (void)didRemovedFromServer __deprecated_msg("Use -userAccountDidRemoveFromServer");

@end

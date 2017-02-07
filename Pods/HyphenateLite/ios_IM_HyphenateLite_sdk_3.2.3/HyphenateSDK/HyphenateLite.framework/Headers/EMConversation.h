/*!
 *  @header EMConversation.h
 *  @abstract Chat conversation
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*
 *  Conversation type
 */
typedef enum{
    EMConversationTypeChat  = 0,    /*!  one to one chat room type */
    EMConversationTypeGroupChat,    /*!  Group chat room type */
    EMConversationTypeChatRoom      /*!  Chatroom chat room type */
} EMConversationType;

/*
 *  Message search direction
 */
typedef enum{
    EMMessageSearchDirectionUp  = 0,    /*!  Search older messages */
    EMMessageSearchDirectionDown        /*!  Search newer messages */
} EMMessageSearchDirection;

@class EMMessage;
@class EMError;

/*!
 *  Chat conversation
 */
@interface EMConversation : NSObject

/*!
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/*!
 *  Conversation type
 */
@property (nonatomic, assign, readonly) EMConversationType type;

/*!
 *  Count of unread messages
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/*!
 *  Conversation extension property
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  Conversation latest message
 */
@property (nonatomic, strong, readonly) EMMessage *latestMessage;

/*!
 *  Insert a message to a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *
 *  @param aMessage Message
 *  @param pError   Error
 */
- (void)insertMessage:(EMMessage *)aMessage
                error:(EMError **)pError;

/*!
 *  Insert a message to the end of a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *
 *  @param aMessage Message
 *  @param pError   Error
 *
 */
- (void)appendMessage:(EMMessage *)aMessage
                error:(EMError **)pError;

/*!
 *  Delete a message
 *
 *  @param aMessageId   MessageId of the message to be deleted
 *  @param pError       Error
 *
 */
- (void)deleteMessageWithId:(NSString *)aMessageId
                      error:(EMError **)pError;

/*!
 *  Delete all message of a conversation
 *  @param pError       Error
 */
- (void)deleteAllMessages:(EMError **)pError;

/*!
 *  Update a local message, conversation's latestMessage and other properties will be updated accordingly. Please note that messageId can not be updated.
 *
 *  @param aMessage Message
 *  @param pError   Error
 *
 */
- (void)updateMessageChange:(EMMessage *)aMessage
                      error:(EMError **)pError;

/*!
 *  Mark a message as read
 *
 *  @param aMessageId   MessageID
 *  @param pError       Error
 *
 */
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(EMError **)pError;

/*!
 *  Mark all message as read
 *
 *  @param pError   Error
 *
 */
- (void)markAllMessagesAsRead:(EMError **)pError;

/*!
 *  Get a message with the ID
 *
 *  @param aMessageId       MessageID
 *  @param pError           Error
 *
 */
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId
                           error:(EMError **)pError;

/*!
 *  Get last received message
 *
 *  @result Message instance
 */
- (EMMessage *)lastReceivedMessage;

#pragma mark - Async method

/*!
 *  Load messages from a specified message, returning messages are sorted by receiving timestamp. If the aMessageId is nil, return the latest received messages.
 *
 *  @param aMessageId       Reference message's ID
 *  @param aCount           Count of messages to load
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesStartFromId:(NSString *)aMessageId
                          count:(int)aCount
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  Load messages with specified type, returning messages are sorted by receiving timestamp. If reference timestamp is negative, load from the latest messages; if message count is negative, count deal with 1 and load one message that meet the condition.
 *
 *  @param aType            Message type to load
 *  @param aTimestamp       Reference timestamp
 *  @param aLimit           Count of messages to load
 *  @param aUsername        Message sender (optional)
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesWithType:(EMMessageBodyType)aType
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString*)aUsername
             searchDirection:(EMMessageSearchDirection)aDirection
                  completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  Load messages with specified keyword, returning messages are sorted by receiving timestamp. If reference timestamp is negative, load from the latest messages; if message count is negative, count deal with 1 and load one message that meet the condition.
 *
 *  @param aKeywords        Search content, will ignore it if it's empty
 *  @param aTimestamp       Reference timestamp
 *  @param aCount           Count of messages to load
 *  @param aSender          Message sender (optional)
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeyword
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  Load messages within specified time range, retruning messages are sorted by receiving timestamp
 *
 *  @param aStartTimestamp  Start time's timestamp in miliseconds
 *  @param aEndTimestamp    End time's timestamp in miliseconds
 *  @param aCount           Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount
              completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

#pragma mark - Deprecated methods

/*!
 *  Insert a message to a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *
 *  @param aMessage  Message
 *
 *  @result Message insert result, return YES or success, return No for failure.
 */
- (BOOL)insertMessage:(EMMessage *)aMessage __deprecated_msg("Use -insertMessage:error:");

/*!
 *  Insert a message to the tail of conversation, message's conversationId should equle to conversation's conversationId, message will be inserted to DB, and update conversation's property
 *
 *  @param aMessage  Message
 *
 *  @result Message insert result, YES: success, No: fail
 */
- (BOOL)appendMessage:(EMMessage *)aMessage __deprecated_msg("Use -appendMessage:error:");

/*!
 *  Delete a message
 *
 *  @param aMessageId  Message's ID who will be deleted
 *
 *  @result Message delete result, YES: success, No: fail
 */
- (BOOL)deleteMessageWithId:(NSString *)aMessageId __deprecated_msg("Use -deleteMessageWithId:error:");

/*!
 *  Delete all message of the conversation
 *
 *  @result Delete result, YES: success, No: fail
 */
- (BOOL)deleteAllMessages __deprecated_msg("Use -deleteAllMessages:");

/*!
 *  Update a message, can't update message's messageId, conversation's latestMessage and so on properties will update after update the message
 *
 *  @param aMessage  Message
 *
 *  @result Message update result, YES: success, No: fail
 */
- (BOOL)updateMessage:(EMMessage *)aMessage __deprecated_msg("Use -updateMessageChange:error:");

/*!
 *  Mark a message as read
 *
 *  @param aMessageId  Message's ID who will be set read status
 *
 *  @result Result of mark message as read, YES: success, No: fail
 */
- (BOOL)markMessageAsReadWithId:(NSString *)aMessageId __deprecated_msg("Use -markMessageAsReadWithId:error:");

/*!
 *  Mark all message as read
 *
 *  @result Result of mark all message as read, YES: success, No: fail
 */
- (BOOL)markAllMessagesAsRead __deprecated_msg("Use -markAllMessagesAsRead:");

/*!
 *  Update conversation extend properties to DB
 *
 *  @result Extend properties update result, YES: success, No: fail
 */
- (BOOL)updateConversationExtToDB __deprecated_msg("setExt: will update extend properties to DB");

/*!
 *  Get a message with the ID
 *
 *  @param aMessageId  Message's id
 *
 *  @result Message instance
 */
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId __deprecated_msg("Use -loadMessageWithId:error:");

/*!
 *  Get more messages from DB, result messages are sorted by receive time, and NOT include the reference message, if reference messag's ID is nil, will fetch message from latest message
 *
 *  @param aMessageId  Reference message's ID
 *  @param aLimit      Count of messages to load
 *  @param aDirection  Message search direction
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesFromId:(NSString *)aMessageId
                              limit:(int)aLimit
                          direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesStartFromId:count:searchDirection:completion:");

/*!
 *  Get more messages with specified type from DB, result messages are sorted by received time, if reference timestamp is negative, will fetch message from latest message, andd will fetch all messages that meet the condition if aLimit is negative
 *
 *  @param aType        Message type to load
 *  @param aTimestamp   Reference timestamp
 *  @param aLimit       Count of messages to load
 *  @param aSender      Message sender, will ignore it if it's empty
 *  @param aDirection   Message search direction
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesWithType:(EMMessageBodyType)aType
                               before:(long long)aTimestamp
                                limit:(int)aLimit
                                 from:(NSString*)aSender
                            direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesWithType:timestamp:count:fromUser:searchDirection:completion:");

/*!
 *  Get more messages contain specified keywords from DB, result messages are sorted by received time, if reference timestamp is negative, will fetch message from latest message, andd will fetch all messages that meet the condition if aLimit is negative
 *
 *  @param aKeywords    Search content, will ignore it if it's empty
 *  @param aTimestamp   Reference timestamp
 *  @param aLimit       Count of messages to load
 *  @param aSender      Message sender, will ignore it if it's empty
 *  @param aDirection    Message search direction
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesContain:(NSString*)aKeywords
                              before:(long long)aTimestamp
                               limit:(int)aLimit
                                from:(NSString*)aSender
                           direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesContainKeywords:timestamp:count:fromUser:searchDirection:completion:");

/*!
 *  Load messages from DB in duration, result messages are sorted by receive time, user should limit the max count to load to avoid memory issue
 *
 *  @param aStartTimestamp  Start time's timestamp in miliseconds
 *  @param aEndTimestamp    End time's timestamp in miliseconds
 *  @param aMaxCount        Message search direction
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesFrom:(long long)aStartTimestamp
                               to:(long long)aEndTimestamp
                         maxCount:(int)aMaxCount __deprecated_msg("Use -loadMessagesFrom:to:count:completion:");

/*!
 *  Get latest message that received from others
 *
 *  @result Message instance
 */
- (EMMessage *)latestMessageFromOthers __deprecated_msg("Use -lastReceivedMessage");

@end

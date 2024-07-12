const userDbId = 'id';
const userDbName = 'username';
const userDbEmail = 'user_email';
const userDbPhoneNumber = 'phone_number';
const userDbAbout ='user_about';
const userDbProfileImage = 'user_profile_image';
const userDbNetworkStatus = 'user_network_status';
const userDbCreatedAt = 'created_at';
const userDbTFAPin = 'tfa_pin';
const userDbBlockedStatus = 'is_blocked_user';
const userDbGroupIdList = 'user_group_id_list';
const isUserDisabled = 'is_disabled_user';
const userDbLastActiveTime = 'user_last_active_time';

// collections names
const usersCollection = 'users';
const chatsCollection = 'chats';
const messagesCollection = 'messages';
const attachmentsCollection = 'attachments';
const starredMessagesCollection = 'starred_collection';



// messageDb fields name
const dbMessageID = 'message_id';
const dbMessageSenderID = 'message_sender_id';
const dbMessageRecieverID = 'message_reciever_id';
const dbMessageContent = 'message_content';
const dbMessageSendTime = 'message_send_time';
const dbMessageStatus = 'message_status';
const dbMessageType = 'message_type';
const dbAttachmentsWithMessage = 'message_attachments';
const dbIsMessageEdited = 'edited_message';
const dbIsMessageDeleted = 'deleted_message';
const dbIsMessagePinned = 'pinned_message';
const dbIsMessageStarred = 'starred_message';
const nameOfMessage = 'message_name';

// chat db fields name
const chatId = 'chat_id';
const senderId = 'sender_id';
const receiverId = 'receiver_id';
const chatLastMessage = 'last_message';
const chatLastMessageTime = 'last_message_time';
const chatMessageNotificationCount = 'not_seen_message_Count';
const receiverProfilePhoto = 'receiver_profile_image';
const chatMuted = 'is_muted_chat';
const lastChatStatus = 'last_message_status';
const lastChatType = 'last_message_type';
const receiverNameInChatList = 'receiver_name';

// database storage folder name or file name
const usersProfileImageFolder = "profile_images/";
const chatAssetFolder = "chatsAsset/";
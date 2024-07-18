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
const groupsCollection = 'groups';
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
const isIncoming = 'is_incoming';
const receiverNameInChatList = 'receiver_name';
const isUserChatOpen = 'isChatOpen';
const isGroupChat = 'is_group';


// group db fields name
const dbGroupId = 'group_id';
const dbGroupName = 'group_name';
const dbGroupDescription = 'group_description';
const dbGroupProfileImage = 'group_profile_image';
const dbGroupAdminsList = 'group_admins';
const dbGroupMembersList = 'group_members';
const dbGroupAdminsPermissionList = 'group_admins_permissions';
const dbGroupMembersPermissionList = 'group_members_permissions';
const dbGroupCreatedAt = 'group_created_at';
const dbGroupLastUpdatedDate = 'group_last_updated_date';

// database storage folder name or file name
const usersProfileImageFolder = "profile_images/";
const chatAssetFolder = "chatsAsset/";
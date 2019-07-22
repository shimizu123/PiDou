//
//  XLInterface.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#ifndef XLInterface_h
#define XLInterface_h


#define TEST_URL // 注释这一行则运行正式服，没有注释这一行则运行测试服

#ifdef TEST_URL
#pragma mark - =================测试环境==================

#define BaseUrl             @"http://120.27.70.141/api/v1.0"

/**--------------------------------------------------------------------------*/
#else
#pragma mark - =================正式环境==================

#define BaseUrl             @"http://pdtv.vip/api/v1.0"

/**--------------------------------------------------------------------------*/
#endif


#define Url_Register        @"/register"
#define Url_BindWechat      @"/bind_wechat"
#define Url_Login           @"/login"
#define Url_GetCode         @"/sms_code"
#define Url_ChangePassword  @"/change_password"
#define Url_CheckSmsCode    @"/check_sms_code"
#define Url_ForgetPassword  @"/forget_password"
#define Url_ChangePhone     @"/change_phone"
#define Url_MyInfo          @"/my_info"
#define Url_ApplyAppraiser  @"/apply_appraiser"
#define Url_AppraiserPage   @"/apply_appraiser_page"
#define Url_WechatLogin     @"/wechat_login"
#define Url_WechatBind      @"/bind_phone"

#define Url_Fans            @"/fans"
#define Url_Followers       @"/followers"
#define Url_FollowUser      @"/follow"
#define Url_UnfollowUser    @"/unfollow"
#define Url_MyFollowTopic   @"/my_follow_topics"
#define Url_HotTopic        @"/hot_topics"
#define Url_FollowTopic     @"/follow_topic"
#define Url_MyCollected     @"/my_collected"
#define Url_TopicDetail     @"/topic_detail"

#define Url_Publish         @"/store"
#define Url_UploadVideo     @"/upload_video"
#define Url_UploadImage     @"/upload_image"

#define Url_Entity          @"/entity"
#define Url_EntityDetail    @"/detail"

#define Url_Comment         @"/comment"
#define Url_Reply           @"/comment_replies"
#define Url_AddComment      @"/comment_store"
#define Url_likeComment     @"/comment_do_like"
#define Url_CommentShare    @"/comment_share"

#define Url_TieziLike       @"/do_like"
#define Url_Collect         @"/collect"
#define Url_Share           @"/share"

#define Url_PDCoin          @"/pdcoin"
#define Url_PDCoinPick      @"/pdcoin_pick"
#define Url_PDCoinBill      @"/pdcoin_bill"
#define Url_JoinProfit      @"/join_profit"
#define Url_JoinProfitBill  @"/join_profit_bill"
#define Url_GainPDcoinWays  @"/gain_pdcoin_ways"
#define Url_GainPDcoin      @"/gain_pdcoin"
#define Url_ExchangeCoin    @"/exchange_coin"
#define Url_XingCoinBill    @"/coin_bill"
#define Url_XingReward      @"/coin_reward"


#define Url_WalletInfo      @"/wallet"
#define Url_WalletBill      @"/bill"
#define Url_WalletTransfer  @"/transfer"

#define Url_Search          @"/search"
#define Url_UserEntity      @"/user_entity"
#define Url_UserComments    @"/user_comments"
#define Url_UserDynamic     @"/user_dynamic"
#define Url_UserAdvise      @"/advise"
#define Url_MyInvite        @"/my_invitation"
#define Url_UserInfoUpdate  @"/user_info_update"

#define Url_Announcement    @"/announcement"
#define Url_AnnoDetail      @"/announcement_detail"

#define Url_Message         @"/message"
#define Url_UserInfo        @"/user_info"
#define Url_UserCancel      @"/user_cancel"
#define Url_EntityDelete    @"/entity_delete"
#define Url_CommentDelete   @"/comment_delete"

#define Url_WechatPrePay    @"/pre_pay"
#define Url_Adv             @"/ad"


#define Url_TotalMessage    @"/total_message"
#define Url_MessageReaded   @"/message_readed"

#endif /* XLInterface_h */

//
//  XLShareModel.h
//  PiDou
//
//  Created by kevin on 8/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLSocialPlatformType) {
    XLSocialPlatformType_WechatSession  = 0, // 微信聊天
    XLSocialPlatformType_WechatTimeLine = 1, // 微信朋友圈
    XLSocialPlatformType_QQ             = 2, // QQ聊天页面
};

typedef NS_ENUM(NSInteger, XLShareType) {
    XLShareType_Text  = 0, // 文字
    XLShareType_Image = 1, // 图片
    XLShareType_Video = 2, // 视频
    XLShareType_Link  = 3, // 链接 
};

@interface XLShareModel : NSObject

/**对帖子的分享*/
@property (nonatomic, copy) NSString *entity_id;
/**对评论的分享*/
@property (nonatomic, copy) NSString *cid;
/**文本*/
@property (nonatomic, copy) NSString *text;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**分享内容描述*/
@property (nonatomic, copy) NSString *desc;
/**缩略图*/
@property (nonatomic, copy) NSString *thumbImage;
/**ShareImage*/
@property (nonatomic, copy) NSString *shareImage;
/**url*/
@property (nonatomic, copy) NSString *pageUrl;
/**分享到的平台*/
@property (nonatomic, assign) XLSocialPlatformType platformType;
/**分享的类型*/
@property (nonatomic, assign) XLShareType shareType;

@end

NS_ASSUME_NONNULL_END

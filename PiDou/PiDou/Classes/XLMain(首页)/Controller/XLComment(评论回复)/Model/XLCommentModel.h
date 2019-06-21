//
//  XLCommentModel.h
//  PiDou
//
//  Created by ice on 2019/4/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCommentModel.h"
#import "XLSizeModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTieziModel;
@interface XLCommentModel : NSObject

/**评论id*/
@property (nonatomic, copy) NSString *cid;

/**评论内容*/
@property (nonatomic, copy) NSString *content;

/**创建时间戳*/
@property (nonatomic, copy) NSString *created;

/**评论类型 video视频 pic图片*/
@property (nonatomic, copy) NSString *type;

/**视频截图 只有视频内容时才显示*/
@property (nonatomic, strong) XLSizeModel *video_image;

/**视频链接 只有视频内容时才显示*/
@property (nonatomic, copy) NSString *video_url;

/**图片链接 只有图片内容时才显示*/
@property (nonatomic, strong) NSArray <XLSizeModel *> *pic_images;

/**是否为神评 0否 1是*/
@property (nonatomic, strong) NSNumber *god;

/**回复条数*/
@property (nonatomic, copy) NSString *reply_count;

/**是否点赞0否 1是*/
@property (nonatomic, strong) NSNumber *do_liked;

/**点赞条数*/
@property (nonatomic, copy) NSString *do_like_count;

/**用户信息*/
@property (nonatomic, strong) XLAppUserModel *user_info;

/**神评论*/
@property (nonatomic, strong) XLCommentModel *god_comment;

/**回复条数*/
@property (nonatomic, strong) NSNumber *total;


@property (nonatomic, strong) XLCommentModel *parent;

@property (nonatomic, strong) NSArray <XLCommentModel *> *replies;

/**我的评论的时候用到*/
@property (nonatomic, strong) XLTieziModel *entity;
/**类别*/
@property (nonatomic, copy) NSString *category;

/**分享个数*/
@property (nonatomic, copy) NSString *share_count;

// parent里面用到
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;

@end

NS_ASSUME_NONNULL_END

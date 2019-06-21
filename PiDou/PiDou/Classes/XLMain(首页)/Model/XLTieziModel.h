//
//  XLTieziModel.h
//  PiDou
//
//  Created by kevin on 29/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSizeModel.h"
#import "XLCommentModel.h"
#import "XLTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTieziModel : NSObject


/**点赞数*/
@property (nonatomic, copy) NSString *do_like_count;
/**分享数*/
@property (nonatomic, copy) NSString *share_count;
/**收藏数*/
@property (nonatomic, copy) NSString *collect_count;
/**评论数*/
@property (nonatomic, copy) NSString *comment_count;
/**该内容获得PDcoin数*/
@property (nonatomic, copy) NSString *pdcoin_count;
/**获得的星票数量*/
@property (nonatomic, copy) NSString *coin_count;

/**内容id*/
@property (nonatomic, copy) NSString *entity_id;
/**发布时间戳*/
@property (nonatomic, copy) NSString *created;
/**内容分类 同发布内容接口*/
@property (nonatomic, copy) NSString *category;
/**内容*/
@property (nonatomic, copy) NSString *content;
/**是否点赞0否 1是*/
@property (nonatomic, strong) NSNumber *do_liked;
/**是否收藏 0否 1是*/
@property (nonatomic, strong) NSNumber *collected;
/**话题*/
@property (nonatomic, strong) NSArray *topics;

/**视频截图 只有视频内容时才显示*/
@property (nonatomic, strong) XLSizeModel *video_image;


/**视频链接 只有视频内容时才显示*/
@property (nonatomic, copy) NSString *video_url;

/**图片链接 只有图片内容时才显示*/
@property (nonatomic, strong) NSArray <XLSizeModel *> *pic_images;

/**链接 只在链接内容时才显示*/
@property (nonatomic, copy) NSString *link;

/**用户信息*/
@property (nonatomic, strong) XLAppUserModel *user_info;

/**神评论*/
@property (nonatomic, strong) XLCommentModel *god_comment;

/**是否是评论*/
@property (nonatomic, assign) BOOL isComment;

/**封面  有封面时显示封面，没封面时显示content---给消息列表用的*/
@property (nonatomic, strong) XLSizeModel *cover;

@property (nonatomic, copy) NSString *nickname;



@end

NS_ASSUME_NONNULL_END

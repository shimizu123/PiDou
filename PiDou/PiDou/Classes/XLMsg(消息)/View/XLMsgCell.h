//
//  XLMsgCell.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

// 左边样式判断
typedef NS_ENUM(NSUInteger, XLMsgActionType) {
    XLMsgActionType_comment = 0,
    XLMsgActionType_zan,
    XLMsgActionType_user,
};

// 右边样式判断
typedef NS_ENUM(NSUInteger, XLMsgInfoType) {
    XLMsgInfoType_image = 0,
    XLMsgInfoType_video,
    XLMsgInfoType_text,
    XLMsgInfoType_focus,
    XLMsgInfoType_pdcoin,
    XLMsgInfoType_xingCoin,
};

@interface XLMsgCell : UITableViewCell

@property (nonatomic, assign) XLMsgActionType actionType;
@property (nonatomic, assign) XLMsgInfoType infoType;

/**消息模型*/
@property (nonatomic, strong) XLMsgModel *msgModel;

@end

NS_ASSUME_NONNULL_END

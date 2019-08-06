//
//  XLShareView.h
//  TG
//
//  Created by kevin on 30/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLShareModel.h"

@protocol XLShareViewDelegate <NSObject>

- (void)didDeleteAction;

@end

@interface XLShareView : UIView

+ (instancetype)shareView;

- (void)show;
- (void)dismiss;

/**是否显示w二维码*/
@property (nonatomic, assign) BOOL showQRCode;

/**没有删除按钮*/
@property (nonatomic, assign) BOOL noDeletebtn;

/**分享模型*/
@property (nonatomic, strong) XLShareModel *message;

@property (nonatomic, weak) id <XLShareViewDelegate> delegate;

@end

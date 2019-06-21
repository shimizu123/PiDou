//
//  XLTextView.h
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XLTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**在对text赋值之后使用，行间距，只能静态设置的时候使用*/
@property (nonatomic, assign) CGFloat tg_lineSpacing;

@property (nonatomic, copy) XLCompletedBlock changeContentSizeBlock;

/**设置字体是否剧中*/
@property (nonatomic, assign) BOOL isTextCenter;

@end

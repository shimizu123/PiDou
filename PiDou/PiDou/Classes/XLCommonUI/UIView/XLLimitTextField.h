//
//  XLLimitTextField.h
//  TG
//
//  Created by kevin on 9/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLLimitTextField : UITextField

/**字数限制*/
@property (nonatomic, assign) NSInteger maxNumLimit;

@property (nonatomic, copy) NSString *xl_placeholder;

@property (nonatomic, strong) NSNumber *leftSpacing;

/**监控输入变化*/
@property (nonatomic, copy) XLCompletedBlock textFieldDidChange;
@property (nonatomic, copy) XLCompletedBlock textFieldBeginEdit;

@end

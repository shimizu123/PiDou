//
//  XLModifyPwdView.h
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLModifyPwdViewDelegate <NSObject>



@end

@interface XLModifyPwdView : UIView

@property (nonatomic, weak) id <XLModifyPwdViewDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *oldPassword;
@property (nonatomic, copy, readonly) NSString *nw1Password;
@property (nonatomic, copy, readonly) NSString *nw2Password;

@end

NS_ASSUME_NONNULL_END

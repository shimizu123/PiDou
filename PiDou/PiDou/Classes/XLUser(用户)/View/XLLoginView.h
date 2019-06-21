//
//  XLLoginView.h
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLLoginView;
@protocol XLLoginViewdelegate <NSObject>

- (void)loginView:(XLLoginView *)loginView didBeginEditing:(UITextField *)textField;

@end

@interface XLLoginView : UIView

/**账号*/
@property (nonatomic, copy, readonly) NSString *username;
/**密码*/
@property (nonatomic, copy, readonly) NSString *password;



@property (nonatomic, weak) id <XLLoginViewdelegate> delegate;


@end

NS_ASSUME_NONNULL_END

//
//  QRCodeViewController.h
//  PiDou
//
//  Created by 邓康大 on 2019/6/19.
//  Copyright © 2019年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *pageUrl;

@end

NS_ASSUME_NONNULL_END

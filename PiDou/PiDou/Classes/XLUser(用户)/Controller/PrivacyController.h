//
//  PrivacyController.h
//  PiDou
//
//  Created by 邓康大 on 2019/6/27.
//  Copyright © 2019年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyController : UIViewController

@property (nonatomic, assign) BOOL isRecharge;

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, assign) BOOL isPDCoin;

@end

NS_ASSUME_NONNULL_END

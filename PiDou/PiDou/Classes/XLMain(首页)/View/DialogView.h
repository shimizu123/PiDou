//
//  DialogView.h
//  PiDou
//
//  Created by 邓康大 on 2019/8/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogView : UIImageView
singleton_h(DialogView)


- (void)showView:(UIView *)container;
- (void)removeView;

@end

NS_ASSUME_NONNULL_END

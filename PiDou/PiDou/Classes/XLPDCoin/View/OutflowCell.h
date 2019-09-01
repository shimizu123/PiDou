//
//  OutflowCell.h
//  PiDou
//
//  Created by 邓康大 on 2019/8/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutflowCell : UITableViewCell

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END

//
//  XLSearchUserCell.h
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLSearchUserCellType) {
    XLSearchUserCellType_FansNum = 0,
    XLSearchUserCellType_noFansNum,
};

@class XLFansModel;
@interface XLSearchUserCell : UITableViewCell

@property (nonatomic, strong) XLFansModel *fansModel;

@property (nonatomic, assign) XLSearchUserCellType cellType;

@end

NS_ASSUME_NONNULL_END


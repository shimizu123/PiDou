//
//  XLMineListCell.h
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLMineListType) {
    XLMineListType_arrow = 0,
    XLMineListType_none,
};

@interface XLMineListCell : UITableViewCell

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *desName;

@property (nonatomic, assign) XLMineListType listType;

@property (nonatomic, strong) NSDictionary *infoDic;

@property (nonatomic, copy) NSString *icon;

@end

NS_ASSUME_NONNULL_END

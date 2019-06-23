//
//  XLPictureCell.h
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTieziModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLPictureCell : UITableViewCell

@property (nonatomic, copy) NSArray *pictures;

@property (nonatomic, strong) XLTieziModel *tieziModel;
@property (nonatomic, assign) BOOL isDetailVC;
/**我的作品，有删除按钮*/
@property (nonatomic, assign) BOOL isMyPublish;

@property (nonatomic, copy) XLCompletedBlock didSelectedAction;

@property (nonatomic, assign) BOOL isDetail;

@end

NS_ASSUME_NONNULL_END

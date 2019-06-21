//
//  XLAlertCollectionViewCell.h
//  CBNReporterVideo
//
//  Created by kevin on 10/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XLAlertAction;
@interface XLAlertCollectionViewCell : UICollectionViewCell

/** action */
@property (nonatomic, strong) XLAlertAction *action;

@end

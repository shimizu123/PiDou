//
//  XLPictureCollectionCell.h
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPictureCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) XLCompletedBlock complete;

@end

NS_ASSUME_NONNULL_END

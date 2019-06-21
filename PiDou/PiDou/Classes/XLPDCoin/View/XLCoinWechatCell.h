//
//  XLCoinWechatCell.h
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQRCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLCoinWechatCell : UICollectionViewCell
//@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, strong) XLQRCodeModel *qrCodeModel;

@end

NS_ASSUME_NONNULL_END

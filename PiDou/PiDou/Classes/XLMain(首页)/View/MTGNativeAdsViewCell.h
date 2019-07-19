//
//  MTGMediaViewCell.h
//  MTGSDKSample
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 Mobvista. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTGMediaView;
@class MTGCampaign;
@interface MTGNativeAdsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appDescLabel;
@property (weak, nonatomic) IBOutlet UIView *clickableView;

-(void)updateCellWithCampaign:(MTGCampaign *)campaign unitId:(NSString *)unitId;

@end

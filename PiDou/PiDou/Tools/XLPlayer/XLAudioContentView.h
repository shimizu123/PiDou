//
//  XLAudioContentView.h
//  TG
//
//  Created by kevin on 30/5/18.
//  Copyright © 2018年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLAudioContentViewDelegate <NSObject>

- (void)audioContentViewRepeatPlay;

@end

@interface XLAudioContentView : UIView

@property (nonatomic, assign) NSInteger videolen;
@property (nonatomic, weak) id <XLAudioContentViewDelegate> assistant;

@end

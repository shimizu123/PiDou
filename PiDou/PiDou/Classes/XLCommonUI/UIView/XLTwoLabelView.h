//
//  XLTwoLabelView.h
//  TG
//
//  Created by kevin on 27/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLTwoLabelView : UIView

@property (nonatomic, copy) NSString *titleTop;
@property (nonatomic, copy) NSString *titleBot;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, strong) UIFont *topFont;
@property (nonatomic, strong) UIFont *botFont;

@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *botColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) NSTextAlignment twoLabelAlignment;

@end

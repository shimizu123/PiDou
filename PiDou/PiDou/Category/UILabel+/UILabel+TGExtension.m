//
//  UILabel+TGExtension.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "UILabel+TGExtension.h"
#import "NSString+TGExtension.h"

@implementation UILabel (TGExtension)

- (void)setGapWithFloat:(CGFloat)gap {
    if (XLStringIsEmpty(self.text)) {
        return;
    }
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.text];//行间距
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:gap];
//    paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.text length])];
//    [self setAttributedText:attributedString1];
//    [self sizeToFit];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [self.text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:gap];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    
    self.attributedText = attributedString;
    
 
}

- (void)setGapWithFloat:(CGFloat)gap labelWidth:(CGFloat)labelWidth {
    if (XLStringIsEmpty(self.text)) {
        return;
    }
    
    CGFloat h = [NSString getRectWithText:self.text width:labelWidth gap:0 size:self.font.pointSize].size.height;
    NSInteger lineNum = h / self.font.lineHeight;
    if (lineNum > 1) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [self.text length])];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:gap];
        [paragraphStyle setLineBreakMode:self.lineBreakMode];
        [paragraphStyle setAlignment:self.textAlignment];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        
        self.attributedText = attributedString;
        
    }
    
}


- (void)xl_setTextColor:(UIColor *)textColor fontSize:(CGFloat)size {
    self.textColor = textColor;
    self.font = [UIFont xl_fontOfSize:size];
}

- (void)addImageInLeftWithNames:(NSArray *)names gap:(CGFloat)gap {
    if (XLArrayIsEmpty(names)) {
        return;
    }
    NSMutableAttributedString *attri = self.attributedText.mutableCopy;
    for (NSString *name in names) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:name];
        // 设置图片大小
        attch.bounds = CGRectMake(0, -2*kWidthRatio6s, self.font.pointSize, self.font.pointSize);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        //在文字下标第几个添加图片  0就是文字前面添加图片
        
        [attri insertAttributedString:string atIndex:0];
    }
    
    [attri addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [self.text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:gap];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attri;
}

@end

//
//  XLPDRecordModel.m
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDRecordModel.h"

@implementation XLPDRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"pid" : @"id",
             };
}

- (NSString *)typeStr {
    NSString *str = @"";
    switch ([self.type integerValue]) {
        case 1:
        {
            str = @"充值";
        }
            break;
        case 2:
        {
            str = @"提现";
        }
            break;
        case 3:
        {
            str = @"参与社区回馈分红";
        }
            break;
        case 4:
        {
            str = @"兑换星票";
        }
            break;
        case 5:
        {
            str = @"兑换星票";
        }
            break;
        case 6:
        {
            str = @"发布内容";
        }
            break;
        case 7:
        {
            str = @"点赞";
        }
            break;
        case 8:
        {
            str = @"打赏星票";
        }
            break;
        case 9:
        {
            str = @"邀请好友";
        }
            break;
        case 10:
        {
            str = @"加入QQ群";
        }
            break;
        case 11:
        {
            str = @"加入微信群";
        }
            break;
        case 12:
        {
            str = @"关注公众号";
        }
            break;
        case 13:
        {
            str = @"同时分享和点赞";
        }
            break;
        case 14:
        {
            str = @"分享";
        }
            break;
        case 15:
        {
            str = @"被邀请人发布内容";
        }
            break;
        case 16:
        {
            str = @"特定时间星票打赏";
        }
            break;
        case 17:
        {
            str = @"被邀请人星票打赏";
        }
            break;
            
        case 18:
        {
            str = @"内容被打赏";
        }
            break;
        case 20:
        {
            str = @"系统添加PDcoin";
        }
            break;
        case 21:
        {
            // -
            str = @"系统减PDcoin";
        }
            break;
        case 22:
        {
            str = @"平台加星票";
        }
            break;
        case 23:
        {
            str = @"平台减星票";
        }
            break;
        case 24:
        {
            str = @"系统加余额";
        }
            break;
        case 25:
        {
            str = @"系统减余额";
        }
            break;
        case 26:
        {
            // -
            str = @"系统冻结PDcoin";
        }
            break;
            
            
        default:
            break;
    }
    return str;
}

@end

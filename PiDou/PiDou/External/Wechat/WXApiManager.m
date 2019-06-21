//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvChooseCardResponse:)]) {
            WXChooseCardResp *chooseCardResp = (WXChooseCardResp *)resp;
            [_delegate managerDidRecvChooseCardResponse:chooseCardResp];
        }
    }else if ([resp isKindOfClass:[WXChooseInvoiceResp class]]){
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvChooseInvoiceResponse:)]) {
            WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *)resp;
            [_delegate managerDidRecvChooseInvoiceResponse:chooseInvoiceResp];
        }
    }else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvSubscribeMsgResponse:)])
        {
            [_delegate managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)resp];
        }
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvLaunchMiniProgram:)]) {
            [_delegate managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)resp];
        }
    }else if([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvInvoiceAuthInsertResponse:)]) {
            [_delegate managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *) resp];
        }
    }else if([resp isKindOfClass:[WXNontaxPayResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvNonTaxpayResponse:)]) {
            [_delegate managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)resp];
        }
    }else if ([resp isKindOfClass:[WXPayInsuranceResp class]]){
        if ([_delegate respondsToSelector:@selector(managerDidRecvPayInsuranceResponse:)]) {
            [_delegate managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)resp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                XLLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:XLPaySuccessNotification object:nil];
                break;
                
            default:
                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = @"支付失败";
                XLLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } if ([resp isKindOfClass:[SendMessageToQQResp class]] && resp.type == ESENDMESSAGETOQQRESPTYPE) {
        SendMessageToQQResp* sendReq = (SendMessageToQQResp*)resp;
        // sendReq.result->0分享成功 -4取消分享
//        if ([sendReq.result integerValue] == 0) {
//            NSLog(@"qq share success");
//        }else{
//            NSLog(@"qq share failed");
//        }
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvQQMessageResponse:)]) {
            [_delegate managerDidRecvQQMessageResponse:sendReq];
        }
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end

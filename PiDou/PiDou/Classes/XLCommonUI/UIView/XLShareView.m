//
//  XLShareView.m
//  TG
//
//  Created by kevin on 30/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLShareView.h"
#import "XLTopBotButton.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "XLTieziHandle.h"
#import "XLCommentHandle.h"
#import "QRCodeViewController.h"

#define ShareBtn_H 101 * kWidthRatio6s

@interface XLShareView () <WXApiManagerDelegate>

@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UILabel *shareL;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *botV;

@property (nonatomic, strong) XLTopBotButton *weixinBtn;
@property (nonatomic, strong) XLTopBotButton *wechatFriendBtn;
@property (nonatomic, strong) XLTopBotButton *qqBtn;
@property (nonatomic, strong) XLTopBotButton *QRCodeBtn;
@property (nonatomic, strong) XLTopBotButton *deleteBtn;

@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *topBgBtn;
@property (nonatomic, strong) UIView *homeV;

@property (nonatomic, strong) UIView *kongView;

@end

@implementation XLShareView

+ (instancetype)shareView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    self.topBgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.topBgBtn addTarget:self action:@selector(clickTopBg) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.topBgBtn];
    
    self.shareView = [[UIView alloc] init];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shareView];
    XLViewRadius(self.shareView, 8 * kWidthRatio6s);
    
    self.cancleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.cancleBtn xl_setTitle:@"取消" color:XL_COLOR_BLACK size:14.f target:self action:@selector(cancleAction)];
    self.cancleBtn.backgroundColor = [UIColor whiteColor];
    [self.shareView addSubview:self.cancleBtn];
    
    
    self.homeV = [[UIView alloc] init];
    self.homeV.backgroundColor = [UIColor whiteColor];
    [self.shareView addSubview:self.homeV];
    
    self.shareL = [[UILabel alloc] init];
    [self.shareL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.shareL.text = @"分享到";
    [self.shareView addSubview:self.shareL];
    self.shareL.textAlignment = NSTextAlignmentCenter;
    
    self.topV = [[UIView alloc] init];
    [self.shareView addSubview:self.topV];
    
    self.botV = [[UIView alloc] init];
    [self.shareView addSubview:self.botV];
    
    
    self.weixinBtn = [XLTopBotButton buttonWithType:(UIButtonTypeCustom)];
    [self.weixinBtn xl_setTitle:@"微信" color:XL_COLOR_BLACK size:14.f target:self action:@selector(clickWeixin)];
    [self.weixinBtn setImage:[UIImage imageNamed:@"share_weixin"] forState:(UIControlStateNormal)];
    [self.topV addSubview:self.weixinBtn];
    
    self.wechatFriendBtn = [XLTopBotButton buttonWithType:(UIButtonTypeCustom)];
    [self.wechatFriendBtn xl_setTitle:@"朋友圈" color:XL_COLOR_BLACK size:14.f target:self action:@selector(clickWechat)];
    [self.wechatFriendBtn setImage:[UIImage imageNamed:@"share_friend"] forState:(UIControlStateNormal)];
    [self.topV addSubview:self.wechatFriendBtn];
    
    self.qqBtn = [XLTopBotButton buttonWithType:(UIButtonTypeCustom)];
    [self.qqBtn xl_setTitle:@"QQ好友" color:XL_COLOR_BLACK size:14.f target:self action:@selector(clickFriends)];
    [self.qqBtn setImage:[UIImage imageNamed:@"share_qq"] forState:(UIControlStateNormal)];
    [self.topV addSubview:self.qqBtn];
    
    //二维码
    self.QRCodeBtn = [XLTopBotButton buttonWithType:(UIButtonTypeCustom)];
    [self.QRCodeBtn xl_setTitle:@"二维码" color:XL_COLOR_BLACK size:14.f target:self action:@selector(clickQRCode)];
    [self.QRCodeBtn setImage:[UIImage imageNamed:@"sao_yi_sao"] forState:(UIControlStateNormal)];
    [self.topV addSubview:self.QRCodeBtn];
    
    self.deleteBtn = [XLTopBotButton buttonWithType:(UIButtonTypeCustom)];
    [self.deleteBtn xl_setTitle:@"删除" color:XL_COLOR_BLACK size:14.f target:self action:@selector(clickDelete)];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:(UIControlStateNormal)];
    [self.botV addSubview:self.deleteBtn];
    
    self.lineV = [[UIView alloc] init];
    self.lineV.backgroundColor = XL_COLOR_LINE;
    [self.botV addSubview:self.lineV];
    
    self.kongView = [[UIView alloc] init];
    self.kongView.backgroundColor = XL_COLOR_BG;
    [self.shareView addSubview:self.kongView];
    
    
    [WXApiManager sharedManager].delegate = self;
    
    [self initLayout];
    
}

- (void)initLayout {
    
    [self.topBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.shareView.mas_top);
    }];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.shareL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.shareView).mas_offset(XL_LEFT_DISTANCE);
        make.right.equalTo(self.shareView).mas_offset(-XL_LEFT_DISTANCE);
        make.height.mas_offset(XL_LEFT_DISTANCE);
    }];
    
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shareView);
        make.top.equalTo(self.shareL.mas_bottom);
        make.height.mas_offset(ShareBtn_H);
    }];
    
    [self.botV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topV);
        make.height.mas_offset(ShareBtn_H);
        make.top.equalTo(self.topV.mas_bottom);
    }];
    
    [self.kongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shareView);
        make.height.mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.botV.mas_bottom);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shareView);
        make.height.mas_offset(49);
        make.top.equalTo(self.kongView.mas_bottom);
        make.bottom.equalTo(self.homeV.mas_top);
    }];
    
    [self.homeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareView);
        make.height.mas_offset(XL_HOME_INDICATOR_H);
        make.bottom.equalTo(self.shareView).mas_offset(-8 * kWidthRatio6s);
    }];
    //修改约束
    [self.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.topV);
       // make.width.mas_offset(80 * kWidthRatio6s);
        make.width.mas_offset(60 * kWidthRatio6s);
    }];
    
    [self.wechatFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.weixinBtn);
        make.left.equalTo(self.weixinBtn.mas_right);
       // make.centerX.equalTo(self.shareView);
    }];
    
    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.weixinBtn);
        make.left.equalTo(self.wechatFriendBtn.mas_right);
    }];
    
    //二维码
    [self.QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.weixinBtn);
        make.left.equalTo(self.qqBtn.mas_right);
        make.right.equalTo(self.topV);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.botV);
        make.width.mas_offset(80 * kWidthRatio6s);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.botV);
        make.height.mas_offset(1);
    }];
}

- (void)setMessage:(XLShareModel *)message {
    _message = message;
    if (!XLStringIsEmpty(self.message.entity_id)) {
        self.message.pageUrl = [NSString stringWithFormat:@"http://pdtv.vip/h5/#/post?entity_id=%@",self.message.entity_id];
    } else if (!XLStringIsEmpty(self.message.cid)) {
        self.message.pageUrl = [NSString stringWithFormat:@"http://pdtv.vip/h5/#/shareEva?cid=%@",self.message.cid];
    } else {
        self.message.pageUrl = [NSString stringWithFormat:@"http://pdtv.vip/h5/#/register?invitation_code=%@",self.message.text];
    }
}

- (void)setShowQRCode:(BOOL)showQRCode {
    _showQRCode = showQRCode;
    self.QRCodeBtn.hidden = !_showQRCode;
    if (_showQRCode) {
        [self.weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(60 * kWidthRatio6s);
        }];
        [self.wechatFriendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.weixinBtn);
            make.left.equalTo(self.weixinBtn.mas_right);
        }];
        [self.QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.weixinBtn);
            make.left.equalTo(self.qqBtn.mas_right);
            make.right.equalTo(self.topV);
        }];
    } else {
        [self.weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(80 * kWidthRatio6s);
        }];
        [self.wechatFriendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareView);
        }];
        [self.QRCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(0);
        }];
    }
}

#pragma mark - 点击微信
- (void)clickWeixin {
    
    BOOL success = [WXApiRequestHandler sendLinkURL:self.message.pageUrl TagName:self.message.text Title:self.message.title Description:self.message.desc ThumbImage:[UIImage imageNamed:@"AppIcon"] InScene:WXSceneSession];
    if (success) {
        
        //[self dismiss];
        
    }
}

#pragma mark - 点击微信朋友圈
- (void)clickWechat {

    BOOL success = [WXApiRequestHandler sendLinkURL:self.message.pageUrl TagName:self.message.text Title:self.message.title Description:self.message.desc ThumbImage:[UIImage imageNamed:@"AppIcon"] InScene:WXSceneTimeline];
    if (success) {
        
        //[self dismiss];
    
    }
}

#pragma mark - 点击QQ
- (void)clickFriends {
    NSString *utf8String = self.message.pageUrl;
    NSString *title = self.message.title;
    NSString *description = self.message.desc;
    NSString *previewImageUrl = self.message.thumbImage;
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    
    //QQApiTextObject *textObject = [QQApiTextObject objectWithText:self.message.title];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    //[self dismiss];
}

#pragma mark - 点击二维码
- (void)clickQRCode {
    QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc] init];
    QRCodeVC.pageUrl = self.message.pageUrl;
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:QRCodeVC animated:false completion:nil];
    
    [self dismiss];
}

#pragma mark - 点击删除
- (void)clickDelete {
    if (_delegate) {
        [_delegate didDeleteAction];
    }
}

#pragma mark - 点击取消按钮
- (void)cancleAction {
    [self dismiss];
}

#pragma mark - 点击顶部空白
- (void)clickTopBg {
    [self dismiss];
}

#pragma mark - show
- (void)show {
    
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - dismiss
- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
    
}

#pragma mark - 分享成功
- (void)shareSuccess {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        return;
    }
    if (!XLStringIsEmpty(self.message.entity_id)) {
        [XLTieziHandle tieziShareWithEntityID:self.message.entity_id success:^(id  _Nonnull responseObject) {
            [HUDController hideHUDWithText:responseObject];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else if (XLStringIsEmpty(self.message.cid)) {
        [XLCommentHandle commentShareWithCid:self.message.cid success:^(id  _Nonnull responseObject) {
            [HUDController hideHUDWithText:responseObject];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }
}

- (void)setNoDeletebtn:(BOOL)noDeletebtn {
    _noDeletebtn = noDeletebtn;
    self.botV.hidden = _noDeletebtn;
    if (_noDeletebtn) {
        [self.botV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
    } else {
        [self.botV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ShareBtn_H);
        }];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"手Q API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前TIM版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TIM API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISHAREDESTUNKNOWN:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未指定分享到QQ或TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
        }
            break;
        default:
        {
            break;
        }
    }
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    [self shareSuccess];

    [self dismiss];
}

- (void)managerDidRecvQQMessageResponse:(SendMessageToQQResp *)response {
    if ([response.result integerValue] == 0) {
        [self shareSuccess];
    }else{
        [HUDController hideHUDWithText:@"分享失败"];
    }

    [self dismiss];
}

@end

//
//  XLGainPDCoinController.m
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGainPDCoinController.h"
#import "XLGainCoinCell.h"
#import "XLCoinQQCell.h"
#import "XLCoinWechatCell.h"
#import "XLGainCoinHeader.h"
#import "XLCoinKongFooter.h"
#import "XLPublishAddLinkView.h"
#import "XLPDCoinHandle.h"
#import "XLGainPDCoinModel.h"
#import "XLShareView.h"
#import "XLUserLoginHandle.h"

static NSString * XLGainCoinCellID = @"kXLGainCoinCell";
static NSString * XLCoinQQCellID = @"kXLCoinQQCell";
static NSString * XLCoinWechatCellID = @"kXLCoinWechatCell";
static NSString * XLGainCoinHeaderID = @"kXLGainCoinHeader";
static NSString * XLCoinKongFooterID = @"kXLCoinKongFooter";

@interface XLGainPDCoinController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XLBaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *gainWaysArr;
@property (nonatomic, strong) NSMutableArray *qqArr;
@property (nonatomic, strong) NSMutableArray *wecharArr;
@property (nonatomic, strong) NSMutableArray *weixinArr;
@property (nonatomic, strong) NSMutableArray *headerTitles;

@property (nonatomic, strong) XLPublishAddLinkView *addLinkView;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *linkTitle;;


@end

@implementation XLGainPDCoinController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"获取PDCoin";
    
    [self initUI];
    
    [self initData];
}

- (void)initUI {
    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)initData {
    kDefineWeakSelf;
    [XLPDCoinHandle gainPDCoinWaysWithSuccess:^(XLGainPDCoinModel *responseObject) {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[@"title"] = @"邀请好友";
        dic1[@"des"] = @"获取更多PDCoin";
        [WeakSelf.gainWaysArr addObject:dic1];
        [WeakSelf.headerTitles addObject:@""];
        
        if (responseObject.join_qq_pdcoin_count) {
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
            dic2[@"title"] = @"加入QQ群";
            dic2[@"des"] = [NSString stringWithFormat:@"+%@ PDCoin",responseObject.join_qq_pdcoin_count];
            [WeakSelf.gainWaysArr addObject:dic2];
            [WeakSelf.headerTitles addObject:@"QQ群"];
        }
        
        if (responseObject.join_wechat_pdcoin_count) {
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
            dic3[@"title"] = @"加入微信群";
            dic3[@"des"] = [NSString stringWithFormat:@"+%@ PDCoin",responseObject.join_wechat_pdcoin_count];
            [WeakSelf.gainWaysArr addObject:dic3];
            [WeakSelf.headerTitles addObject:@"微信群"];
        }
        
        if (responseObject.follow_wechat_mp) {
            NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
            dic4[@"title"] = @"关注微信公众号";
            dic4[@"des"] = [NSString stringWithFormat:@"+%@ PDCoin",responseObject.follow_wechat_mp];
            [WeakSelf.gainWaysArr addObject:dic4];
            [WeakSelf.headerTitles addObject:@"微信公众号"];
        }
        
        WeakSelf.qqArr = responseObject.qq_group.mutableCopy;
        WeakSelf.wecharArr = responseObject.wechat_group.mutableCopy;
        WeakSelf.weixinArr = responseObject.mp.mutableCopy;
        [WeakSelf.collectionView reloadData];
    } failure:^(id  _Nonnull result) {
        
    }];
}

- (void)registCell {
    [self.collectionView registerClass:[XLGainCoinCell class] forCellWithReuseIdentifier:XLGainCoinCellID];
    [self.collectionView registerClass:[XLCoinQQCell class] forCellWithReuseIdentifier:XLCoinQQCellID];
    [self.collectionView registerClass:[XLCoinWechatCell class] forCellWithReuseIdentifier:XLCoinWechatCellID];
    [self.collectionView registerClass:[XLGainCoinHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XLGainCoinHeaderID];
    [self.collectionView registerClass:[XLCoinKongFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:XLCoinKongFooterID];
}

- (void)showAddLinkView {
    if (!_addLinkView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.addLinkView];
    }
}
- (void)dismissAddLinkView {
    if (_addLinkView) {
        [_addLinkView removeFromSuperview];
        _addLinkView = nil;
    }
}

- (void)shareAction {
    [HUDController xl_showHUD];
    [XLUserLoginHandle userInfoWithSuccess:^(XLAppUserModel *userInfo) {
        [HUDController hideHUD];
        XLShareModel *message = [[XLShareModel alloc] init];
        message.title = [NSString stringWithFormat:@"皮逗邀请码：%@",userInfo.invitation_code];
        message.text = userInfo.invitation_code;
        
        XLShareView *shareView = [XLShareView shareView];
        shareView.message = message;
        shareView.noDeletebtn = YES;
        shareView.showQRCode = YES;
        [shareView show];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.gainWaysArr.count;
    }
    if (section == 1) {
        return self.qqArr.count;
    }
    if (section == 2) {
        return self.wecharArr.count;
    }
    return self.weixinArr.count;;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.headerTitles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        XLGainCoinCell *gainCell = [collectionView dequeueReusableCellWithReuseIdentifier:XLGainCoinCellID forIndexPath:indexPath];
        gainCell.titleName = [self.gainWaysArr[row] valueForKey:@"title"];
        gainCell.desName = [self.gainWaysArr[row] valueForKey:@"des"];
        return gainCell;
    }
    else if (section == 1) {
        XLCoinQQCell *qqCell = [collectionView dequeueReusableCellWithReuseIdentifier:XLCoinQQCellID forIndexPath:indexPath];
        qqCell.qqModel = self.qqArr[row];
        return qqCell;
    }
    else {
        XLCoinWechatCell *wechatCell = [collectionView dequeueReusableCellWithReuseIdentifier:XLCoinWechatCellID forIndexPath:indexPath];
        if (section == 2) {
            wechatCell.qrCodeModel = self.wecharArr[row];
        } else {
            wechatCell.qrCodeModel = self.weixinArr[row];
        }
        return wechatCell;
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        XLCoinKongFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:XLCoinKongFooterID forIndexPath:indexPath];
        footer.backgroundColor = XL_COLOR_BG;
        return footer;
    } else {
        XLGainCoinHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XLGainCoinHeaderID forIndexPath:indexPath];
        header.titleName = self.headerTitles[section];
        return header;
    }
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击图片%ld",indexPath.row);
    if (indexPath.section != 0) {
        return;
    }
    switch (indexPath.item) {
        case 0:
        {
            [self shareAction];
        }
            break;
        case 1:
        {
            self.type = @"qq_group";
            self.linkTitle = @"加入QQ群";
            [self showAddLinkView];
        }
            break;
        case 2:
        {
            self.type = @"wechat_group";
            self.linkTitle = @"加入微信群";
            [self showAddLinkView];
        }
            break;
        case 3:
        {
            self.type = @"mp";
            self.linkTitle = @"关注微信公众号";
            [self showAddLinkView];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return CGSizeMake((SCREEN_WIDTH - 1.0) * 0.5, 92 * kWidthRatio6s);
    } else if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 20 * kWidthRatio6s);
    }
    return CGSizeMake(SCREEN_WIDTH / 3.0 - 0.1, 126 * kWidthRatio6s);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4 * kWidthRatio6s;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4 * kWidthRatio6s;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(SCREEN_WIDTH, 48 * kWidthRatio6s);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 8 * kWidthRatio6s);
    } else {
        return CGSizeZero;
    }
}


#pragma mark - lazy load
- (XLBaseCollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        
        _collectionView = [[XLBaseCollectionView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H)) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self registCell];
        
    }
    return _collectionView;
}

- (NSMutableArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = [NSMutableArray array];
    }
    return _headerTitles;
}

- (NSMutableArray *)gainWaysArr {
    if (!_gainWaysArr) {
        _gainWaysArr = [NSMutableArray array];
    }
    return _gainWaysArr;
}

- (NSMutableArray *)qqArr {
    if (!_qqArr) {
//        _qqArr = [NSMutableArray arrayWithObjects:@"QQ1群：123123123（已满）",@"QQ2群：821798391（已满）",@"QQ3群：231998133",@"QQ4群：123981392", nil];
        _qqArr = [NSMutableArray array];
    }
    return _qqArr;
}

- (NSMutableArray *)wecharArr {
    if (!_wecharArr) {
        _wecharArr = [NSMutableArray array];
//        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//        dic1[@"title"] = @"微信1群";
//        dic1[@"des"] = @"";
//        [_wecharArr addObject:dic1];
//
//        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
//        dic2[@"title"] = @"微信2群";
//        dic2[@"des"] = @"";
//        [_wecharArr addObject:dic2];
//
//        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
//        dic3[@"title"] = @"微信3群";
//        dic3[@"des"] = @"";
//        [_wecharArr addObject:dic3];
//
//        NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
//        dic4[@"title"] = @"微信4群";
//        dic4[@"des"] = @"";
//        [_wecharArr addObject:dic4];
    }
    return _wecharArr;
}

- (NSMutableArray *)weixinArr {
    if (!_weixinArr) {
        _weixinArr = [NSMutableArray array];
//        NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
//        dic4[@"title"] = @"关注微信公众号";
//        dic4[@"des"] = @"";
//        [_weixinArr addObject:dic4];
    }
    return _weixinArr;
}

- (XLPublishAddLinkView *)addLinkView {
    if (!_addLinkView) {
        kDefineWeakSelf;
        _addLinkView = [[XLPublishAddLinkView alloc] initPublishAddLinkViewWithComplete:^(NSString *text) {
            [WeakSelf.view endEditing:YES];
            if (!XLStringIsEmpty(text) && !XLStringIsEmpty(WeakSelf.type)) {
                [HUDController xl_showHUD];
                [XLPDCoinHandle gainPDCoinCode:text type:WeakSelf.type success:^(id  _Nonnull responseObject) {
                    [HUDController hideHUDWithText:responseObject];
                    [WeakSelf dismissAddLinkView];
                } failure:^(id  _Nonnull result) {
                    [HUDController xl_hideHUDWithResult:result];
                    [WeakSelf dismissAddLinkView];
                }];
            } else {
                [WeakSelf dismissAddLinkView];
            }
        }];
        _addLinkView.title = self.linkTitle;
    }
    return _addLinkView;
}

@end

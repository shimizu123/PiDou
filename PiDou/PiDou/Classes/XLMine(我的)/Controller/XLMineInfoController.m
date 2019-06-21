//
//  XLMineInfoController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineInfoController.h"
#import "XLMineListCell.h"
#import "XLMineSettingTopCell.h"
#import "XLMineNameController.h"
#import "XLMineSignController.h"
#import "XLMineOriPhoneController.h"
#import "XLUserLoginHandle.h"
#import "XLMineHandle.h"
#import "XLVODUploadManager.h"
#import "XLFileManager.h"

static NSString * XLMineListCellID      = @"kXLMineListCell";
static NSString *XLMineSettingTopCellID = @"kXLMineSettingTopCell";

@interface XLMineInfoController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) XLBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArr;


@end

@implementation XLMineInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    kDefineWeakSelf;
    [XLUserLoginHandle userInfoWithSuccess:^(XLAppUserModel *userInfo) {
        WeakSelf.userInfo = userInfo;
        [WeakSelf initInfoData];
        WeakSelf.tableView.hidden = NO;
    } failure:^(id  _Nonnull result) {
        WeakSelf.tableView.hidden = NO;
    }];
}


- (void)initUI {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H);
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)initInfoData {
    [self.listArr removeAllObjects];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"title"] = @"昵称";
    dic1[@"desc"] = self.userInfo.nickname;
    dic1[@"type"] = @(0);
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"title"] = @"个性签名";
    dic2[@"desc"] = self.userInfo.sign;
    dic2[@"type"] = @(0);
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"title"] = @"性别";
    dic3[@"desc"] = self.userInfo.sex;
    dic3[@"type"] = @(0);
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    dic4[@"title"] = @"手机号码";
    dic4[@"desc"] = self.userInfo.phone_number;
    dic4[@"type"] = @(0);
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    dic5[@"title"] = @"微信";
    dic5[@"desc"] = self.userInfo.wechat_id;
    dic5[@"type"] = @(1);
    
    [self.listArr addObject:dic1];
    [self.listArr addObject:dic2];
    [self.listArr addObject:dic3];
    [self.listArr addObject:dic4];
    [self.listArr addObject:dic5];
    [self.tableView reloadData];
}


- (void)setup {
    [self registerCell];
}

- (void)registerCell {
    [_tableView registerClass:[XLMineListCell class] forCellReuseIdentifier:XLMineListCellID];
    [_tableView registerClass:[XLMineSettingTopCell class] forCellReuseIdentifier:XLMineSettingTopCellID];
}

- (void)updateAvatarWithUrl:(NSString *)url {
    [HUDController xl_showHUD];
    kDefineWeakSelf;
    [XLMineHandle userInfoUpdateWithNickname:@"" sign:@"" sex:@"" avatar:url success:^(id  _Nonnull responseObject) {
        [HUDController hideHUD];
        WeakSelf.userInfo.avatar = url;
        [WeakSelf.tableView reloadData];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}


#pragma mark -- Image Picker Controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    // 2.5.0 kevin 将UIImagePickerControllerOriginalImage改成UIImagePickerControllerEditedImage
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSString *file = [NSString stringWithFormat:@"%@%@.jpg",XLFileManager.tmpDir,[XLVODUploadManager sharedXLVODUploadManager].getTimeNow];
    
    [XLFileManager createFileAtPath:file];
    [XLFileManager writeFileAtPath:file content:image];
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLVODUploadManager vodImageFilePath:file success:^(NSString *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController hideHUD];
            if (!XLStringIsEmpty(url)) {
                NSString *sizeUrl = [NSString stringWithFormat:@"%@?w=%.0f&h=%.0f",url,image.size.width,image.size.height];
                
                [WeakSelf updateAvatarWithUrl:sizeUrl];
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        });
    } failure:^(id  _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDController xl_hideHUDWithResult:result];
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    }];
   

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 2 && actionSheet.tag == 1001) {
        [HUDController xl_showHUD];
        kDefineWeakSelf;
        [XLMineHandle userInfoUpdateWithNickname:@"" sign:@"" sex:buttonIndex == 1 ? @"女":@"男" avatar:@"" success:^(id  _Nonnull responseObject) {
            [HUDController hideHUDWithText:responseObject];
            [WeakSelf initData];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }
    
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController* ctrl = [[UIImagePickerController alloc] init];
                ctrl.delegate = self;
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
                    ctrl.allowsEditing = YES;
                }
                
                [self presentViewController:ctrl animated:YES completion:^{
                }];
            }
                break;
            case 1:
            {
                UIImagePickerController* ctrl = [[UIImagePickerController alloc]init];
                ctrl.delegate = self;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    ctrl.allowsEditing = YES;
                }
                
                if ([ctrl.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
                    [ctrl.navigationBar setTintColor:[UIColor grayColor]];
                }
                
                [self.navigationController presentViewController:ctrl animated:YES completion:^{
                }];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.listArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        XLMineSettingTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:XLMineSettingTopCellID forIndexPath:indexPath];
        topCell.titleName = @"头像";
        topCell.url = self.userInfo.avatar;
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
    }
    XLMineListCell *listCell = [tableView dequeueReusableCellWithIdentifier:XLMineListCellID forIndexPath:indexPath];
    if (!XLArrayIsEmpty(self.listArr)) {
        listCell.infoDic = self.listArr[row];
    }
    
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return listCell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48 * kWidthRatio6s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        // 头像
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
        popup.tag = 1000;
        [popup showInView:self.view];
    } else {
        
        switch (row) {
            case 0:
            {
                // 昵称
                XLMineNameController *nameVC = [[XLMineNameController alloc] init];
                nameVC.name = self.userInfo.nickname;
                [self.navigationController pushViewController:nameVC animated:YES];
            }
                break;
            case 1:
            {
                // 个性签名
                XLMineSignController *signVC = [[XLMineSignController alloc] init];
                signVC.sign = self.userInfo.sign;
                [self.navigationController pushViewController:signVC animated:YES];
            }
                break;
            case 2:
            {
                // 性别
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
                sheet.tag = 1001;
                [sheet showInView:self.view];
            }
                break;
            case 3:
            {
                // 手机号码
                XLMineOriPhoneController *oriPhoneVC = [[XLMineOriPhoneController alloc] init];
                oriPhoneVC.phoneNum = self.userInfo.phone_number;
                [self.navigationController pushViewController:oriPhoneVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - lazy load
- (XLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.hidden = YES;
        [self setup];
    }
    return _tableView;
}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}


@end

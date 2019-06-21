//
//  XLMineNameController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineNameController.h"
#import "XLLimitTextField.h"
#import "XLMineHandle.h"
#import <MBProgressHUD.h>

@interface XLMineNameController () <UITextFieldDelegate>

@property (nonatomic, strong) XLLimitTextField *detailTF;

@end

@implementation XLMineNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改昵称";
    [self initUI];
}


- (void)initUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" size:16.f target:self action:@selector(saveAction)];
    
    self.detailTF = [[XLLimitTextField alloc] init];
    self.detailTF.textAlignment = NSTextAlignmentLeft;
    self.detailTF.textColor = XL_COLOR_DARKBLACK;
    self.detailTF.tintColor = XL_COLOR_DARKBLACK;
    self.detailTF.font = [UIFont xl_fontOfSize:16.f];
    self.detailTF.delegate = self;
    self.detailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.detailTF.leftSpacing = @(1 * kWidthRatio6s);
    [self.view addSubview:self.detailTF];
    self.detailTF.xl_placeholder = @"昵称";
    self.detailTF.text = self.name;
    
    [self.detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.view);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
}

- (void)saveAction {
    NSString *nickname = self.detailTF.text;
    if (XLStringIsEmpty(nickname)) {
        [HUDController hideHUDWithText:@"请输入昵称"];
        return;
    }
    [HUDController xl_showHUD];
    [XLMineHandle userInfoUpdateWithNickname:nickname sign:@"" sex:@"" avatar:@"" success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:responseObject];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    XLLog(@"姓名:%@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    UITextRange *selectedRange = [textField markedTextRange];//高亮选择的字
    UITextPosition *startPos = [textField positionFromPosition:selectedRange.start offset:0];
    UITextPosition *endPos = [textField positionFromPosition:selectedRange.end offset:0];
    NSInteger markLength = [textField offsetFromPosition:startPos toPosition:endPos];
    
    NSInteger confirmlength =  textField.text.length - markLength - range.length;//已经确认输入的字符长度
    if(confirmlength >= 15 ){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"最多只能输入15个字符";
        [hud hideAnimated:true afterDelay:1];
        return NO;
    }
    
    NSInteger allowMaxMarkLength = [self allowMaxMarkLength:15 - confirmlength];
    if(markLength > allowMaxMarkLength ){// && string.length > 0){
        return NO;
    }
    return YES;
}
/**
 主要是用于中文输入的场景，可根据需要自定义
 剩余的允许输入的字数较少时，限制拼音字符的输入，提升体验
 */
- (NSInteger)allowMaxMarkLength:(NSInteger)remainLength
{
    NSInteger length = 0;
    if(remainLength > 2){
        length = NSIntegerMax;
    }else if(remainLength > 0){
        length = remainLength * 6;  //一个中文对应的拼音一般不超过6个
    }
    
    return length;
}

@end

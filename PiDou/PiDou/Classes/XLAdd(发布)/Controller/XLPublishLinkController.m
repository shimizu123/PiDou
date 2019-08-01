//
//  XLPublishLinkController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishLinkController.h"
#import "XLTextView.h"
#import "XLTopBotButton.h"
#import "PublishLinkHandler.h"
#import "HXPhotoManager.h"
#import "XLAddController.h"
#import "XLPublishVideoPhotoController.h"
#import "XLBaseNavigationController.h"

#define Btn_H 101 * kWidthRatio6s

@interface XLPublishLinkController ()

@property (nonatomic, strong) XLTextView *linkTV;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) XLTopBotButton *ppxBtn;
@property (nonatomic, strong) XLTopBotButton *ppgxBtn;
@property (nonatomic, strong) XLTopBotButton *watermelonBtn;


@end

@implementation XLPublishLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入链接";
    [self initUI];
}

- (void)initUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"下一步" size:16.f target:self action:@selector(nextStep)];
    
    self.linkTV = [[XLTextView alloc] init];
    [self.view addSubview:self.linkTV];
    // 设置首字母不大写
    [self.linkTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.linkTV.font = [UIFont xl_fontOfSize:14.f];
    self.linkTV.placeholder = @"长按粘贴外站播放页链接";
    self.linkTV.placeholderColor = UIColor.whiteColor;
    self.linkTV.showsVerticalScrollIndicator = NO;
    self.linkTV.showsHorizontalScrollIndicator = NO;
    self.linkTV.textColor = UIColor.blackColor;
    self.linkTV.backgroundColor = XL_COLOR_RED;
    self.linkTV.contentInset = UIEdgeInsetsMake(5 * kWidthRatio6s, (310 * kWidthRatio6s - 168 * kWidthRatio6s) / 2, 0, 0);
    XLViewRadius(self.linkTV, 20 * kWidthRatio6s);
    
    self.desLabel = [[UILabel alloc] init];
    [self.view addSubview:self.desLabel];
    self.desLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"1.打开外站视频播放页，点击分享按钮\n2.点击分享按钮上的复制链接按钮\n3.把剪切板上的链接复制到上方输入框"];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 10 * kWidthRatio6s;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:XL_COLOR_DARKBLACK range:NSMakeRange(0, attributedStr.length)];
    self.desLabel.attributedText = attributedStr;
    
    self.label = [[UILabel alloc] init];
    [self.view addSubview:self.label];
    self.label.text = @"支持外站";
    self.label.textColor = XL_COLOR_DARKBLACK;
    self.label.font = [UIFont systemFontOfSize:18.f];
    
    self.ppxBtn = [XLTopBotButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.ppxBtn];
    self.ppxBtn.userInteractionEnabled = NO;
    [self.ppxBtn xl_setTitle:@"皮皮虾" color:XL_COLOR_BLACK size:13.f];
    [self.ppxBtn setImage:[UIImage imageNamed:@"zwlj_picture01"] forState:UIControlStateNormal];
    
    self.ppgxBtn = [XLTopBotButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.ppgxBtn];
    self.ppgxBtn.userInteractionEnabled = NO;
    [self.ppgxBtn xl_setTitle:@"皮皮搞笑" color:XL_COLOR_BLACK size:13.f];
    [self.ppgxBtn setImage:[UIImage imageNamed:@"zwlj_picture02"] forState:UIControlStateNormal];
    
    self.watermelonBtn = [XLTopBotButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.watermelonBtn];
    self.watermelonBtn.userInteractionEnabled = NO;
    [self.watermelonBtn xl_setTitle:@"西瓜视频" color:XL_COLOR_BLACK size:13.f];
    [self.watermelonBtn setImage:[UIImage imageNamed:@"zwlj_picture03"] forState:UIControlStateNormal];
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.linkTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(40 * kWidthRatio6s);
        make.width.mas_offset(310 * kWidthRatio6s);
        make.height.mas_offset(44 * kWidthRatio6s);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.linkTV.mas_bottom).mas_offset(50 * kWidthRatio6s);
        make.width.mas_offset(220 * kWidthRatio6s);
       // make.height.mas_offset(68 * kWidthRatio6s);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.ppgxBtn.mas_top).mas_offset(-50 * kWidthRatio6s);
    }];
    
    [self.ppxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-XL_HOME_INDICATOR_H - 50 * kWidthRatio6s);
    }];
    
    [self.ppgxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.equalTo(self.ppxBtn);
        make.left.equalTo(self.ppxBtn.mas_right);
    }];
    
    [self.watermelonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.equalTo(self.ppxBtn);
        make.left.equalTo(self.ppgxBtn.mas_right);
        make.right.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.linkTV endEditing:YES];
}

- (void)nextStep {
    if (self.linkTV.text.length != 0 && [self.linkTV.text containsString:@"http"]) {
        [HUDController showProgressLabel:@"解析中"];
        if ([self.linkTV.text containsString:@"pipix"]) {
           // link = @"https://h5.pipix.com/s/APTjSv/";
            [self parsePPxia:self.linkTV.text];
        } else if ([self.linkTV.text containsString:@"ippzone"]) {
           // link = @"http://share.ippzone.com/pp/post/118839858";
            [self parsePPgx:self.linkTV.text];
        }
    }
}

- (void)parsePPxia:(NSString *)link {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Maxthon/4.3.2.1000 Chrome/30.0.1599.101 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [manager GET:link parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSURLRequest *header = (NSURLRequest *)task.currentRequest;
        NSString *str = header.URL.absoluteString;
        
        NSString *pattern = @"item/\\d*\\?";
        NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *result = [regExp matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        NSString *itemId = [str substringWithRange:NSMakeRange(((NSTextCheckingResult *)result.firstObject).range.location + 5, ((NSTextCheckingResult *)result.firstObject).range.length - 6)];
        
        [PublishLinkHandler parsePPXLink:itemId success:^(NSString *downloadUrl) {
            [HUDController hideHUDWithText:@"解析成功"];
            [self download:downloadUrl manager:manager];
        } failure:^(id  _Nonnull result) {
            [HUDController hideHUDWithText:@"解析失败"];
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDController hideHUDWithText:@"解析失败"];
    }];
}

- (void)parsePPgx:(NSString *)link {
    NSArray *arr = [link componentsSeparatedByString:@"/"];
    NSInteger pid = [arr.lastObject integerValue];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置接受的参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"application/x-gzip", nil];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *url = @"http://share.ippzone.com/ppapi/post/detail";
    NSDictionary *pidDic = @{@"pid":[NSNumber numberWithInteger:pid]};
    
    [manager POST:url parameters:pidDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HUDController hideHUDWithText:@"解析成功"];
        NSNumber *targetId = responseObject[@"data"][@"post"][@"imgs"][0][@"id"];
        NSString *target = [NSString stringWithFormat:@"%@", targetId];
        NSString *downloadUrl = responseObject[@"data"][@"post"][@"videos"][target][@"url"];
        
        [self download:downloadUrl manager:manager];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDController hideHUDWithText:@"解析失败"];
    }];
}


- (void)download:(NSString *)urlStr manager:(AFHTTPSessionManager *)manager {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:SS";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *savePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"%@.mp4", dateStr]];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"下载视频失败");
        } else {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:savePath]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"保存视频成功");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        XLPublishVideoPhotoController *videoVC = [[XLPublishVideoPhotoController alloc] init];
                        videoVC.publishVCType = XLPublishVideoPhotoType_video;
                        XLBaseNavigationController *baseNaviC = [[XLBaseNavigationController alloc] initWithRootViewController:videoVC];
                        [self presentViewController:baseNaviC animated:NO completion:nil];
                    });
                } else {
                    NSLog(@"保存视频失败");
                }
            }];
        }
        
    }];
    [task resume];
}



@end

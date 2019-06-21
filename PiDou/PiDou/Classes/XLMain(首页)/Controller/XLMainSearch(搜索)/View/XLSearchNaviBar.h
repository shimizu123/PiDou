//
//  XLSearchNaviBar.h
//  CBNReporterVideo
//
//  Created by kevin on 12/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLSearchNaviBar;
@protocol XLSearchNaviBarDelegate <NSObject>

@optional
- (void)searchBar:(XLSearchNaviBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarDidBeginEditing:(XLSearchNaviBar *)searchBar;
- (void)searchBarDidEndEditing:(XLSearchNaviBar *)searchBar;
- (void)searchBarDidBack;
- (void)searchBarDidSearch;

@end

@interface XLSearchNaviBar : UIView
@property (nonatomic, weak) id <XLSearchNaviBarDelegate> delegate;
/**搜索内容*/
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;

@end

//
//  XLSizeModel.h
//  PiDou
//
//  Created by kevin on 29/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLSizeModel : NSObject

/**链接*/
@property (nonatomic, copy) NSString *url;
/**宽*/
@property (nonatomic, strong) NSNumber *width;
/**h高*/
@property (nonatomic, strong) NSNumber *height;

@end

NS_ASSUME_NONNULL_END

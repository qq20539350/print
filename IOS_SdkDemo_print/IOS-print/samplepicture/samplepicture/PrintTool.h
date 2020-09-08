//
//  PrintTool.h
//  samplepicture
//
//  Created by YT_lwf on 2019/9/25.
//  Copyright © 2019 开聪电子. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrintTool : NSObject

- (NSData *)getDataForPrint:(UIImage *)img;

@end

NS_ASSUME_NONNULL_END

//
//  UIImage+Tool.h
//  samplepicture
//
//  Created by YT_lwf on 2019/9/25.
//  Copyright © 2019 开聪电子. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tool)
- (UIImage*)grayscale:(UIImage*)anImage type:(int)type;
- (UIImage*)grayscaleImageForImage:(UIImage*)image;
-(NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength;
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

NS_ASSUME_NONNULL_END

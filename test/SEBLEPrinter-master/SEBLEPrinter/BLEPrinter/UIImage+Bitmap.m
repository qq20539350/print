//
//  UIImage+Bitmap.m
//  HLBluetoothDemo
//
//  Created by Harvey on 16/5/3.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "UIImage+Bitmap.h"

#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Bitmap)

//
- (NSData *)bitmapData
{
    CGImageRef imageRef = self.CGImage;
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self bitmapRGBA8Context];
    
    if(!context) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    uint32_t *bitmapData = (uint32_t *)CGBitmapContextGetData(context);
    
    
    if(bitmapData) {
        
        uint8_t *m_imageData = (uint8_t *) malloc(width * height/8 + 8*height/8);
        memset(m_imageData, 0, width * height/8 + 8*height/8);
        int result_index = 0;
        
        for(int y = 0; (y + 24) < height; ) {
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 51;
            m_imageData[result_index++] = 0;
            
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 42;
            m_imageData[result_index++] = 33;
            
            m_imageData[result_index++] = width%256;
            m_imageData[result_index++] = width/256;
            for(int x = 0; x < width; x++) {
                int value = 0;
                for (int temp_y = 0 ; temp_y < 8; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 8 ; temp_y < 16; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 16 ; temp_y < 24; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[BPRed] + 0.59 * rgbaPixel[BPGreen] + 0.11 * rgbaPixel[BPBlue];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
            }
            m_imageData[result_index++] = 13;
            m_imageData[result_index++] = 10;
            y += 24;
        }
        
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
        [data appendBytes:m_imageData length:result_index];
        
        free(bitmapData);
        return data;
    }
    
    NSLog(@"Error getting bitmap pixel data\n");
    CGContextRelease(context);
    
    return nil ; 
}

- (CGContextRef)bitmapRGBA8Context
{
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) {
        return NULL;
    }
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);	// RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;	

}

- (UIImage *)imageWithscaleMaxWidth:(CGFloat)maxWidth
{
    CGFloat width = self.size.width;
    if (width > maxWidth)
    {
        CGFloat height = self.size.height;
        CGFloat maxHeight = maxWidth * height / width;
        
        CGSize size = CGSizeMake(maxWidth, maxHeight);
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
    return self;
}

- (UIImage *)blackAndWhiteImage
{
//    CGSize size = self.size;
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"
                                  keysAndValues:kCIInputImageKey,beginImage,kCIInputColorKey,[CIColor colorWithCGColor:[UIColor blackColor].CGColor],nil];

    CIImage *outputImage = [filter outputImage];

//    UIImage *newImage = [UIImage createNonInterpolatedUIImageFormCIImage:outputImage withSize:size.width];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    return newImage;
}

@end

@implementation UIImage (QRCode)

+ (UIImage *)barCodeImageWithInfo:(NSString *)info
{
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 将字符串转换成NSData
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 将CIImage转换成UIImage，并放大显示
    UIImage *image =[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:300];
    return image;
}

+ (UIImage *)qrCodeImageWithInfo:(NSString *)info centerImage:(UIImage *)centerImage  width:(CGFloat)width
{
    if (!info) {
        return nil;
    }
    
    NSData *strData = [info dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    //创建二维码滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;

    UIImage *codeImage = [UIImage createNonInterpolatedUIImageFormCIImage:qrImage withSize:width];
    
    //二维码rect
    CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
    UIGraphicsBeginImageContext(rect.size);
    [codeImage drawInRect:rect];
    //定制logo
    if (centerImage) {
        //icon尺寸,UIBezierPath
        CGSize logoSize = CGSizeMake(rect.size.width*0.2, rect.size.height*0.2);
        CGFloat x = CGRectGetMidX(rect) - logoSize.width*0.5;
        CGFloat y = CGRectGetMidY(rect) - logoSize.height*0.5;
        CGRect logoFrame = CGRectMake(x, y, logoSize.width, logoSize.height);
        [[UIBezierPath bezierPathWithRoundedRect:logoFrame cornerRadius:10] addClip];
        
        [centerImage drawInRect:logoFrame];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage*)imageBgColorToTransparentWith:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

/**
   * 对图片进行压缩（去除透明度）
   *
   * @param bitmapOrg
   */
//  public static Bitmap compressPic(Bitmap bitmap) {
//      // 获取这个图片的宽和高
//      int width = bitmap.getWidth();
//      int height = bitmap.getHeight();
//      // 指定调整后的宽度和高度
//      int newWidth = 240;
//      int newHeight = 240;
//      Bitmap targetBmp = Bitmap.createBitmap(newWidth, newHeight, Bitmap.Config.ARGB_8888);
//      Canvas targetCanvas = new Canvas(targetBmp);
//      targetCanvas.drawColor(0xffffffff);
//      targetCanvas.drawBitmap(bitmap, new Rect(0, 0, width, height), new Rect(0, 0, newWidth, newHeight), null);
//      return targetBmp;
//  }

/**
    * 灰度图片黑白化，黑色是1，白色是0
    *
    * @param x   横坐标
    * @param y   纵坐标
    * @param bit 位图
    * @return
    */
//   public static byte px2Byte(int x, int y, Bitmap bit) {
//       if (x < bit.getWidth() && y < bit.getHeight()) {
//           byte b;
//           int pixel = bit.getPixel(x, y);
//           int red = (pixel & 0x00ff0000) >> 16; // 取高两位
//           int green = (pixel & 0x0000ff00) >> 8; // 取中两位
//           int blue = pixel & 0x000000ff; // 取低两位
//           int gray = RGB2Gray(red, green, blue);
//           if (gray < 128) {
//               b = 1;
//           } else {
//               b = 0;
//           }
//           return b;
//       }
//       return 0;
//   }
//
//   /**
//    * 图片灰度的转化
//    */
//   private static int RGB2Gray(int r, int g, int b) {
//       int gray = (int) (0.29900 * r + 0.58700 * g + 0.11400 * b);  //灰度转化公式
//       return gray;
//   }

/*************************************************************************
 * 假设一个240*240的图片，分辨率设为24, 共分10行打印
 * 每一行,是一个 240*24 的点阵, 每一列有24个点,存储在3个byte里面。
 * 每个byte存储8个像素点信息。因为只有黑白两色，所以对应为1的位是黑色，对应为0的位是白色
 **************************************************************************/
/**
 * 把一张Bitmap图片转化为打印机可以打印的字节流
 *
 * @param bmp
 * @return
 */
//public static byte[] draw2PxPoint(Bitmap bmp) {
//    //用来存储转换后的 bitmap 数据。为什么要再加1000，这是为了应对当图片高度无法
//    //整除24时的情况。比如bitmap 分辨率为 240 * 250，占用 7500 byte，
//    //但是实际上要存储11行数据，每一行需要 24 * 240 / 8 =720byte 的空间。再加上一些指令存储的开销，
//    //所以多申请 1000byte 的空间是稳妥的，不然运行时会抛出数组访问越界的异常。
//    int size = bmp.getWidth() * bmp.getHeight() / 8 + 1000;

@end

//
//  POSPrinting.h
//  PrinterLibs
//
//  Created by 彭书旗 on 15/12/18.
//  Copyright © 2015年 开聪电子. All rights reserved.
//

#ifndef POSPrinting_h
#define POSPrinting_h

#import <Foundation/Foundation.h>

#import <UIKit/UIImage.h>

#import "IO.h"

// 类的声明
@interface POSPrinting : NSObject

- (instancetype) init;

/**
 * 读写方式和打印指令分离，给该类设置一个io即可实现打印。
 */
- (void) SetIO:(IO *) io;

/**
 * 打印图片，mImage是原始图片，nMethod代表压缩算法（0－抖动算法 1-平均阀值）
 * 图片高度无要求，图片宽度要求像素是8的倍数，图片宽度不能超过打印纸宽。（2寸纸384点宽，3寸纸576点宽）
 */
- (void) POS_PrintPicture:(UIImage *)mImage nMethod:(int)nMethod;

/**
 * 打印图片，mImage是原始图片，nWidth、nHeight是打印宽高。nMethod代表压缩算法（0－抖动算法 1-平均阀值）
 * 图片高度无要求，图片宽度要求不能超过打印纸宽。（2寸纸384点宽，3寸纸576点宽）
 */
- (void) POS_PrintPicture:(UIImage *)mImage nWidth:(int)nWidth nHeight:(int)nHeight nAlign:(int)nAlign nMethod:(int)nMethod;

/**
 * 按照一定的格式打印字符串
 *
 * @param pszString
 *            需要打印的字符串
 * @param nOrgx
 *            指定 X 方向（水平）的起始点位置离左边界的点数。 一般为0。2寸打印机一行384点，3寸打印机一行576点。
 * @param nWidthTimes
 *            指定字符的宽度方向上的放大倍数。可以为 0到 1。
 * @param nHeightTimes
 *            指定字符高度方向上的放大倍数。可以为 0 到 1。
 * @param nFontType
 *            指定字符的字体类型。 (0x00 标准 ASCII 12x24) (0x01 压缩ASCII 9x17)
 * @param nFontStyle
 *            指定字符的字体风格。可以为以下列表中的一个或若干个。 (0x00 正常) (0x08 加粗) (0x80 1点粗的下划线)
 *            (0x100 2点粗的下划线) (0x200 倒置、只在行首有效) (0x400 反显、黑底白字) (0x1000
 *            每个字符顺时针旋转 90 度)
 */
- (void) POS_S_TextOut:(char *)pszString nOrgx:(int)nOrgx nWidthTimes:(int)nWidthTimes nHeightTimes:(int)nHeightTimes nFontType:(int)nFontType nFontStyle:(int)nFontStyle;

- (void) POS_S_SetBarcode:(char *)strCodedata nOrgx:(int)nOrgx nType:(int)nType nUnitWidth:(int)nUnitWidth nHeight:(int)nHeight nHriFontType:(int)nHriFontType nHriFontPosition:(int)nHriFontPosition;

- (void) POS_S_SetQRCode:(char *)strCodedata nUnitWidth:(int)nUnitWidth nVersion:(int)nVersion nErrorCorrectionLevel:(int)nErrorCorrectionLevel;

- (void) POS_EPSON_SetQRCode:(char *)strCodedata nUnitWidth:(int)nUnitWidth nVersion:(int)nVersion nErrorCorrectionLevel:(int)nErrorCorrectionLevel;

- (void) POS_FeedLine;

- (void) POS_SetAlign:(int)align;

- (void) POS_SetLineHeight:(int)nHeight;

- (void) POS_Reset;

- (void) POS_SetKey:(Byte[8])key;

// 固定为1
- (bool) POS_CheckKey:(Byte[8])key nPara:(int)nPara;

- (void) POS_SetMotionUnit:(int)nHorizontalMU nVerticalMU:(int)nVerticalMU;

- (void) POS_SetCharSetAndCodePage:(int)nCharSet nCodePage:(int)nCodePage;

// 0-GBK 1-UTF8 3-BIG5 4-SHIFT-JIS 5-EUC-KR
- (void) POS_SetLanguage:(int)nLanguage;

- (void) POS_SetRightSpacing:(int)nDistance;

- (void) POS_S_SetAreaWidth:(int)nWidth;

- (bool) POS_QueryStatus:(Byte[1])precbuf timeout:(int)timeout;

- (bool) POS_RTQueryStatus:(Byte[1])precbuf timeout:(int)timeout;

- (bool) POS_QueryOnline:(int)timeout;

@end

#endif /* POSPrinting_h */

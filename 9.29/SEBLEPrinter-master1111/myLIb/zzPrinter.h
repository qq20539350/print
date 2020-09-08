//
//  zzPrinter.h
//  zzPrinter
//
//  Created by hu on 2019/4/27.
//  Copyright © 2019 hu. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef unsigned int DWORD;


@interface zzPrinter : NSObject

void key_init(const char *key, int len);

// 位图宽度 转 每行字节数
#define BM_LINEDOTS_BYTES(dots)      (((dots)+7)/8)

// out: bitmap output data buffer
// in: bitmap data
// len: in buffer size
// w_bytes: bitmap per line bytes
// out为输出，in位位图点阵数据（横向取模--->，高位先）, srclen为in数据个数, w_bytes为位图点阵数据每行字节数
int getPrintPictureCommand(BYTE *out, BYTE *in, int srclen, int w_bytes);

#define getPrintPictureData(out, in, inlen, width)  getPrintPictureCommand(out, in, inlen, BM_LINEDOTS_BYTES(width))

// 获取打印机校验命令
// tag: 校验标记， 默认放NULL
// check: 校验数据，长度=8Bytes
// cmd: 校验命令, 长度=11Bytes。
// 使用说明：1. 将cmd数据发给打印机，打印机回复8bytes数据
//         2. 比较check与打印机回复的数据是否一致
//         3. 一致则校验通过
int getPrinterCheckCmd(const char *tag, BYTE *check, BYTE *cmd);

+(void)show; 

@end

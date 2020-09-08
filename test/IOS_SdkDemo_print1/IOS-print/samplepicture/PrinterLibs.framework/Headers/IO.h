//
//  NSObject+IO.h
//  PrinterLibs
//
//

#import <Foundation/Foundation.h>

@interface IO : NSObject

- (instancetype)init;

/***
  * 空实现，继承该类的子类需要实现这个函数
  */
- (bool) IsOpened;

/***
 * 空实现，继承该类的子类需要实现这个函数
 */
- (int) Write:(Byte * ) buffer offset:(int) offset count:(int) count;

/***
 * 空实现，继承该类的子类需要实现这个函数
 */
- (int) Read:(Byte *)buffer offset:(int)offset count:(int)count timeout:(int)timeout;

- (void) SkipAvailable;

@end

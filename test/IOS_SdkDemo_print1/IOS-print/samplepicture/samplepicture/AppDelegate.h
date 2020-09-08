//
//  AppDelegate.h
//  samplebarcode
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PrinterLibs/PrinterLibs.h"
#import "JDStatusBarNotification.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BLEPrintingOpenDelegate,BLEPrintingDisconnectDelegate,NETPrintingOpenDelegate,NETPrintingDisconnectDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NETPrinting * myNet;
@property BLEPrinting * myBle;
@property POSPrinting * myPos;
@property LabelPrinting * myLabel;

@property dispatch_queue_t myQueue;

@end


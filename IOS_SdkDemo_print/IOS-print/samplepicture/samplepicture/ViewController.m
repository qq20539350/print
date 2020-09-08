//
//  ViewController.m
//  samplebarcode
//
//

#import "ViewController.h"
#import "UIImage+Tool.h"
#import "PrintTool.h"
#import "UIImage+Bitmap.h"

@interface ViewController () <BLEPrintingDiscoverDelegate>

@property AppDelegate * myApp;
// 搜索到的蓝牙设备都会出现在这里了
@property NSMutableArray * arrayPeripehral;
@property NSMutableArray * arrayPeripheralName;
@property UITextField * tfRec;
@property UIScrollView * scrollView;

- (void)handleSearchBT:(id)sender;

- (void)handleConnect:(id)sender;

- (void)handleDisconnect:(id)sender;

@end

@implementation ViewController

@synthesize myApp,arrayPeripehral,arrayPeripheralName,tfRec,scrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.myBle.myDiscoverDelegate = self;
    arrayPeripehral = [[NSMutableArray alloc] init];
    arrayPeripheralName = [[NSMutableArray alloc] init];
    
    UIColor *randomColor = [UIColor colorWithRed:255/255. green:200/255. blue:0. alpha:1.f];
    
    self.view.backgroundColor = randomColor;
    //self.view.layer.borderColor = [UIColor orangeColor].CGColor;
    //self.view.layer.borderWidth = 2.f;
    
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    
    UITextField * tf1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    tf1.textAlignment = NSTextAlignmentCenter;
    tf1.enabled = false;
    [self.view addSubview:tf1];
    
    UIButton * buttonDisconnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonDisconnect setTitle:@"断开✖️" forState:UIControlStateNormal];
    buttonDisconnect.frame = CGRectMake(width - 100, 20, 100, 60);
    buttonDisconnect.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    buttonDisconnect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [buttonDisconnect addTarget:self action:@selector(handleDisconnect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDisconnect];
    
    tfRec = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, width, 60)];
    tfRec.textAlignment = NSTextAlignmentCenter;
    tfRec.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfRec.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    tfRec.text = @"";
    tfRec.enabled = false;
    [self.view addSubview:tfRec];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, width, height - 140)];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    UIButton * buttonSearchBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSearchBT setTitle:@"搜索" forState:UIControlStateNormal];
    buttonSearchBT.frame = CGRectMake(0, height - 60, width, 60);
    buttonSearchBT.backgroundColor = [UIColor orangeColor];
    buttonSearchBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonSearchBT.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [buttonSearchBT addTarget:self action:@selector(handleSearchBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSearchBT];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self handleSearchBT:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSearchBT:(id)sender
{
    [arrayPeripehral removeAllObjects];
    [arrayPeripheralName removeAllObjects];
    for (UIView * subview in [scrollView subviews])
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    [myApp.myBle scan];
}

- (void)handleConnect:(id)sender
{
    UIButton * btn = sender;
    
    if ([myApp.myBle IsOpened]) {
        tfRec.text = @"Please disconnect first ...\r\n";
        return;
    }
    
    [myApp.myBle stopScan];
    
    long index = [arrayPeripheralName indexOfObject:[btn titleForState:UIControlStateNormal]];
    
    CBPeripheral * peripheral = arrayPeripehral[index];
    
    tfRec.text = @"Connecting...\r\n";
    
    dispatch_async(myApp.myQueue, ^{
        // 耗时的操作
        if([myApp.myBle Open:peripheral])
        {
            [myApp.myPos SetIO:myApp.myBle];
            [myApp.myLabel SetIO:myApp.myBle];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                tfRec.text = @"Connected\r\n";
                [self dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"Open Success. Jump to print page.");
                }];
            });
            // 连接成功之后，打印一张测试页。
            UIImage * img = [UIImage imageNamed:@"yellowmen.png"];
            UIImage * img2 = [UIImage imageNamed:@"1.png"];
            UIImage * img3 = [UIImage imageNamed:@"2.png"];
            UIImage * img4 = [UIImage imageNamed:@"3.png"];
            NSLog(@"- -------- - 打印图片 ---");
        
            
            UIImage * cImg = [img imageWithImage:img scaledToSize:CGSizeMake(341, 341 * img.size.height / img.size.width)];
            //    UIImage * cImg = [UIImage imageWithData:cData];
            //    UIImage *gImg = [cImg grayscale:cImg type:2];
//            UIImage *gImg = [cImg grayscaleImageForImage:cImg];
            NSData * data = [[[PrintTool alloc] init] getDataForPrint:cImg];
            [myApp.myBle Write:data.bytes offset:0 count:data.length];
            
            
            UIImage *newImage = [img imageWithscaleMaxWidth:341];
            NSData *imageData = [img bitmapData];
            Byte *bts = (Byte *)imageData.bytes;
//            [myApp.myBle Write:bts offset:0 count:imageData.length];
            
//            [myApp.myBle Write:data.bytes offset:0 count:data.length];
            
//            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:0];
//            [myApp.myPos POS_PrintPicture:img nWidth:384 nHeight:600 nAlign:1 nMethod:0];
//            [myApp.myPos POS_PrintPicture:img2 nWidth:384 nHeight:240 nAlign:1 nMethod:0];
//            [myApp.myPos POS_PrintPicture:img4 nWidth:380 nHeight:480 nAlign:1 nMethod:0];
//            [myApp.myPos POS_PrintPicture:gImg nWidth:380 nHeight:480 nAlign:1 nMethod:0];
//            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:0];
//            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:1];
//            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:0 nMethod:2];
//            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:1];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                tfRec.text = @"Failed\r\n";
            });
        }
    });
}

- (void)handleDisconnect:(id)sender
{
    [myApp.myBle Close];
    tfRec.text = @"Disconnected\r\n";
}


// BLEPrintingDelegate
- (void)didDiscoverBLE:(CBPeripheral *)peripheral address:(NSString *)address rssi:(int)rssi
{
    // 更新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Handle Discovery
        if([arrayPeripehral containsObject:peripheral])
            return;
        
        [arrayPeripehral addObject:peripheral];
        
        NSString * title = [NSString stringWithFormat:@"%@ %@ (RSSI:%d)", peripheral.name, address, rssi];
        
        [arrayPeripheralName addObject:title];
        
        int width = self.view.bounds.size.width;
        //int height = self.view.bounds.size.height;
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.frame = CGRectMake(30, ([arrayPeripheralName count]-1)*40, width-60, 40);
        button1.backgroundColor = [UIColor lightGrayColor];
        [button1 setTitle:title  forState:UIControlStateNormal];
        button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button1 addTarget:self action:@selector(handleConnect:) forControlEvents:UIControlEventTouchUpInside];
        scrollView.contentSize = CGSizeMake(width, [arrayPeripheralName count]*40);
        [scrollView addSubview:button1];
        
    });
}

@end


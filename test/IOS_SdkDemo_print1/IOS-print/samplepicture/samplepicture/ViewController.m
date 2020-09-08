//
//  ViewController.m
//  samplebarcode
//
//

#import "ViewController.h"
#import "zzPrinter.h"
#import "UIImage+Tool.h"

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
    
    
    
    
    
    
    
    
    
    
    
//    {
//
//        UIImage * img = [UIImage imageNamed:@"yellowmen.png"];
//        CGImageRef imgref = img.CGImage;
//        CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref); //资源提供
//        CFDataRef data = CGDataProviderCopyData(dataProvider);
//        int t_width = 384;
//        int w_bytes = BM_LINEDOTS_BYTES(t_width);
//        long o_szie = CFDataGetLength(data);
//        BYTE in[o_szie];
//        UInt16 len = sizeof(in);
//        memset(in, 0xFF, len);
//        int size = getPrintPictureCommand(NULL, in, len, w_bytes);
//        BYTE *out = (BYTE *)malloc(size);
//        if (out){
//            size = getPrintPictureCommand(out, in, len, w_bytes);
//            free(out);
//            NSLog(@"打印 =======");
//            [myApp.myBle Write:out offset:0 count:size];
//        }
//
//    }
//
    
    
    
    
    
    
    
    
    
    
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
        NSLog(@"- -------- - 打印图片 ---");
        //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:0];
        //            [myApp.myPos POS_PrintPicture:img nWidth:384 nHeight:600 nAlign:1 nMethod:0];
        //            [myApp.myPos POS_PrintPicture:img2 nWidth:384 nHeight:240 nAlign:1 nMethod:0];
        //            [myApp.myPos POS_PrintPicture:img3 nWidth:380 nHeight:480 nAlign:1 nMethod:0];
        //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:0];
        //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:1];
        //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:0 nMethod:2];
        //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:1];
        
        //            NSString * str = @"abaadadasdsadsad";
        //            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        //            Byte * byts = (Byte *)data.bytes;
        //            NSLog(@"%s",byts);
        //            [myApp.myBle Write:byts offset:0 count:20];
        
//        NSData * data = [img compressBySizeWithMaxLength:380];
//        UIImage * comImg = [UIImage imageWithData:data];
//        UIImage *gImg = [comImg grayscale:comImg type:1];
//        NSLog(@"");
//        [myApp.myPos POS_PrintPicture:gImg nWidth:384 nHeight:600 nAlign:1 nMethod:0];
        
        [self imageToTransparent:img];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            tfRec.text = @"Failed\r\n";
        });
    }
    
//    dispatch_async(myApp.myQueue, ^{
//        // 耗时的操作
//        if([myApp.myBle Open:peripheral])
//        {
//            [myApp.myPos SetIO:myApp.myBle];
//            [myApp.myLabel SetIO:myApp.myBle];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 更新界面
//                tfRec.text = @"Connected\r\n";
//                [self dismissViewControllerAnimated:YES completion:^{
//                    NSLog(@"Open Success. Jump to print page.");
//                }];
//            });
//            // 连接成功之后，打印一张测试页。
//            UIImage * img = [UIImage imageNamed:@"yellowmen.png"];
//            UIImage * img2 = [UIImage imageNamed:@"1.png"];
//            UIImage * img3 = [UIImage imageNamed:@"2.png"];
//            NSLog(@"- -------- - 打印图片 ---");
//            //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:0];
//            //            [myApp.myPos POS_PrintPicture:img nWidth:384 nHeight:600 nAlign:1 nMethod:0];
//            //            [myApp.myPos POS_PrintPicture:img2 nWidth:384 nHeight:240 nAlign:1 nMethod:0];
////            [myApp.myPos POS_PrintPicture:img3 nWidth:380 nHeight:480 nAlign:1 nMethod:0];
//            //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:0];
//            //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:1 nMethod:1];
//            //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:0 nMethod:2];
//            //            [myApp.myPos POS_PrintPicture:img nWidth:100 nHeight:200 nAlign:2 nMethod:1];
//
////            NSString * str = @"abaadadasdsadsad";
////            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
////            Byte * byts = (Byte *)data.bytes;
////            NSLog(@"%s",byts);
////            [myApp.myBle Write:byts offset:0 count:20];
//
//            CGImageRef imgref = img.CGImage;
//            size_t width = CGImageGetWidth(imgref);
//            size_t height = CGImageGetHeight(imgref);
//            size_t bitsPerCommponent = CGImageGetBitsPerComponent(imgref); //返回单色的位数
//            size_t bitsPerPixel = CGImageGetBitsPerPixel(imgref); //一个像素的位数
//            size_t bytesPerRow = CGImageGetBytesPerRow(imgref); // 一行多少字节
//            CGColorSpaceRef colorspace = CGImageGetColorSpace(imgref); // 色彩空间
//            //        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
//            CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imgref); // 图像的位图信息 (像素中bit的布局， 是rgba还是 argb)
//            bool shouldInterpolate = CGImageGetShouldInterpolate(imgref); //抗锯齿参数
//            CGColorRenderingIntent intent = CGImageGetRenderingIntent(imgref); //图片渲染相关参数
//            CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref); //资源提供
//            CFDataRef data = CGDataProviderCopyData(dataProvider); // 获取data
//            UInt8 *buff = (UInt8*)CFDataGetBytePtr(data);
//
//            long t_width = 384;
//            long w_bytes = BM_LINEDOTS_BYTES(t_width);    //48
//            long o_szie = CFDataGetLength(data);
//            BYTE in[216000];
//            long len = sizeof(in);
//            memset(in, 0xFF, sizeof(in));
//            int size = getPrintPictureCommand(NULL, in, len, w_bytes);
//            BYTE *out = (BYTE *)malloc(size);
//            if (out){
//                size = getPrintPictureCommand(out, in, len, w_bytes);
//                NSLog(@"打印 =======");
//                [myApp.myBle Write:out offset:0 count:size];
//                free(out);
//            }
//
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 更新界面
//                tfRec.text = @"Failed\r\n";
//            });
//        }
//    });
}

- (void)test3{
    UIImage *img = [UIImage imageNamed:@"yellowmen.png"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef imgref = img.CGImage;
        size_t width = CGImageGetWidth(imgref);
        size_t height = CGImageGetHeight(imgref);
        size_t bitsPerCommponent = CGImageGetBitsPerComponent(imgref); //返回单色的位数
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imgref); //一个像素的位数
        size_t bytesPerRow = CGImageGetBytesPerRow(imgref); // 一行多少字节
        CGColorSpaceRef colorspace = CGImageGetColorSpace(imgref); // 色彩空间
        //        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imgref); // 图像的位图信息 (像素中bit的布局， 是rgba还是 argb)
        bool shouldInterpolate = CGImageGetShouldInterpolate(imgref); //抗锯齿参数
        CGColorRenderingIntent intent = CGImageGetRenderingIntent(imgref); //图片渲染相关参数
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref); //资源提供
        CFDataRef data = CGDataProviderCopyData(dataProvider); // 获取data
        UInt8 *buff = (UInt8*)CFDataGetBytePtr(data);
        
//        long t_width = 384;
//        long w_bytes = BM_LINEDOTS_BYTES(t_width);    //48
//        long o_szie = CFDataGetLength(data);
//        BYTE in[o_szie];
//        long len = sizeof(in);
//        memset(in, 0xFF, len);
//        int size = getPrintPictureCommand(NULL, in, len, w_bytes);
//        BYTE *out = (BYTE *)malloc(size);
//        if (out){
//            size = getPrintPictureCommand(out, in, len, w_bytes);
//            free(out);
//        }
        
        NSUInteger x,y;
        // 修改值
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                UInt8 *tmp;
                tmp = buff + y * bytesPerRow + x * 4; //buff 数据的首指针 ; tmp 当前地址位
                UInt8 alpha;
                alpha = *(tmp + 3);
                //                if (alpha) {// 透明不处理 其他变成红色
                //                    *tmp = 255;//red
                //                    *(tmp + 1) = 0;//green
                //                    *(tmp + 2) = 0;// Blue
                //                }
                
                if (alpha) {// 透明不处理 其他变成红色
                    UInt8 *red = tmp;//red
                    UInt8 *green = (tmp + 1);//green
                    UInt8 *blue = (tmp + 2);// Blue
                    int rv = *(int*)red;
                    int gv = *(int*)green;
                    int bv = *(int*)blue;
                    *red = rv + 5;
                    *green = gv + 100;
                    *blue = bv + 5;
                }
            }
        }
        CFDataRef effectedData = CFDataCreate(NULL, buff, CFDataGetLength(data)); //生成新数据
        CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
        // 生成一张新的位图
        CGImageRef effectedCgImage = CGImageCreate(
                                                   width, height,
                                                   bitsPerCommponent, bitsPerPixel, bytesPerRow,
                                                   colorspace, bitmapInfo, effectedDataProvider,
                                                   NULL, shouldInterpolate, intent);
        UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        CGImageRelease(effectedCgImage);
        CFRelease(effectedDataProvider);
        CFRelease(effectedData);
        CFRelease(data);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
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

-  (void) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    //初始化一个RGB图像流
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context，设置RGB图像流
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);
    
    //RGB图像流接受图像
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    CGContextRelease(context);
    
    int w_bytes = (imageWidth + 7) / 8;
    BYTE* dotsmap = (BYTE*)malloc(w_bytes * imageHeight);
    
    if (dotsmap){
        memset(dotsmap, 0, w_bytes * imageHeight);
        
        // 遍历像素
        int pixelNum = imageWidth * imageHeight;
        uint32_t* pCurPtr = rgbImageBuf;//
        
        for (int y=0; y<imageHeight; y++){
            for (int x = 0; x < imageWidth; x++){
                // 分离三原色及透明度
                int red = ((*pCurPtr & 0xFF000000) >> 24);
                int green = ((*pCurPtr & 0x00FF0000) >> 16);
                int blue = ((*pCurPtr & 0x0000FF00) >> 8);
                int alpha =  ((*pCurPtr & 0x000000FF) >> 0);
                pCurPtr ++;
                
                int gray = red * 0.3 + green * 0.59 + blue * 0.11;
                
//                if (gray < 127){
//                    int idx = y*w_bytes + (x>>3);
//                    int off = x & 7;
//                    dotsmap[idx] |= 0x80>>off;
//                }
                
                if (gray < 127){
                    int idx = y*w_bytes + x;
                    dotsmap[idx] = 0xff;
                }
            }
        }
        
        [myApp.myBle Write:dotsmap offset:0 count:w_bytes * imageHeight];
        
        int size = getPrintPictureCommand(NULL, dotsmap, w_bytes * imageHeight, w_bytes);
        BYTE *out = (BYTE *)malloc(size);
        if (out){
            size = getPrintPictureCommand(out, dotsmap, w_bytes * imageHeight, w_bytes);
            
//            bt.write(out, size);        // print bitmap
//            [myApp.myBle Write:out offset:0 count:size];
            
            printf("\n\n");
            for (int i=0; i<size; i++){
                if (i && i%16==0) printf("\n");
                printf("%02x ", out[i]);
            }
            printf("\n\n");
            
            
            free(out);
        }
        free(dotsmap);
    }
    
}

/** 颜色变化 */
void ProviderReleaseData(void *info, const void *data, size_t size)
{
    free((void*)data);
}


@end


//
//  ViewController.m
//  SEBLEPrinter
//
//  Created by Harvey on 16/5/5.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "ViewController.h"

#import "SEPrinterManager.h"
#import "SVProgressHUD.h"
#import "zzPrinter.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)   NSArray              *deviceArray;  /**< 蓝牙设备个数 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"未连接";
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        _deviceArray = perpherals;
        [_tableView reloadData];
    } failure:^(SEScanError error) {
         NSLog(@"error:%ld",(long)error);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([SEPrinterManager sharedInstance].connectedPerpheral) {
//        self.title = [SEPrinterManager sharedInstance].connectedPerpheral.name;
//    } else {
//        [[SEPrinterManager sharedInstance] autoConnectLastPeripheralTimeout:10 completion:^(CBPeripheral *perpheral, NSError *error) {
//            NSLog(@"自动重连返回");
//            self.title = [SEPrinterManager sharedInstance].connectedPerpheral.name;
            // 因为自动重连后，特性还没扫描完，所以延迟一会开始写入数据
//            [self performSelector:@selector(rightAction) withObject:nil afterDelay:1.0];
//        }];
//    }
}

- (HLPrinter *)getPrinter
{
    HLPrinter *printer = [[HLPrinter alloc] init];
    
    UIImage * img = [UIImage imageNamed:@"yellowmen.png"];
    [self imageToTransparent:img printer:printer];
    
    
#if 0
    NSString *title = @"冷链全程温度监控";
   // NSString *str1 = @"";
    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
   // [printer appendText:str1 alignment:HLTextAlignmentCenter];
    [printer appendBarCodeWithInfo:@"1122334455"];
//    [printer appendSeperatorLine];
    [printer appendTitle:@"起始时间:" value:@"2016-04-27 10:01:50" valueOffset:150];
    [printer appendTitle:@"结束时间:" value:@"4000020160427100150" valueOffset:150];
    NSDictionary *dict1 = @{@"过程温度:":@"12,23,4,5,6,7,8,9"};
    [printer appendLeftText:dict1[@"过程温度:"] middleText:@"" rightText:@"" isTitle:YES];
    
    [printer appendSeperatorLine];
//    [printer appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
//    CGFloat total = 0.0;
//    NSDictionary *dict1 = @{@"公司名称":@"座头鲸"};
//    NSDictionary *dict2 = @{@"设备名称":@"abcdefghijfdf"};
//    NSDictionary *dict3 = @{@"设备编号":@"1223334"};
//    NSArray *goodsArray = @[dict1, dict2, dict3];
//    for (NSDictionary *dict in goodsArray) {
//        [printer appendLeftText:dict[@"公司名称"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
//        
//        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
//    }
    
    [printer appendSeperatorLine];
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//    [printer appendTitle:@"起始时间:" value:@"2016.11.27"];
//    [printer appendTitle:@"结束时间:" value:@"2016.11.28"];
//    NSString *leftStr = [NSString stringWithFormat:@"%.2f",100.00 - total];
   // [printer appendTitle:@"找零:" value:leftStr];
    
//    [printer appendSeperatorLine];
    
//    [printer appendText:@"位图方式二维码" alignment:HLTextAlignmentCenter];
//    [printer appendQRCodeWithInfo:@"www.baidu.com"];
//    
//    [printer appendSeperatorLine];
//    [printer appendText:@"指令方式二维码" alignment:HLTextAlignmentCenter];
//    [printer appendQRCodeWithInfo:@"www.baidu.com" size:10];
//
//    [printer appendFooter:nil];
//    [printer appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
    
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    
    UIImage * img = [UIImage imageNamed:@"yellowmen.png"];
    [ViewController imageToTransparent:img printer:printer];
#endif
    
    return printer;
}

- (void)rightAction
{
    //方式一：
    HLPrinter *printer = [self getPrinter];
    
    NSData *mainData = [printer getFinalData];
    
    [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
        NSLog(@"写入结果：%d:%@",completion,error);
    }];
    
    //方式二：
//    [_manager prepareForPrinter];
//    [_manager appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
//    [_manager appendText:str1 alignment:HLTextAlignmentCenter];
////    [_manager appendBarCodeWithInfo:@"RN3456789012"];
//    [_manager appendSeperatorLine];
//    
//    [_manager appendTitle:@"时间:" value:@"2016-04-27 10:01:50" valueOffset:150];
//    [_manager appendTitle:@"订单:" value:@"4000020160427100150" valueOffset:150];
//    [_manager appendText:@"地址:深圳市南山区学府路东深大店" alignment:HLTextAlignmentLeft];
//    
//    [_manager appendSeperatorLine];
//    [_manager appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
//    CGFloat total = 0.0;
//    NSDictionary *dict1 = @{@"name":@"铅笔",@"amount":@"5",@"price":@"2.0"};
//    NSDictionary *dict2 = @{@"name":@"橡皮",@"amount":@"1",@"price":@"1.0"};
//    NSDictionary *dict3 = @{@"name":@"笔记本",@"amount":@"3",@"price":@"3.0"};
//    NSArray *goodsArray = @[dict1, dict2, dict3];
//    for (NSDictionary *dict in goodsArray) {
//        [_manager appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
//        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
//    }
//    
//    [_manager appendSeperatorLine];
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//    [_manager appendTitle:@"总计:" value:totalStr];
//    [_manager appendTitle:@"实收:" value:@"100.00"];
//    NSString *leftStr = [NSString stringWithFormat:@"%.2f",100.00 - total];
//    [_manager appendTitle:@"找零:" value:leftStr];
//    
//    [_manager appendFooter:nil];
//    
////    [_manager appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
//    
//    [_manager printWithResult:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"deviceId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    CBPeripheral *peripherral = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称:%@",peripherral.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    
    [[SEPrinterManager sharedInstance] connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        } else {
            self.title = @"已连接";
            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
        }
    }];
    
    // 如果你需要连接，立刻去打印
//    [[SEPrinterManager sharedInstance] fullOptionPeripheral:peripheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
//        if (stage == SEOptionStageSeekCharacteristics) {
//            HLPrinter *printer = [self getPrinter];
//            
//            NSData *mainData = [printer getFinalData];
//            [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:nil];
//        }
//    }];
}


- (void) imageToTransparent:(UIImage*) image printer:(HLPrinter *)printer
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
                
                if (gray < 127){
                    int idx = y*w_bytes + (x>>3);
                    int off = x & 7;
                    dotsmap[idx] |= 0x80>>off;
                }
            }
        }
        int size = getPrintPictureCommand(NULL, dotsmap, w_bytes * imageHeight, w_bytes);
        BYTE *out = (BYTE *)malloc(size);
        if (out){
            size = getPrintPictureCommand(out, dotsmap, w_bytes * imageHeight, w_bytes);
            
            [printer appendBytes:out length:size];
            
            //bt.write(out, size);        // print bitmap
            
            free(out);
        }
        free(dotsmap);
    }
    
}

@end

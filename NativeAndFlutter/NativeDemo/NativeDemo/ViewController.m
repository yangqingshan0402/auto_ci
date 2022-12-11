//
//  ViewController.m
//  NativeDemo
//
//  Created by hank on 2020/6/17.
//  Copyright © 2020 hank. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()
@property(nonatomic, strong) FlutterEngine* flutterEngine;
@property(nonatomic, strong) FlutterViewController* flutterVc;
@property(nonatomic, strong) FlutterBasicMessageChannel * msgChannel;
@end

@implementation ViewController

- (FlutterEngine *)flutterEngine{
    if (!_flutterEngine) {
        FlutterEngine* flutterEngine = [[FlutterEngine alloc] initWithName:@"hank"];
        if (flutterEngine.run) {
            _flutterEngine = flutterEngine;
        }
    }
    return _flutterEngine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flutterVc = [[FlutterViewController alloc] initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    
    self.msgChannel = [FlutterBasicMessageChannel messageChannelWithName:@"messageChannel" binaryMessenger:self.flutterVc];
    [self.msgChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"收到Flutter的%@",message);
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int a = 0;
    [self.msgChannel sendMessage:[NSString stringWithFormat:@"%d",a++]];
}
 


- (IBAction)pushFlutter:(id)sender {
    //告诉Flutter显示one_page
    FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"one_page" binaryMessenger:self.flutterVc];
    [methodChannel invokeMethod:@"one" arguments:nil];
    self.flutterVc.modalPresentationStyle = UIModalPresentationFullScreen;
    //弹出Flutter页面!
    [self presentViewController:self.flutterVc animated:YES completion:nil];
    //监听Flutter页面的回调
    __weak typeof(self) weakSelf = self;
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //如果是要我退出
        if ([call.method isEqualToString:@"exit"]) {
            [weakSelf.flutterVc dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

- (IBAction)pushFlutterTow:(id)sender {
    //告诉Flutter显示one_page
       FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"tow_page" binaryMessenger:self.flutterVc];
    [methodChannel invokeMethod:@"tow" arguments:nil];
    self.flutterVc.modalPresentationStyle = UIModalPresentationFullScreen;
       //弹出Flutter页面!
       [self presentViewController:self.flutterVc animated:YES completion:nil];
       //监听Flutter页面的回调
    __weak typeof(self) weakSelf = self;
       [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
           //如果是要我退出
           if ([call.method isEqualToString:@"exit"]) {
               [weakSelf.flutterVc dismissViewControllerAnimated:YES completion:nil];
           }
       }];
}

- (void)p{
    FlutterViewController* vc = [FlutterViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}
@end

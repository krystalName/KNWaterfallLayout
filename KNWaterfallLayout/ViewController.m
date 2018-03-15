//
//  ViewController.m
//  KNWaterfallLayout
//
//  Created by 刘凡 on 2018/3/15.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"瀑布流";
    
    [self getWebData];
}


///获取数据
-(void)getWebData{
    
    ///需要utf-8解析
    NSString *urlString = [@"http://image.baidu.com/channel/listjson?pn=0&rn=50&tag1=美女&tag2=全部&ie=utf8" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ///设置请求url
    NSURL *url =[NSURL URLWithString:urlString];
    ///创建request 请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    ///配置request请求
    [request setHTTPMethod:@"GET"];
    ///设置请求超时时间。默认为60s
    [request setTimeoutInterval:30.0];
    ///设置头部参数
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 构造NSURLSessionConfiguration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    ///创建网络会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"get error : %@",error.localizedDescription);
        }else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            ///判断是否解析成功
            if (error) {
                NSLog(@"get error :%@",error.localizedDescription);
            }else {
                /// 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                NSLog(@"get success :%@",object);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面...
                    
                });
            }
        }
        
    }];
    
    ///执行任务
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

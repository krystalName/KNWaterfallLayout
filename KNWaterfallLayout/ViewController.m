//
//  ViewController.m
//  KNWaterfallLayout
//
//  Created by 刘凡 on 2018/3/15.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "CollectionCell.h"
#import "KNCollectionLayout.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>



///view;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)KNCollectionLayout *layout;
///数据dataArray
@property(nonatomic, strong)NSMutableArray  *dataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"瀑布流";

    // 刷新界面...
    [self CreateSubView];
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
              
                NSMutableArray *array = [object[@"data"] mutableCopy];
                                
                for (NSDictionary *dic in array) {
                    Model *model = [Model new];
                    model.ImageURL = dic[@"image_url"];
                    model.ImageTitle = dic[@"abs"];
                    model.ImageHeight = [dic[@"image_height"] floatValue];
                    model.ImageWidth = [dic[@"image_width"] floatValue];
                    ///添加对象
                    [self.dataArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
        
    }];
    ///执行任务
    [task resume];
}

-(void)CreateSubView{
    
    self.layout = [[KNCollectionLayout alloc]init];
    self.layout.lineNumber = 2;//列数
    self.layout.rowSpacing = 5;//行间距
    self.layout.lineSpacing = 5; //列间距
    self.layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:self.layout];
    
    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInsetAdjustmentBehavior = NO;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
    
    
    //返回每个cell的高   对应indexPath
    [self.layout computeindexItemHightWithWidhtBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        
        Model *model = self.dataArray[indexPath.row];
        CGFloat oldWidth = model.ImageWidth;
        CGFloat oldHeight = model.ImageHeight;
        
        CGFloat newWidth = width;
        CGFloat newHeigth = oldHeight * newWidth / oldWidth;
        return newHeigth;
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSLog(@"%ld",self.dataArray.count);
    if (self.dataArray.count > 0) {
        return self.dataArray.count - 1;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *cell =[self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了第%ld个item",indexPath.row);
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

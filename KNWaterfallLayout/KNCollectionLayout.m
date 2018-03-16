//
//  KNCollectionLayout.m
//  KNWaterfallLayout
//
//  Created by 刘凡 on 2018/3/16.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "KNCollectionLayout.h"

@interface KNCollectionLayout()

///存放每列高度字典
@property(nonatomic, strong) NSMutableDictionary *dicOfHeight;

///存放所有item的attrubutes 属性
@property(nonatomic, strong) NSMutableArray *array;

///计算每个item的高度的block
@property(nonatomic, copy) HeightBlock block;

@end

@implementation KNCollectionLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        ///对默认属性进行设置
        self.linNumber = 2;
        self.rowSpacing = 10.0f;
        self.lineSoacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfHeight = [NSMutableDictionary dictionary];
        _array = [NSMutableArray array];
    }
    return self;
}


/**
 准备好布局时调用
 */
-(void)prepareLayout{
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    ///初始化好每列的高度
    for (NSInteger i = 0; i < self.linNumber; i++) {
        [_dicOfHeight setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    //得到每个item的属性进行存储
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}


-(CGSize)collectionViewContentSize
{
    __block NSString *maxHeightline = @"0";
    
    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSNumber * obj, BOOL *  stop) {
        if ([_dicOfHeight[maxHeightline] floatValue] < [obj floatValue]) {
            maxHeightline = key;
        }
    }];
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width, [_dicOfHeight[maxHeightline] floatValue]+ self.sectionInset.bottom);
    
    return size;
}


/**

 @return 返回视图内item的属性，可以直接返回所有的item 属性
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return _array;
}

///计算indexPath下item的属性方法
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ///通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item 宽
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) -(self.linNumber - 1) * self.lineSoacing) / self.linNumber;
    
    //计算item高
    CGFloat itemH = 0.0f;
    if (!self.block) {
        itemH = self.block(indexPath, itemW);
    }else{
        NSAssert(itemH != 0 ,@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    ///计算item的frame
    CGRect frame ;
    frame.size = CGSizeMake(itemW, itemH);
    ///循环遍历找出高度最短行
    __block NSString *lineMinHeight = @"0";
    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj ,BOOL *stop){
        if ([_dicOfHeight[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];
    ///找出最短行后。 计算item位置
    frame.origin = CGPointMake(self.sectionInset.left + line * ( itemW + self.lineSoacing), [_dicOfHeight[lineMinHeight] floatValue]);
    _dicOfHeight[lineMinHeight] = @(frame.size.height + self.rowSpacing + [_dicOfHeight[lineMinHeight] floatValue]);
    att.frame = frame;
    
    return att;
}

///计算高度block方法
-(void)computeindexItemHightWithWidhtBlock:(CGFloat (^)(NSIndexPath *, CGFloat))block
{
    if (!self.block) {
        self.block = block;
    }
}

@end

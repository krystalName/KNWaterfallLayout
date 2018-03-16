//
//  KNCollectionLayout.h
//  KNWaterfallLayout
//
//  Created by 刘凡 on 2018/3/16.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat widht);

@interface KNCollectionLayout : UICollectionViewLayout



 ///列数
@property(nonatomic, assign) NSInteger linNumber;

///行间距
@property(nonatomic, assign) CGFloat rowSpacing;

///列间距
@property(nonatomic, assign) CGFloat lineSoacing;

@property(nonatomic, assign) UIEdgeInsets sectionInset;

/**
 对象方法

 @param block 在block中最后返回一个item的宽度
 */
-(void)computeindexItemHightWithWidhtBlock:(CGFloat(^)(NSIndexPath *indexPath, CGFloat widht))block;

@end

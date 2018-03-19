//
//  CollectionCell.m
//  KNWaterfallLayout
//
//  Created by 刘凡 on 2018/3/19.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "CollectionCell.h"

@interface CollectionCell()

///图片
@property(nonatomic, strong)UIImageView *imageView;

///背景虚化图
@property(nonatomic, strong)UIVisualEffectView *visView;

///图片描叙文字
@property(nonatomic, strong)UILabel *titleLable;

@end

@implementation CollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.visView];
        [self.contentView addSubview:self.titleLable];
    }
    return self;
}


-(void)setModel:(Model *)model
{
    _model = model;
    self.imageView.frame = self.bounds;
    self.visView.frame = CGRectMake(0, self.frame.size.height-16, self.frame.size.width, 16);
    self.titleLable.frame = CGRectMake(0, 3, CGRectGetWidth(self.visView.frame), 10);
    
    ///赋值
    [self.imageView setImage:[self getImageWithUrl:_model.ImageURL]];
    self.titleLable.text = _model.ImageTitle;
}



-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIVisualEffectView *)visView
{
    if (!_visView) {
        _visView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    }
    return _visView;
}

-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = [UIColor redColor];
        _titleLable.font = [UIFont systemFontOfSize:13];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}


///URL切换成图片
-(UIImage *)getImageWithUrl:(NSString *)urlString{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
    
}


@end

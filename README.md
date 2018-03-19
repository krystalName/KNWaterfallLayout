# KNWaterfallLayout
创建瀑布流的小demo  ～。～

### 先上一张gif图片

![](https://github.com/krystalName/KNWaterfallLayout/blob/master/KNWaterfallLayoutGif.gif)

### 主要代码！ 计算每个item 的高度～

```objc

 //通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber;
    CGFloat itemH = 0.0f;
    //计算item高
    if (self.block != nil) {
        
        itemH = self.block(indexPath, itemW);
    } else {
        NSAssert(itemH != 0,@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    //计算item的frame
    CGRect frame;
    frame.size = CGSizeMake(itemW, itemH);
    //循环遍历找出高度最短行
    __block NSString *lineMinHeight = @"0";
    [_dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([_dicOfheight[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];
    //找出最短行后，计算item位置
    frame.origin = CGPointMake(self.sectionInset.left + line * (itemW + self.lineSpacing), [_dicOfheight[lineMinHeight] floatValue]);
    _dicOfheight[lineMinHeight] = @(frame.size.height + self.rowSpacing + [_dicOfheight[lineMinHeight] floatValue]);
    attr.frame = frame;
    
    return attr;
 
```

//
//  JHColumnItem.h
//  JHChartDemo
//
//  Created by 简豪 on 2017/7/3.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHIndexPath;
@class JHColumnItem;
@protocol JHColumnItemActionDelegate <NSObject>

- (void)columnItem:(JHColumnItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath;

@end

@interface JHColumnItem : UIView

@property (nonatomic , strong)NSIndexPath * index;//为兼容老版本所留
@property (nonatomic , strong)JHIndexPath * indexPath;
@property (nonatomic , assign)id<JHColumnItemActionDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame
                   perHeight:(CGFloat)perHeight
                  valueArray:(id)values
                      colors:(id)colors;
@end

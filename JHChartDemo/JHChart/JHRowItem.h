//
//  JHRowItem.h
//  JHChartDemo
//
//  Created by Mayqiyue on 30/11/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHIndexPath;
@class JHRowItem;

@protocol JHRowItemActionDelegate <NSObject>

- (void)rowItem:(JHRowItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath;

@end

@interface JHRowItem : UIView

@property (nonatomic , strong)NSIndexPath * index;//为兼容老版本所留
@property (nonatomic , strong)JHIndexPath * indexPath;
@property (nonatomic , assign)id<JHRowItemActionDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     perWidth:(CGFloat)perWidth
                   valueArray:(id)values
                       colors:(id)colors;

@end

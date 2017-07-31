//
//  JHPieItemsView.h
//  JHCALayer
//
//  Created by 简豪 on 16/4/28.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHPieItemsView;
@protocol JHPieChartDelegate <NSObject>

@optional

- (void)pieChart:(JHPieItemsView *)pieChart animationDidEnd:(BOOL)flag;

@end
@interface JHPieItemsView : UIView

@property (nonatomic , assign)NSTimeInterval animationDuration ;

@property (nonatomic , weak)id<JHPieChartDelegate> delegate;

/**
 *  Each initialization method of pie chart
 *  @param frame:frame
 *  @param beginAngle:Starting angle of cake block
 *  @param endAngle：End angle of cake block
 *  @param fillColor：Fill color for this cake block
 */
- (JHPieItemsView *)initWithFrame:(CGRect)frame
                    andBeginAngle:(CGFloat)beginAngle
                      andEndAngle:(CGFloat)endAngle
                     andFillColor:(UIColor *)fillColor;

- (void)showAnimation;
- (void)itemDidClickWithRediusChange:(CGFloat)length;
@property (nonatomic , assign)BOOL hasClick;

@end

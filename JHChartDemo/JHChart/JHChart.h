//
//  JHChart.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//


/*******************************************
 *
 *
 *
 *   自定义图表绘制 包括折线图 柱状图 饼状图等等
 *
 *
 *
 ********************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define P_M(x,y) CGPointMake(x, y)

@interface JHChart : UIView


/*              图表视图与view的边界值                  */
@property (nonatomic,assign) UIEdgeInsets  contentInsets;



@property (assign, nonatomic)  CGPoint chartOrigin;

- (void)showAnimation;

- (void)clear;
@end

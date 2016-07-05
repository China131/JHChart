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


/*         原点          */
@property (assign, nonatomic)  CGPoint chartOrigin;

/*         表名          */
@property (copy, nonatomic) NSString * chartTitle;
- (void)showAnimation;
- (void)clear;

- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color;

- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize;

- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;

- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)p andContext:(CGContextRef)contex;
- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex;
@end

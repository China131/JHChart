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

#define weakSelf(weakSelf)  __weak typeof(self) weakself = self;

@interface JHChart : UIView


/*              图表视图与view的边界值                  */
@property (nonatomic,assign) UIEdgeInsets  contentInsets;


/*         原点          */
@property (assign, nonatomic)  CGPoint chartOrigin;

/*         表名          */
@property (copy, nonatomic) NSString * chartTitle;

/*        动画开始         */
- (void)showAnimation;

/*        清除当前视图         */
- (void)clear;

/*        绘制线条 从start点 到end点 及是否为曲线  线条颜色         */
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color;

- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize;
- (void)drawText:(NSString *)text context:(CGContextRef )context atPoint:(CGRect )rect WithColor:(UIColor *)color font:(UIFont*)font;
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;

- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)p andContext:(CGContextRef)contex;
- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex;


- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString;
@end

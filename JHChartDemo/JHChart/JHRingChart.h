//
//  JHRingChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChart.h"

/**
 圆环展示样式

 - RingChartType_Default: 默认，有模块指示线百分比
 - RingChartType_BottomTips: 指示线百分比在圆环下方显示
 */
typedef NS_ENUM(NSUInteger, RingChartType) {
    
    RingChartType_Default = 0,
    RingChartType_BottomTips,
    
};


@interface JHRingChart : JHChart
#define k_Width_Scale  (self.frame.size.width / [UIScreen mainScreen].bounds.size.width)


/**
 *  Description of each segment of a pie graph
 */
@property (nonatomic, strong) NSArray * descArr;

/**
  圆环展示样式
 */
@property (nonatomic, assign) RingChartType ringShowType;
/**
 圆环模块间隔， 默认为 10
 */
@property (nonatomic, assign) CGFloat ringItemsSpace;
/**
 *  Data source Array
 */
@property (nonatomic, strong) NSArray * valueDataArr;


/**
 *  An array of colors in the loop graph
 */
@property (nonatomic, strong) NSArray * fillColorArray;


/**
 *  Ring Chart width
 */
@property (nonatomic, assign) CGFloat ringWidth;
@end

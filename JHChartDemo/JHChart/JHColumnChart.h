//
//  JHColumnChart.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@interface JHColumnChart : JHChart


/**
 *  Each histogram of the background color, if you do not set the default value for green. Setup must ensure that the number and type of the data source array are the same, otherwise the default is not set.
 */
@property (nonatomic, strong) NSArray<NSArray *> * columnBGcolorsArr;

/**
 *  Data source array
 */
@property (nonatomic, strong) NSArray<NSArray *> * valueArr;

/**
 *  X axis classification of each icon
 */
@property (nonatomic, strong) NSArray * xShowInfoText;


/**
 *  The background color of the content view
 */
@property (nonatomic, strong) UIColor  * bgVewBackgoundColor;


/**
 *  Column spacing, non continuous, default is 5
 */
@property (nonatomic, assign) CGFloat typeSpace;

/**
 *  The width of the column, the default is 40
 */
@property (nonatomic, assign) CGFloat columnWidth;

/**
 *  Whether the need for Y, X axis, the default YES
 */
@property (nonatomic, assign) BOOL needXandYLine;

/**
 *  Y, X axis line color
 */
@property (nonatomic, strong) UIColor * colorForXYLine;

/**
 *  X, Y axis text description color
 */
@property (nonatomic, strong) UIColor * drawTextColorForX_Y;

/**
 *  Dotted line guide color
 */
@property (nonatomic, strong) UIColor * dashColor;

/**
 *  The starting point, can be understood as the origin of the left and bottom margins
 */
@property (nonatomic, assign) CGPoint originSize;

/**
 *  Starting from the origin of the horizontal distance histogram
 */
@property (nonatomic, assign) CGFloat drawFromOriginX;

/**
 *  Whether this chart show Y line or not .Default is Yes
 */
@property (nonatomic,assign) BOOL isShowYLine;

@end

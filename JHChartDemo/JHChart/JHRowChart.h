//
//  JHRowChart.h
//  JHChartDemo
//
//  Created by Mayqiyue on 30/11/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import "JHChart.h"

@class JHRowItem,JHIndexPath,JHRowChart;
@protocol JHRowChartDelegate<NSObject>

@optional
- (void)rowChart:(JHRowChart *)chart rowItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath; //1.2.0
- (void)rowChart:(JHRowChart *)chart rowItem:(JHRowItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath;//1.2.1
@end

@interface JHRowChart : JHChart

/**
 *  Each histogram of the background color, if you do not set the default value for green. Setup must ensure that the number and type of the data source array are the same, otherwise the default is not set.
 */
@property (nonatomic, strong) NSArray *rowBGcolorsArr;

@property (nonatomic , assign)id <JHRowChartDelegate> delegate;

/**
 *  Data source array
 */
@property (nonatomic, strong) NSArray<NSArray *> *valueArr;

/**
 *  X axis classification of each icon
 */
@property (nonatomic, strong) NSArray *xShowInfoText;

/**
 *  The background color of the content view
 */
@property (nonatomic, strong) UIColor *bgVewBackgoundColor;

/**
 *  Row spacing, non continuous, default is 5
 */
@property (nonatomic, assign) CGFloat rowSpacing;

/**
 *  The height of the Row, the default is 40
 */
@property (nonatomic, assign) CGFloat rowHeight;

/**
 *  Whether the need for Y, X axis, the default YES
 */
@property (nonatomic, assign) BOOL needXandYLine;

/**
 *  Y, X axis line color
 */
@property (nonatomic, strong) UIColor *colorForXYLine;

/**
 *  X, Y axis text description color
 */
@property (nonatomic, strong) UIColor *drawTextColorForX_Y;

/**
 *  Dotted line guide color
 */
@property (nonatomic, strong) UIColor *dashColor;

/**
 *  Whether this chart show Y line or not .Default is Yes
 */
@property (nonatomic,assign) BOOL isShowYLine;

/**
 *  Whether this chart show line or not.Default is NO;
 */
@property (nonatomic,assign) BOOL isShowLineChart;

/**
 *  If isShowLineChart proprety is YES,we need this value array to draw chart
 */
@property (nonatomic,strong)NSArray *lineValueArray;

/**
 *  If isShowLineChart proprety is Yes,we will draw path of this linechart with this color
 *  Default is blue
 */
@property (nonatomic,strong)UIColor *lineChartPathColor;

/**
 *  if isShowLineChart proprety is Yes,we will draw this linechart valuepoint with this color
 *  Default is yellow
 */
@property (nonatomic,strong)UIColor *lineChartValuePointColor;

@end

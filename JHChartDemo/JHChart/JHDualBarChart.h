//
//  JHDualBarChart.h
//  JHChartDemo
//
//  Created by Mayqiyue on 06/12/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import "JHChart.h"

@interface JHDualBarChart : JHChart

/**
 *  Each histogram of the background color, if you do not set the default value for green. Setup must ensure that the number and type of the data source array are the same, otherwise the default is not set.
 */
@property (nonatomic, strong) NSArray <UIColor *>*leftBarBGColors;

@property (nonatomic, strong) NSArray <UIColor *>*rightBarBGColors;

/**
 *  Data source array
 */
@property (nonatomic, strong) NSArray<NSNumber *> *leftBarValues;
@property (nonatomic, strong) NSArray<NSNumber *> *rightBarValues;

/**
 *  X axis classification of each icon
 */
@property (nonatomic, strong) NSArray <NSString *>*xTexts;

@property (nonatomic, assign) CGFloat yLeftRadix;

@property (nonatomic, assign) CGFloat yRightRadix;

/**
 *  X axis classification of each icon
 */
@property (nonatomic, assign) NSUInteger levelLineNum;

@property (nonatomic, copy) UIFont *xTextFont;

@property (nonatomic, copy) UIFont *yleftTextFont;

@property (nonatomic, copy) UIFont *yRightTextFont;

@property (nonatomic, copy) UIFont *barTextFont;

/**
 *  Whether the need for Y, X axis, the default YES
 */
@property (nonatomic, assign) BOOL needXLine;

@property (nonatomic, assign) BOOL needYLines;

@property (nonatomic, assign) BOOL needLeftYTexts;

@property (nonatomic, assign) BOOL needRightYTexts;

@property (nonatomic, assign) CGFloat leftYTextsMargin;

/**
 *  The background color of the content view
 */
@property (nonatomic, strong) UIColor *chartBackgroundColor;

/**
 *  Column spacing, non continuous, default is 15
 */
@property (nonatomic, assign) CGFloat barSpacing;

/**
 *  The width of the column, the default is 40
 */
@property (nonatomic, assign) CGFloat barWidth;

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
@property (nonatomic, strong) UIColor *levelLineColor;

/**
 *  Controls whether text for x-axis be straight or rotate 45 degree.
 */
@property (nonatomic) BOOL rotateForXAxisText;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  If isShowLineChart proprety is YES,we need this value array to draw chart
 */
/**
 *  Whether this chart show line or not.Default is NO;
 */
@property (nonatomic, assign) BOOL isShowLineChart;


@property (nonatomic, strong) NSArray *leftLineValues;

/**
 *  If isShowLineChart proprety is Yes,we will draw path of this linechart with this color
 *  Default is blue
 */
@property (nonatomic, strong) UIColor *leftLinePathColor;

/**
 *  if isShowLineChart proprety is Yes,we will draw this linechart valuepoint with this color
 *  Default is yellow
 */
@property (nonatomic, strong)UIColor *leftLinePointColor;

@property (nonatomic, strong) NSArray *rightLineValues;

/**
 *  If isShowLineChart proprety is Yes,we will draw path of this linechart with this color
 *  Default is blue
 */
@property (nonatomic, strong) UIColor *rightLinePathColor;

/**
 *  if isShowLineChart proprety is Yes,we will draw this linechart valuepoint with this color
 *  Default is yellow
 */
@property (nonatomic, strong)UIColor *rightLinePointColor;


@end

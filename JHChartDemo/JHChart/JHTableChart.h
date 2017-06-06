//
//  JHTableChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//
/************************************************************
 *                                                           *
 *                                                           *
                            表格
 *                                                           *
 *                                                              *
 ************************************************************/


#import "JHChart.h"
@protocol JHTableChartDelegate<NSObject>
@optional
///具体的表格数据填充内容 （不包含表头和属性解释行）
- (UIView *)viewForContentAtRow:(NSInteger)row column:(NSInteger)column subRow:(NSInteger)subRow contentSize:(CGSize)contentSize;
- (UIView *)viewForPropertyAtColumn:(NSInteger)column contentSize:(CGSize)contentSize;
- (UIView *)viewForTableHeaderWithContentSize:(CGSize)contentSize;
@end
@interface JHTableChart : JHChart
/**
 *  Table name, if it is empty, does not display a table name
 */
@property (nonatomic, copy) NSString * tableTitleString;

/**
 *  Table header row height, default 50
 */
@property (nonatomic, assign) CGFloat tableChartTitleItemsHeight;


/**
 *  Table header text font size (default 15), color (default depth)
 */
@property (nonatomic, strong) UIFont * tableTitleFont;
@property (nonatomic, strong) UIColor * tableTitleColor;



/**
 *  Table line color
 */
@property (nonatomic, strong) UIColor  * lineColor;


/**
 *  Data Source Arrays
 */
@property (nonatomic, strong) NSArray * dataArr;


/**
 *  Width of each column
 */
@property (nonatomic, strong) NSArray * colWidthArr;

/**
 *  The smallest line is high, the default is 50
 */
@property (nonatomic, assign) CGFloat minHeightItems;

/**
 *  Table data font , default : [UIFont systemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont * bodyTextFont;

/**
 *  Table data display color
 */
@property (nonatomic, strong) UIColor * bodyTextColor;

/**
 *  Color of each column data, use 'bodyTextColor' instead if you want to display only one color
 */
@property (nonatomic, strong) NSArray * bodyTextColorArr;

/**
 *  The column header font, equals to 'bodyTextFont' if it's set to nil
 */
@property (nonatomic, strong) UIFont * colTitleFont;
/**
 *  The column header name, the first column horizontal statement, need to use | segmentation
 */
@property (nonatomic, strong) NSArray * colTitleArr;

/**
 *  The column header color, use 'bodyTextColor' instead if header and body are the same
 */
@property (nonatomic, strong) UIColor * colTitleColor;

/**
 *  Color of each column header, use 'colTitleColor' instead if you want to display only one color
 */
@property (nonatomic, strong) NSArray * colTitleColorArr;

/**
 *  The column header height, use 'minHeightItems' instead if it's set to 0
 */
@property (nonatomic, assign) CGFloat colTitleHeight;

/**
 *  Anyway, the ranks of name statement, if it is necessary to fill out a two data
 */
@property (nonatomic, strong) NSArray * rowAndColTitleArr;


/**
 *  Offset value of start point
 */
@property (nonatomic, assign) CGFloat beginSpace;

@property (nonatomic , assign)id <JHTableChartDelegate> delegate;

/**
 *  According to the current data source to determine the desired table view
 */
- (CGFloat)heightFromThisDataSource;

@end

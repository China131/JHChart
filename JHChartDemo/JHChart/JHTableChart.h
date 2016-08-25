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

@interface JHTableChart : JHChart


/*--------------------      表格头相关       -----------------------*/

/*        表格名称 如果为空则不显示表格名称         */
@property (nonatomic,copy)NSString * tableTitleString;

/*        表格头的行高 默认50         */
@property (nonatomic,assign) CGFloat tableChartTitleItemsHeight;


/*        表格头字号(默认15) 颜色（默认深度灰）         */
@property (nonatomic,strong)UIFont * tableTitleFont;


@property (nonatomic,strong)UIColor * tableTitleColor;


/*--------------------      <#表格头相关#>       -----------------------*/

/*        表格线条颜色         */
@property (nonatomic,strong)UIColor  * lineColor;

/*        数据源         */
@property (nonatomic,strong)NSArray * dataArr;


/*        每列的宽度         */
@property (nonatomic,strong)NSArray * colWidthArr;

/*        最小的行高 默认为50         */
@property (nonatomic,assign) CGFloat minHeightItems;

/*        表格数据显示颜色         */
@property (nonatomic,strong)UIColor * bodyTextColor;


/*        列头名称 第一个为横竖列声明 需要用|分割        */
@property (nonatomic,strong)NSArray * colTitleArr;

/*        横竖行列名声明 如果需要则填写一到两个数据        */
@property (nonatomic,strong)NSArray * rowAndColTitleArr;


/*        起始点的偏移值         */
@property (nonatomic,assign) CGFloat beginSpace;


/*        根据当前数据源所需要的表格视图高度         */
- (CGFloat)heightFromThisDataSource;

@end

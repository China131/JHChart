//
//  JHScatterChart.h
//  JHChartDemo
//
//  Created by 简豪 on 2016/12/22.
//  Copyright © 2016年 JH. All rights reserved.
//
/**
 *  散点图
 */

#import "JHChart.h"

@interface JHScatterChart : JHChart



/**
 *  散点图数据源
 */
@property (nonatomic,strong)NSArray * valueDataArray;

/**
 *  散点图是否区分等级 默认值 NO
 */
@property (nonatomic,assign) BOOL levelEnable;


/**
 *  等级划分区间数组
 */
@property (nonatomic,strong)NSArray * levelValueArray;


/**
 *  等级颜色数组
 */
@property (nonatomic,strong)NSArray * levelColorArray;


/**
 *  X轴刻度值数组 会均分刻度数组
 */
@property (nonatomic,strong)NSArray * xLineDataArray;

/**
 *  最大半径 默认为15.0
 */
@property (nonatomic,assign) float maxRadius;
@end

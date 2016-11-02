//
//  JHRadarChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/9/9.
//  Copyright © 2016年 JH. All rights reserved.
//

/************************************************************
 *                                                           *
 *                                                           *
                            雷达图
 *                                                           *
 *                                                           *
 ************************************************************/


#import "JHChart.h"

@interface JHRadarChart : JHChart


/*        数据源数据         */
@property (nonatomic,strong)NSArray<NSArray*> * valueDataArray;


/*        描述文字         */
@property (nonatomic,strong)NSArray<NSString *> * valueDescArray;


/*        层的个数 默认为3层         */
@property (nonatomic,assign) NSInteger layerCount;

/*        层的填充颜色 最好选择透明颜色         */
@property (nonatomic,strong)UIColor * layerFillColor;


/*        层的边界线条颜色         */
@property (nonatomic,strong)UIColor * layerBoardColor;

/*        块的分割线颜色         */
@property (nonatomic,strong)UIColor * speraLineColor;

/*        满分值         */
@property (nonatomic,assign) CGFloat perfectNumber;

/*        描述文字字体         */
@property (nonatomic,strong)UIFont * descTextFont;

/*        描述文字颜色         */
@property (nonatomic,strong)UIColor * descTextColor;

/*        值模块的填充颜色数组         */
@property (nonatomic,strong)NSArray<UIColor *> * valueDrawFillColorArray;

/*        值模块的边界颜色         */
@property (nonatomic,strong)NSArray<UIColor *> * valueBoardColorArray;


@end

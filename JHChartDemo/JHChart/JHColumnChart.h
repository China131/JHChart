//
//  JHColumnChart.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@interface JHColumnChart : JHChart


/*        每种柱状图的背景颜色 如果不设置默认值为绿色 设置必须保证数量和数据源数组的类型的个数相同 否则默认为未设置         */
@property (nonatomic,strong) NSArray<NSArray *> * columnBGcolorsArr;

/*        数据源数组 样式参考demo         */
@property (nonatomic,strong) NSArray<NSArray *> * valueArr;

/*        每项图标的X轴分类显示语         */
@property (nonatomic,strong)NSArray * xShowInfoText;


/*        背景颜色         */
@property (nonatomic,strong)UIColor  * bgVewBackgoundColor;

/*        两个柱状图的间距 非连续 默认为5        */
@property (nonatomic,assign) CGFloat typeSpace;

/*        柱状图的宽度 默认为40        */
@property (nonatomic,assign) CGFloat columnWidth;

/*        是否需要X、Y轴 默认YES         */
@property (nonatomic,assign) BOOL needXandYLine;

/*        X、Y轴颜色         */
@property (nonatomic,strong)UIColor * colorForXYLine;

/*        X、Y轴字符颜色         */
@property (nonatomic,strong)UIColor * drawTextColorForX_Y;

/*        虚线颜色         */
@property (nonatomic,strong)UIColor * dashColor;

/*        起点  可以理解为原点左边距和下边距         */
@property (nonatomic,assign) CGPoint originSize;

/*        柱状图起点距原点水平距离         */
@property (nonatomic,assign) CGFloat drawFromOriginX;

@end

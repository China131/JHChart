//
//  JHLineChart.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//
/*******************************************
 *
 *
 *
 *折线图 按象限分为4种
 *
 *
 *
 ********************************************/
#import <UIKit/UIKit.h>
#import "JHChart.h"

/*         折线图数值类型          */
typedef  NS_ENUM(NSInteger,JHLineChartType){
    /*     每一个存在的X点都有一个y坐标对应   此时valueArr的对象类型为数值   只有一个象限   */
    JHChartLineEveryValueForEveryX=0,
    
    /*     点的坐标不一定和坐标轴上的X数值一一对应   此时valueArr的对象类型为点       */
    JHChartLineValueNotForEveryX
    

};



/*        折线图象限分布类型           */
typedef NS_ENUM(NSInteger,JHLineChartQuadrantType){
    
    /*         折线图分布于第一象限          */
    JHLineChartQuadrantTypeFirstQuardrant,
    
    /*         折线图分布于第一二象限          */
    JHLineChartQuadrantTypeFirstAndSecondQuardrant,
    
    /*         折线图分布于第一四象限          */
    JHLineChartQuadrantTypeFirstAndFouthQuardrant,
    
    /*         折线图分布于全局四个象限          */
    JHLineChartQuadrantTypeAllQuardrant
    
    
};



/****************************华丽的分割线***********************************/



@interface JHLineChart :JHChart

/*         折线图的X轴刻度数据 建议使用NSNumber或数字的字符串化                */
@property (nonatomic,strong) NSArray * xLineDataArr;


/*         折线图的Y轴刻度数据 同上                */
@property (nonatomic,strong) NSArray * yLineDataArr;


/*         折线图的点坐标数组 不同类型对应不同数据源  参考上面JHLineChartType       */
@property (nonatomic,strong) NSArray * valueArr;


/*         折线图类型          */
@property (assign , nonatomic) JHLineChartType  lineType ;


/*         折线图象限类型          */
@property (assign, nonatomic) JHLineChartQuadrantType  lineChartQuadrantType;


/*         线条宽度          */
@property (assign, nonatomic) CGFloat lineWidth;


/*         数值线条颜色          */
@property (nonatomic,strong) NSArray * valueLineColorArr;


/*         x y轴线条颜色          */
@property (nonatomic,strong) UIColor * xAndYLineColor;


/*         点的颜色          */
@property (nonatomic,strong) NSArray * pointColorArr;


/*         x,y轴刻度值颜色          */
@property (nonatomic,strong) UIColor * xAndYNumberColor;


/*         点的引导虚线颜色          */
@property (nonatomic,strong) NSArray * positionLineColorArr;


/*         坐标点数值颜色          */
@property (nonatomic,strong) NSArray * pointNumberColorArr;

/*         是否需要点          */
@property (assign, nonatomic) BOOL hasPoint;




/**
 *  重写初始化方法
 *
 *  @param frame         frame
 *  @param lineChartType 折线图类型
 *
 *  @return 自定义折线图
 */
-(instancetype)initWithFrame:(CGRect)frame andLineChartType:(JHLineChartType)lineChartType;



@end

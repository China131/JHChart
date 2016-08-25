//
//  JHShowController.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/12.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHShowController.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface JHShowController ()

@end

@implementation JHShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    switch (_index) {
        case 0:
        {
            [self showFirstQuardrant];
        }
            break;
        case 1:
        {
            [self showFirstAndSecondQuardrant];
            
        }
            break;
        case 2:
        {
            [self showFirstAndFouthQuardrant];
        }
            break;
        case 3:
        {
            [self showAllQuardrant];
        }
            break;
        case 4:
        {
            [self showPieChartUpView];
        }
            break;
        case 5:
        {
            [self showRingChartView];
        }
            break;
        case 6:
        {
            [self showColumnView];
        }break;
            case 7:
        {
            [self showTableView];
        }break;
        default:
            break;
    }
    
    
    
}


//第一象限折线图
- (void)showFirstQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    lineChart.xLineDataArr = @[@"0",@"1",@"2",@3,@4,@5,@6,@7];
    
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    /* 数据源 */
    lineChart.valueArr = @[@[@"1",@"2",@"1",@6,@4,@9,@6,@7]];
    
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor greenColor];
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];
    
    /* 坐标点的虚线颜色 */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    [self.view addSubview:lineChart];
    [lineChart showAnimation];
}


//第一二象限
- (void)showFirstAndSecondQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndSecondQuardrant;
    lineChart.valueArr = @[@[@"5",@"2",@"7",@4,@25,@15,@6],@[@"1",@"2",@"1",@6,@4,@9,@7]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor greenColor];
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];
 
    [self.view addSubview:lineChart];
    
    [lineChart showAnimation];
    
    /* 清除折线图内容 */
//    [lineChart clear];
}

//第一四象限
- (void)showFirstAndFouthQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"0",@"1",@"2",@3,@4,@5,@6,@7];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = @[@[@"5",@"-22",@"7",@(-4),@25,@15,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor greenColor];
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];

    [self.view addSubview:lineChart];
    [lineChart showAnimation];
}


/**
 *  折线图全象限
 */
- (void)showAllQuardrant{
    
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    lineChart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeAllQuardrant;
      lineChart.valueArr = @[@[@"5",@"-22",@"7",@(-4),@25,@15,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor greenColor];
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];

    [self.view addSubview:lineChart];
    [lineChart showAnimation];
}


/**
 *  饼状图
 */
- (void)showPieChartUpView{
    

    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(100, 100, 321, 421)];
    pie.center = CGPointMake(CGRectGetMaxX(self.view.frame)/2, CGRectGetMaxY(self.view.frame)/2);
    
    /* 饼状图数值 会自动根据数值计算百分比 */
    pie.valueArr = @[@18,@10,@25,@40,@18,@10,@25,@40,@18,@10,@15,@12,@30,@18];
    
    /* 每一个扇形区的描述 必须要填 并且数量必须和饼状图数值个数相同 */
    pie.descArr = @[@"第一个元素",@"第二个元素",@"第三个元素",@"第四个元素",@"5",@"6",@"7",@"8",@"9",@"10",@"23",@"12",@"21",@"30"];
    pie.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pie];
    pie.positionChangeLengthWhenClick = 15;
    [pie showAnimation];
}


//环状图
- (void)showRingChartView{
    
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    ring.backgroundColor = [UIColor blackColor];
    ring.valueDataArr = @[@"0.5",@"5",@"2",@"10",@"6"];
    [ring showAnimation];
    [self.view addSubview:ring];
    
}

//柱状图
- (void)showColumnView{
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    column.valueArr = @[
                        @[@12,@15,@20],
                         @[@22,@15,@20],
                         @[@12,@5,@40],
                         @[@2,@15,@20]
                        
                        ];
    column.originSize = CGPointMake(30, 30);
    column.drawFromOriginX = 10;
    column.columnWidth = 40;
    column.drawTextColorForX_Y = [UIColor greenColor];
    column.colorForXYLine = [UIColor greenColor];
    column.columnBGcolorsArr = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
    column.xShowInfoText = @[@"第一组",@"第二组",@"第三组",@"第四组"];
    [column showAnimation];
    [self.view addSubview:column];

}



/**
 *  创建表格视图
 */
- (void)showTableView{
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(10, 64, k_MainBoundsWidth-20, k_MainBoundsHeight)];
    table.tableTitleString = @"全选jeep自由光";

    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量"];
    table.colWidthArr = @[@100.0,@120.0,@70,@100];
    table.bodyTextColor = [UIColor redColor];
    table.minHeightItems = 40;
    table.lineColor = [UIColor orangeColor];
    table.dataArr = @[
                      @[@"2.4L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"]],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"]],
                      @[@"2.4豪华版",@[@"4",@"3",@"2"]],
                      @[@"2.4旗舰版"]
                      ];
    [table showAnimation];
    [self.view addSubview:table];
    
    table.frame = CGRectMake(10, 64, k_MainBoundsWidth-20, [table heightFromThisDataSource]);
    
}


























@end

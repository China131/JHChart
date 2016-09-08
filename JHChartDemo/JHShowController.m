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
    /*        创建表对象         */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    lineChart.xLineDataArr = @[@"0",@"1",@"2",@3,@4,@5,@6,@7];
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    /* 数据源 */
    lineChart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7],@[@"3",@"1",@"2",@16,@2,@3,@5,@10]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];
    /* 坐标点的虚线颜色 */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        设置是否填充内容 默认为否         */
    lineChart.contentFill = YES;
    /*        设置为曲线路径         */
    lineChart.pathCurve = YES;
    
    /*        设置填充颜色数组         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0.500 green:0.000 blue:0.500 alpha:0.468],[UIColor colorWithRed:0.500 green:0.214 blue:0.098 alpha:0.468]];
    [self.view addSubview:lineChart];
    /*        开始动画         */
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
    
    /*        设置是否填充内容         */
    lineChart.contentFill = YES;
    
    /*        设置曲线路径         */
    lineChart.pathCurve = YES;
    
    /*        填充颜色数组         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:0.002 blue:0.832 alpha:0.472]];
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
    
    lineChart.contentFill = YES;
    
    lineChart.pathCurve = YES;
    
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:0.002 blue:0.832 alpha:0.472]];
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
    /*        触碰某块饼图时动画偏移值         */
    pie.positionChangeLengthWhenClick = 15;
    /*        动画展示         */
    [pie showAnimation];
}


//环状图
- (void)showRingChartView{
    /*        创建对象         */
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    /*        背景颜色         */
    ring.backgroundColor = [UIColor blackColor];
    /*        数据源数组 只需要传入值 相应的比例会自动计算         */
    ring.valueDataArr = @[@"0.5",@"5",@"2",@"10",@"6"];
    /*        环图的宽度         */
    ring.ringWidth = 35.0;
    /*        每段环图的填充颜色         */
    ring.fillColorArray = @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]];
    /*        动画展示         */
    [ring showAnimation];
    [self.view addSubview:ring];
    
}

//柱状图
- (void)showColumnView{
    /*        创建对象         */
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    /*        创建数据源数组 每个数组即为一个模块数据 例如第一个数组可以表示某个班级的不同科目的平均成绩 下一个数组表示另外一个班级的不同科目的平均成绩         */
    column.valueArr = @[
                         @[@12,@15,@20],
                         @[@22,@15,@20],
                         @[@12,@5,@40],
                         @[@2,@15,@20]
                        ];
    /*       该点 表示原点距左下角的距离         */
    column.originSize = CGPointMake(30, 30);
    
    /*        第一个柱状图距原点的距离         */
    column.drawFromOriginX = 10;
    /*        柱状图的宽度         */
    column.columnWidth = 40;
    /*        X、Y轴字体颜色         */
    column.drawTextColorForX_Y = [UIColor greenColor];
    /*        X、Y轴线条颜色         */
    column.colorForXYLine = [UIColor greenColor];
    /*        每个模块的颜色数组 例如A班级的语文成绩颜色为红色 数学成绩颜色为绿色         */
    column.columnBGcolorsArr = @[[UIColor redColor],[UIColor greenColor],[UIColor orangeColor]];
    /*        模块的提示语         */
    column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级"];
    /*        开始动画         */
    [column showAnimation];
    [self.view addSubview:column];

}





/**
 *  创建表格视图
 */
- (void)showTableView{
    /*        创建对象         */
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(10, 64, k_MainBoundsWidth-20, k_MainBoundsHeight)];
    /*        表名称         */
    table.tableTitleString = @"全选jeep自由光";
    /*        每一列的声明 其中第一个如果需要分别显示行和列的说明 可以用‘|’分割行和列         */
    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量"];
    /*        列的宽度数组 从第一列开始         */
    table.colWidthArr = @[@100.0,@120.0,@70,@100];
    /*        表格体的文字颜色         */
    table.bodyTextColor = [UIColor redColor];
    /*        最小的方格高度         */
    table.minHeightItems = 40;
    /*        表格的线条颜色         */
    table.lineColor = [UIColor orangeColor];
    /*        数据源数组 按照从上到下表示每行的数据 如果其中一行中某列存在多个单元格 可以再存入一个数组中表示         */
    table.dataArr = @[
                      @[@"2.4L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"]],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"]],
                      @[@"2.4豪华版",@[@"4",@"3",@"2"]],
                      @[@"2.4旗舰版"]
                      ];
    /*        显示 无动画效果         */
    [table showAnimation];
    [self.view addSubview:table];
    /*        设置表格的布局 其中 [table heightFromThisDataSource] 为自动按照当前数据源计算所需高度        */
    table.frame = CGRectMake(10, 64, k_MainBoundsWidth-20, [table heightFromThisDataSource]);
    
}


























@end

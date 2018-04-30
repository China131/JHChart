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
@interface JHShowController ()<JHColumnChartDelegate,JHTableChartDelegate>

@property (nonatomic, strong)JHLineChart * lineChart;

@end

@implementation JHShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    switch (_index) {
        case 0:
        {
            [self addBtn];
            [self showFirstWithIndex:0];
            
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
            [self showRingChart];
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
            case 8:
        {
            [self showRadarChartView];
        }break;
            case 9:
        {
            [self showScatterChart];
        }break;
        default:
            break;
    }
    
    
    
}
NSArray * xLineDatas() {
    return @[
             @[@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16"],
             @[@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月"]
             ];
}
NSArray * valueDatas() {
    
    return @[
             @[@[@"10",@"22",@"1",@6,@4,@9,@6,@7]],
             @[@[@"20",@"12",@"30",@6,@14,@9,@3,@30]]
             ];
}
- (void)addBtn {
    
    NSArray * titles = @[@"周",@"月"];
    CGFloat width = (CGRectGetWidth(self.view.frame) - 20)/2 ;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10 + i * width, 500, width, 30);
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
- (void)changeBtnClick:(UIButton *)btn {
    
    
    [self showFirstWithIndex:btn.tag - 1];
    
}
- (JHLineChart *)lineChart {
    
    if (!_lineChart) {
        _lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 60, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
        [self.view addSubview:_lineChart];
    }
    return _lineChart;
}
- (void)showFirstWithIndex:(NSInteger)index {
    /*     Create object        */
//    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 60, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    JHLineChart * lineChart = self.lineChart;
    
    [lineChart clear];
    
    // x 轴坐标显示 yLineDataArr
    lineChart.xLineDataArr = xLineDatas()[index];
    // 偏移量
    lineChart.contentInsets = UIEdgeInsetsMake(50, 25, 35, 25);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    // 分布象限
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    // 需要绘制的数据（对应每个 x 点坐标的 y 值）
    lineChart.valueArr = valueDatas()[index];
    //    lineChart.valueBaseRightYLineArray = @[@[@"3",@"1",@"2",@1,@2,@3,@2,@5]];
    
    // 绘制线条宽度
    lineChart.animationPathWidth = 1;
    // 是否显示绘制点
    lineChart.hasPoint = YES;
    // 显示 y轴水平线
    lineChart.showYLevelLine = YES;
    // 是否显示 Y 轴，默认为 YES
    lineChart.showYLine = YES;
    
    // 是否显示 双 Y 轴
    lineChart.showDoubleYLevelLine = NO;
    
    // Y 轴显示对应的坐标值 单 y 轴时，无需填写
    //    lineChart.yLineDataArr = @[@[@5,@10,@15,@20,@25,@30],@[@1,@2,@3,@4,@5,@6]];
    
    //    lineChart.yLineDataArr = @[@5,@10,@15,@20,@25,@30];
    //    lineChart.drawPathFromXIndex = 1;
    
    // 动画绘制时间
    lineChart.animationDuration = 2.0;
    // 是否显示标尺线
    lineChart.showValueLeadingLine = NO;
    // 标尺线是否为 虚线
    lineChart.leavelLineIsDotted = NO;
    // 点值字号大小
    lineChart.valueFontSize = 9.0;
    lineChart.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:49 / 255.0 blue:100 / 255.0 alpha:1.0];
    
    // 显示点值 描述
    lineChart.showPointDescription = YES;
    
    // 垂直显示 X轴 坐标（此时布局为 UILabel）
    lineChart.showXDescVertical = NO;
    // 垂直显示是的最大宽度
    lineChart.xDescMaxWidth = 15;
    
    /* 折线颜色 */
    lineChart.valueLineColorArr =@[ [UIColor colorWithWhite:0.8 alpha:0.5]];
    /* 描点颜色*/
    lineChart.pointColorArr = @[[UIColor redColor]];
    /* XY 轴线颜色 */
    lineChart.xAndYLineColor = [UIColor grayColor];
    /* XY 轴线坐标颜色 */
    lineChart.xAndYNumberColor = [UIColor whiteColor];
//    /* Dotted line color of the coordinate point */
//    lineChart.positionLineColorArr = @[[UIColor whiteColor]];
    /* 是否需要颜色填充 */
    lineChart.contentFill = YES;
    /* 是否为曲线 */
    lineChart.pathCurve = YES;
    /* 填充色 */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:55/255.0 green:90/255.0 blue:150/255.0 alpha:0.5]];
//    [self.view addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
    
}
//第一象限折线图
- (void)showFirstQuardrant{
    /*     Create object        */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 60, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    lineChart.xLineDataArr = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 25);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    lineChart.valueArr = @[@[@"0",@"12",@"1",@6,@4,@9,@6,@7]];
    lineChart.valueBaseRightYLineArray = @[@[@"3",@"1",@"2",@1,@2,@3,@2,@5]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    lineChart.yLineDataArr = @[@[@5,@10,@15,@20,@25,@30],@[@1,@2,@3,@4,@5,@6]];
//    lineChart.yLineDataArr = @[@5,@10,@15,@20,@25,@30];
//    lineChart.drawPathFromXIndex = 1;
    lineChart.animationDuration = 2.0;
    lineChart.showDoubleYLevelLine = YES;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 9.0;
    lineChart.backgroundColor = [UIColor whiteColor];
    lineChart.showPointDescription = NO;
    lineChart.showXDescVertical = YES;
    lineChart.xDescMaxWidth = 15;
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ [UIColor greenColor], [UIColor orangeColor]];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = NO;
    /*        Set whether the curve path         */
    lineChart.pathCurve = YES;
    /*        Set fill color array         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.view addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
}


//第一二象限
- (void)showFirstAndSecondQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 50, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndSecondQuardrant;
    lineChart.valueArr = @[@[@"5",@"2",@"7",@4,@25,@15,@6],@[@"1",@"2",@"1",@6,@4,@9,@7]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    lineChart.showXDescVertical = YES;
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.showYLevelLine = YES;
    lineChart.showValueLeadingLine = NO;
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart.valueFontSize = 9.0;
    
    lineChart.showYLevelLine = YES;

 
    [self.view addSubview:lineChart];
    
    /*        设置是否填充内容         */
    lineChart.contentFill = YES;
    
    /*        设置曲线路径         */
    lineChart.pathCurve = YES;
    
    /*        填充颜色数组         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
    [lineChart showAnimation];
    
    /* 清除折线图内容 */
//    [lineChart clear];
}

//第一四象限
- (void)showFirstAndFouthQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 54, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = @[@[@"5",@"-220",@"170",@(-4),@25,@5,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];
    lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
    lineChart.valueFontSize = 9.0;
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    lineChart.showPointDescription = NO;
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    lineChart.showXDescVertical = YES;
    lineChart.xDescMaxWidth = 15.0;
    /*        是否展示Y轴分层线条 默认否        */
    lineChart.showYLevelLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    //从下标为1的点开始绘制 默认从下标为0的点开始绘制
    lineChart.drawPathFromXIndex = 1;
    lineChart.contentInsets = UIEdgeInsetsMake(10, 30, 5, 10);
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.backgroundColor = [UIColor whiteColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    
    lineChart.contentFill = YES;
    
    lineChart.pathCurve = YES;
    
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
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
      lineChart.valueArr = @[@[@"5",@"-22",@"70",@(-4),@25,@15,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];    /* 值折线的折线颜色 默认暗黑色*/
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
    pie.backgroundColor = [UIColor greenColor];
    pie.center = CGPointMake(CGRectGetMaxX(self.view.frame)/2, CGRectGetMaxY(self.view.frame)/2);
    /* Pie chart value, will automatically according to the percentage of numerical calculation */
    pie.valueArr = @[@18,@14,@25,@40,@18,@18,@25,@40];
    /* The description of each sector must be filled, and the number must be the same as the pie chart. */
    pie.descArr = @[@"第一个元素",@"第二个元素",@"第三个元素",@"第四个元素",@"5",@"6",@"7",@"8"];
//    pie.backgroundColor = [UIColor whiteColor];
    pie.didClickType = JHPieChartDidClickTranslateToBig;
    pie.animationDuration = 1.0;
    [self.view addSubview:pie];
    /*    When touching a pie chart, the animation offset value     */
    pie.positionChangeLengthWhenClick = 15;
    pie.showDescripotion = YES;
    pie.animationType = JHPieChartAnimationByOrder;
//    pie.colorArr = @[[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor yellowColor]];
    /*        Start animation         */
    [pie showAnimation];
    
}

//环状图
- (void)showRingChart{
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    /*        background color         */
    ring.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:49 / 255.0 blue:100 / 255.0 alpha:1.0];
    /*        Data source array, only the incoming value, the corresponding ratio will be automatically calculated         */
    ring.ringItemsSpace = 0;
    ring.ringShowType = RingChartType_BottomTips;
    ring.ringScore = @"100分";
    // 顺时针排序
    ring.valueDataArr = @[@"27",@"20",@"53"];

    ring.descArr = @[@"浅眠",@"中度",@"深度"];
    /*         Width of ring graph        */
    ring.ringWidth = 35.0;
    /*        Fill color for each section of the ring diagram         */
    ring.fillColorArray = @[[UIColor colorWithRed:25/255.0 green:203/255.0 blue:168/255.0 alpha:1.0], [UIColor colorWithRed:4/255.0 green:145/255.0 blue:240/255.0 alpha:1.0],[UIColor colorWithRed:175/255.0 green:161/255.0 blue:110/255.0 alpha:1.0]];
    /*        Start animation             */
    [ring showAnimation];
    [self.view addSubview:ring];
    
}
//环状图
- (void)showRingChartView{
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    /*        background color         */
    ring.backgroundColor = [UIColor whiteColor];
    /*        Data source array, only the incoming value, the corresponding ratio will be automatically calculated         */
    ring.valueDataArr = @[@"0.5",@"5",@"2",@"10",@"6",@"6"];
    /*         Width of ring graph        */
    ring.ringWidth = 35.0;
    /*        Fill color for each section of the ring diagram         */
    ring.fillColorArray = @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]];
    /*        Start animation             */
    [ring showAnimation];
    [self.view addSubview:ring];
   
}

//柱状图
- (void)showColumnView{
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 64, k_MainBoundsWidth, 320)];
    /*        Create an array of data sources, each array is a module data. For example, the first array can represent the average score of a class of different subjects, the next array represents the average score of different subjects in another class        */
    column.valueArr = @[
                        @[@[@15,@10]],//第一组元素 如果有多个元素，往该组添加，每一组只有一个元素，表示是单列柱状图| | | | |
                        @[@[@15,@20]],//第二组元素
                        @[@[@10,@5]],//第三组元素
                        @[@[@21,@12]],
                        @[@19],
                        @[@12],
                        @[@15],
                        @[@9],
                        @[@8],
                        @[@6],
                        @[@9],
                        @[@18],
                        @[@11],
                        ];
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(30, 20);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 20;
    column.backgroundColor = [UIColor yellowColor];
    column.typeSpace = 10;
    column.isShowYLine = NO;
    column.contentInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    /*        Column width         */
    column.columnWidth = 30;
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor yellowColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    column.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    column.columnBGcolorsArr = @[@[[UIColor redColor],[UIColor greenColor]],@[[UIColor redColor],[UIColor greenColor]],@[[UIColor redColor],[UIColor greenColor]]];//如果为复合型柱状图 即每个柱状图分段 需要传入如上颜色数组 达到同时指定复合型柱状图分段颜色的效果
    /*        Module prompt         */
    column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级",@"E班级",@"F班级",@"G班级",@"H班级",@"i班级",@"J班级",@"L班级",@"M班级",@"N班级"];
    column.isShowLineChart = YES;
    column.lineValueArray =  @[
                               @6,
                               @12,
                               @10,
                               @1,
                               @9,
                               @5,
                               @9,
                               @9,
                               @5,
                               @6,
                               @4,
                               @8,
                               @11
                               ];

    column.delegate = self;
    /*       Start animation        */
    [column showAnimation];
    [self.view addSubview:column];
}

/**
 *  创建表格视图
 */
- (void)showTableView{
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(10, 84, k_MainBoundsWidth-20, k_MainBoundsHeight)];
    /*       Table name         */
//    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
//    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"",@"",@"",@"",@"",@""];
    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"专业评价"];
    /*        The width of the column array, starting with the first column         */
    table.colWidthArr = @[@80.0,@100.0,@70,@40,@100];
//    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
//    table.beginSpace = 30;
    UIColor *textColor = [UIColor redColor];
    /*        Text color of the table body         */
    table.bodyTextColor = textColor;
    
    table.bodyTextFont = [UIFont systemFontOfSize:5];
    /*        Text color for every column         */
    table.bodyTextColorArr = @[textColor,textColor,textColor,textColor,[UIColor blueColor]];
    /*        Minimum grid height         */
    table.minHeightItems = 35;
    /*        The height of the column title*/
    table.colTitleHeight = 80;
    /*        Text color of the column title*/
    table.colTitleColor = [UIColor grayColor];
    /*        Font of the column title*/
    table.colTitleFont = [UIFont systemFontOfSize:15];
    /*        Text color for every column title        */
//    table.colTitleColorArr = @[textColor,textColor,textColor,textColor,[UIColor greenColor]];
    /*        Font of the table body*/
//    table.bodyTextFont = [UIFont systemFontOfSize:14];
    /*        Table line color         */
    table.lineColor = [UIColor orangeColor];
    table.tableTitleString = @"库存";
    table.backgroundColor = [UIColor whiteColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    table.dataArr = @[
                      @[@"2.4L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"],@"价格十分优惠，相信市场会非常好"],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"],@"性价比还不错，内部配置较为不错，值得入手"]                      ];
    table.delegate = self;
    /*        show                            */
    [table showAnimation];
    [self.view addSubview:table];
    
    /*        Automatic calculation table height        */
    table.frame = CGRectMake(10, 64, k_MainBoundsWidth-20, [table heightFromThisDataSource]);
    
    [table clear];
    table.dataArr = @[
                      @[@"2.0L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"],@"价格十分优惠，相信市场会非常好"],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"],@"性价比还不错，内部配置较为不错，值得入手"]                      ];
    [table showAnimation];
}


- (void)showRadarChartView{
    
    
    JHRadarChart *radarChart = [[JHRadarChart alloc] initWithFrame:CGRectMake(10, 74, k_MainBoundsWidth - 20, k_MainBoundsWidth - 20)];
    radarChart.backgroundColor = [UIColor whiteColor];
    /*       Each point of the description text, according to the number of the array to determine the number of basic modules         */
    radarChart.valueDescArray = @[@"击杀",@"能力",@"生存",@"推塔",@"补兵",@"其他"];
    
    /*         Number of basic module layers        */
    radarChart.layerCount = 5;
    
    /*        Array of data sources, the need to add an array of arrays         */
    radarChart.valueDataArray = @[@[@"80",@"40",@"100",@"76",@"75",@"50"],@[@"50",@"80",@"30",@"46",@"35",@"50"]];
    
    /*        Color of each basic module layer         */
    radarChart.layerFillColor = [UIColor colorWithRed:94/ 256.0 green:187/256.0 blue:242 / 256.0 alpha:0.5];
    
    /*        The fill color of the value module is required to specify the color for each value module         */
    radarChart.valueDrawFillColorArray = @[[UIColor colorWithRed:57/ 256.0 green:137/256.0 blue:21 / 256.0 alpha:0.5],[UIColor colorWithRed:149/ 256.0 green:68/256.0 blue:68 / 256.0 alpha:0.5]];
    
    /*       show        */
    [radarChart showAnimation];
    
    [self.view addSubview:radarChart];
    
}





- (void)showScatterChart{
    
    /*        创建对象         */
    JHScatterChart *scatterChart = [[JHScatterChart alloc] initWithFrame:CGRectMake(0, 64, k_MainBoundsWidth, 320)];
    
    /*        X轴刻度值         */
    scatterChart.xLineDataArray = @[@0,@1,@2,@3,@4,@5];
    
    /*        点的数组         */
    scatterChart.valueDataArray = @[
                                    [NSValue valueWithCGPoint:P_M(0, 1)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 5.7)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 5)],
                                    [NSValue valueWithCGPoint:P_M(0.7, 5)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.2, 9)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5,4)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 2)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8.3)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 5.3)],
                                    [NSValue valueWithCGPoint:P_M(2, 3)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5)],
                                    [NSValue valueWithCGPoint:P_M(2, 11)],
                                    [NSValue valueWithCGPoint:P_M(6, 15)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(1, 1)],
                                    [NSValue valueWithCGPoint:P_M(2.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(3.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(4, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(1.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 6.5)],
                                    [NSValue valueWithCGPoint:P_M(2.2,4)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 9.8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]  ,
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 14)],
                                    [NSValue valueWithCGPoint:P_M(0.9, 2)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 12.7)],
                                    [NSValue valueWithCGPoint:P_M(0.1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2.3)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 2.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(1.4, 3)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.3, 1.3)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 1.8)],
                                    [NSValue valueWithCGPoint:P_M(1.7, 1.4)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)],
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 11)],
                                    [NSValue valueWithCGPoint:P_M(0.8, 15)],
                                    [NSValue valueWithCGPoint:P_M(4, 3)],
                                    [NSValue valueWithCGPoint:P_M(5, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]];
    scatterChart.contentInsets = UIEdgeInsetsMake(10, 40, 20, 10);
    [scatterChart showAnimation];
    [self.view addSubview:scatterChart];
}


-(void)columnChart:(JHColumnChart*)chart columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

-(void)columnChart:(JHColumnChart*)chart columnItem:(JHColumnItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

-(UIView *)tableChart:(JHTableChart*)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column subRow:(NSInteger)subRow contentSize:(CGSize)contentSize{
    
    if (1) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        vi.backgroundColor = [UIColor greenColor];
        return vi;
    }
    return nil;
}

-(UIView *)tableChart:(JHTableChart*)chart viewForPropertyAtColumn:(NSInteger)column contentSize:(CGSize)contentSize{
    if (1) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        vi.backgroundColor = [UIColor greenColor];
        return vi;
    }
    return nil;
}

-(UIView *)tableChart:(JHTableChart*)chart viewForTableHeaderWithContentSize:(CGSize)contentSize{
    
//    return nil;
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    vi.backgroundColor = [UIColor greenColor];
    return vi;
}











@end

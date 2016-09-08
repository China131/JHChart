//
//  JHRingChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@interface JHRingChart : JHChart
#define k_Width_Scale  (self.frame.size.width / [UIScreen mainScreen].bounds.size.width)
/*        值数组         */
@property (nonatomic,strong)NSArray * valueDataArr;


/*        环图的颜色数组         */
@property (nonatomic,strong)NSArray * fillColorArray;


/*        环的宽度         */
@property (nonatomic,assign) CGFloat ringWidth;
@end

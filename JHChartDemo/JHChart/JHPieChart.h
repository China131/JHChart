//
//  JHPieChart.h
//  JHCALayer
//
//  Created by 简豪 on 16/5/3.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChart.h"
typedef  NS_ENUM(NSInteger,JHPieChartAnimationType){
    JHPieChartAnimationNormalType = 0,//Default
    JHPieChartAnimationByOrder = 1
};

@interface JHPieChart : JHChart

/**
 *  Need to draw the specific values。Elements can be either NSString or NSNumber type
 */
@property (nonatomic, strong) NSArray * valueArr;


/**
 *  Description of each segment of a pie graph
 */
@property (nonatomic, strong) NSArray * descArr;


/**
 *  An array of colors for each section of the pie
 */
@property (nonatomic, strong) NSArray * colorArr;


/**
 *  The length of the outward shift when the pie chart hits
 */
@property (assign , nonatomic) CGFloat positionChangeLengthWhenClick;


/**
 *  whether this chart show the description or not,default is YES.
 */
@property (nonatomic,assign) BOOL showDescripotion;

@property (nonatomic , assign)JHPieChartAnimationType animationType;
@end

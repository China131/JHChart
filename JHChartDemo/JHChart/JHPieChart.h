//
//  JHPieChart.h
//  JHCALayer
//
//  Created by cjatech-简豪 on 16/5/3.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChart.h"
@interface JHPieChart : JHChart


@property (nonatomic,strong) NSArray * valueArr;

@property (nonatomic,strong) NSArray * descArr;


@property (nonatomic,strong) NSArray * colorArr;

@property (assign , nonatomic) CGFloat  positionChangeLengthWhenClick ;




@end

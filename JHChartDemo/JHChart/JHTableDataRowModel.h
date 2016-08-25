//
//  JHTableDataRowModel.h
//  JHChartDemo
//
//  Created by 简豪 on 16/8/25.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JHTableDataRowModel : NSObject

/*        该模型中最多的一列数量         */
@property (nonatomic,assign) NSInteger maxCount;


/*        数据源         */
@property (nonatomic,strong) NSArray * dataArr;



@end

//
//  JHIndexPath.h
//  JHChartDemo
//
//  Created by 简豪 on 2017/7/3.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHIndexPath : NSObject
@property (nonatomic , assign)int section;
@property (nonatomic , assign)int row;
@property (nonatomic , assign)NSInteger index;

+ (instancetype)indexPathWithSection:(int)section row:(int)row index:(NSInteger)index;

- (instancetype)initIndexPathWithSection:(int)section row:(int)row index:(NSInteger)index;

@end

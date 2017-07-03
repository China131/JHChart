//
//  JHIndexPath.m
//  JHChartDemo
//
//  Created by 简豪 on 2017/7/3.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "JHIndexPath.h"

@implementation JHIndexPath
+ (instancetype)indexPathWithSection:(int)section row:(int)row index:(NSInteger)index{
    JHIndexPath *path = [[[self class] alloc] initIndexPathWithSection:section row:row index:index];
    return path;
}

- (instancetype)initIndexPathWithSection:(int)section row:(int)row index:(NSInteger)index{
    if (self = [super init]) {
        self.section = section;
        self.row = row;
        self.index = index;
    }
    return self;
}
@end

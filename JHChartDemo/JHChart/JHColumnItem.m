//
//  JHColumnItem.m
//  JHChartDemo
//
//  Created by 简豪 on 2017/7/3.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "JHColumnItem.h"
#import "JHIndexPath.h"
@interface JHColumnItem ()

@property(nonatomic,strong)NSArray *valueArray;

@property (nonatomic , strong)id colors;

@property (nonatomic , assign)CGFloat perHeight;

@end

@implementation JHColumnItem

-(instancetype)initWithFrame:(CGRect)frame perHeight:(CGFloat)perHeight valueArray:(id)values colors:(id)colors{
    if (self = [super initWithFrame:frame]) {
        if ([values isKindOfClass:[NSArray class]]) {
            _valueArray = values;
            _colors = colors;
            _perHeight = perHeight;
            [self configBaseView];
        }else{
            self.backgroundColor = colors;
            self.tag = 0 ;
            [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemsClick:)]];

        }
    }
    return self;
}


- (void)configBaseView{
    UIView *last = nil;
    for (int i = 0; i < _valueArray.count; i++) {
        UIView *item = [[UIView alloc] init];
        CGFloat heigth = [NSString stringWithFormat:@"%@",_valueArray[i]].floatValue * _perHeight;
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemsClick:)]];
        item.tag = i;
        if (!last) {
            item.frame = CGRectMake(0, CGRectGetHeight(self.frame) - heigth, CGRectGetWidth(self.frame), heigth);
        }else{
            item.frame = CGRectMake(0, CGRectGetHeight(self.frame) - heigth - CGRectGetHeight(last.frame), CGRectGetWidth(self.frame), heigth);
        }
        last = item;
        item.backgroundColor = _colors[i];
        [self addSubview:item];
    }
}

- (void)itemsClick:(UITapGestureRecognizer *)sender{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(columnItem:didClickAtIndexPath:)]) {
            JHIndexPath *index = [JHIndexPath indexPathWithSection:self.indexPath.section row:self.indexPath.row index:sender.view.tag];
            [_delegate columnItem:self didClickAtIndexPath:index];
        }
    }
}
@end

//
//  JHRowItem.m
//  JHChartDemo
//
//  Created by Mayqiyue on 30/11/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import "JHRowItem.h"
#import "JHIndexPath.h"

@interface JHRowItem()
@property(nonatomic,strong)NSArray *valueArray;

@property (nonatomic , strong)id colors;

@property (nonatomic , assign)CGFloat perWidth;

@end

@implementation JHRowItem

-(instancetype)initWithFrame:(CGRect)frame perWidth:(CGFloat)perWidth valueArray:(id)values colors:(id)colors {
    if (self = [super initWithFrame:frame]) {
        if ([values isKindOfClass:[NSArray class]]) {
            _valueArray = values;
            _colors = colors;
            _perWidth = perWidth;
            [self configBaseView];
        }else{
            self.backgroundColor = colors;
            self.tag = 0 ;
            [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemsClick:)]];
            
        }
    }
    return self;
}


- (void)configBaseView {
    UIView *last = nil;
    for (int i = 0; i < _valueArray.count; i++) {
        UIView *item = [[UIView alloc] init];
        CGFloat width = [NSString stringWithFormat:@"%@",_valueArray[i]].floatValue * _perWidth;
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemsClick:)]];
        item.tag = i;
        if (!last) {
            item.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
        }
        else {
            item.frame = CGRectMake(CGRectGetMaxX(last.frame), 0, width, CGRectGetHeight(self.frame));
        }
        last = item;
        item.backgroundColor = _colors[i];
        [self addSubview:item];
    }
}

- (void)itemsClick:(UITapGestureRecognizer *)sender{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(rowItem:didClickAtIndexPath:)]) {
            JHIndexPath *index = [JHIndexPath indexPathWithSection:self.indexPath.section row:self.indexPath.row index:sender.view.tag];
            [_delegate rowItem:self didClickAtIndexPath:index];
        }
    }
}
@end


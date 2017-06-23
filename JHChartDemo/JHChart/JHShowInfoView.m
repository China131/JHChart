//
//  JHShowInfoView.m
//  JHChartDemo
//
//  Created by 简豪 on 16/5/4.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHShowInfoView.h"


@interface JHShowInfoView ()


@property (nonatomic,strong) UILabel * bgLabel;

@end


@implementation JHShowInfoView


-(instancetype)init{
    
    if (self = [super init]) {
        self.layer.borderWidth  = 2;
        self.layer.cornerRadius = 5;
        self.clipsToBounds      = YES;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    
    return self;
    
}


-(void)setShowContentString:(NSString *)showContentString{
    
    
    _showContentString = showContentString;
    CGSize size = [showContentString boundingRectWithSize:CGSizeMake(50, 100) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor darkGrayColor]} context:nil].size;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+10, 30);
    
    if (_bgLabel==nil) {
        
        _bgLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _bgLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _bgLabel.backgroundColor = [UIColor clearColor];
        _bgLabel.font = [UIFont systemFontOfSize:8];
        _bgLabel.textColor = [UIColor blackColor];
        _bgLabel.numberOfLines = 2;
        [self addSubview:_bgLabel];
        
    }
    _bgLabel.frame = CGRectMake(0, 0, size.width, size.height);
    _bgLabel.text = _showContentString;
    _bgLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
}

-(void)updateFrameTo:(CGRect)frame andBGColor:(UIColor *)bgColor andShowContentString:(NSString *)contentString{
    self.showContentString = contentString;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.borderColor = bgColor.CGColor;

        self.center = CGPointMake(frame.origin.x, frame.origin.y);
        
    } completion:^(BOOL finished) {
        
    }];
    
}



@end

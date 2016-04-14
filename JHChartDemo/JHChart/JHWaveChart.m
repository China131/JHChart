//
//  JHWaveChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/13.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHWaveChart.h"

@interface JHWaveChart()


@property (nonatomic,strong) NSArray * yLineDataArr;
@property (assign , nonatomic) JHWaveChartType  waveChartType ;
@property (assign , nonatomic) CGFloat  perXLength ;
@property (assign , nonatomic) CGFloat  xLength ;
@property (assign , nonatomic) CGFloat  yLength ;
@property (assign , nonatomic) CGPoint  originPoint ;
@end


@implementation JHWaveChart


-(instancetype)initWithFrame:(CGRect)frame andType:(JHWaveChartType)waveChartType{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _waveChartType = waveChartType;
        _xLineDataArr = @[@0,@1,@2,@3,@4,@5,@6,@7];
        _xAndYLineColor = [UIColor darkGrayColor];
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    return self;
}




- (void)countPerXandPerYLength{
    _xLength = CGRectGetWidth(self.frame) - self.contentInsets.left - self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame) - self.contentInsets.top - self.contentInsets.bottom;
    
    if (_xLineDataArr.count) {
        _perXLength = _xLength/(_xLineDataArr.count-1);
    }
    
    switch (_waveChartType) {
        case JHWaveChartUpType:
        {
            _originPoint = P_M(self.contentInsets.left, CGRectGetHeight(self.frame) - self.contentInsets.bottom);
            
        }
            break;
        case JHWaveChartUpAndDownType:
        {
            
        }
            break;
        default:
            break;
    }
    
    
}


- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self countPerXandPerYLength];
    if (_xLineDataArr.count) {
        /* 绘制X轴 */
        [self drawXLineWithContext:context];
        
    }
    
    
}

/**
 *  绘制X轴
 *
 */
- (void)drawXLineWithContext:(CGContextRef)contex{
    
    [self drawLineWithContext:contex andStarPoint:P_M(self.contentInsets.left, CGRectGetHeight(self.frame)-self.contentInsets.bottom) andEndPoint:P_M(CGRectGetWidth(self.frame)-self.contentInsets.right, CGRectGetHeight(self.frame)-self.contentInsets.bottom) andIsDottedLine:NO andColor:_xAndYLineColor];
    
    for (NSInteger i =0 ; i<_xLineDataArr.count ; i++) {
        
        [self drawLineWithContext:contex andStarPoint:P_M(i*_perXLength, _originPoint.y) andEndPoint:P_M(i*_perXLength, _originPoint.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
        CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
        [self drawText:_xLineDataArr[i] andContext:contex atPoint:P_M(i*_perXLength-len/2+_originPoint.x, _originPoint.y+5) WithColor:_xAndYLineColor];
        
    }
    
}

-(void)setValueDataArr:(NSArray *)valueDataArr{
    
    
    _valueDataArr = valueDataArr;
    
    [self setNeedsDisplay];
    
}


@end

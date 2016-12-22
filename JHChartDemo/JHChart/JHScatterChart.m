//
//  JHScatterChart.m
//  JHChartDemo
//
//  Created by 简豪 on 2016/12/22.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHScatterChart.h"

@interface JHScatterChart()

@property (nonatomic , assign)int32_t maxY;

@property (nonatomic,assign) float perY;

@property (nonatomic,assign) float perX;
@property (nonatomic,assign) float drawHeight;

@property (nonatomic,assign) float drawWidth;

@property (nonatomic,assign) float valuePerX;
@end

@implementation JHScatterChart


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _maxY = 0;
        _perY = 0;
        self.maxRadius = 15.0f;
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}


- (void)updatePerY{

    
    self.chartOrigin = P_M(self.contentInsets.left, CGRectGetHeight(self.frame) - self.contentInsets.bottom);
    if (_valueDataArray.count == 0) {
        return;
    }
    
    for (NSValue * value in _valueDataArray) {
        
        CGPoint p = value.CGPointValue;
        
        float s = p.y;
        if (s>_maxY) {
            _maxY = s;
        }
        
    }
    
    if (_maxY %5 != 0) {
        
        if (_maxY < 5) {
            _maxY = 5;
        }else if (_maxY<10){
            _maxY = 10;
        }else{
            _maxY += 5;
        }
        
    }
    _drawHeight = CGRectGetHeight(self.frame) - self.contentInsets.top - self.contentInsets.bottom -10;
    _perY = _drawHeight / _maxY;
    
    _drawWidth = CGRectGetWidth(self.frame) - self.chartOrigin.x - self.contentInsets.right;
    
    _perX = (_drawWidth - 10)/(_xLineDataArray.count-1);
    
    
    [self setNeedsDisplay];
}


-(void)setValueDataArray:(NSArray *)valueDataArray{
    
    _valueDataArray = valueDataArray;
    
    if (_valueDataArray.count == 0) {
        return;
    }
    
    
    
    
    
}

-(void)clear{
    
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*        绘制Y轴         */
    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x, self.contentInsets.top) andIsDottedLine:NO andColor:[UIColor blackColor]];
   
    /*        绘制刻度及文字         */
    for (int32_t i = 0; i<7; i++) {
        
        CGPoint drawP = P_M(self.chartOrigin.x , self.chartOrigin.y - _drawHeight * i / 6);
        [self drawLineWithContext:context andStarPoint:drawP andEndPoint:P_M(drawP.x - 3, drawP.y ) andIsDottedLine:NO andColor:[UIColor blackColor]];
        NSString *drawText = [NSString stringWithFormat:@"%0.1f",_maxY / 6.0 * i];
        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_perX, 30) textFont:self.xDescTextFontSize aimString:drawText];
        [self drawText:drawText andContext:context atPoint:P_M(drawP.x - size.width - 3, drawP.y -size.height / 2) WithColor:self.xAndYLineColor andFontSize:self.xDescTextFontSize];
        
    }
    
    
    
    /*        绘制X轴         */
    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x + self.drawWidth, self.chartOrigin.y ) andIsDottedLine:NO andColor:self.xAndYLineColor];
    
    
    /*        绘制刻度及文字         */
    for (int32_t i = 0; i<_xLineDataArray.count; i++) {
        CGPoint drawP = P_M(self.chartOrigin.x + i * _perX, self.chartOrigin.y);
        [self drawLineWithContext:context andStarPoint:drawP andEndPoint:P_M(drawP.x, drawP.y - 3) andIsDottedLine:NO andColor:[UIColor blackColor]];
        NSString *drawText = [NSString stringWithFormat:@"%@",_xLineDataArray[i]];
        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_perX, 30) textFont:self.xDescTextFontSize aimString:drawText];
        [self drawText:drawText andContext:context atPoint:P_M(drawP.x - size.width / 2, drawP.y + 5) WithColor:self.xAndYLineColor andFontSize:self.xDescTextFontSize];
        
        if (i == _xLineDataArray.count - 1) {
            
            _valuePerX = (_drawWidth - 10)/[_xLineDataArray[i] floatValue];
            
        }
        
    }
}


-(void)showAnimation{
    [self updatePerY];
    
    _valuePerX = (_drawWidth - 10)/[[_xLineDataArray lastObject] floatValue];
    
    
    for (NSValue *value in _valueDataArray) {
        CGPoint p = value.CGPointValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:P_M(p.x * _valuePerX + self.chartOrigin.x, self.chartOrigin.y - p.y * _perY) radius:p.y / _maxY * _maxRadius startAngle:M_PI endAngle:M_PI + 2 * M_PI clockwise:YES];
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.frame = CGRectMake(0, 0, 30, 30);
        shaper.path = path.CGPath;
        shaper.fillColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:shaper];
        
        
    }
    
    
    
    
    
    
    
    
}



@end

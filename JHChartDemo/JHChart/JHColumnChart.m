//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"

@interface JHColumnChart ()

//背景图
@property (nonatomic,strong)UIScrollView *BGScrollView;

//峰值
@property (nonatomic,assign) CGFloat maxHeight;

//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;

@property (nonatomic,assign) CGFloat perHeight;
@end

@implementation JHColumnChart


-(NSMutableArray *)showViewArr{
    
    
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    
    return _showViewArr;
    
}

-(NSMutableArray *)layerArr{
    
    
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    
    return _layerArr;
}


-(UIScrollView *)BGScrollView{
    
    
    if (!_BGScrollView) {

        _BGScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
        _bgVewBackgoundColor = _bgVewBackgoundColor;
        [self addSubview:_BGScrollView];
        
    }
    
    return _BGScrollView;
    
    
}


-(void)setBgVewBackgoundColor:(UIColor *)bgVewBackgoundColor{
    
    _bgVewBackgoundColor = bgVewBackgoundColor;
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
}


-(NSMutableArray *)yLineDataArr{
    
    
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {

        _needXandYLine = YES;
        _isShowYLine = YES;
    }
    return self;
    
}


-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    
    
    _valueArr = valueArr;
    CGFloat max = 0;
 
    for (NSArray *arr in _valueArr) {
        
        for (id number in arr) {
            
            CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
            if (currentNumber>max) {
                max = currentNumber;
            }
            
        }

    }
    
    if (max<5.0) {
        _maxHeight = 5.0;
    }else if(max<10){
        _maxHeight = 10;
    }else{
        _maxHeight = max;
    }
    
    _maxHeight += 4;
    _perHeight = (CGRectGetHeight(self.frame) - 30 - _originSize.y)/_maxHeight;
    
    
}


-(void)showAnimation{

    [self clear];
    
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + _typeSpace + 40;
    self.BGScrollView.contentSize = CGSizeMake(_maxWidth, 0);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        if (self.isShowYLine) {
            [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
             [bezier addLineToPoint:P_M(self.originSize.x, 20)];
        }
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
    
        [bezier addLineToPoint:P_M(_maxWidth , CGRectGetHeight(self.frame) - self.originSize.y)];
        
        
        layer.path = bezier.CGPath;
        
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = self.isShowYLine?1.5:0.75;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
        
//        _maxHeight += 4;
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<5; i++) {
            NSInteger pace = (_maxHeight) / 5;
            CGFloat height = _perHeight * (i+1)*pace;
            [second moveToPoint:P_M(_originSize.x, CGRectGetHeight(self.frame) - _originSize.y -height)];
            [second addLineToPoint:P_M(_maxWidth, CGRectGetHeight(self.frame) - _originSize.y - height)];
            
            
            
            CATextLayer *textLayer = [CATextLayer layer];
            
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            NSString *text =[NSString stringWithFormat:@"%ld",(i + 1) * pace];
            CGFloat be = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:text].width;
            textLayer.frame = CGRectMake(self.originSize.x - be - 3, CGRectGetHeight(self.frame) - _originSize.y -height - 5, be, 15);
            
            UIFont *font = [UIFont systemFontOfSize:self.yDescTextFontSize];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = text;
            
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];

        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = second.CGPath;
        
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor darkGrayColor].CGColor):_dashColor.CGColor);
        
        shapeLayer.lineWidth = 0.5;
        
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic2.duration = 1.5;
        
        basic2.fromValue = @(0);
        
        basic2.toValue = @(1);
        
        basic2.autoreverses = NO;
        
        
        
        basic2.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:basic2 forKey:nil];
        
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
    }
    
    
    

    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    if (_xShowInfoText.count == _valueArr.count&&_xShowInfoText.count>0) {
        
        NSInteger count = [_valueArr[0] count];
        
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            

            
            CATextLayer *textLayer = [CATextLayer layer];
            
            CGFloat wid =  count * _columnWidth;
            
            
            
            CGSize size = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xDescTextFontSize]} context:nil].size;
            
            textLayer.frame = CGRectMake( i * (count * _columnWidth + _typeSpace) + _typeSpace + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
            textLayer.string = _xShowInfoText[i];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont systemFontOfSize:self.xDescTextFontSize];
            

            
            textLayer.fontSize = font.pointSize;
            
            textLayer.foregroundColor = _drawTextColorForX_Y.CGColor;
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            
            [_BGScrollView.layer addSublayer:textLayer];
            
            [self.layerArr addObject:textLayer];
            
            
        }
        
        
    }
    
    
    
    
    
    
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        
        
        NSArray *arr = _valueArr[i];

        for (NSInteger j = 0; j<arr.count; j++) {
            

            CGFloat height =[arr[j] floatValue] *_perHeight;
            

            UIView *itemsView = [UIView new];
            [self.showViewArr addObject:itemsView];
            itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - _originSize.y-1, _columnWidth, 0);
            NSLog(@"%@",NSStringFromCGRect(itemsView.frame));
            itemsView.backgroundColor = (UIColor *)(_columnBGcolorsArr.count<arr.count?[UIColor greenColor]:_columnBGcolorsArr[j]);
            [UIView animateWithDuration:1 animations:^{
                
                 itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, height);
                
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    
                    CATextLayer *textLayer = [CATextLayer layer];
                    
                    [self.layerArr addObject:textLayer];
                    NSString *str = [NSString stringWithFormat:@"%@",arr[j]];
                    
                    CGSize size = [str boundingRectWithSize:CGSizeMake(_columnWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
                    
                    textLayer.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - height - _originSize.y -3 - size.height, _columnWidth, size.height);
                    
                    textLayer.string = str;
                    
                    textLayer.fontSize = 9.0;
                    
                    textLayer.alignmentMode = kCAAlignmentCenter;
                    textLayer.contentsScale = [UIScreen mainScreen].scale;
                    textLayer.foregroundColor = itemsView.backgroundColor.CGColor;
                    
                    [_BGScrollView.layer addSublayer:textLayer];
                    
                }
                
            }];
            
            [self.BGScrollView addSubview:itemsView];
            

        }
        
    }
    
    
    
    
    
}


-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
}









@end

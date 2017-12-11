//
//  JHRowChart.m
//  JHChartDemo
//
//  Created by Mayqiyue on 30/11/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import "JHRowChart.h"
#import <objc/runtime.h>
#import "JHRowItem.h"

@interface JHRowChart ()<CAAnimationDelegate, JHRowItemActionDelegate>

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

@property (nonatomic,assign) CGFloat perWidth;

@property (nonatomic , strong) NSMutableArray * drawLineValue;
@end

@implementation JHRowChart

-(NSMutableArray *)drawLineValue{
    if (!_drawLineValue) {
        _drawLineValue = [NSMutableArray array];
    }
    return _drawLineValue;
}

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
        _BGScrollView.backgroundColor = _bgVewBackgoundColor;
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
        _lineChartPathColor = [UIColor blueColor];
        _lineChartValuePointColor = [UIColor yellowColor];
    }
    return self;
}

-(void)setLineValueArray:(NSArray *)lineValueArray{
    if (!_isShowLineChart) {
        return;
    }
    
    _lineValueArray = lineValueArray;
    CGFloat max = 0;
    
    for (id number in _lineValueArray) {
        CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
        max = MAX(max, currentNumber);
    }
    
    if (max<5.0) {
        max = 5.0;
    } else if(max<10){
        max = 10;
    }
    max += 4;
    _maxWidth = MAX(_maxWidth, max);
    
    _perWidth = (CGRectGetWidth(self.frame) - 30 - _originSize.x - self.contentInsets.right)/_maxWidth;
}

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    _valueArr = valueArr;
    CGFloat max = 0;
    
    for (NSArray *arr in _valueArr) {
        CGFloat total= 0;
        for (NSNumber *number in arr) {
            total += number.floatValue;
        }
        max = MAX(total, max);
    }
    
    if (max<5.0) {
        max = 5.0;
    }
    else if(max<10) {
        max = 10;
    }
    max += 4;
    
    _maxWidth = MAX(_maxWidth, max);
    _perWidth = (CGRectGetWidth(self.frame) - 30 - _originSize.x)/_maxWidth;
}

-(void)showAnimation{
    
    [self clear];
    
    _rowHeight = (_rowHeight<=0?30:_rowHeight);
    _rowSpacing = (_rowSpacing<=0?15:_rowSpacing);
    _maxHeight = _originSize.y + _valueArr.count * _rowHeight + (_valueArr.count +1) * _rowSpacing + 10;
    self.BGScrollView.contentSize = CGSizeMake(_maxWidth, _maxHeight);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        if (self.isShowYLine) {
            [bezier moveToPoint:_originSize];
            [bezier addLineToPoint:P_M(G_W(self.frame), _originSize.y)];
        }
        [bezier moveToPoint:_originSize];
        [bezier addLineToPoint:P_M(self.originSize.x, _maxHeight)];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezier.CGPath;
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basic.duration = self.isShowYLine?1.5:0.75;
        basic.fromValue = @(0);
        basic.toValue = @(1);
        basic.autoreverses = NO;
        basic.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:basic forKey:nil];
        [self.layerArr addObject:layer];
        [self.BGScrollView.layer addSublayer:layer];
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<5; i++) {
            NSInteger pace = (_maxWidth) / 5;
            CGFloat width = _perWidth * (i+1)*pace;
            [second moveToPoint:P_M(_originSize.x + width, _originSize.y)];
            [second addLineToPoint:P_M(_originSize.x + width, _maxHeight)];
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            NSString *text =[NSString stringWithFormat:@"%zd",(i + 1) * pace];
            CGSize size = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:text];
            textLayer.frame = CGRectMake(_originSize.x + width - size.width/2.0, 0, _originSize.y - size.height/2.0, size.height);
            
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
    
    if (_xShowInfoText.count == _valueArr.count&&_xShowInfoText.count>0) {
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, _rowHeight)
                                                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xDescTextFontSize]}
                                                              context:nil];
            textLayer.position = P_M(_originSize.x - textLayer.frame.size.width/2.0 -5, _originSize.y + (i + 1) * (_rowHeight + _rowSpacing) - 0.5 * _rowHeight);
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
    for (NSInteger j = 0; j<_valueArr.count; j++) {
        NSArray *arr = _valueArr[j];
        
        NSArray *colors = nil;
        CGFloat width = 0;
        for (NSNumber *num in arr) {
            width += num.floatValue;
        }
        if (j >= _rowBGcolorsArr.count) {
            colors = _rowBGcolorsArr.lastObject;
        }
        else {
            colors = _rowBGcolorsArr[j];
        }

        JHRowItem *itemsView = [[JHRowItem alloc] initWithFrame:CGRectMake(_originSize.x+1, _originSize.y + (_rowSpacing + _rowHeight) *j, width * _perWidth, _rowHeight)
                                                       perWidth:_perWidth
                                                     valueArray:arr
                                                         colors:colors];
        itemsView.clipsToBounds = YES;
        itemsView.delegate = self;
        [self.showViewArr addObject:itemsView];
        itemsView.frame = CGRectMake(_originSize.x+1, _originSize.y + _rowSpacing + (_rowSpacing + _rowHeight) *j, 0, _rowHeight);
        
        if (_isShowLineChart) {
            NSString *value = [NSString stringWithFormat:@"%@",_lineValueArray[j]];
            NSValue *lineValue = [NSValue valueWithCGPoint:P_M(_originSize.x+_perWidth *value.floatValue, itemsView.center.y)];
            [self.drawLineValue addObject:lineValue];
        }
        [self.BGScrollView addSubview:itemsView];
        
        [UIView animateWithDuration:1 animations:^{
            itemsView.frame = CGRectMake(_originSize.x+1, _originSize.y + _rowSpacing + (_rowSpacing + _rowHeight) * j, width * _perWidth, _rowHeight);
        } completion:^(BOOL finished) {
            /*        动画结束后添加提示文字         */
            if (finished) {
                
                CATextLayer *textLayer = [CATextLayer layer];
                
                [self.layerArr addObject:textLayer];
                NSString *str = [NSString stringWithFormat:@"%0.2f", width];
                
                CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
                                                options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]}
                                                context:nil].size;
                textLayer.frame = CGRectMake(CGRectGetMaxX(itemsView.frame), CGRectGetMidY(itemsView.frame)-size.height/2.0f, size.width, size.height);
                textLayer.string = str;
                textLayer.fontSize = 9.0;
                textLayer.alignmentMode = kCAAlignmentCenter;
                textLayer.contentsScale = [UIScreen mainScreen].scale;
                textLayer.foregroundColor = itemsView.backgroundColor.CGColor;

                [_BGScrollView.layer addSublayer:textLayer];
                
                //添加折线图
                if (j==_valueArr.count - 1 && _isShowLineChart) {
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    
                    for (int32_t m=0;m<_lineValueArray.count;m++) {
                        NSLog(@"%@",_drawLineValue[m]);
                        if (m==0) {
                            [path moveToPoint:[_drawLineValue[m] CGPointValue]];
                            
                        }else{
                            [path addLineToPoint:[_drawLineValue[m] CGPointValue]];
                            [path moveToPoint:[_drawLineValue[m] CGPointValue]];
                        }
                        
                    }
                    
                    CAShapeLayer *shaper = [CAShapeLayer layer];
                    shaper.path = path.CGPath;
                    shaper.frame = self.bounds;
                    shaper.lineWidth = 2.5;
                    shaper.strokeColor = _lineChartPathColor.CGColor;
                    
                    [self.layerArr addObject:shaper];
                    
                    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                    
                    basic.fromValue = @0;
                    basic.toValue = @1;
                    basic.duration = 1;
                    basic.delegate = self;
                    [shaper addAnimation:basic forKey:@"stokentoend"];
                    [self.BGScrollView.layer addSublayer:shaper];
                }
            }
        }];
    }
}

- (void)itemClick:(UITapGestureRecognizer *)sender{
//    if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexRow:)]) {
//        [_delegate columnChart:self columnItem:sender.view didClickAtIndexRow:objc_getAssociatedObject(sender.view, "indexPath")];
//    }
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

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if (flag) {
        
        if (_isShowLineChart) {
            
            
            for (int32_t m=0;m<_lineValueArray.count;m++) {
                NSLog(@"%@",_drawLineValue[m]);
                
                
                
                CAShapeLayer *roundLayer = [CAShapeLayer layer];
                UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:[_drawLineValue[m] CGPointValue] radius:4.5 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI * 2 clockwise:YES];
                roundLayer.path = roundPath.CGPath;
                roundLayer.fillColor = _lineChartValuePointColor.CGColor;
                [self.layerArr addObject:roundLayer];
                [self.BGScrollView.layer addSublayer:roundLayer];
                
                
            }
        }
    }
}

-(void)rowItem:(JHRowItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(rowChart:rowItem:didClickAtIndexRow:)]) {
            [_delegate rowChart:self rowItem:item didClickAtIndexPath:indexPath];
        }
        
        if ([_delegate respondsToSelector:@selector(rowChart:rowItem:didClickAtIndexRow:)]) {
            [_delegate rowChart:self rowItem:item didClickAtIndexRow:item.index];
        }
    }
}
@end


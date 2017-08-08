//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"
#import <objc/runtime.h>
#import "JHColumnItem.h"
@interface JHColumnChart ()<CAAnimationDelegate,JHColumnItemActionDelegate>

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

@property (nonatomic , strong) NSMutableArray * drawLineValue;
@end

@implementation JHColumnChart

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
    CGFloat max = _maxHeight;
    
    for (id number in _lineValueArray) {
        
        CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
        if (currentNumber>max) {
            max = currentNumber;
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

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    
    
    _valueArr = valueArr;
    CGFloat max = 0;
 
    for (NSArray *arr in _valueArr) {
        
        for (id number in arr) {
            CGFloat currentNumber = 0;

            if ([number isKindOfClass:[NSArray class]]) {
                for (id sub in number) {
                    currentNumber += [NSString stringWithFormat:@"%@",sub].floatValue;
                };
            }else{
                currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
            }
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
    _perHeight = (CGRectGetHeight(self.frame) - 30 - _originSize.y - self.contentInsets.top)/_maxHeight;
    
    
}


-(void)showAnimation{

    [self clear];
    
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + _typeSpace + 40 + _drawFromOriginX;
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
            
            textLayer.frame = CGRectMake( i * (count * _columnWidth + _typeSpace) + _typeSpace + _originSize.x+ _drawFromOriginX, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
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
            CGFloat height = 0;
            id colors = nil;
            if ([arr[j] isKindOfClass:[NSArray class]]) {
                NSAssert([_columnBGcolorsArr[j]isKindOfClass:[NSArray class]] &&_columnBGcolorsArr.count >= arr.count , @"when current columnItem is  component，you must offer a NSArray type for item's color");
                colors = _columnBGcolorsArr[j];
                for (id obj in arr[j]) {
                    height += [obj floatValue];
                }
                height = height * _perHeight;
            }else{
                height =[arr[j] floatValue] *_perHeight;
                colors = (_columnBGcolorsArr.count<arr.count?[UIColor greenColor]:_columnBGcolorsArr[j]);
                if ([colors isKindOfClass:[NSArray class]] && [colors count] > 0) {
                    colors = colors[0];
                }
            }
            JHColumnItem *itemsView = [[JHColumnItem alloc] initWithFrame:CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, height) perHeight:_perHeight valueArray:arr[j] colors:colors];
            itemsView.clipsToBounds = YES;
            itemsView.delegate = self;
            NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
            itemsView.index = path;
            [self.showViewArr addObject:itemsView];
            itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace + _drawFromOriginX, CGRectGetHeight(self.frame) - _originSize.y-1, _columnWidth, 0);

            if (_isShowLineChart) {
                NSString *value = [NSString stringWithFormat:@"%@",_lineValueArray[i]];
                float valueFloat =[value floatValue];
                NSValue *lineValue = [NSValue valueWithCGPoint:P_M(CGRectGetMaxX(itemsView.frame) - _columnWidth / 2, CGRectGetHeight(self.frame) - valueFloat * _perHeight - _originSize.y -1)];
                [self.drawLineValue addObject:lineValue];
            }
            [self.BGScrollView addSubview:itemsView];

            [UIView animateWithDuration:1 animations:^{
                
                 itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace + _drawFromOriginX, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, height);
                
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    
                    CATextLayer *textLayer = [CATextLayer layer];
                    
                    [self.layerArr addObject:textLayer];
                    NSString *str = [NSString stringWithFormat:@"%0.2f",height / _perHeight];
                    
                    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
                    
                    textLayer.frame = CGRectMake(CGRectGetMinX(itemsView.frame), CGRectGetMinY(itemsView.frame) - size.height - 5,size.width, size.height);
                    CGPoint center = textLayer.position;
                    center.x = itemsView.center.x;
                    textLayer.position = center;
                    textLayer.string = str;
                    
                    textLayer.fontSize = 9.0;
                    
                    textLayer.alignmentMode = kCAAlignmentCenter;
                    textLayer.contentsScale = [UIScreen mainScreen].scale;
                    textLayer.foregroundColor = itemsView.backgroundColor.CGColor;
                    
                    [_BGScrollView.layer addSublayer:textLayer];
                 
                    
                    //添加折线图
                    if (i==_valueArr.count - 1&&j == arr.count-1 && _isShowLineChart) {
                        
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
}

- (void)itemClick:(UITapGestureRecognizer *)sender{
    if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexRow:)]) {
        [_delegate columnChart:self columnItem:sender.view didClickAtIndexRow:objc_getAssociatedObject(sender.view, "indexPath")];
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


-(void)columnItem:(JHColumnItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexPath:)]) {
            [_delegate columnChart:self columnItem:item didClickAtIndexPath:indexPath];
        }
        
        if ([_delegate respondsToSelector:@selector(columnChart:columnItem:didClickAtIndexRow:)]) {
            [_delegate columnChart:self columnItem:item didClickAtIndexRow:item.index];
        }
    }
}






@end

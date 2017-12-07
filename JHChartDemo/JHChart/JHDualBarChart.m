//
//  JHDualBarChart.m
//  JHChartDemo
//
//  Created by Mayqiyue on 06/12/2017.
//  Copyright © 2017 JH. All rights reserved.
//

#import "JHDualBarChart.h"
@interface JHDualBarChart () <CAAnimationDelegate>
{
    CGFloat _maxH, _maxW, lPerH, rPerH;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *leftBarViews;
@property (nonatomic, strong) NSMutableArray *rightBarViews;
@property (nonatomic, strong) NSMutableArray *layerArr;

@property (nonatomic, strong) NSMutableArray *drawLineValue;

@end

@implementation JHDualBarChart

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    _needYLines = YES;
    _needXLine = YES;
    _needLeftYTexts = YES;
    _needRightYTexts = YES;
    _leftYTextsMargin = 5;
    _xTextFont = [UIFont systemFontOfSize:8];
    _yRightTextFont = [UIFont systemFontOfSize:8];
    _yleftTextFont = [UIFont systemFontOfSize:8];
    _barTextFont = [UIFont systemFontOfSize:8];
    _yDetailTextFont = [UIFont systemFontOfSize:10];
    _chartSubTitleFont = [UIFont systemFontOfSize:16];
    _drawTextColorForX_Y = [UIColor blackColor];
    _colorForXYLine = [UIColor blackColor];
    _levelLineColor = [UIColor blackColor];
    _showLineChart = false;
    self.contentInsets = UIEdgeInsetsMake(50, 50, 0, 50);
    self.chartOrigin = CGPointMake(0, self.scrollView.frame.size.height - 40);
}

- (void)showAnimation {
    NSAssert(self.leftBarBGColors.count > 0 || self.rightBarBGColors.count > 0, @"");

    [self clear];
    
    _barWidth = _barWidth ? : 30;
    _barSpacing = _barSpacing ?: 15;
    _maxW = self.chartOrigin.x + _barWidth * (_leftBarValues.count + _rightBarValues.count) + (_barSpacing + 1) * MAX(_leftBarValues.count, _rightBarValues.count);
    _maxH = self.chartOrigin.y;
    lPerH = _maxH / (_levelLineNum * _yLeftRadix);
    rPerH = _maxH / (_levelLineNum * _yRightRadix);
    
    self.scrollView.contentSize = CGSizeMake(_maxW, _maxH);
    
    CGPoint p = [self.scrollView convertPoint:self.chartOrigin toView:self];

    [self drawChartTitles];
    [self drawXAndYAxis:p];
    [self drawLevelLines:p];
    [self drawDualYTexts:p];
    [self drawXTexts];
    [self drawBars];
}

- (void)drawChartTitles {
    NSMutableArray <CALayer *>*array = [NSMutableArray new];
    
    if (self.leftBarValues.count > 0) {
        CALayer *lump = [CALayer layer];
        lump.backgroundColor = self.leftBarBGColors.firstObject.CGColor;
        lump.frame = CGRectMake(0, 0, 10, 10);
        CATextLayer *l = [self createTextLayer:self.yLeftDetailText font:self.chartSubTitleFont color:self.leftBarBGColors.firstObject];
        CGRect f = l.frame;
        f.size.width += 5;
        l.frame = f;

        CALayer *container = [CALayer new];
        container.backgroundColor = [UIColor clearColor].CGColor;
        container.frame = CGRectMake(0, 0, lump.frame.size.width + l.frame.size.width + 5, MAX(lump.frame.size.height, l.frame.size.height));

        [container addSublayer:lump];
        [container addSublayer:l];
        
        lump.position = P_M(lump.frame.size.width/2.0, container.frame.size.height/2.0);
        l.position = P_M(lump.frame.size.width + 5 + l.frame.size.width/2.0, container.frame.size.height/2.0);
        
        [array addObject:container];
    }
    if (self.rightBarValues.count > 0) {
        CALayer *lump = [CALayer layer];
        lump.backgroundColor = self.rightBarBGColors.firstObject.CGColor;
        lump.frame = CGRectMake(0, 0, 10, 10);
        CATextLayer *l = [self createTextLayer:self.yRightDetailText font:self.chartSubTitleFont color:self.rightBarBGColors.firstObject];
        CGRect f = l.frame;
        f.size.width += 5;
        l.frame = f;
        

        CALayer *container = [CALayer new];
        container.backgroundColor = [UIColor clearColor].CGColor;
        container.frame = CGRectMake(0, 0, lump.frame.size.width + l.frame.size.width + 5, MAX(lump.frame.size.height, l.frame.size.height));
        
        lump.position = P_M(lump.frame.size.width/2.0, container.frame.size.height/2.0);
        l.position = P_M(lump.frame.size.width + 5 + l.frame.size.width/2.0, container.frame.size.height/2.0);

        [container addSublayer:lump];
        [container addSublayer:l];
        
        [array addObject:container];
    }
    
    for (CALayer *l in array) {
        [self.layerArr addObject:l];
        [self.layer addSublayer:l];
    }
    
    if (array.count == 1) {
        array.firstObject.position = P_M(self.frame.size.width/2.0f, 30);
    }
    else if (array.count == 2) {
        CGFloat h = 15;
        CGFloat w = (self.frame.size.width - h - array.firstObject.frame.size.width - array[1].frame.size.width) / 2.0;
        array.firstObject.position = P_M(w + array.firstObject.frame.size.width/2.0f, 30);
        array[1].position = P_M(CGRectGetMaxX(array.firstObject.frame) + h + array[1].frame.size.width/2.0f, 30);
    }
}

- (void)drawXAndYAxis:(CGPoint)p {
    if (_needXLine) {
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:p];
        [bezier addLineToPoint:P_M(self.frame.size.width - p.x, p.y)];
        
        if (_needYLines) {
            [bezier moveToPoint:p];
            [bezier addLineToPoint:P_M(p.x, self.contentInsets.top)];
            [bezier moveToPoint:P_M(self.frame.size.width - p.x, p.y)];
            [bezier addLineToPoint:P_M(self.frame.size.width - p.x, self.contentInsets.top)];
        }
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezier.CGPath;
        layer.strokeColor = _colorForXYLine.CGColor;
        
        [self.layer addSublayer:layer];
        [self.layerArr addObject:layer];
    }
}

- (void)drawLevelLines:(CGPoint)p {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 1; i <_levelLineNum + 1; i++) {
        CGFloat h = i * lPerH * _yLeftRadix;
        [path moveToPoint:P_M(p.x, p.y - h)];
        [path addLineToPoint:P_M(self.frame.size.width - p.x, p.y - h)];
    }
    
    CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic2.duration = 1.5;
    basic2.fromValue = @(0);
    basic2.toValue = @(1);
    basic2.autoreverses = NO;
    basic2.duration = 1.0;
    basic2.fillMode = kCAFillModeForwards;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = _levelLineColor.CGColor;
    shapeLayer.lineWidth = 0.5;
    [shapeLayer setLineDashPattern:@[@(3),@(3)]];
    [shapeLayer addAnimation:basic2 forKey:nil];
    
    [self.layer insertSublayer:shapeLayer atIndex:0];
    [self.layerArr addObject:shapeLayer];
}

- (void)drawXTexts {
    /* Darw x texts*/
    for (NSInteger i = 0; i<_xTexts.count; i++) {
        CATextLayer *textLayer = [CATextLayer layer];
        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) textFont:self.xTextFont.pointSize aimString:_xTexts[i]];
        textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
        textLayer.string = _xTexts[i];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.fontSize = self.xTextFont.pointSize;
        textLayer.foregroundColor = _drawTextColorForX_Y.CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        
        if (_leftBarValues.count > i && _rightBarValues.count > i) {
            textLayer.position = CGPointMake(self.chartOrigin.x + (_barWidth * 2 + _barSpacing) * (i + 1) - _barWidth, self.chartOrigin.y + size.height/2.0f + 5);
        }
        else {
            textLayer.position = CGPointMake(self.chartOrigin.x + (i + MIN(_leftBarValues.count, _rightBarValues.count)) * _barWidth + (_barSpacing) * (i + 1) + _barWidth/2.0, self.chartOrigin.y + size.height/2.0f + 5);
        }
        
        if (self.rotateForXAxisText) {
            CGFloat r = -45.0 / 180.0 * M_PI;
            textLayer.transform = CATransform3DMakeRotation(r, 0.0, 0.0, 1.0);
            textLayer.position = CGPointMake(textLayer.position.x - size.width/2.0 * cos(r), textLayer.position.y - size.width/2.0 * sin(r));
        }
        else {
            textLayer.transform = CATransform3DIdentity;
        }
        
        [self.scrollView.layer addSublayer:textLayer];
        [self.layerArr addObject:textLayer];
    }
}

- (void)drawDualYTexts:(CGPoint)p {

    for (NSInteger i = 1; i <_levelLineNum + 1; i++) {
        CGFloat h = i * lPerH * _yLeftRadix;
        
        if (self.needLeftYTexts) {
            CATextLayer *layer = [self createTextLayer:@(i * _yLeftRadix).stringValue font:_yleftTextFont color:_drawTextColorForX_Y];
            layer.position = CGPointMake(p.x - layer.frame.size.width/2.0 - _leftYTextsMargin, p.y - h);
            [self.layer addSublayer:layer];
            [self.layerArr addObject:layer];
        }
        
        if (self.needRightYTexts) {
            CATextLayer *layer = [self createTextLayer:@(i * _yRightRadix).stringValue font:_yRightTextFont color:_drawTextColorForX_Y];
            layer.position = CGPointMake(self.frame.size.width - p.x + layer.frame.size.width/2.0 + _leftYTextsMargin, p.y - h);
            [self.layer addSublayer:layer];
            [self.layerArr addObject:layer];
        }
    }
    
    if (_needLeftYTexts) {
        CATextLayer *layer = [self createTextLayer:_yLeftDetailText font:_yDetailTextFont color:_drawTextColorForX_Y];
        layer.position = CGPointMake(p.x - layer.frame.size.height/2.0 - 20, p.y - _maxH/2.0f);
        layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, 1.0);
        
        [self.layer addSublayer:layer];
        [self.layerArr addObject:layer];
    }
    if (self.needRightYTexts) {
        CATextLayer *layer = [self createTextLayer:_yRightDetailText font:_yDetailTextFont color:_drawTextColorForX_Y];
        layer.position = CGPointMake(self.frame.size.width - p.x + layer.frame.size.height/2.0 + _leftYTextsMargin + 20, p.y - _maxH/2.0f);
        layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, 1.0);
        
        [self.layer addSublayer:layer];
        [self.layerArr addObject:layer];
    }
}


- (void)drawBars {
    
    NSArray *moreArr = self.leftBarValues.count >= self.rightBarValues.count ? self.leftBarValues : self.rightBarValues;
    
    for (NSUInteger i = 0; i < self.leftBarValues.count; i ++) {
        UIView *view = [UIView new];
        view.backgroundColor = self.leftBarBGColors.count > i ? self.leftBarBGColors[i] : self.leftBarBGColors.firstObject;
        [self.scrollView addSubview:view];
        [self.leftBarViews addObject:view];
    }
    
    for (NSUInteger i = 0; i < self.rightBarValues.count; i ++) {
        UIView *view = [UIView new];
        view.backgroundColor = self.rightBarBGColors.count > i ? self.rightBarBGColors[i] : self.rightBarBGColors.firstObject;
        [self.scrollView addSubview:view];
        [self.rightBarViews addObject:view];
    }
    
    for (NSUInteger i = 0; i < moreArr.count; i ++) {
        UIView *left = self.leftBarViews.count > i ? self.leftBarViews[i] : nil;
        UIView *right = self.rightBarViews.count > i ? self.rightBarViews[i] : nil;
        
        if (!left) {
            right.frame = CGRectMake(self.chartOrigin.x + (self.leftBarViews.count + i) * _barWidth + (i + 1) * _barSpacing, self.chartOrigin.y, _barWidth, 0);
        }
        if (!right) {
            left.frame = CGRectMake(self.chartOrigin.x + (self.rightBarViews.count + i) * _barWidth + (i + 1) * _barSpacing, self.chartOrigin.y, _barWidth, 0);
        }
        else {
            left.frame = CGRectMake(self.chartOrigin.x + i * (_barWidth*2 + _barSpacing) + _barSpacing, self.chartOrigin.y, _barWidth, 0);
            right.frame = CGRectMake(self.chartOrigin.x + i * (_barWidth*2 + _barSpacing) + _barSpacing + _barWidth, self.chartOrigin.y, _barWidth, 0);
        }
        
        [UIView animateWithDuration:1 animations:^{
            if (left) {
                CGRect frame = left.frame;
                frame.size.height = self.leftBarValues[i].floatValue * lPerH;
                frame.origin.y = self.chartOrigin.y - frame.size.height - 1;
                left.frame = frame;
            }
            if (right) {
                CGRect frame = right.frame;
                frame.size.height = self.rightBarValues[i].floatValue * rPerH;
                frame.origin.y = self.chartOrigin.y - frame.size.height - 1;
                right.frame = frame;
            }
            
        } completion:^(BOOL finished) {
            if (!finished) {
                return;
            }
            
            /*        动画结束后添加提示文字         */
            void (^addTextBlock)(UIView *, UIFont *, NSString *) = ^(UIView *view, UIFont *font, NSString *str) {
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) textFont:font.pointSize aimString:str];
                
                CATextLayer *textLayer = [CATextLayer layer];
                textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
                textLayer.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMinY(view.frame) - size.height - 3);
                textLayer.string = str;
                textLayer.fontSize = font.pointSize;
                textLayer.alignmentMode = kCAAlignmentCenter;
                textLayer.contentsScale = [UIScreen mainScreen].scale;
                textLayer.foregroundColor = self.drawTextColorForX_Y.CGColor;
                
                [self.layerArr addObject:textLayer];
                [self.scrollView.layer addSublayer:textLayer];
            };
            
            if (self.leftBarValues.count > i) {
                addTextBlock(left, self.barTextFont, self.leftBarValues[i].stringValue);
            }
            if (self.rightBarValues.count > i) {
                addTextBlock(right, self.barTextFont, self.rightBarValues[i].stringValue);
            }
            
            [self drawLineChart];
        }];
    }
}

- (void)drawLineChart {
    if (!self.showLineChart) {
        return;
    }
    NSAssert(self.leftLineValues.count <= MAX(self.leftBarValues.count, self.rightBarValues.count), @"");
    NSAssert(self.rightLineValues.count <= MAX(self.leftBarValues.count, self.rightBarValues.count), @"");
    
    void (^addLineBlock)(NSArray *, CGFloat, UIColor *, BOOL) = ^(NSArray *values, CGFloat h, UIColor *lineColor, BOOL isLeft) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSUInteger i = 0; i < values.count; i ++) {
            UIView *l = SAFE_ACCESS(self.leftBarViews, i);
            UIView *r = SAFE_ACCESS(self.rightBarViews, i);
            if (l && r) {
                if (i == 0) {
                    [path moveToPoint:P_M(CGRectGetMidX((isLeft ? l : r).frame), self.chartOrigin.y - h * [values[i] floatValue])];
                }
                else {
                    [path addLineToPoint:P_M(CGRectGetMidX((isLeft ? l : r).frame), self.chartOrigin.y - h * [values[i] floatValue])];
                }
            }
            else if (l || r) {
                l = l ?: r;
                if (i == 0) {
                    [path moveToPoint:P_M(CGRectGetMidX(l.frame), self.chartOrigin.y - h * [values[i] floatValue])];
                }
                else {
                    [path addLineToPoint:P_M(CGRectGetMidX(l.frame), self.chartOrigin.y - h * [values[i] floatValue])];
                }
            }
        }
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.path = path.CGPath;
        shaper.frame = self.scrollView.bounds;
        shaper.lineWidth = 1.5;
        shaper.fillColor = [UIColor clearColor].CGColor;
        shaper.strokeColor = lineColor.CGColor;

        [self.layerArr addObject:shaper];
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        
        basic.fromValue = @0;
        basic.toValue = @1;
        basic.duration = 1;
        basic.delegate = self;
        [shaper addAnimation:basic forKey:@"stokentoend"];
        [self.scrollView.layer addSublayer:shaper];
    };
    
    addLineBlock(self.leftLineValues, lPerH, self.leftLinePathColor, true);
    addLineBlock(self.rightLineValues, rPerH, self.rightLinePathColor, false);
}

- (void)clear {
    [self.leftBarViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rightBarViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layerArr makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        // TODO: add line point
    }
}

#pragma mark - Geters and Setters

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    [super setContentInsets:contentInsets];
    self.scrollView.frame = CGRectMake(contentInsets.left,
                                       contentInsets.top,
                                       self.frame.size.width - contentInsets.left - contentInsets.right,
                                       self.frame.size.height - contentInsets.top - contentInsets.bottom);
}

- (void)setLeftBarValues:(NSArray<NSNumber *> *)leftBarValues {
    NSAssert(_yLeftRadix > 0, @"You should set  yLeftRadix first");
    
    _leftBarValues = leftBarValues;
    
    CGFloat max = 0;
    for (NSNumber *num in leftBarValues) {
        max = MAX(num.floatValue, max);
    }
    CGFloat t = max/_yLeftRadix;
    t = t - floor(t) > 0 ? t + 1 : t;
    self.levelLineNum = MAX((NSUInteger)t, _levelLineNum);
}

- (void)setRightBarValues:(NSArray<NSNumber *> *)rightBarValues {
    NSAssert(_yRightRadix > 0, @"You should set  yLeftRadix first");
    
    _rightBarValues = rightBarValues;
    
    CGFloat max = 0;
    for (NSNumber *num in rightBarValues) {
        max = MAX(num.floatValue, max);
    }
    CGFloat t = max/_yRightRadix;
    t = t - floor(t) > 0 ? t + 1 : t;
    self.levelLineNum = MAX((NSUInteger)t, _levelLineNum);
}

- (void)setLevelLineNum:(NSUInteger)levelLineNum {
    _levelLineNum = MAX(_levelLineNum, levelLineNum);
}

- (void)setChartBackgroundColor:(UIColor *)chartBackgroundColor {
    _chartBackgroundColor = chartBackgroundColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (NSMutableArray *)layerArr {
    if (!_layerArr) {
        _layerArr = [[NSMutableArray alloc] init];
    }
    return _layerArr;
}

- (NSMutableArray *)rightBarViews {
    if (!_rightBarViews) {
        _rightBarViews = [[NSMutableArray alloc] init];
    }
    return _rightBarViews;
}

- (NSMutableArray *)leftBarViews {
    if (!_leftBarViews) {
        _leftBarViews = [[NSMutableArray alloc] init];
    }
    return _leftBarViews;
}

- (CATextLayer *)createTextLayer:(NSString *)text
                            font:(UIFont *)font
                           color:(UIColor *)textColor {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CGSize size = [self sizeOfString:text withFont:font];
    textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    textLayer.string = text;
    textLayer.foregroundColor = textColor.CGColor;
    return textLayer;
};


@end

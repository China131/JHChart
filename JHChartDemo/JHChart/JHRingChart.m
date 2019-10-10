//
//  JHRingChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHRingChart.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]]

@interface JHRingChart ()
{
    // 中心评分控件
    UILabel *_percentLabel;
}
//环图间隔 单位为π
@property (nonatomic,assign)CGFloat itemsSpace;

//数值和
@property (nonatomic,assign) CGFloat totolCount;

@property (nonatomic,assign) CGFloat redius;


@property (assign , nonatomic) NSInteger  allValueCount ;
// 下方小标签 宽度
@property (assign , nonatomic) CGFloat  chartArcLength ;




@end


@implementation JHRingChart



-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
        _redius = (CGRectGetHeight(self.frame) -60*k_Width_Scale)/4;
        _ringWidth = 40;
        _ringItemsSpace = 10;
        _chartArcLength = 8.0;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, _redius, _redius)];
    _percentLabel.textColor = [UIColor whiteColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = [UIFont boldSystemFontOfSize:50];
    _percentLabel.text = @"95分";
    _percentLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_percentLabel];
//    [self bringSubviewToFront:_percentLabel];
//    [self.layer addSublayer:_percentLabel.layer];
    
    
}

-(void)setValueDataArr:(NSArray *)valueDataArr{
    
    
    _valueDataArr = valueDataArr;
    
    [self configBaseData];
    
}
- (void)setRingItemsSpace:(CGFloat)ringItemsSpace {
    _ringItemsSpace = ringItemsSpace;
    [self configBaseData];
}
- (void)configBaseData{
    
    _totolCount = 0;
    _itemsSpace = (M_PI * 2.0 * _ringItemsSpace / 360)/_valueDataArr.count ;
    for (id obj in _valueDataArr) {
        
        _totolCount += [obj floatValue];
        
    }

}



//开始动画
- (void)showAnimation{
    
    /*        动画开始前，应当移除之前的layer         */
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    if (_ringShowType == RingChartType_BottomTips) {
        self.chartOrigin = CGPointMake(self.chartOrigin.x, self.chartOrigin.y * 2 / 3 );
    }
    
    CGFloat lastBegin = -M_PI/2;
    
    CGFloat totloL = 0;
    NSInteger  i = 0;
    for (id obj in _valueDataArr) {
        
        CAShapeLayer *layer = [CAShapeLayer layer] ;

        UIBezierPath *path = [UIBezierPath bezierPath];
        
        layer.fillColor = [UIColor clearColor].CGColor;
        
        if (i<_fillColorArray.count) {
            layer.strokeColor =[_fillColorArray[i] CGColor];
        }else{
             layer.strokeColor =[k_COLOR_STOCK[i%k_COLOR_STOCK.count] CGColor];
        }
        CGFloat cuttentpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        totloL += [obj floatValue] / _totolCount;

        [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        layer.lineWidth = _ringWidth;
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basic.fromValue = @(0);
        basic.toValue = @(1);
        basic.duration = 0.5;
        basic.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:basic forKey:@"basic"];
        lastBegin += (cuttentpace+_itemsSpace);
        i++;

    }

}

- (void)countAllValue{
    _allValueCount = 0;
    for (NSString *obj in _valueDataArr) {
        
        _allValueCount += obj.integerValue;
        
    }
}
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andTextFontSize:(CGFloat )fontSize{
    
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    
    
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
    
}
-(void)drawRect:(CGRect)rect{
    
    
    CGContextRef contex = UIGraphicsGetCurrentContext();

    // 绘制中心评分
    if (self.ringScore.length > 0) {
        
        CGSize txtSize = [self getTextWithWhenDrawWithText:self.ringScore fontSize:30*k_Width_Scale maxSize:CGSizeMake(_redius, _redius)];
        [self drawText:self.ringScore andContext:contex atPoint:P_M(self.chartOrigin.x - txtSize.width/2,self.chartOrigin.y - txtSize.height/2) WithColor:[UIColor whiteColor] andTextFontSize:30*k_Width_Scale];
    }

    
    if (!_descArr) {
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:_valueDataArr.count];
        [_valueDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:@""];
        }];
        _descArr = arr;
    }
    
    // 绘制底部标签
    if (_valueDataArr.count>0 && _ringShowType == RingChartType_BottomTips) {
        
        NSArray *colors = nil;
        
        if (_fillColorArray.count==_valueDataArr.count) {
            colors = _fillColorArray;
        }else{
            colors = k_COLOR_STOCK;
        }
        
        for (NSInteger i = 0; i<_descArr.count; i++) {
            
            [self drawQuartWithColor:colors[i%colors.count] andBeginPoint:P_M(20+15+self.frame.size.width/3*(i%3), 20*(i/3  )+ self.chartOrigin.y * 2 + 25+_chartArcLength*2) andContext:contex];

            CGFloat present = [_valueDataArr[i] floatValue] / _totolCount * 100;
            [self drawText:[NSString stringWithFormat:@"%@ 占比:%.1f%c",_descArr[i],present,'%'] andContext:contex atPoint:P_M(30+self.frame.size.width/3*(i%3)+20, 20*(i/3)+ self.chartOrigin.y * 2 + 25+_chartArcLength*2) WithColor:[UIColor whiteColor] andTextFontSize:10*k_Width_Scale];
        }
        
        
    }
    
    
    CGFloat lastBegin = 0;
    CGFloat longLen = _redius +30*k_Width_Scale;
    for (NSInteger i = 0; i<_valueDataArr.count; i++) {
        id obj = _valueDataArr[i];
        CGFloat currentSpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);;
        NSLog(@"%f",currentSpace);
        CGFloat midSpace = lastBegin + currentSpace / 2;

        CGPoint begin = CGPointMake(self.chartOrigin.x + sin(midSpace) * _redius, self.chartOrigin.y - cos(midSpace)*_redius);
        CGPoint endx = CGPointMake(self.chartOrigin.x + sin(midSpace) * longLen, self.chartOrigin.y - cos(midSpace)*longLen);

        NSLog(@"%@%@",NSStringFromCGPoint(begin),NSStringFromCGPoint(endx));
        lastBegin += _itemsSpace + currentSpace;

        UIColor *color;

        if (_fillColorArray.count<_valueDataArr.count) {
            color = k_COLOR_STOCK[i%k_COLOR_STOCK.count];
        }else{
            color = _fillColorArray[i];
        }

        if (_ringShowType == RingChartType_Default) {

            // 绘制指示线
            [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:color];

            // 绘制百分比
            CGPoint secondP = CGPointZero;
            CGFloat present = [_valueDataArr[i] floatValue] / _totolCount * 100;
            NSString * txt = [NSString stringWithFormat:@"%@:\n%.1f%c",_descArr[i],present,'%'];
            
            CGSize size = [txt boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10*k_Width_Scale]} context:nil].size;

            if (midSpace<M_PI) {
                secondP =CGPointMake(endx.x + 20*k_Width_Scale, endx.y);
                [self drawText:txt andContext:contex atPoint:CGPointMake(secondP.x + 3, secondP.y - size.height / 2) WithColor:color andFontSize:8*k_Width_Scale];

            }else{
                secondP =CGPointMake(endx.x - 20*k_Width_Scale, endx.y);
                [self drawText:txt andContext:contex atPoint:CGPointMake(secondP.x - size.width - 3, secondP.y - size.height/2) WithColor:color andFontSize:10*k_Width_Scale];
            }
            [self drawLineWithContext:contex andStarPoint:endx andEndPoint:secondP andIsDottedLine:NO andColor:color];
            [self drawPointWithRedius:3*k_Width_Scale andColor:color andPoint:secondP andContext:contex];

        }
    }
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGSize)getTextWithWhenDrawWithText:(NSString *)text fontSize:(CGFloat)fsize maxSize:(CGSize)maxSize{
    
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fsize]} context:nil].size;
    
    return size;
}




@end

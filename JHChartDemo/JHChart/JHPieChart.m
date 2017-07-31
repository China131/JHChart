//
//  JHPieChart.m
//  JHCALayer
//
//  Created by 简豪 on 16/5/3.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHPieChart.h"
#import "JHPieItemsView.h"
#import "JHPieForeBGView.h"
#import "JHShowInfoView.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:244/255.0 green:161/255.0 blue:100/255.0 alpha:1],[UIColor colorWithRed:87/255.0 green:255/255.0 blue:191/255.0 alpha:1],[UIColor colorWithRed:254/255.0 green:224/255.0 blue:90/255.0 alpha:1],[UIColor colorWithRed:240/255.0 green:58/255.0 blue:63/255.0 alpha:1],[UIColor colorWithRed:147/255.0 green:111/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:255/255.0 blue:199/255.0 alpha:1],[UIColor colorWithRed:90/255.0 green:159/255.0 blue:229/255.0 alpha:1],[UIColor colorWithRed:100/255.0 green:230/255.0 blue:95/255.0 alpha:1],[UIColor colorWithRed:33/255.0 green:255/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:249/255.0 green:110/255.0 blue:176/255.0 alpha:1],[UIColor colorWithRed:192/255.0 green:168/255.0 blue:250/255.0 alpha:1],[UIColor colorWithRed:166/255.0 green:134/255.0 blue:54/255.0 alpha:1],[UIColor colorWithRed:217/255.0 green:221/255.0 blue:228/255.0 alpha:1],[UIColor colorWithRed:99/255.0 green:106/255.0 blue:192/255.0 alpha:1]]

@interface JHPieChart ()<JHPieChartDelegate>

@property (nonatomic,strong) JHPieForeBGView * pieForeView;


@property (assign , nonatomic) NSInteger  allValueCount ;


@property (nonatomic,strong) NSMutableArray * angleArr;


@property (nonatomic,strong) NSMutableArray * countPreAngeleArr;


@property (nonatomic,strong) NSMutableArray * layersArr;

@property (assign , nonatomic) NSInteger  saveIndex ;


@property (assign , nonatomic) CGFloat  chartArcLength ;

@property (nonatomic,strong) JHShowInfoView * showInfoView;
@end


@implementation JHPieChart



-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _chartArcLength = 8.0;
        _showDescripotion = YES;
        _animationType = JHPieChartAnimationNormalType;
        _saveIndex = -1;
        _didClickType = JHPieChartDidClickNormalType;
    }
    
    return self;
    
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    if (_descArr.count==_valueArr.count&&_descArr.count>0) {
        
        NSArray *colors = nil;
        
        if (_colorArr.count==_valueArr.count) {
            colors = _colorArr;
        }else{
            colors = k_COLOR_STOCK;
        }
        
        if (!self.showDescripotion) {
            return;
        }
        
        for (NSInteger i = 0; i<_descArr.count; i++) {
        
            [self drawQuartWithColor:colors[i%colors.count] andBeginPoint:P_M(15+self.frame.size.width/2*(i%2), 20*(i/2  )+25+_chartArcLength*2) andContext:contex];
            CGFloat present = [_valueArr[i] floatValue]/_allValueCount*100;
            [self drawText:[NSString stringWithFormat:@"%@ 数量:% 3ld 占比:%.1f%c",_descArr[i],[_valueArr[i] integerValue],present,'%'] andContext:contex atPoint:P_M(30+self.frame.size.width/2*(i%2), 20*(i/2  )+25+_chartArcLength*2) WithColor:[UIColor blackColor] andTextFontSize:8];
        }
       
        
    }
    
    
}
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andTextFontSize:(CGFloat )fontSize{
    
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"CourierNewPSMT" size:fontSize],NSForegroundColorAttributeName:color}];
    
    
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
    
}
- (void)countAllValue{
    _allValueCount = 0;
    for (NSString *obj in _valueArr) {
        
        _allValueCount += obj.integerValue;
        
    }
}


- (void)countAllAngleDataArr{
    
    _angleArr = [NSMutableArray array];
    for (NSString *obj in _valueArr) {
        
        [_angleArr addObject:[NSNumber numberWithDouble:obj.floatValue*M_PI * 2/_allValueCount]];
        
    }
    
    _countPreAngeleArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<_angleArr.count; i++) {
        
        if (i==0) {
             [_countPreAngeleArr addObject:[NSNumber numberWithFloat:0]];
        }
        CGFloat angle = 0.0;
        for (NSInteger j = 0; j<=i; j++) {
            
            angle += [_angleArr[j] floatValue];
            
        }
        
        [_countPreAngeleArr addObject:[NSNumber numberWithFloat:angle]];

        
    }
    
    
    
}


- (void)pieChart:(JHPieItemsView *)pieChart animationDidEnd:(BOOL)flag{
    if (flag) {
        if (_animationType == JHPieChartAnimationByOrder) {
            if (pieChart.tag < _layersArr.count - 1) {
                JHPieItemsView *nextView = _layersArr[pieChart.tag + 1];
                nextView.delegate = self;
                [nextView showAnimation];
            }
            
        }
        
    }
}


-(void)showAnimation{
    
 
    
    if (_valueArr.count>0) {
        
        [self countAllValue];
        
        [self countAllAngleDataArr];
        
        _layersArr = [NSMutableArray array];
        
        CGFloat wid = self.frame.size.width-20;
        self.chartOrigin = P_M(10 + wid / 2, 15 + wid / 2);
        if (_descArr.count>0) {
            
            NSInteger i = _descArr.count/2 + _descArr.count%2;
            
            wid = self.frame.size.height - 10 - i*25;
            
        }
        
        _chartArcLength = wid/2;
        
        NSArray *colors = nil;
        
        if (_colorArr.count == _valueArr.count) {
            
            colors = _colorArr;
            
        }else{
            
            colors = k_COLOR_STOCK;
            
        }
        
        
        for (NSInteger i = 0; i<_countPreAngeleArr.count-1; i++) {
            
            JHPieItemsView *itemsView = [[JHPieItemsView alloc] initWithFrame:CGRectMake(10, 10, wid/2, wid/2) andBeginAngle:[_countPreAngeleArr[i] floatValue] andEndAngle:[_countPreAngeleArr[i+1] floatValue] andFillColor:colors[i%colors.count]];
            
            itemsView.center = CGPointMake(self.frame.size.width/2, 10+wid/2);
            
            itemsView.tag = i;
            itemsView.animationDuration = self.animationDuration;
            
            NSTimeInterval cacheTime = ([_countPreAngeleArr[i+1] floatValue] - [_countPreAngeleArr[i] floatValue]) * self.animationDuration / M_PI;
            
            if (_animationType == JHPieChartAnimationNormalType || i == 0) {
                if (i == 0 && _animationType == JHPieChartAnimationByOrder) {
                    itemsView.delegate = self;
                    itemsView.animationDuration = cacheTime;
                }
                [itemsView showAnimation];
                
            }else{
                itemsView.delegate = self;
                itemsView.animationDuration = cacheTime;
            }
            [_layersArr addObject:itemsView];
            
            [self addSubview:itemsView];
            
        }
        
        _pieForeView = [[JHPieForeBGView alloc] initWithFrame:CGRectMake(10, 10, wid,  wid)];
        
        _pieForeView.center = CGPointMake(self.frame.size.width/2, 10+wid/2);
        
        _pieForeView.backgroundColor = [UIColor clearColor];
        if (_showInfoView==nil) {
            _showInfoView = [[JHShowInfoView alloc] init];
            _showInfoView.hidden = YES;
            [_pieForeView addSubview:_showInfoView];
        }
        __weak typeof(self) weakSelf = self;
        _pieForeView.select = ^(CGFloat angle,CGPoint p){
           
            [weakSelf judgeWhitchOneIsNowAngle:angle andShowPoint:p];
            
        };
        
        [self addSubview:_pieForeView];
        
    }
    
    [self setNeedsDisplay];
    
}


- (void)judgeWhitchOneIsNowAngle:(CGFloat )angel andShowPoint:(CGPoint)p{
    weakSelf(weakSelf)
    for (NSInteger i = 0; i<_countPreAngeleArr.count-1; i++) {
        
        if ([_countPreAngeleArr[i+1] floatValue]>=angel) {
            
            /*        当前饼块中心点的角度         */
            float NOW_ANGLE = [_countPreAngeleArr[i] floatValue]+[_angleArr[i] floatValue]/2.0f;
            
            /*        中心点         */
            CGPoint centerPoint = P_M(self.frame.size.width / 2 + self.chartArcLength / 2*cos(NOW_ANGLE), self.chartOrigin.y + self.chartArcLength / 2 * sin(NOW_ANGLE));
            
            NSLog(@"%@",NSStringFromCGPoint(centerPoint));
            
            
//            CALayer *lay = [CALayer layer];
//            lay.frame = CGRectMake(0, 0, 2, 2);
//            lay.backgroundColor = [UIColor blackColor].CGColor;
//            lay.position = centerPoint;
//            lay.cornerRadius = 1;
//            lay.masksToBounds = YES;
//            [self.layer addSublayer:lay];
//
            
            CGFloat standarSpa = _positionChangeLengthWhenClick;
            
            CGFloat spa = sin(NOW_ANGLE)*standarSpa;
            
            CGFloat xSpa = cos(NOW_ANGLE)*standarSpa;
            
            JHPieItemsView *itemsView = _layersArr[i];
           
            JHPieItemsView *saveItems = nil;
            if (_saveIndex != -1) {
                saveItems = _layersArr[_saveIndex];
            }
            
            CGFloat wid = self.frame.size.width-20;
            
            if (_descArr.count>0) {
                
                NSInteger i = _descArr.count/2 + _descArr.count%2;
                
                wid = self.frame.size.height - 10 - i*25;
                
            }
            
            
            NSArray *colors = nil;
            
            if (_colorArr.count == _valueArr.count) {
                
                colors = _colorArr;
                
            }else{
                
                colors = k_COLOR_STOCK;
                
            }
            CGFloat present = [_valueArr[i] floatValue]/_allValueCount*100;
            
            
            if (_didClickType == JHPieChartDidClickTranslateToBig) {
                if (_saveIndex == i) {
                    saveItems = nil;
                    _saveIndex = -1;
                }else{
                    [saveItems itemDidClickWithRediusChange:self.positionChangeLengthWhenClick];
                    _saveIndex = i;
                }
                
                [itemsView itemDidClickWithRediusChange:self.positionChangeLengthWhenClick];
                
                self.showInfoView.hidden = !itemsView.hasClick;
                [self.showInfoView updateFrameTo:CGRectMake(p.x, p.y, self.showInfoView.frame.size.width, self.showInfoView.frame.size.height) andBGColor:colors[i%colors.count] andShowContentString:[NSString stringWithFormat:@"%@ 数量:% 3ld 占比:%.1f%c",weakself.descArr[i],[self.valueArr[i] integerValue],present,'%']];
                return;
            }
            
            
            
           
            
            return;
            
            [UIView animateWithDuration:0.3 animations:^{
                if (weakself.saveIndex==i) {
                    
                    if (saveItems.center.x==self.frame.size.width/2) {
                        weakself.showInfoView.hidden = NO;
                        itemsView.center = CGPointMake(weakself.frame.size.width/2+xSpa, 10+wid/2+spa);
                        [weakself.showInfoView updateFrameTo:CGRectMake(p.x, p.y, weakself.showInfoView.frame.size.width, weakself.showInfoView.frame.size.height) andBGColor:colors[i%colors.count] andShowContentString:[NSString stringWithFormat:@"%@ 数量:% 3ld 占比:%.1f%c",weakself.descArr[i],[weakself.valueArr[i] integerValue],present,'%']];
//                        _showInfoView.frame = C   GRectMake(p.x, p.y, _showInfoView.frame.size.width, _showInfoView.frame.size.height);
                        
                    }else{
                        weakself.showInfoView.hidden = YES;
                        saveItems.center = CGPointMake(self.frame.size.width/2, 10+wid/2);
                        
                    }
                    
                }else{
                    
                    saveItems.center = CGPointMake(self.frame.size.width/2, 10+wid/2);
                    weakself.showInfoView.hidden = NO;
                    [weakself.showInfoView updateFrameTo:CGRectMake(p.x, p.y, weakself.showInfoView.frame.size.width, weakself.showInfoView.frame.size.height) andBGColor:colors[i%colors.count] andShowContentString:[NSString stringWithFormat:@"%@ 数量:% 3ld 占比:%.1f%c",weakself.descArr[i],[weakself.valueArr[i] integerValue],present,'%']];
                    itemsView.center = CGPointMake(weakself.frame.size.width/2+xSpa, 10+wid/2+spa);
                    
                }
            }];
           
            
            
            break;
        }
        
    }
    
    
}



@end

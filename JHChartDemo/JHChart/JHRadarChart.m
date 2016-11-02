//
//  JHRadarChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/9/9.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHRadarChart.h"

@interface JHRadarChart ()

@property (nonatomic,assign)CGFloat chartRadius;
@property (nonatomic,strong)NSMutableArray * drawPointArray;

@property (nonatomic,strong)NSMutableArray * baseDrawPointArray;
@end


@implementation JHRadarChart


-(NSMutableArray *)drawPointArray{
    
    if (!_drawPointArray) {
        _drawPointArray = [NSMutableArray array];
    }
    
    return _drawPointArray;
}


-(NSMutableArray *)baseDrawPointArray{
    
    if (!_baseDrawPointArray) {
        _baseDrawPointArray = [NSMutableArray array];
    }
    return _baseDrawPointArray;
}

-(void)setLayerCount:(NSInteger)layerCount{
    
    if (layerCount<=0) {
        return;
    }
    
    _layerCount = layerCount;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    

    if (self = [super initWithFrame:frame]) {
        
        self.layerCount = 3;
        self.chartRadius = (self.frame.size.height - 50 * 2) / 2.0;
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
        self.layerFillColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        self.layerBoardColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        self.speraLineColor = [UIColor whiteColor];
        self.perfectNumber = 100.0;
        self.descTextFont = [UIFont systemFontOfSize:14];
        self.descTextColor = [UIColor darkGrayColor];
    }
    
    
    return self;
    
}


/**
 *  初始化点数组
 */
- (void)configDrawingData{
    
    
    if (self.valueDataArray.count==0) {
        return;
    }
    

    CGFloat perAngle = M_PI * 2 / self.valueDescArray.count;
    for (NSInteger i = 0; i<self.valueDataArray.count; i++) {
        
        NSArray *valueArray = [self.valueDataArray objectAtIndex:i];
        NSMutableArray *cacheArray = [NSMutableArray array];
        
        for (NSInteger j = 0; j<valueArray.count; j++) {
            CGFloat value = [[valueArray objectAtIndex:j] floatValue];
            
            value = (value>self.perfectNumber?self.perfectNumber:value);
            
            CGPoint cachePoint = CGPointMake(self.chartOrigin.x + value / self.perfectNumber * self.chartRadius * sin(j * perAngle), self.chartOrigin.y - value / self.perfectNumber * self.chartRadius * cos(j * perAngle));
            [cacheArray addObject:[NSValue valueWithCGPoint:cachePoint]];
            
        }
        
        [self.drawPointArray addObject:[cacheArray copy]];
        
    }
    
}


- (void)configBaseViewDataArray{
    
    [self.baseDrawPointArray removeAllObjects];
    CGFloat perLength = self.chartRadius / self.layerCount;
    
    CGFloat perAngle = M_PI * 2 / self.valueDescArray.count;
    
    for (NSInteger i = 0; i<self.layerCount; i++) {
        
        NSMutableArray *cacheArray = [NSMutableArray array];
        CGFloat cacheLength = (i+1) * perLength;
        for (NSInteger j = 0; j<self.valueDescArray.count; j++) {
            
            CGPoint cachePoint = CGPointMake(self.chartOrigin.x + cacheLength * sin(j * perAngle) , self.chartOrigin.y - cacheLength * cos(j * perAngle));
            
            NSLog(@"-----%-----i== %ld     ======%@",j * perAngle,i,NSStringFromCGPoint(cachePoint));
            NSValue *cacheValue = [NSValue valueWithCGPoint:cachePoint];
            [cacheArray addObject:cacheValue];
            
            
            if (i==0) {
                
                CGFloat width = [self sizeOfStringWithMaxSize:CGSizeMake(100, 20) textFont:self.descTextFont.pointSize aimString:self.valueDescArray[j]].width;
                UILabel *cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
                cacheLabel.font = self.descTextFont;
                cacheLabel.center = CGPointMake(self.chartOrigin.x + (self.chartRadius + width / 2 + 5) * sin(j * perAngle) ,self.chartOrigin.y - (self.chartRadius + 20 / 2 + 5) * cos(j * perAngle));
                cacheLabel.text = self.valueDescArray[j];
                cacheLabel.textColor = self.descTextColor;
                [self addSubview:cacheLabel];
            }

            
        }
        
        [self.baseDrawPointArray addObject:[cacheArray copy]];
        [cacheArray removeAllObjects];
        
    }
    
    
    
}


/**
 *  添加基本的视图模块
 */
- (void)drawBaseView{
    for (NSInteger i = self.baseDrawPointArray.count-1; i>=0; i--) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        NSArray * cacheArray = [self.baseDrawPointArray objectAtIndex:i];
        for (NSInteger j = 0; j<cacheArray.count; j++) {
            
            NSValue *cacheValue = [cacheArray objectAtIndex:j];
            CGPoint currentCachePoint = [cacheValue CGPointValue];
            
            
            NSLog(@"i== %ld     ======%@",i,NSStringFromCGPoint(currentCachePoint));
            if (j==0) {
                [path moveToPoint:currentCachePoint];
            }else if(j==cacheArray.count){
                [path addLineToPoint:currentCachePoint];
                [path moveToPoint:currentCachePoint];
            }else{
                [path addLineToPoint:currentCachePoint];
            }
        }
        
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = self.layerFillColor.CGColor;
        shapeLayer.strokeColor = self.layerBoardColor.CGColor;
        [self.layer addSublayer:shapeLayer];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path closePath];
    [path moveToPoint:self.chartOrigin];
    NSMutableArray * cacheArray = [self.baseDrawPointArray lastObject];
    for (NSInteger j = 0; j<cacheArray.count; j++) {
        NSValue *cacheValue = [cacheArray objectAtIndex:j];
        CGPoint currentCachePoint = [cacheValue CGPointValue];
        
        [path addLineToPoint:currentCachePoint];
        [path moveToPoint:self.chartOrigin];
    }
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.speraLineColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    
    
    

}


- (void)drawValueView{
    
    
    if (self.drawPointArray.count==0) {
        return;
    }
    
    
    for (NSInteger i = 0 ; i<self.drawPointArray.count; i++) {
        
        NSArray *cacheArray = [self.drawPointArray objectAtIndex:i];
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSInteger j = 0; j<cacheArray.count; j++) {
            
            
            
            if (j==0) {
                [path moveToPoint:[[cacheArray objectAtIndex:j] CGPointValue]];
            }else{
                [path addLineToPoint:[[cacheArray objectAtIndex:j] CGPointValue]];
            }

        }
        [path closePath];
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.path = path.CGPath;
        shaper.borderWidth = 1.0;
        UIColor *cacheColor = [UIColor clearColor];
        if (self.valueDrawFillColorArray.count>i) {
            cacheColor = self.valueDrawFillColorArray[i];
        }
        shaper.fillColor = cacheColor.CGColor;
        
        
        if (self.valueBoardColorArray.count>i) {
            cacheColor = self.valueBoardColorArray[i];
        }else{
            cacheColor = [UIColor clearColor];
        }
        shaper.strokeColor = cacheColor.CGColor;
        
        
        [self.layer addSublayer:shaper];
        
    }
    
    
    
}

-(void)showAnimation{
    
    [self configBaseViewDataArray];
    [self configDrawingData];
    [self drawBaseView];
    [self drawValueView];
    
}





@end

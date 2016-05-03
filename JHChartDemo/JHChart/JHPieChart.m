//
//  JHPieChart.m
//  JHCALayer
//
//  Created by cjatech-简豪 on 16/5/3.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHPieChart.h"
#import "JHPieItemsView.h"
#import "JHPieForeBGView.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:227/255.0 green:90/255.0 blue:64/255.0 alpha:1],[UIColor colorWithRed:104/255.0 green:184/255.0 blue:233/255.0 alpha:1],[UIColor colorWithRed:254/255.0 green:214/255.0 blue:90/255.0 alpha:1],[UIColor colorWithRed:147/255.0 green:141/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:144/255.0 green:38/255.0 blue:93/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:255/255.0 blue:199/255.0 alpha:1],[UIColor colorWithRed:71/255.0 green:142/255.0 blue:95/255.0 alpha:1],[UIColor colorWithRed:33/255.0 green:255/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:251/255.0 green:0/255.0 blue:255/255.0 alpha:1]]

@interface JHPieChart ()

@property (nonatomic,strong) JHPieForeBGView * pieForeView;


@property (assign , nonatomic) NSInteger  allValueCount ;


@property (nonatomic,strong) NSMutableArray * angleArr;


@property (nonatomic,strong) NSMutableArray * countPreAngeleArr;


@property (nonatomic,strong) NSMutableArray * layersArr;

@property (assign , nonatomic) NSInteger  saveIndex ;


@end


@implementation JHPieChart



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

-(void)showAnimation{
    
    if (_valueArr.count>0) {
        [self countAllValue];
        [self countAllAngleDataArr];
        _layersArr = [NSMutableArray array];
        for (NSInteger i = 0; i<_countPreAngeleArr.count-1; i++) {
            
            JHPieItemsView *itemsView = [[JHPieItemsView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width/2-20,  self.frame.size.width/2-20) andBeginAngle:[_countPreAngeleArr[i] floatValue] andEndAngle:[_countPreAngeleArr[i+1] floatValue] andFillColor:k_COLOR_STOCK[i%9]];
            itemsView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            itemsView.tag = i;
            [_layersArr addObject:itemsView];
            [self addSubview:itemsView];
            
        }
        _pieForeView = [[JHPieForeBGView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20,  self.frame.size.width-20)];
        _pieForeView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _pieForeView.backgroundColor = [UIColor clearColor];
        _pieForeView.select = ^(CGFloat angle){
          
            
            [self judgeWhitchOneIsNowAngle:angle];
            
            
        };
        [self addSubview:_pieForeView];
    }
    
    
}


- (void)judgeWhitchOneIsNowAngle:(CGFloat )angel{
    
    for (NSInteger i = 0; i<_countPreAngeleArr.count-1; i++) {
        
        if ([_countPreAngeleArr[i+1] floatValue]>=angel) {
            
         
            
            CGFloat NOW_ANGLE = [_countPreAngeleArr[i] floatValue]+[_angleArr[i] floatValue]/2;
            
            CGFloat standarSpa = 8.0;
            

            
            CGFloat spa = sin(NOW_ANGLE)*standarSpa;
            CGFloat xSpa = cos(NOW_ANGLE)*standarSpa;
            JHPieItemsView *itemsView = _layersArr[i];
           
            JHPieItemsView *saveItems = _layersArr[_saveIndex];
            
            if (_saveIndex==i) {
                
                if (saveItems.center.x==self.frame.size.width/2) {
                    itemsView.center = CGPointMake(self.frame.size.width/2+xSpa, self.frame.size.height/2+spa);
                }else{
                     saveItems.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                }
                
            }else{
                saveItems.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                
                itemsView.center = CGPointMake(self.frame.size.width/2+xSpa, self.frame.size.height/2+spa);

                
            }
            
            _saveIndex = i;
            
            
            
            break;
        }
        
    }
    
    
}
-(void)drawRect:(CGRect)rect{
    
    
    
}

@end

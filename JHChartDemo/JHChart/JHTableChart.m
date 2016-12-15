//
//  JHTableChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHTableChart.h"
#import "JHTableDataRowModel.h"
@interface JHTableChart ()

@property (nonatomic,assign)CGFloat tableWidth;
@property (nonatomic,assign) CGFloat tableHeight;
@property (nonatomic,assign) CGFloat lastY;
@property (nonatomic,assign) CGFloat bodyHeight;
@property (nonatomic,strong)NSMutableArray * dataModelArr;
@end

@implementation JHTableChart

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _minHeightItems             = 40;
        _beginSpace                 = 15.0;
        _tableChartTitleItemsHeight = 50.0;
        _lineColor                  = [UIColor darkGrayColor];
        _tableTitleFont             = [UIFont systemFontOfSize:15];
        _tableTitleColor            = [UIColor darkGrayColor];
        _tableWidth                 = 100;
        _lastY                      = _beginSpace;
        _bodyHeight                 = 0;
        _bodyTextColor              = [UIColor darkGrayColor];
        
    }
    return self;
}

-(void)setBeginSpace:(CGFloat)beginSpace{
    
    _beginSpace = beginSpace;
    _lastY = beginSpace;
    
}


-(void)setDataArr:(NSArray *)dataArr{
    
    
    _dataArr = dataArr;
    
    _dataModelArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<_dataArr.count; i++) {
        
        JHTableDataRowModel *model = [JHTableDataRowModel new];
        model.maxCount = 1;
        
        for (id obj in _dataArr[i]) {
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (model.maxCount<=[obj count]) {
                    model.maxCount = [obj count];
                }
            }
        }
        model.dataArr = dataArr[i];
      
        [_dataModelArr addObject:model];
    }
    
    
    
}


/**
 *  CoreGraphic 绘图
 *
 *  @param rect
 */
-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*        表格四周线条         */
    
    /*        上         */
    [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace) andIsDottedLine:NO andColor:_lineColor];
    
    /*        下         */
    [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,_beginSpace + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
    
    
    NSLog(@"视图大小%@\n",NSStringFromCGRect(self.frame));
    NSLog(@"起始点：%f\n",_beginSpace);
    
    /*        左         */
    [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace) andEndPoint:P_M(_beginSpace,  _beginSpace + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
    
    /*        右         */
    [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, _beginSpace) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  _beginSpace + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
    
    /*        表头         */
    if (_tableTitleString.length>0) {
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:_lineColor];

        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
        [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:_tableTitleColor font:_tableTitleFont];
        _lastY = _beginSpace + _tableChartTitleItemsHeight;
    }
    
    
    /*        绘制列的分割线         */
    if (_colTitleArr.count>0) {
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        CGFloat lastX = _beginSpace;
        for (NSInteger i = 0; i<_colTitleArr.count; i++) {
            
            
            
            CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
            
            NSLog(@"第%d列 宽度 为 %f\n",i,wid);
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
            
            
            if (i==0) {

                NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                if (firArr.count>=2) {
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];

                    [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];

                    [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                }else{

                    [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:14]];;
                }
                
                
            }else{
            
                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:14]];;
            }
            lastX += wid;
            if (i==_colTitleArr.count - 1) {
                
            }else
                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
            
            
        }
        _lastY += _minHeightItems;
    }
    /*        列名分割线         */
    [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
    
    
    
    
    BOOL hasSetColWidth = 0;
    /*        如果指定了列的宽度         */
    if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
        
        hasSetColWidth = YES;
        
    }else{
        hasSetColWidth = NO;
    }

    /*        绘制具体的行数据         */
    
    for (NSInteger i = 0; i<_dataModelArr.count; i++) {
        
        
        JHTableDataRowModel *model = _dataModelArr[i];
        
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
        
        CGFloat lastX = _beginSpace;
        
        for (NSInteger j = 0; j< model.dataArr.count; j++) {
            
            
            id rowItems = model.dataArr[j];
            
          
            CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
            if ([rowItems isKindOfClass:[NSArray class]]) {
                
                CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                /*       具体某一列有多个元素时       */
                for (NSInteger n = 0; n<[rowItems count]; n++) {
                    
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
//                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                    [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                }
                
            }else{
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];

                  [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
            }
            lastX += wid;

            
        }
        _lastY += model.maxCount * _minHeightItems;
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}


/**
 *  绘图前数据构建
 */
- (void)configBaseData{
    _tableWidth = CGRectGetWidth(self.frame) - _beginSpace * 2;
    
    [self configColWidthArr];
    [self countTableHeight];
    
}


/**
 *  重构列数据
 */
- (void)configColWidthArr{
    
    CGFloat wid = 0;

    if (_colTitleArr.count>0&&_colTitleArr.count == _colWidthArr.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i<_colWidthArr.count; i++) {
            
            if (wid>_tableWidth) {
                arr = nil;
            }else{
                if (i==_colWidthArr.count-1) {
                    
                    [arr addObject:[NSNumber numberWithFloat:(_tableWidth - wid)]];
                }else
                    [arr addObject:_colWidthArr[i]];
                
            }
            wid += [_colWidthArr[i] floatValue];
        }
        _colWidthArr = [arr copy];
      
    }else{
        _colWidthArr = nil;
    }
    
}

/**
 *  计算表格总高度和表格体高度
 */
- (void)countTableHeight{
    
    NSInteger rowCount = 0;
    for (NSArray * itemsArr in _dataArr) {
        
        NSInteger nowCount = 1;
        
        for (id obj in itemsArr) {
            
            if ([obj isKindOfClass:[NSArray class]]) {
                
                if (nowCount<=[obj count]) {
                    nowCount = [obj count];
                }
                
            }
            
        }
        rowCount += nowCount;
    }
    
    _bodyHeight = rowCount * _minHeightItems  + (_colTitleArr.count>0?_minHeightItems:0);
    _tableHeight = 0;
    _tableHeight += (_tableTitleString.length>0?_tableChartTitleItemsHeight:0) + _bodyHeight;
}

/**
 *  绘制图形
 */
-(void)showAnimation{
    
    [self configBaseData];
    
    [self setNeedsDisplay];
    
    
    
    
}

/**
 *  返回该图表所需的高度
 *
 *  @return 高度
 */
- (CGFloat)heightFromThisDataSource{
    [self countTableHeight];
    return _tableHeight + _beginSpace * 2;
    
}

@end

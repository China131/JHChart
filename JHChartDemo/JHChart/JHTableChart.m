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

@property (nonatomic,assign) CGFloat tableWidth;
@property (nonatomic,assign) CGFloat tableHeight;
@property (nonatomic,assign) CGFloat lastY;
@property (nonatomic,assign) CGFloat bodyHeight;
@property (nonatomic,strong) NSMutableArray * dataModelArr;

//用于保存每个field的frame
//表头和属性头
@property (nonatomic,strong) NSMutableArray<NSString *> * titleFieldFrameArr;
//数据内容
@property (nonatomic,strong) NSMutableArray * dataFieldFrameArr;

@end

@implementation JHTableChart

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _minHeightItems             = 40;
        _beginSpace                 = 15.0;
        _tableChartTitleItemsHeight = 50.0;
        _lineColor                  = [UIColor darkGrayColor];
        _tableTitleFont             = [UIFont systemFontOfSize:15];
        _bodyTextFont               = [UIFont systemFontOfSize:15];
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
    //绘制前初始化数组
    _dataFieldFrameArr = [NSMutableArray array];
    _titleFieldFrameArr = [NSMutableArray array];
    
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

        BOOL drawText = true;
        if ([_delegate respondsToSelector:@selector(tableChart:viewForTableHeaderWithContentSize:)]) {
            UIView *header = [_delegate tableChart:self viewForTableHeaderWithContentSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight)];
            if (header) {
                header.frame = CGRectMake(_beginSpace+1, _beginSpace+1, _tableWidth-2, _tableChartTitleItemsHeight-2);
                drawText = false;
                [self addSubview:header];
            }
        }
        
        if (drawText) {
            //需要绘制文字时再计算宽度
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:_tableTitleColor font:_tableTitleFont];
        }
        
        // 将表头frame添加进去
        [_titleFieldFrameArr addObject:NSStringFromCGRect(CGRectMake(_beginSpace+1, _beginSpace+1, _tableWidth-2, _tableChartTitleItemsHeight-2))];
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
        //属性头绘制
        for (NSInteger i = 0; i<_colTitleArr.count; i++) {
            CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
            
            NSLog(@"第%ld列 宽度 为 %f\n",i,wid);
            
            //将属性头frame添加进去
            [_titleFieldFrameArr addObject:NSStringFromCGRect(CGRectMake(lastX+1, _lastY+1, wid-2, self.colTitleHeight-2))];
            BOOL drawText = true;
            // 上层调用代理传进自定义的view
            if ([_delegate respondsToSelector:@selector(tableChart:viewForPropertyAtColumn:contentSize:)]) {
                UIView *proView = [_delegate tableChart:self viewForPropertyAtColumn:i contentSize:CGSizeMake(wid-2, self.colTitleHeight-2)];
                if (proView) {
                    proView.frame = CGRectMake(lastX+1, _lastY+1, wid-2, self.colTitleHeight-2);
                    drawText = false;
                    [self addSubview:proView];
                }
            }
            
            if (!drawText) {
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else{
                    //绘制列分割线
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                }
                //跳出本次循环，下面绘制文字代码不执行
                continue;
            }
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:self.colTitleFont.pointSize aimString:_colTitleArr[i]];
            
            if (i == 0) {
                NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                if (firArr.count>=2) {
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + self.colTitleHeight) andIsDottedLine:NO andColor:_lineColor];
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:firArr[0]];
                    
                    [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + self.colTitleHeight / 4.0 -size.height / 2.0, wid, self.colTitleHeight / 2.0) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
                    size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, self.colTitleHeight) textFont:14 aimString:firArr[1]];
                    
                    [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + self.colTitleHeight / 2.0 + self.colTitleHeight / 4.0 - size.height / 2.0, size.width+5, self.colTitleHeight / 2.0) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
                }else{
                    
                    [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + self.colTitleHeight / 2.0 -size.height / 2.0, wid, size.height) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
                }
                
                
            }else{
                
                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + self.colTitleHeight / 2.0 -size.height / 2.0, wid, self.colTitleHeight) WithColor:[self colorForColTitle:i] font:self.colTitleFont];
            }
            lastX += wid;
            if (i == _colTitleArr.count - 1) {
                
            }else{
                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
            }
            
        }
        _lastY += self.colTitleHeight;
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

    /*        绘制具体的行数据   i表示第几行 j表示第几列      */
    
    for (NSInteger i = 0; i<_dataModelArr.count; i++) {
        
        
        JHTableDataRowModel *model = _dataModelArr[i];
        
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
        
        CGFloat lastX = _beginSpace;
        
        // 新建data中每行数组
        NSMutableArray *rowFrameArr = [NSMutableArray array];
        for (NSInteger j = 0; j< model.dataArr.count; j++) {
            id rowItems = model.dataArr[j];
            CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
            
            //绘制列数组元素
            if ([rowItems isKindOfClass:[NSArray class]]) {//列元素为数组时
                
                // 一行中某个有多个分行，用于存储该行所有分行frame
                NSMutableArray *rowItemsFrameArr = [NSMutableArray array];
                
                CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                /*       具体某一列有多个元素时       */
                for (NSInteger n = 0; n<[rowItems count]; n++) {
                    
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                    CGSize contentSize = CGSizeMake(wid - 2, _minHeightItems*model.maxCount/[rowItems count] - 2);
                    BOOL drawText = true;
                    if ([_delegate respondsToSelector:@selector(tableChart:viewForContentAtRow:column:subRow:contentSize:)]) {
                        UIView *cacheView = [_delegate tableChart:self  viewForContentAtRow:i column:j subRow:n contentSize:contentSize];
                        if (cacheView) {
                            cacheView.frame = CGRectMake(lastX+1, _lastY+2 + n * _minHeightItems*model.maxCount/[rowItems count] , contentSize.width, contentSize.height);
                            drawText = false;
                            [self addSubview:cacheView];
                        }
                    }
                    
                    if (drawText) {
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_bodyTextFont.pointSize aimString:rowItems[n]];
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_bodyTextFont];
                    }
                    //将一行中某个多分行frame添加进去
                    [rowItemsFrameArr addObject:NSStringFromCGRect(CGRectMake(lastX+1, _lastY+2 + n * _minHeightItems*model.maxCount/[rowItems count] , contentSize.width, contentSize.height))];
                }
                [rowFrameArr addObject:rowItemsFrameArr];
            }else{//绘制列元素 非数组
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_bodyTextFont.pointSize aimString:rowItems];
                CGSize contentSize = CGSizeMake(wid - 2, _minHeightItems * model.maxCount - 2);
                BOOL drawText = true;
                if ([_delegate respondsToSelector:@selector(tableChart:viewForContentAtRow:column:subRow:contentSize:)]) {
                    
                    UIView *cacheView = [_delegate tableChart:self  viewForContentAtRow:i column:j subRow:0 contentSize:contentSize];
                    if (cacheView) {
                        cacheView.frame = CGRectMake(lastX+1, _lastY+1, contentSize.width, contentSize.height);
                        drawText = false;
                        [self addSubview:cacheView];
                    }
                    
                }
                if (drawText) {
                    [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_bodyTextFont];
                }
                //将一行中没有分行的frame添加进去
                [rowFrameArr addObject:NSStringFromCGRect(CGRectMake(lastX+1, _lastY+1, contentSize.width, contentSize.height))];
            }
            lastX += wid;
        }
        
        //将每行中的所有frame添加进去
        [_dataFieldFrameArr addObject:rowFrameArr];
        _lastY += model.maxCount * _minHeightItems;

        
    }
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    BOOL contained = false;
    //int x = -1, y = -1, z = -1;
    NSLog(@"point %@",NSStringFromCGPoint(p));
    for (int i = 0; i < _titleFieldFrameArr.count; i++) {
        CGRect rect = CGRectFromString(_titleFieldFrameArr[i]);
        //NSLog(@"rect %@",_titleFieldFrameArr[i]);
        if (CGRectContainsPoint(rect, p)) {
            NSLog(@"title contained %d",i);
            contained = true;
            if ([_delegate respondsToSelector:@selector(didClickedTableChart:content:indexString:)]) {
                [_delegate didClickedTableChart:self content:(i == 0? _tableTitleString: _colTitleArr[i - 1]) indexString:(i == 0? nil: [NSString stringWithFormat:@"{%d}",i - 1])];
            }
            return;
        }
    }
    
    if (!contained) {
        for (int i = 0; i < _dataFieldFrameArr.count; i++) {
            id item = _dataFieldFrameArr[i];
            if ([item isKindOfClass:[NSString class]]) {
                CGRect rect = CGRectFromString(item);
                if (CGRectContainsPoint(rect, p)) {
                    NSLog(@"data contained %d",i);
                    contained = true;
                    if ([_delegate respondsToSelector:@selector(didClickedTableChart:content:indexString:)]) {
                        [_delegate didClickedTableChart:self content:_dataArr[i] indexString:[NSString stringWithFormat:@"{%d}",i]];
                    }
                    return;
                }
            } else if ([item isKindOfClass:[NSArray class]]) {
                NSArray *items = (NSArray *)item;
                for (int j = 0; j < items.count; j++) {
                    id subItem = items[j];
                    if ([subItem isKindOfClass:[NSString class]]) {
                        CGRect rect = CGRectFromString(items[j]);
                        if (CGRectContainsPoint(rect, p)) {
                            NSLog(@" data contained %d %d",i,j);
                            contained = true;
                            if ([_delegate respondsToSelector:@selector(didClickedTableChart:content:indexString:)]) {
                                [_delegate didClickedTableChart:self content:_dataArr[i][j] indexString:[NSString stringWithFormat:@"{%d,%d}",i,j]];
                            }
                            return;
                        }
                    } else if ([subItem isKindOfClass:[NSArray class]]) {
                        NSArray *subItems = (NSArray *)subItem;
                        for (int k = 0; k < subItems.count; k++) {
                            CGRect rect = CGRectFromString(subItems[k]);
                            if (CGRectContainsPoint(rect, p)) {
                                NSLog(@" data contained %d %d %d",i,j,k);
                                contained = true;
                                if ([_delegate respondsToSelector:@selector(didClickedTableChart:content:indexString:)]) {
                                    [_delegate didClickedTableChart:self content:_dataArr[i][j][k] indexString:[NSString stringWithFormat:@"{%d,%d,%d}",i,j,k]];
                                }
                                return;
                            }
                        }
                    }
                }
            }
        }
    }
    
    if (!contained) {
        NSLog(@"not contained");
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
    
    _bodyHeight = rowCount * _minHeightItems  + (_colTitleArr.count>0?self.colTitleHeight:0);
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

#pragma mark - 数据行高及字体颜色处理
- (UIFont *)colTitleFont{
    if (!_colTitleFont) {
        _colTitleFont = self.bodyTextFont;
    }
    return _colTitleFont;
}

- (CGFloat)colTitleHeight{
    return _colTitleHeight > 0 ? _colTitleHeight : self.minHeightItems;
}

- (UIColor *)colorForColTitle:(NSInteger)colTitleIndex{
    UIColor *defaultTitleColor = self.colTitleColor ?: self.bodyTextColor;
    if (self.colTitleColorArr) {
        if (colTitleIndex < self.colTitleColorArr.count) {
            if (![self.colTitleColorArr[colTitleIndex] isKindOfClass:[UIColor class]]) {
                return defaultTitleColor;
            }
            return self.colTitleColorArr[colTitleIndex];
        }
    }
    return defaultTitleColor;
}

- (UIColor *)colorForCol:(NSInteger)colIndex{
    if (self.bodyTextColorArr) {
        if (colIndex < self.bodyTextColorArr.count) {
            if (![self.bodyTextColorArr[colIndex] isKindOfClass:[UIColor class]]) {
                return self.bodyTextColor;
            }
            return self.bodyTextColorArr[colIndex];
        }
    }
    return self.bodyTextColor;
}
///清空表格
-(void)clear{
    //移除视图上的所有子视图
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}

@end

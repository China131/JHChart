//
//  JHChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"
@interface JHChart()



@end
@implementation JHChart

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _xDescTextFontSize = _yDescTextFontSize = 8.0;
        self.xAndYLineColor = [UIColor darkGrayColor];
        self.contentInsets = UIEdgeInsetsMake(10, 20, 10, 10);
        self.chartOrigin = P_M(self.contentInsets.left, CGRectGetHeight(self.frame) - self.contentInsets.bottom);
        self.animationDuration = 2.0;
    }
    return self;
}

-(void)showAnimation{
    
}


-(void)clear{
    
}




/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    
    
    //    移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    //    连接到
    CGContextAddLineToPoint(context, end.x, end.y);
    
    
    CGContextSetLineWidth(context, 0.3);
    
    
    [color setStroke];
    
    if (isDotted) {
        CGFloat ss[] = {1.5,2};
        
        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param rect    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{


    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];

    [color setFill];

    CGContextDrawPath(context, kCGPathFill);

}


- (void)drawText:(NSString *)text context:(CGContextRef )context atPoint:(CGRect )rect WithColor:(UIColor *)color font:(UIFont*)font{
    
    
//    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [[NSString stringWithFormat:@"%@",text] drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [color setFill];

    
    CGContextDrawPath(context, kCGPathFill);
    
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]} context:nil].size;
    
    return size.width;
}


/**
 *  绘制长方形
 *
 *  @param color  填充颜色
 *  @param p      开始点
 *  @param contex 图形上下文
 */
- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddRect(contex, CGRectMake(p.x, p.y, 10, 10));
    [color setFill];
    [color setStroke];
    CGContextDrawPath(contex, kCGPathFillStroke);
    
    
}


- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddArc(contex, p.x, p.y, redius, 0, M_PI * 2, YES);
    [color setFill];
    CGContextDrawPath(contex, kCGPathFill);
    
}

/**
 *  返回字符串的占用尺寸
 *
 *  @param maxSize   最大尺寸
 *  @param fontSize  字号大小
 *  @param aimString 目标字符串
 *
 *  @return 占用尺寸
 */
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
}

-(void)dealloc{
#if DEBUG
    NSLog(@"%@ has dealloc",NSStringFromClass([self class]));
#endif
}

@end

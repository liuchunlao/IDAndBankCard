//
//  IDOverLayerView.m
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/11.
//  Copyright © 2016年 AN. All rights reserved.
//

#import "IDOverLayerView.h"

@interface IDOverLayerView()

@property (nonatomic, assign) int lineLenght;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IDOverLayerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = frame.size.height;
        CGFloat height = frame.size.width;
        
        self.backgroundColor = [UIColor clearColor];
        _lineLenght = height / 10;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.text = @"请将扫描线对准身份证并对齐左右边缘。";
        [self addSubview:label];
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        label.transform = transform;
        
        float x = height * 22 / 54;
        x = x + (height - x) / 2;
        label.center = CGPointMake(x, width/2);
    }
    return self;
}


-(void)timerFire:(id)notice {
    [self setNeedsDisplay];
}

-(void)dealloc {
    [self.timer invalidate];
}

//画边框和线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8.0);
    CGContextSetRGBStrokeColor(context, .3, 0.8, .3, .8);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+_lineLenght);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y+_lineLenght);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y-_lineLenght);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-_lineLenght);
    CGContextStrokePath(context);
    

    static float moveX = 0;
    static float distance = 2;
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGPoint p1, p2;
    
    moveX += distance;
    if (moveX > rect.size.width) {
        distance = -2;
    } else if (moveX < rect.origin.x){
        distance = 2;
    }
    p1 = CGPointMake(rect.origin.x + moveX, rect.origin.y);
    p2 = CGPointMake(rect.origin.x + moveX, rect.origin.y + rect.size.height);
    CGContextMoveToPoint(context,p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextStrokePath(context);

}

+ (CGRect)getOverlayFrame:(CGRect)rect {
    float previewWidth = rect.size.width;
    float previewHeight = rect.size.height;
    
    float cardh, cardw;
    float left, top;
    
    cardw = previewWidth*70/100;
    //if(cardw < 720) cardw = 720;
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (int)(cardw / 0.63084f);
    
    left = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    
    return CGRectMake(left, top, cardw, cardh);
}

@end

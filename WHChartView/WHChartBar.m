//
//  WHChartBar.m
//  WHChartView
//
//  Created by 王振辉 on 15/8/15.
//  Copyright (c) 2015年 王振辉. All rights reserved.
//

#import "WHChartBar.h"
#import "UIColor+WHColor.h"
@interface WHChartBar (){
    BOOL    labelHasShown;
    UILabel *label;
}
@end

@implementation WHChartBar

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundColorofBar = [UIColor whiteColor];
        _colorofBar = [UIColor whLightBlue];
        
        _bar = [CAShapeLayer layer];
        _bar.lineWidth = self.frame.size.width;
        _bar.strokeEnd = 0.0;
        _bar.strokeColor = _colorofBar.CGColor;
        labelHasShown = NO;
        
        self.clipsToBounds = YES;
        [self.layer addSublayer:_bar];
        self.layer.cornerRadius = 2.0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapped:)];
        
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

#pragma mark - Action
- (void)labelTapped:(id)sender{
    if (!labelHasShown) {
        label = [[UILabel alloc]init];
        label.text = @"179";
        label.font = [UIFont systemFontOfSize:13.0];
        label.textAlignment = NSTextAlignmentCenter;
        //label.text = [NSString stringWithFormat:@"%f",_labelValue];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        [self SetAutoLayoutOfLabelAndSelf];

        labelHasShown = YES;
    }else{
        [label removeFromSuperview];
        labelHasShown = NO;
    }
}

#pragma mark - AutoLayout
- (void)SetAutoLayoutOfLabelAndSelf
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:label
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0];
    NSNumber *number = [NSNumber numberWithDouble:(_percentage == 1) ? (self.frame.size.height - 20):(self.frame.size.height*_percentage - 2)];
    NSDictionary *metrics = @{@"height":number};
    NSDictionary *views = @{@"label":label};
    NSArray *topConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-height-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views];
    NSArray *leftConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views];
    
    [self addConstraint:widthConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraints:topConstraints];
    [self addConstraints:leftConstraint];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    //Draw Background
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _backgroundColorofBar.CGColor);
    CGContextFillRect(context, rect);
    
}

- (void)setPercentage:(float)percentage
{
    if (!percentage) {
        return;
    }
    _bar.strokeColor = _colorofBar.CGColor;
    _percentage = percentage;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path setLineCapStyle:kCGLineCapSquare];
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1.0 - percentage) * self.frame.size.height)];
    _bar.path = path.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue =[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_bar addAnimation:pathAnimation forKey:@"strokeAnimation"];
    
    _bar.strokeEnd = 1.0;
    
}


@end
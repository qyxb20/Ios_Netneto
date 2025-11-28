//
//  UIView+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "UIView+tool.h"
static char activityViewKey;
static char lastTitleKey;


@implementation UIView (tool)
- (void)addTapAction:(ViewTapBlock)clickBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = YES;
    tapGr.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGr];
    objc_setAssociatedObject(self, &ClickBlockKey, clickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addTopCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addBottomCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addRightCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addLeftCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addDiagonalCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addDiagonalNewCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addTopCornerPath:(CGFloat)radius frame:(CGRect)bounds{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)appendActivityView:(UIColor *)color {
    if (!self.appendActivity) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        activityIndicator.frame = self.bounds;
        activityIndicator.color = color;
        [activityIndicator startAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        self.appendActivity = activityIndicator;
        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
        [self addSubview:activityIndicator];
    }

    [self bringSubviewToFront:self.appendActivity];
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = NO;
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        self.lastTitle = btn.titleLabel.text;
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)removeActivityView {
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = YES;
    }
    for (UIView *view in self.subviews) {
        view.hidden = NO;
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        [btn setTitle:self.lastTitle forState:UIControlStateNormal];
    }
    if (self.appendActivity) {
        self.appendActivity.hidden = YES;
        [self.appendActivity stopAnimating]; // 结束旋转
        [self.appendActivity removeFromSuperview];
        self.appendActivity = nil;
        self.lastTitle = nil;
    }
}

#pragma mark - 运行时添加属性
- (UIActivityIndicatorView *)appendActivity {
    return objc_getAssociatedObject(self, &activityViewKey);
}

- (void)setAppendActivity:(UIActivityIndicatorView *)appendActivity {
    objc_setAssociatedObject(self, &activityViewKey, appendActivity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)lastTitle {
    return objc_getAssociatedObject(self, &lastTitleKey);;
}

- (void)setLastTitle:(NSString *)lastTitle {
    objc_setAssociatedObject(self, &lastTitleKey, lastTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)clickAction:(UITapGestureRecognizer *)sender {
    ViewTapBlock block = objc_getAssociatedObject(self, &ClickBlockKey);
    ExecBlock(block,sender.view);
}

- (void)drawSideImageViewLineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor sides:(NSInteger)sides {
    [self drawSideImageViewLineWidth:lineWidth color:lineColor sides:sides corner:0];
}

- (void)drawSideImageViewLineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor sides:(NSInteger)sides corner:(CGFloat)corner {
    UIBezierPath *path = [UIBezierPath polygonInRect:self.bounds sides:sides linewidth:lineWidth cornerRadius:corner];
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    mask.lineWidth       = lineWidth;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
    self.layer.mask = mask;
     
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path          = path.CGPath;
    border.lineWidth     = lineWidth;
    border.strokeColor   = lineColor.CGColor;
    border.fillColor     = [UIColor clearColor].CGColor;
    [self.layer addSublayer:border];
}

#pragma mark - =====================
- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}
- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}
- (CGSize)size {
    return self.frame.size;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint {
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (void)setSize:(CGSize)aSize {
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (void)setHeight:(CGFloat)newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth {
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright {
    CGRect frame = self.frame;
    frame.origin.x = newright - frame.size.width;
    self.frame = frame;
}

- (CGFloat)centetX {
    return self.center.x;
}

- (void)setCentetX:(CGFloat)centetX {
    CGPoint center = self.center;
    center.x = centetX;
    self.center = center;
}

- (CGFloat)centetY {
    return self.center.y;
}

- (void)setCentetY:(CGFloat)centetY {
    CGPoint center = self.center;
    center.y = centetY;
    self.center = center;
}
@end

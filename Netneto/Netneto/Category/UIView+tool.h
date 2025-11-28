//
//  UIView+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static char ClickBlockKey;

typedef void (^ViewTapBlock)(UIView *view);
@interface UIView (tool)<UIGestureRecognizerDelegate>

- (void)addTapAction:(ViewTapBlock)clickBlock;
- (void)addLeftCornerPath:(CGFloat)radius;
- (void)addRightCornerPath:(CGFloat)radius;
- (void)addTopCornerPath:(CGFloat)radius;
- (void)addBottomCornerPath:(CGFloat)radius;
- (void)addDiagonalCornerPath:(CGFloat)radius;
- (void)addTopCornerPath:(CGFloat)radius frame:(CGRect)bounds;
- (void)addDiagonalNewCornerPath:(CGFloat)radius;
- (void)drawSideImageViewLineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor sides:(NSInteger)sides;
- (void)drawSideImageViewLineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor sides:(NSInteger)sides corner:(CGFloat)corner;

- (void)appendActivityView:(UIColor *)color;
- (void)removeActivityView;
@property (nonatomic,strong) UIActivityIndicatorView *appendActivity;
@property (nonatomic, copy) NSString *lastTitle;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@property CGSize size;
@property CGPoint origin;
@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

@end

NS_ASSUME_NONNULL_END

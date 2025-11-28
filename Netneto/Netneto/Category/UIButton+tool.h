//
//  UIButton+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ButtonStyle) {
    /// image在上，label在下
    ButtonStyleImageTopTitleBottom,
    /// image在左，label在右
    ButtonStyleImageLeftTitleRight,
    /// image在下，label在上
    ButtonStyleImageBottomTitleTop,
    /// image在右，label在左
    ButtonStyleImageRightTitleLeft
};
@interface UIButton (tool)
- (void)setEnlargeEdge:(CGFloat)size;
- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
- (void)loadImage:(NSString *)url placeholder:(NSString *_Nullable)placeholder;
- (void)layoutButtonWithButtonStyle:(ButtonStyle)style imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END

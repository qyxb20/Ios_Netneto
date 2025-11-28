//
//  UITextView+tool.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import "UITextView+tool.h"

@implementation UITextView (tool)
+ (void)load {
    Method setFontMethod = class_getInstanceMethod(self, @selector(setFont:));
    Method was_setFontMethod = class_getInstanceMethod(self, @selector(was_setFont:));
    method_exchangeImplementations(setFontMethod, was_setFontMethod);
}

- (void)was_setFont:(UIFont *)font{
    [self was_setFont:font];
    UILabel *label = [self valueForKey:@"_placeholderLabel"];
    label.font = font;
}
- (void)setRightPlaceholderWithText:(NSString *)text Color:(UIColor *)color{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];

}
- (void)setPlaceholderWithText:(NSString *)text Color:(UIColor *)color {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
}
- (void)setCustomPlaceholderWithText:(NSString *)text Color:(UIColor *)color font:(NSInteger)font{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
}
@end

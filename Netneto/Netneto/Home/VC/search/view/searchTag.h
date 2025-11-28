//
//  searchTag.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface searchTag : NSObject
@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSAttributedString *attributedText;
@property (strong, nonatomic, nullable) UIColor *textColor;
///backgound color
@property (strong, nonatomic, nullable) UIColor *bgColor;
@property (strong, nonatomic, nullable) UIColor *highlightedBgColor;
///background image
@property (strong, nonatomic, nullable) UIImage *bgImg;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;
///like padding in css
@property (assign, nonatomic) UIEdgeInsets padding;
@property (strong, nonatomic, nullable) UIFont *font;
///if no font is specified, system font with fontSize is used
@property (assign, nonatomic) CGFloat fontSize;
///default:YES
@property (assign, nonatomic) BOOL enable;

- (nonnull instancetype)initWithText: (nonnull NSString *)text;
+ (nonnull instancetype)tagWithText: (nonnull NSString *)text;

@end

NS_ASSUME_NONNULL_END

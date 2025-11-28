//
//  searchTag.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/22.
//

#import "searchTag.h"

@implementation searchTag
- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = 13;
        _textColor = [UIColor blackColor];
        _bgColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text {
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

+ (instancetype)tagWithText: (NSString *)text {
    return [[self alloc] initWithText: text];
}

@end

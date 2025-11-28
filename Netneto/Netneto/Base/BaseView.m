//
//  BaseView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseView.h"

@implementation BaseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self CreateView];
        [self GetData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
        [self CreateView];
        [self GetData];
    }
    return self;
}

- (void)initData {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)CreateView {}
- (void)GetData {}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

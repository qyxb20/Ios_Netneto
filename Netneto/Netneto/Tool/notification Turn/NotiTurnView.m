//
//  NotiTurnView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "NotiTurnView.h"
@interface NotiTurnView ()
{
    UILabel *label1;
    UILabel *label2;
    NSTimer *timer;
    BOOL wichOne;
    int count;
}
@end
@implementation NotiTurnView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)timer{
    count++;
    if (count>_turnArray.count-1) {
        count = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (!self->wichOne) {
            self->label1.frame = CGRectMake(14, -self.frame.size.height, self.frame.size.width - 80, self.frame.size.height);
            self->label2.frame = CGRectMake(14, 0, self.frame.size.width - 80, self.frame.size.height);
        }
        if (self->wichOne) {
            self->label1.frame = CGRectMake(14, 0, self.frame.size.width - 80, self.frame.size.height);
            self->label2.frame = CGRectMake(14, -self.frame.size.height, self.frame.size.width - 80, self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self->wichOne = !self->wichOne;
        if ((int)self->label1.frame.origin.y==-self.frame.size.height) {
            self->label1.frame = CGRectMake(14, self.frame.size.height, self.frame.size.width - 80, self.frame.size.height);
            self->label1.text = [NSString isNullStr:self->_turnArray[self->count][@"title"]];
        }
        if ((int)self->label2.frame.origin.y==-self.frame.size.height) {
            self->label2.frame = CGRectMake(14, self.frame.size.height, self.frame.size.width - 80, self.frame.size.height);
            self->label2.text = [NSString isNullStr:self->_turnArray[self->count][@"title"]];
        }
    }];
    
}

- (void)setTurnArray:(NSArray *)turnArray {
    _turnArray = turnArray;
    [timer invalidate];
    [label1 removeFromSuperview];
    [label2 removeFromSuperview];
    count = 1;
    if (_turnArray.count == 0) {
        return;
    }
    if (_turnArray.count == 1) {
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.frame.size.width - 80, self.frame.size.height)];
        label1.text = [NSString isNullStr:_turnArray[0][@"title"]];
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = RGB(0x808080);
        label1.backgroundColor = [UIColor clearColor];
        [self addSubview:label1];
    }else{
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.frame.size.width - 80, self.frame.size.height)];
        label1.text = [NSString isNullStr:_turnArray[0][@"title"]];
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = RGB(0x808080);
       
        label1.backgroundColor = [UIColor clearColor];
        [self addSubview:label1];
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(14, self.frame.size.height, self.frame.size.width - 80, self.frame.size.height)];
        label2.text = [NSString isNullStr:_turnArray[1][@"title"]];
        label2.font = [UIFont systemFontOfSize:12];
        label2.textColor = RGB(0x808080);
       
        label2.backgroundColor = [UIColor clearColor];
        [self addSubview:label2];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timer)
                                               userInfo:@"aaaa" repeats:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

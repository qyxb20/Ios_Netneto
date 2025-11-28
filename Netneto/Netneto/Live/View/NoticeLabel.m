//
//  NoticeLabel.m
//  Netneto
//
//  Created by apple on 2024/11/29.
//

#import "NoticeLabel.h"

@implementation NoticeLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _embeddedView = [[UIView alloc] init];
        _embeddedView.backgroundColor =RGB(0xFE9803);
        _embeddedView.layer.cornerRadius = 8;
        _embeddedView.clipsToBounds = YES;
        CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"直播公告") height:20 font:12];
       
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(7, 1.5, w , 17);
        label.text =TransOutput(@"直播公告");
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_embeddedView addSubview:label];
        [self addSubview:_embeddedView];
    }
    return self;
}
 
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"直播公告") height:20 font:12];
    // Position the embedded view on top of the label's text
    _embeddedView.frame = CGRectMake(10, 5, w + 14, 20);
   
}
 
- (void)setEmbeddedView:(UIView *)embeddedView {
    if (_embeddedView != embeddedView) {
        [_embeddedView removeFromSuperview];
        _embeddedView = embeddedView;
        _embeddedView.backgroundColor =RGB(0xFE9803);
        _embeddedView.layer.cornerRadius = 8;
        _embeddedView.clipsToBounds = YES;
        CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"直播公告") height:20 font:12];
       
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(7, 1.5, w , 17);
        label.text =TransOutput(@"直播公告");
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_embeddedView addSubview:label];
        [self addSubview:_embeddedView];
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

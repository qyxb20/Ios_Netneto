//
//  LiveStartButtonView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/7.
//

#import "LiveStartButtonView.h"
@interface LiveStartButtonView ()
@property(nonatomic, strong)UILabel *line;
@property(nonatomic, strong)UIButton *startBtn;

@end

@implementation LiveStartButtonView
-(void)CreateView{
    [self addSubview:self.line];
    [self addSubview:self.startBtn];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(1);
    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.line.mas_bottom).offset(12);
        make.height.mas_offset(44);
    }];
    
}
-(UILabel *)line{
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = RGB(0xE6E5E5);
    }
    return _line;
}
-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.backgroundColor = [UIColor gradientColorArr:@[RGB(0x1778FD),RGB(0x1778FD)] withWidth:WIDTH - 32];
        [_startBtn setTitle:TransOutput(@"开启直播") forState:UIControlStateNormal];
        _startBtn.layer.cornerRadius = 22;
        _startBtn.clipsToBounds = YES;
        @weakify(self);
        [_startBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.startLiveBtnClickBlock);
        }];
    }
    return _startBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

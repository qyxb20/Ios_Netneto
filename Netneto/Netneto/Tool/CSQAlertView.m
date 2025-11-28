//
//  CSQAlertView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "CSQAlertView.h"
@interface CSQAlertView ()

@property (nonatomic, copy) btnClickBlock btnBlock;
@property (nonatomic, copy) cancelClickBlock cancelBlock;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *btnTitle;
@property(nonatomic,copy)NSString *cancelTitle;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *closeCustomBtn;
@end
@implementation CSQAlertView
- (instancetype)initWithTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)message btnTitle:(NSString *_Nullable)btnTitle cancelBtnTitle:(NSString *_Nullable)cancelTitle btnClick:(nullable btnClickBlock)btnClick cancelBlock:(nullable cancelClickBlock)cancleBlock {
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.btnTitle = btnTitle;
        self.btnBlock = btnClick;
        self.cancelBlock = cancleBlock;
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCutomOrderTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)message btnTitle:(NSString *_Nullable)btnTitle cancelBtnTitle:(NSString *_Nullable)cancelTitle btnClick:(nullable btnClickBlock)btnClick cancelBlock:(nullable cancelClickBlock)cancleBlock {
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.btnTitle = btnTitle;
        self.btnBlock = btnClick;
        self.cancelBlock = cancleBlock;
        [self setupCustomerOrderUI];
    }
    return self;
}
-(instancetype)initWithOtherTitle:(NSString *)title Message:(NSString *)message btnTitle:(NSString *)btnTitle btnClick:(btnClickBlock)btnClick{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.btnTitle = btnTitle;
        self.btnBlock = btnClick;
      
        [self setupOtherUI];
    }
    return self;
}
#pragma mark - 取消/确定 联系客服UI
-(void)setupCustomerOrderUI{
    self.backgroundColor = RGB_ALPHA(0x000000, 0.3);
    [self addSubview:self.contentView];
    
    if (self.title.length > 0) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (self.message.length > 0) {
        [self.contentView addSubview:self.messageLabel];
    }
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.closeCustomBtn];
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.confirmBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    [self.closeCustomBtn setTitle:self.cancelTitle.length > 0 ? self.cancelTitle : TransOutput(@"はい") forState:UIControlStateNormal];
    
    [self.closeCustomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(19);
        make.bottom.mas_equalTo(-19);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((WIDTH - 70 - 38-17) /2);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-19);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-19);
        make.width.mas_equalTo((WIDTH - 70 - 38-17) /2);
    }];
    
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
    if (self.title.length > 0) {
        titleSize = [self sizeForString:self.title font:[UIFont boldSystemFontOfSize:16] maxWidth: WIDTH-70-64];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.leading.mas_equalTo(32);
            make.trailing.mas_equalTo(-32);
            make.height.mas_equalTo(titleSize.height);
        }];
        
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-34];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
                make.leading.mas_equalTo(17);
                make.trailing.mas_equalTo(-17);
                make.height.mas_equalTo(messageSize.height);
            }];
        }
    }else {
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-34];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(25);
                make.leading.mas_equalTo(17);
                make.trailing.mas_equalTo(-17);
                make.height.mas_equalTo(messageSize.height+10);
            }];
        }
    }
    CGFloat h = 0;
    if (self.title.length > 0 && self.message.length > 0) {
        h = 32+titleSize.height+10+messageSize.height+20+40+10+40+32;
    }else  if (self.title.length > 0 && self.message.length == 0){
        h = 32+titleSize.height+20+40+19;
    }
    else  if (self.message.length > 0 && self.title.length == 0){
        h = 32+messageSize.height+20+40+19;
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo( WIDTH - 70);
        make.height.mas_equalTo(h);
        make.centerX.centerY.equalTo(self);
    }];
   
}
#pragma mark - 取消/确定单按钮UI
-(void)setupOtherUI{
    self.backgroundColor = RGB_ALPHA(0x000000, 0.3);
    [self addSubview:self.contentView];
    
    if (self.title.length > 0) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (self.message.length > 0) {
        [self.contentView addSubview:self.messageLabel];
    }
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.closeBtn];
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
        self.messageLabel.textAlignment = NSTextAlignmentLeft;

    [self.confirmBtn setTitle:self.btnTitle forState:UIControlStateNormal];
   
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(19);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-19);
        make.trailing.mas_equalTo(-19);
    }];
    
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
    if (self.title.length > 0) {
        titleSize = [self sizeForString:self.title font:[UIFont boldSystemFontOfSize:16] maxWidth: WIDTH-70-64];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.leading.mas_equalTo(32);
            make.trailing.mas_equalTo(-32);
            make.height.mas_equalTo(titleSize.height);
        }];
        
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-64];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
                make.leading.mas_equalTo(32);
                make.trailing.mas_equalTo(-32);
                make.height.mas_equalTo(messageSize.height);
            }];
        }
    }else {
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-64];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(25);
                make.leading.mas_equalTo(32);
                make.trailing.mas_equalTo(-32);
                make.height.mas_equalTo(messageSize.height+10);
            }];
        }
    }
    CGFloat h = 0;
    if (self.title.length > 0 && self.message.length > 0) {
        h = 32+titleSize.height+10+messageSize.height+20+40+10+40+32;
    }else  if (self.title.length > 0 && self.message.length == 0){
        h = 32+titleSize.height+20+40+19;
    }
    else  if (self.message.length > 0 && self.title.length == 0){
        h = 32+messageSize.height+20+40+19;
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo( WIDTH - 70);
        make.height.mas_equalTo(h);
        make.centerX.centerY.equalTo(self);
    }];
   
}
#pragma mark - 取消确定双按钮UI
- (void)setupUI {
    self.backgroundColor = RGB_ALPHA(0x000000, 0.3);
    [self addSubview:self.contentView];
    
    if (self.title.length > 0) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (self.message.length > 0) {
        [self.contentView addSubview:self.messageLabel];
    }
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.closeBtn];
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
    
    [self.confirmBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    [self.closeBtn setTitle:self.cancelTitle.length > 0 ? self.cancelTitle : TransOutput(@"取消") forState:UIControlStateNormal];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-19);
        make.bottom.mas_equalTo(-19);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((WIDTH - 70 - 38-17) /2);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(19);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-19);
        make.width.mas_equalTo((WIDTH - 70 - 38-17) /2);
    }];
    
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
    if (self.title.length > 0) {
        titleSize = [self sizeForString:self.title font:[UIFont boldSystemFontOfSize:16] maxWidth: WIDTH-70-64];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.leading.mas_equalTo(32);
            make.trailing.mas_equalTo(-32);
            make.height.mas_equalTo(titleSize.height);
        }];
        
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-64];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
                make.leading.mas_equalTo(32);
                make.trailing.mas_equalTo(-32);
                make.height.mas_equalTo(messageSize.height);
            }];
        }
    }else {
        if (self.message.length > 0) {
            messageSize = [self sizeForString:self.message font:[UIFont systemFontOfSize:14] maxWidth: WIDTH-70-64];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(25);
                make.leading.mas_equalTo(32);
                make.trailing.mas_equalTo(-32);
                make.height.mas_equalTo(messageSize.height+10);
            }];
        }
    }
    CGFloat h = 0;
    if (self.title.length > 0 && self.message.length > 0) {
        h = 32+titleSize.height+10+messageSize.height+20+40+19;
    }else  if (self.title.length > 0 && self.message.length == 0){
        h = 32+titleSize.height+20+40+19;
    }
    else  if (self.message.length > 0 && self.title.length == 0){
        h = 32+messageSize.height+20+40+19;
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo( WIDTH - 70);
        make.height.mas_equalTo(h);
        make.centerX.centerY.equalTo(self);
    }];
   
}

#pragma mark - lazyload
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(35, (HEIGHT-220)/2, (WIDTH-70), 220)];
        _contentView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xE3EDFF),RGB(0xFFFFFF)] withWidth:WIDTH - 70];
        _contentView.layer.cornerRadius = 24;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = RGB(0x6A6A6A);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = RGB(0x6A6A6A);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH-70];
        _confirmBtn.layer.cornerRadius = 20;
        @weakify(self)
        [[_confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hide];
            ExecBlock(self.btnBlock);
        }];
    }
    return _confirmBtn;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _closeBtn.layer.cornerRadius = 20;
        _closeBtn.backgroundColor = [UIColor gradientColorArr:@[RGB(0xEA8A2F),RGB(0xEFB675)] withWidth:WIDTH-70-64];
        [_closeBtn setTitle:TransOutput(@"取消") forState:UIControlStateNormal];
        @weakify(self)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hide];
            ExecBlock(self.cancelBlock);
        }];
    }
    return _closeBtn;
}
-(UIButton *)closeCustomBtn{
    if (!_closeCustomBtn) {
        _closeCustomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeCustomBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
        _closeCustomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _closeCustomBtn.layer.cornerRadius = 20;
        _closeCustomBtn.backgroundColor = [UIColor clearColor];
        _closeCustomBtn.layer.borderColor = RGB(0x197CF5).CGColor;
        _closeCustomBtn.layer.borderWidth = 1;
        [_closeCustomBtn setTitle:TransOutput(@"取消") forState:UIControlStateNormal];
        @weakify(self)
        [[_closeCustomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hide];
            ExecBlock(self.cancelBlock);
        }];
    }
    return _closeCustomBtn;
}
#pragma mark - public
- (void)show {
    self.tag = 9999;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    [self shakeToShow:self.contentView];
}

- (void)hide {
    ExecBlock(self.hideBlock);
    [self removeFromSuperview];
}

#pragma mark - event
- (void)shakeToShow:(UIView *)aView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (CGSize)sizeForString:(NSString*)content font:(UIFont *)font maxWidth:(CGFloat) maxWidth{
    if (!content || content.length == 0) {
        return CGSizeMake(0, 0);
    }
    NSDictionary * attributes = @{NSFontAttributeName:font};
    CGSize textRect = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize textSize = [content boundingRectWithSize:textRect options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    CGFloat h = ceilf(textSize.height);
    textSize.height = h;
    return textSize;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [touches.anyObject locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, p)) {
        [self hide];
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

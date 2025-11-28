//
//  OrderDetailInfoFootView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderDetailInfoFootView.h"
@interface OrderDetailInfoFootView ()
{
    NSInteger time;
}
@property (nonatomic, strong) UIButton *surePayBtn;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation OrderDetailInfoFootView
-(void)CreateView{
    self.backgroundColor = RGB(0xEBEDEF);
    
   
}
- (void)setStatus:(NSString *)status{
    _status = status;
    
}

-(void)setModel:(OrderDetailModel *)model{
    _model = model;
    if ([self.status isEqual:@"3"]) {
        UILabel *label = [[UILabel alloc] init];
        NSString *price = [NSString ChangePriceStr:model.actualTotal];
        NSString *str =[NSString stringWithFormat:@"%@:¥%@",TransOutput(@"实际支付"),price];
        label.textColor = RGB(0x868585);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - price.length - 1, price.length + 1)];
        
        label.attributedText = att;
        label.font = [UIFont systemFontOfSize:14];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.mas_offset(0);
            make.height.mas_offset(30);
        }];
        
        
        //待支付
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.bottom.mas_offset(0);
            make.top.mas_equalTo(label.mas_bottom).offset(0);
           
        }];
        
        UIButton *checkWuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkWuBtn setTitle:TransOutput(@"查看物流") forState:UIControlStateNormal];
        checkWuBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
        checkWuBtn.layer.cornerRadius = 22;
        checkWuBtn.clipsToBounds = YES;
        @weakify(self);
        [checkWuBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.checkWuClickBlock);
        }];
        [whiteView addSubview:checkWuBtn];
        [checkWuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.top.mas_offset(12);
            make.trailing.mas_offset(-16);
            make.height.mas_offset(44);
        }];
        
        UIButton *sureReceviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureReceviBtn setTitle:TransOutput(@"确认收货") forState:UIControlStateNormal];
        sureReceviBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
        sureReceviBtn.layer.cornerRadius = 22;
        sureReceviBtn.clipsToBounds = YES;
        [sureReceviBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.sureRevClickBlock);
        }];
        [whiteView addSubview:sureReceviBtn];
        [sureReceviBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.bottom.mas_offset(-12);
            make.trailing.mas_offset(-16);
            make.height.mas_offset(44);
        }];
    }
   
    else if([self.status isEqual:@"1"]){
        //待支付
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_offset(0);
            make.height.mas_offset(124);
        }];
        
        NSInteger cha =[Tool getCompareTime:model.createTime endTime:[Tool getCurtenTimeStrWithString]];
       time = 0;
        
        NSLog(@"订单支付时间差：%ld",cha);
        
        
        self.surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.surePayBtn setTitle:TransOutput(@"确认支付") forState:UIControlStateNormal];
        if (cha  < 1800) {
            time= 1800 - cha ;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
        }
        else{
            [self.surePayBtn setTitle:TransOutput(@"确认支付") forState:UIControlStateNormal];
            
        }
        self.surePayBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
        self.surePayBtn.layer.cornerRadius = 22;
        self.surePayBtn.clipsToBounds = YES;
        @weakify(self);
        [self.surePayBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.surePayClickBlock);
        }];
        [whiteView addSubview:self.surePayBtn];
        [self.surePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.top.mas_offset(12);
            make.trailing.mas_offset(-16);
            make.height.mas_offset(44);
        }];
        
        UIButton *cancelPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelPayBtn setTitle:TransOutput(@"取消订单") forState:UIControlStateNormal];
        cancelPayBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
        cancelPayBtn.layer.cornerRadius = 22;
        cancelPayBtn.clipsToBounds = YES;
        [cancelPayBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.cancelPayClickBlock);
        }];
        [whiteView addSubview:cancelPayBtn];
        [cancelPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.bottom.mas_offset(-12);
            make.trailing.mas_offset(-16);
            make.height.mas_offset(44);
        }];
    }
    else  {
         UILabel *label = [[UILabel alloc] init];
         NSString *price = [NSString ChangePriceStr:model.actualTotal];
         NSString *str =[NSString stringWithFormat:@"%@:¥%@",TransOutput(@"实际支付"),price];
         label.textColor = RGB(0x868585);
         NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
         [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - price.length - 1, price.length + 1)];
         
         label.attributedText = att;
         label.font = [UIFont systemFontOfSize:14];
         
         label.textAlignment = NSTextAlignmentCenter;
         
         [self addSubview:label];
         [label mas_makeConstraints:^(MASConstraintMaker *make) {
             make.leading.top.trailing.bottom.mas_offset(0);
         }];
     }
}
-(void)daojishi{
    if (time > 0) {
        time --;
        NSString *str;
        if (time%60 < 10) {
            str= [NSString stringWithFormat:@"%@ %ld:0%ld",TransOutput(@"确认支付"),time/60,time%60];
        }
        else{
            str= [NSString stringWithFormat:@"%@ %ld:%ld",TransOutput(@"确认支付"),time/60,time%60];
        }
        
        [self.surePayBtn setTitle:str forState:UIControlStateNormal];

    }
    else{
        [self.timer invalidate];
        [self.surePayBtn setTitle:TransOutput(@"确认支付") forState:UIControlStateNormal];

    }
}
- (void)setRemodel:(OrderDetailInfoRefunModel *)remodel{
    _remodel = remodel;
    UILabel *label = [[UILabel alloc] init];
    NSString *price = [NSString ChangePriceStr:remodel.refundAmount];
    NSString *str =[NSString stringWithFormat:@"%@:¥%@",TransOutput(@"实际支付"),price];
    label.textColor = RGB(0x868585);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - price.length - 1, price.length + 1)];
    
    label.attributedText = att;
    label.font = [UIFont systemFontOfSize:14];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(60);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_equalTo(label.mas_bottom).offset(0);
        make.height.mas_offset(60);
    }];
    
    if ([remodel.applyType isEqual:@"2"] && [remodel.refundSts isEqual:@"2"] && remodel.expressNo.length == 0 ){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:TransOutput(@"填写物流信息") forState:UIControlStateNormal];
        button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(15);
            make.top.mas_offset(8);
            make.height.mas_offset(44);
            make.trailing.mas_offset(-15);
        }];
        @weakify(self)
        [button addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.btnClickBlock);
        }];
    }
    if ([remodel.returnMoneySts isEqual:@"1"] && [remodel.refundSts isEqual:@"1"] ){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:TransOutput(@"取消申请") forState:UIControlStateNormal];
        button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(15);
            make.top.mas_offset(8);
            make.height.mas_offset(44);
            make.trailing.mas_offset(-15);
        }];
        @weakify(self)
        [button addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.cancelApplyClickBlock);
        }];
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

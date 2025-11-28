//
//  shopUserApplyDetailView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "shopUserApplyDetailView.h"
@interface shopUserApplyDetailView ()
@property(nonatomic, strong)UIImageView *bgPic;
@property(nonatomic, strong)UIImageView *shopLog;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *desLabel;
@property(nonatomic, strong)UIButton *modyButton;
@property(nonatomic, strong)UIButton *intButton;
@property(nonatomic, strong)UIButton *addBtn;
@property(nonatomic, strong)UIView *vi;
@end
@implementation shopUserApplyDetailView
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.bgPic.userInteractionEnabled = YES;
    [self addSubview:self.bgPic];
    [self.bgPic addSubview:self.shopLog];
    [self.bgPic addSubview:self.nameLabel];
   
    [self.shopLog sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dataDic[@"shopLogo"]]]];
    self.nameLabel.text = [NSString isNullStr:dataDic[@"shopName"]];

    [self.bgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_offset(16);
        make.height.mas_offset(145 );
    }];
    [self.shopLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_offset(32);
        make.width.height.mas_offset(81);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopLog.mas_trailing).offset(25);
        make.trailing.mas_equalTo(self.bgPic.mas_trailing).offset(-12);
        make.top.mas_offset(55);
        make.height.mas_offset(35);
    }];

   
    [self.shopLog addSubview:self.vi];
    [self.vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_offset(5);
        make.trailing.bottom.mas_offset(-5);
    }];
    UIImageView *ima = [[UIImageView alloc] init];
    ima.image = [UIImage imageNamed:@"矢量 5"];
    ima.userInteractionEnabled = YES;
    [self.vi addSubview:ima];
    [ima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(33);
        make.center.mas_equalTo(self.vi);
    }];
    [self addSubview:self.modyButton];
    @weakify(self);
    [self.shopLog addTapAction:^(UIView * _Nonnull view) {
        
            @strongify(self);
            ExecBlock(self.modyShopInfoBlock);
            
        
    }];
    [self addSubview:self.intButton];
    
    [_intButton addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
        ExecBlock(self.intrBlock,[NSString isNullStr:dataDic[@"intro"]]);
    }];

    
    [self.modyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgPic.mas_bottom).offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(40);
    }];
    [self.intButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.modyButton.mas_bottom).offset(14);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(40);
    }];

}
-(UIImageView *)bgPic{
    if (!_bgPic) {
        _bgPic = [[UIImageView alloc] init];
        _bgPic.image = [UIImage imageNamed:@"组合 260"];
        _bgPic.layer.cornerRadius = 10;
        _bgPic.clipsToBounds = YES;
    }
    return _bgPic;
}
-(UIImageView *)shopLog{
    if (!_shopLog) {
        _shopLog = [[UIImageView alloc] init];
        _shopLog.layer.cornerRadius = 40.5;
        _shopLog.clipsToBounds = YES;
        _shopLog.layer.borderColor = [UIColor whiteColor].CGColor;
        _shopLog.layer.borderWidth = 5;
        _shopLog.userInteractionEnabled = YES;
    }
    return _shopLog;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:24];
        _nameLabel.textColor = [UIColor whiteColor];
      
    }
    return _nameLabel;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor  = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:10];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}
-(UIButton *)modyButton{
    if (!_modyButton) {
        _modyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _modyButton.backgroundColor = RGB(0xFCB26D);
        _modyButton.layer.cornerRadius = 5;
        _modyButton.clipsToBounds = YES;
        [_modyButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
        [_modyButton setTitle:TransOutput(@"修改基础信息") forState:UIControlStateNormal];
        [_modyButton layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        [_modyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        @weakify(self);
        [_modyButton addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.modyShopInfoBlock);
            
        }];
    }
    return _modyButton;
}
-(UIButton *)intButton{
    if (!_intButton) {
        _intButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _intButton.backgroundColor = RGB(0xFCB26D);
        _intButton.layer.cornerRadius = 5;
        _intButton.clipsToBounds = YES;
        [_intButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
        [_intButton setTitle:TransOutput(@"店铺简介") forState:UIControlStateNormal];
        [_intButton layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        [_intButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    return _intButton;
}
-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.layer.borderColor = RGB(0x197CF5).CGColor;
        _addBtn.layer.borderWidth = 1;
        _addBtn.layer.cornerRadius = 5;
        _addBtn.clipsToBounds = YES;
        [_addBtn setImage:[UIImage imageNamed:@"addLan"] forState:UIControlStateNormal];
        [_addBtn setTitle:TransOutput(@"添加商品") forState:UIControlStateNormal];
        [_addBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        [_addBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        @weakify(self);
        [_addBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.addGoodsBlock);
        }];
    }
    return _addBtn;
}
-(UIView *)vi{
    if (!_vi) {
        _vi = [[UIView alloc] init];
        _vi.backgroundColor = RGB_ALPHA(0x030303,0.3);
        _vi.layer.cornerRadius = 35.5;
        _vi.clipsToBounds = YES;
        _vi.userInteractionEnabled = YES;
    }
    return _vi;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  addressCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import "addressCell.h"
@interface addressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIButton *moAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIButton *edBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *setMo;

@end
@implementation addressCell

-(void)setModel:(addressModel *)model{
    _model = model;
    
    NSString *code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:model.postCode] substringToIndex:3],[[NSString isNullStr:model.postCode] substringFromIndex:3]];
    
    self.nameLabel.text = [NSString isNullStr:model.receiver];
    self.phoneLabel.text = [NSString isNullStr:model.mobile];
    self.addLabel.text = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:model.province],[NSString isNullStr:model.city],[NSString isNullStr:model.area],[NSString isNullStr:model.addr]];
    [self.setMo setTitle:TransOutput(@"设置为默认地址") forState:UIControlStateNormal];
    if ([model.commonAddr isEqual:@"1"]) {
        [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    }
    else{
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    }
    @weakify(self)
    [self.choseBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.choseClickBlock,model.addrId,model);
    }];
    [self.moAddBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.choseClickBlock,model.addrId,model);
    }];
    [self.delBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.delClickBlock,model.addrId,model);
    }];
    [self.edBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.editClickBlock);
    }];
}
- (IBAction)choseClick:(UIButton *)sender {
   
}
- (IBAction)moTap:(UIButton *)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

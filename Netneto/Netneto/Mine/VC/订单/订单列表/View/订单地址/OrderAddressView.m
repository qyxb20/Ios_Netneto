//
//  OrderAddressView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderAddressView.h"
@interface OrderAddressView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *wuliuBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end
@implementation OrderAddressView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)setRemodel:(OrderDetailInfoRefunModel *)remodel
{
    _remodel = remodel;
    self.nameLabel.text = [NSString isNullStr:remodel.receiver];
    self.phoneLabel.text = [NSString isNullStr:remodel.mobile];
    NSString *code;
    if ([[NSString isNullStr:remodel.postCode] length] == 0) {
        code = @"";
        
             self.addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[NSString isNullStr:remodel.province],[NSString isNullStr:remodel.city],[NSString isNullStr:remodel.area],[NSString isNullStr:remodel.addr]];
    }else{
        code= [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:remodel.postCode] substringToIndex:3],[[NSString isNullStr:remodel.postCode] substringFromIndex:3]];
   
        self.addLabel.text = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:remodel.province],[NSString isNullStr:remodel.city],[NSString isNullStr:remodel.area],[NSString isNullStr:remodel.addr]]; }
    self.wuliuBtn.hidden = YES;
}
-(void)setDetailmodel:(OrderDetailModel *)detailmodel{
    _detailmodel = detailmodel;
    addressModel *model = [addressModel mj_objectWithKeyValues:detailmodel.userAddrDto];
//
    if (detailmodel.userAddrDto.count > 0) {
        
        NSString *code;
        if ([[NSString isNullStr:model.postCode] length] ==0 ) {
            code = @"";
        }else{
            code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:model.postCode] substringToIndex:3],[[NSString isNullStr:model.postCode] substringFromIndex:3]];
        }
        self.nameLabel.text = [NSString isNullStr:model.receiver];
        self.phoneLabel.text = [NSString isNullStr:model.mobile];
        if (code.length == 0) {
            self.addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[NSString isNullStr:model.province],[NSString isNullStr:model.city],[NSString isNullStr:model.area],[NSString isNullStr:model.addr]];
        }
        else{
            self.addLabel.text = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:model.province],[NSString isNullStr:model.city],[NSString isNullStr:model.area],[NSString isNullStr:model.addr]];
        }
      
    }else{
        NSString *code;
        if ([[NSString isNullStr:detailmodel.postCode] length] ==0 ) {
            code = @"";
        }else{
            code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:detailmodel.postCode] substringToIndex:3],[[NSString isNullStr:detailmodel.postCode] substringFromIndex:3]];
        }
  
        self.nameLabel.text = [NSString isNullStr:detailmodel.receiver];
        self.phoneLabel.text = [NSString isNullStr:detailmodel.mobile];

        if (code.length == 0) {
            self.addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[NSString isNullStr:detailmodel.province],[NSString isNullStr:detailmodel.city],[NSString isNullStr:detailmodel.area],[NSString isNullStr:detailmodel.addr]];
        }
        else{
            self.addLabel.text = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:detailmodel.province],[NSString isNullStr:detailmodel.city],[NSString isNullStr:detailmodel.area],[NSString isNullStr:detailmodel.addr]];
        }
    }
    
    if ([detailmodel.status isEqual:@"3"]) {

        self.wuliuBtn.hidden = YES;
    }
    else{
        self.wuliuBtn.hidden = YES;
    }
}
-(void)setAddrmodel:(addressModel *)addrmodel{
    self.nameLabel.text = [NSString isNullStr:addrmodel.receiver];
    self.phoneLabel.text = [NSString isNullStr:addrmodel.mobile];
    NSString *code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:addrmodel.postCode] substringToIndex:3],[[NSString isNullStr:addrmodel.postCode] substringFromIndex:3]];

   
    self.addLabel.text = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:addrmodel.province],[NSString isNullStr:addrmodel.city],[NSString isNullStr:addrmodel.area],[NSString isNullStr:addrmodel.addr]];
    self.wuliuBtn.hidden = YES;
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

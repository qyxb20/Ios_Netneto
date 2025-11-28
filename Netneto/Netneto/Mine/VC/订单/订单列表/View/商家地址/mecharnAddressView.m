//
//  mecharnAddressView.m
//  Netneto
//
//  Created by apple on 2025/2/28.
//

#import "mecharnAddressView.h"
@interface mecharnAddressView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation mecharnAddressView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)setRemodel:(OrderDetailInfoRefunModel *)remodel
{
    _remodel = remodel;
    self.titleLabel.text = TransOutput(@"商家地址信息");
    
    NSString *code;
    if ([[NSString isNullStr:remodel.postCode] length] == 0) {
        code = @"";
        
        self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@%@%@%@",[NSString isNullStr:remodel.receiver], [NSString isNullStr:remodel.mobile],[NSString isNullStr:remodel.province],[NSString isNullStr:remodel.city],[NSString isNullStr:remodel.area],[NSString isNullStr:remodel.addr]];
    }else{
        code= [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:remodel.postCode] substringToIndex:3],[[NSString isNullStr:remodel.postCode] substringFromIndex:3]];
        
        self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@\n〒%@\n%@%@%@%@",[NSString isNullStr:remodel.receiver], [NSString isNullStr:remodel.mobile],code,[NSString isNullStr:remodel.province],[NSString isNullStr:remodel.city],[NSString isNullStr:remodel.area],[NSString isNullStr:remodel.addr]];
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

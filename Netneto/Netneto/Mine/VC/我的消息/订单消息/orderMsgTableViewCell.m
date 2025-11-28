//
//  orderMsgTableViewCell.m
//  Netneto
//
//  Created by apple on 2025/2/24.
//

#import "orderMsgTableViewCell.h"
@interface orderMsgTableViewCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuaidiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuaidiInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;

@end
@implementation orderMsgTableViewCell
-(void)setModel:(ImDvyMsgInfo *)model{
    _model = model;
    self.orderNumLabel.text = [NSString stringWithFormat:@"%@ %@",TransOutput(@"订单号"),model.orderNumber];
    self.shopTitleLabel.text = TransOutput(@"商品名称");
    self.shopTitleInfoLabel.text = model.prodName;
//    self.shopTitleInfoLabel.text = @"这个是商品名称文字内容、这个是商品名称文字内容、这个是商品名称文字内容";
    self.shopNumLabel.text = TransOutput(@"商品件数");
    self.shopNumInfoLabel.text = [NSString stringWithFormat:@"%d %@",model.prodCount,TransOutput(@"件")];
    self.sendTimeLabel.text = TransOutput(@"发送日时");
    self.sendTimeInfoLabel.text = model.createTime;
    self.kuaidiLabel.text = TransOutput(@"快递单号");
   
    self.kuaidiInfoLabel.text = model.dvyOrderNumber;
    [self.copBtn setTitle:TransOutput(@"复制") forState:UIControlStateNormal];
    [self.copBtn addTapAction:^(UIView * _Nonnull view) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:model.dvyOrderNumber];
        ToastShow(TransOutput(@"复制成功"), @"chenggong", RGB(0x36D053));
    }];
    
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

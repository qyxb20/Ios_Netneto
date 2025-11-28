//
//  refunOrderMsgTableViewCellTwo.m
//  Netneto
//
//  Created by apple on 2025/2/24.
//

#import "refunOrderMsgTableViewCellTwo.h"
@interface refunOrderMsgTableViewCellTwo ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTimeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *refunPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *refunPriceInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *refunBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *addNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UITextView *addressInfoTextView;

@end
@implementation refunOrderMsgTableViewCellTwo
-(void)setModel:(ImRefundMsgInfo *)model{
    _model = model;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"%@ %@",TransOutput(@"订单号"),model.orderNumber];
    self.shopTitleLabel.text = TransOutput(@"商品名称");
    self.shopTitleInfoLabel.text = model.prodName;
    self.shopNumLabel.text = TransOutput(@"商品件数");
    self.shopNumInfoLabel.text = [NSString stringWithFormat:@"%d %@",model.prodCount,TransOutput(@"件")];
    self.shopTimeLabel.text = TransOutput(@"店舗処理日時");
    self.shopTimeInfoLabel.text = model.createTime;
    self.refunPriceLabel.text = TransOutput(@"退款金额");
    self.refunPriceInfoLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:model.refundAmount]];
    if (model.refundType == 1) {
        self.statusLabel.text = TransOutput(@"仅退款");
        self.copBtn.hidden = YES;
    
    }
    else{
        self.copBtn.hidden = NO;
        self.statusLabel.text = TransOutput(@"退货退款");
       
    }
    if (model.refundStatus == 1) {
        [self.refunBtn setTitle:TransOutput(@"退款处理中") forState:UIControlStateNormal];
        [self.refunBtn setTitleColor:RGB(0xF80402) forState:UIControlStateNormal];
        self.refunBtn.layer.borderColor = RGB(0xF80402).CGColor;
        self.refunBtn.layer.borderWidth = 1;
       
    }
  else  if (model.refundStatus == 2) {
        [self.refunBtn setTitle:TransOutput(@"退款成功") forState:UIControlStateNormal];
        [self.refunBtn setTitleColor:RGB(0x34C759) forState:UIControlStateNormal];
        self.refunBtn.layer.borderColor = RGB(0x34C759).CGColor;
        self.refunBtn.layer.borderWidth = 1;
       
    }
  else{
      [self.refunBtn setTitle:TransOutput(@"退款失败") forState:UIControlStateNormal];
      [self.refunBtn setTitleColor:RGB(0xFF3350) forState:UIControlStateNormal];
      self.refunBtn.layer.borderColor = RGB(0xFF3350).CGColor;
      self.refunBtn.layer.borderWidth = 1;
  }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_addressInfoTextView setContentOffset:CGPointZero animated:NO];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

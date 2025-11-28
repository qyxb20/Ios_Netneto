//
//  MineOrderRefunTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "MineOrderRefunTableViewCell.h"


@interface MineOrderRefunTableViewCell ()
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UILabel *orderLabel;
@property(nonatomic, strong)UILabel *payLabel;
@property(nonatomic, strong)UIView *itemView;
@property(nonatomic, strong)UILabel *proNumLabel;
@property(nonatomic, strong)UILabel *reLabel;
@property(nonatomic, strong)UILabel *totalPriceLabel;
@end
@implementation MineOrderRefunTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.clipsToBounds = YES;
        self.bgView.layer.borderColor = RGB(0xE1E1E1).CGColor;
        self.bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.bgView];
        
        self.orderLabel = [[UILabel alloc] init];
        self.orderLabel.textColor = RGB(0xACABAB);
        self.orderLabel.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:self.orderLabel];
        
        self.payLabel = [[UILabel alloc] init];
        self.payLabel.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:self.payLabel];
        
      
        
        self.itemView = [[UIView alloc] init];
        [self.bgView addSubview:self.itemView];
        
       
        
        self.proNumLabel = [[UILabel alloc] init];
        self.proNumLabel.font = [UIFont systemFontOfSize:12];
        self.proNumLabel.textColor =  RGB(0xACABAB);
        [self.bgView addSubview:self.proNumLabel];
        
        self.reLabel = [[UILabel alloc] init];
        self.reLabel.font = [UIFont systemFontOfSize:16];
        self.reLabel.textColor =  RGB(0xACABAB);
        [self.bgView addSubview:self.reLabel];
        
        self.totalPriceLabel = [[UILabel alloc] init];
        self.totalPriceLabel.font = [UIFont systemFontOfSize:16];
        self.totalPriceLabel.textColor =  RGB(0xACABAB);
        [self.bgView addSubview:self.totalPriceLabel];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_offset(12);
        make.trailing.mas_offset(-16);
        make.bottom.mas_offset(0);
    }];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.top.mas_offset(8);
        make.height.mas_offset(17);
    }];
    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-12);
        make.top.mas_offset(8);
        make.height.mas_offset(17);
    }];
    
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(34);
    }];
   
    [self.proNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.bottom.mas_offset(-9);
        make.height.mas_offset(17);
    }];
    
    [self.reLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-12);
        make.bottom.mas_offset(-9);
        make.height.mas_offset(17);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-12);
        make.bottom.mas_equalTo(self.reLabel.mas_top).offset(-10);
        make.height.mas_offset(17);
    }];
    
}
- (void)setModel:(RefunOrderModel *)model
{
    _model = model;
    self.orderLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"订单编号"),model.orderNumber];
    NSString *pyStr;
    if ([model.applyType isEqual:@"1"]) {
        pyStr = TransOutput(@"仅退款");
    }
    else{
        pyStr = TransOutput(@"退货退款");
    }
    
   
           
   
    self.payLabel.text = pyStr;
    self.payLabel.textColor = RGB(0x197CF5);

    self.proNumLabel.text = @"";
    if ([model.returnMoneySts isEqual:@"3"]) {
        self.reLabel.text = TransOutput(@"退款失败");
        self.reLabel.textColor = RGB(0xDE1135);
    }
   else if ([model.returnMoneySts isEqual:@"2"]) {
        self.reLabel.text = TransOutput(@"退款成功");
       self.reLabel.textColor =RGB(0x197CF5);
    }
   else  {
       if ([model.applyType isEqual:@"2"] && [model.refundSts isEqual:@"2"] && [NSString isNullStr:model.expressName].length == 0) {
           
                self.reLabel.text = TransOutput(@"等待退货退回处理");
                self.reLabel.textColor  = RGB(0xF80402);
           
            
        }
        else{
            self.reLabel.text = TransOutput(@"退款处理中");
           self.reLabel.textColor =RGB(0xF80402);
        }
    }
    NSString *heStr = TransOutput(@"退款金额");
    NSString *price = [NSString ChangePriceStr:model.refundAmount];
    NSString *totalPriceStr = [NSString stringWithFormat:@"%@:¥%@",heStr,price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:totalPriceStr];
    [priceAtt addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(heStr.length+1, price.length + 1)];
    self.totalPriceLabel.attributedText = priceAtt;
    
    for (int i = 0 ; i <model.orderItems.count; i++) {
        
        RefunOrderModel *itemModel = [RefunOrderModel mj_objectWithKeyValues:model.orderItems[i]];
        MineOrderItemView *vi = [MineOrderItemView initViewNIB];
//        vi.frame = CGRectMake(0, 98 * i, WIDTH - 32, 98);
        vi.refModel = itemModel;
        
        vi.layer.cornerRadius = 5;
        vi.clipsToBounds = YES;
        vi.layer.borderColor = RGB(0xE1E1E1).CGColor;
        vi.layer.borderWidth = 0.5;
        [self.itemView addSubview:vi];
        [vi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.height.mas_offset(98);
            make.top.mas_offset(98 * i);
        }];
    }

    
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

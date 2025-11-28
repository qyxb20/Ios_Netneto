//
//  MineOrderChildTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "MineOrderChildTableViewCell.h"
@interface MineOrderChildTableViewCell ()
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UILabel *orderLabel;
@property(nonatomic, strong)UILabel *payLabel;
@property(nonatomic, strong)UIView *itemView;
@property(nonatomic, strong)UILabel *proNumLabel;
@property(nonatomic, strong)UILabel *totalPriceLabel;

@end
@implementation MineOrderChildTableViewCell
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
        make.bottom.mas_offset(-34);
    }];
   
    [self.proNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.bottom.mas_offset(-9);
        make.height.mas_offset(17);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-12);
        make.bottom.mas_offset(-9);
        make.height.mas_offset(17);
    }];
    
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    self.orderLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"订单编号"),model.orderNumber];
    NSString *pyStr;
    UIColor *color;
    switch ([model.status intValue]) {
        case 6:
            pyStr = TransOutput(@"订单关闭");
            color = RGB(0xACABAB);
            break;
        case 5:
            pyStr = TransOutput(@"已完成");
            color = RGB(0xACABAB);
            break;
        
        case 3:
            pyStr = TransOutput(@"待收货");
            color = RGB(0xF80402);
            break;
        case 2:
            if ([model.refundSts isEqual:@"1"]) {
                pyStr = TransOutput(@"店舗処理中");
                color = RGB(0x197CF5);
               
                
            }else{
                pyStr = TransOutput(@"待发货");
                color = RGB(0x197CF5);
            }
            break;
        case 1:
            pyStr = TransOutput(@"待支付");
            color = RGB(0xF80402);
            break;
        default:
            break;
    }
   
    self.payLabel.text = pyStr;
    self.payLabel.textColor = color;
    NSString *numStrheader = TransOutput(@"共计");
    NSString *numStrfooter = TransOutput(@"件商品");
    NSString *str = [NSString stringWithFormat:@"%@%@%@",numStrheader,model.productNums,numStrfooter];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:str];
    [atts addAttributes:@{NSForegroundColorAttributeName:RGB(0x197CF5)} range:NSMakeRange(numStrheader.length, model.productNums.length)];
    self.proNumLabel.attributedText = atts;
    
    NSString *heStr = TransOutput(@"合计:");
    NSString *price = [NSString ChangePriceStr:model.actualTotal];
    NSString *totalPriceStr = [NSString stringWithFormat:@"%@¥%@",heStr,price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:totalPriceStr];
    [priceAtt addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(heStr.length, price.length + 1)];
    self.totalPriceLabel.attributedText = priceAtt;
    if (model.reduceAmount > 0 ) {
        
        self.fanJinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
        [self.fanJinBtn setTitle:TransOutput(@"申请退款") forState:UIControlStateNormal];
        [self.fanJinBtn setTitleColor:RGB(0x646464) forState:UIControlStateNormal];
        self.fanJinBtn.layer.cornerRadius = 3;
        self.fanJinBtn.clipsToBounds = YES;
        self.fanJinBtn.layer.borderColor = RGB(0xE7E7E7).CGColor;
        self.fanJinBtn.layer.borderWidth = 1;
        self.fanJinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.fanJinBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.bgView addSubview:self.fanJinBtn];
        [self.fanJinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-17);
            make.height.mas_offset(20);
            make.trailing.mas_offset(-8);
        }];
        
        if (  [model.status intValue] == 2 || [model.status intValue] == 5) {
            if ( [model.refundSts isEqual:@"1"]){
                self.fanJinBtn.hidden = YES;
                [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-34);
                }];
                
                [self.proNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-9);
                }];
                [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-9);
                }];
            }else{
                self.fanJinBtn.hidden = NO;
                [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-74);
                }];
                
                [self.proNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-49);
                }];
                [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-49);
                }];
            }
        }
        else if([model.status intValue] == 6||[model.status intValue]  == 3 ||[model.status intValue]  == 1){
            self.fanJinBtn.hidden = YES;
            [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-34);
            }];
            
            [self.proNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-9);
            }];
            [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-9);
            }];
        }
        else{
            self.fanJinBtn.hidden = NO;
            [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-74);
            }];
            
            [self.proNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-49);
            }];
            [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-49);
            }];
        }
    }
    for (int i = 0 ; i <model.orderItemDtos.count; i++) {
        OrderModel *itemModel = [OrderModel mj_objectWithKeyValues:model.orderItemDtos[i]];
        MineOrderItemView *vi = [MineOrderItemView initViewNIB];
//        vi.frame = CGRectMake(0, 98 * i, WIDTH - 32, 98);
        vi.status = model.status;
        vi.reduceAmount = model.reduceAmount;
        vi.model = itemModel;
        vi.isDetail = NO;
        vi.layer.cornerRadius = 5;
        vi.clipsToBounds = YES;
        vi.layer.borderColor = RGB(0xE1E1E1).CGColor;
        vi.layer.borderWidth = 0.5;
        
        [self.itemView addSubview:vi];
         @weakify(self);
        [vi setPushAddComBlock:^(OrderModel * _Nonnull model) {
           //添加评论;
            @strongify(self);
            ExecBlock(self.pushComAddBlock,model);
        }];
        
        [vi setRefunApplyBlock:^(OrderModel * _Nonnull model) {
            //申请退款
            @strongify(self);
            ExecBlock(self.applyTuiBlock,model);
        }];
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

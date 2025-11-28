//
//  ShoppingCartCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import "ShoppingCartCell.h"
const CGFloat ShoppingCartCellHeight = 108;
NSString *const ShoppingCartCellReuserIdentifier = @"ShoppingCartCell";

@interface ShoppingCartCell () <BEMCheckBoxDelegate, PPNumberButtonDelegate>

@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *specificationLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *sukNumLabel;
@property (nonatomic, strong) PPNumberButton *numberButton;
@property (nonatomic, strong) UILabel *limitSumLabel;

@end
@implementation ShoppingCartCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.checkBox];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.specificationLabel];
    [self.contentView addSubview:self.sukNumLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.numberButton];
    [self.contentView addSubview:self.delBtn];

    // 单选按钮
    CGFloat padding = 12.0f;
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 商品图片,Vertical: |-10-88-10-|
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(10);
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(88, 88));
        make.bottom.mas_equalTo(self.contentView).with.offset(-10);
    }];
    
    // 商品名称
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(padding);
        make.left.mas_equalTo(self.goodsImageView.mas_right).with.offset(padding);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-padding);
    }];
    
    // 商品规格
    [self.specificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(6);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.nameLabel);
    }];
    [self.sukNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.specificationLabel.mas_bottom).with.offset(6);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.nameLabel);
    }];
    // 商品价格
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodsImageView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    // 商品购买数量
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-padding);

        make.bottom.mas_offset(-32);
        make.size.mas_equalTo(CGSizeMake(90, 22));
    }];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-padding);
        make.bottom.mas_equalTo(self.numberButton.mas_top).offset(-10);
        make.width.height.mas_offset(25);
    }];

}
-(UILabel *)limitSumLabel{
    if (!_limitSumLabel) {
        _limitSumLabel = [[UILabel alloc] init];
        _limitSumLabel.font = [UIFont systemFontOfSize:10];
        _limitSumLabel.textColor = RGB(0x838383);
        _limitSumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _limitSumLabel;
}
-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:[UIImage imageNamed:@"elements"] forState:UIControlStateNormal];
        @weakify(self)
        [_delBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.delBlock) {
                self.delBlock(self.goods.basketId);
                
            }
        }];
    }
    return _delBtn;
}
#pragma mark - Custom Accessors

- (BEMCheckBox *)checkBox {
    if (!_checkBox) {
        _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        // 外观属性
        _checkBox.lineWidth = 1.0;
        // 颜色样式
        _checkBox.tintColor = [UIColor lightGrayColor];
        _checkBox.onTintColor = RGB(0xFF3B30);
        _checkBox.onFillColor = RGB(0xFF3B30);
        _checkBox.onCheckColor = [UIColor whiteColor];
        // 动画样式
        _checkBox.onAnimationType = BEMAnimationTypeBounce;
        _checkBox.offAnimationType = BEMAnimationTypeBounce;
        _checkBox.animationDuration = 0.1;
        _checkBox.minimumTouchSize = CGSizeMake(25, 25);
        _checkBox.delegate = self;
    }
    return _checkBox;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageView.image = [UIImage imageNamed:@"goods_placeholder"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)specificationLabel {
    if (!_specificationLabel) {
        _specificationLabel = [[UILabel alloc] init];
        _specificationLabel.font = [UIFont systemFontOfSize:12.0f];
        _specificationLabel.textColor = [UIColor grayColor];
    }
    return _specificationLabel;
}
-(UILabel *)sukNumLabel{
    if (!_sukNumLabel) {
        _sukNumLabel = [[UILabel alloc] init];
        _sukNumLabel.font = [UIFont systemFontOfSize:12.0f];
        _sukNumLabel.textColor = [UIColor grayColor];
    }
    return _sukNumLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
       
    }
    return _priceLabel;
}

- (PPNumberButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectZero];
        _numberButton.backgroundColor = [UIColor whiteColor];
        _numberButton.borderColor = [UIColor whiteColor];
        _numberButton.increaseImage = [UIImage imageNamed:@"add-01"];
        _numberButton.decreaseImage = [UIImage imageNamed:@"munus"];
        _numberButton.currentNumber = 1;
        _numberButton.editing = YES;
        _numberButton.isCar = YES;
        _numberButton.delegate = self;
        [_numberButton setTipBlock:^(NSString *str) {

                ToastShow(TransOutput(str), errImg,RGB(0xFF830F));

        }];
    }
    return _numberButton;
}

- (void)setGoods:(ShopCarModel *)goods {
    _goods = goods;
    
    // 商品选中状态
    [self.checkBox setOn:self.goods.selectedState.boolValue];
    
    // 商品图片
    UIImage *placeHolderImage = [UIImage imageNamed:@"goods_placeholder"];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods.pic] placeholderImage:placeHolderImage];
   
    
    // 商品标题
    self.nameLabel.text = goods.prodName;
    
    // 商品规格
    self.specificationLabel.text = goods.skuName;
    self.sukNumLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),goods.stocks];
    // 商品价格
    [self.priceLabel netneto_setAttributedTextWithGoodsPrice:goods.price.floatValue];
    self.priceLabel.textColor = RGB(0xF80402);
    // 商品数量
 
            self.numberButton.currentNumber = goods.prodCount.intValue;
       
    self.numberButton.minValue = 1;
    self.numberButton.stockValue = goods.stocks.intValue;
    self.numberButton.limValue = goods.limitSum.intValue;
    if (goods.stocks.intValue == -1 && goods.limitSum.intValue == 0) {
        self.numberButton.maxValue = 999999999999;
        self.limitSumLabel.text = @"";
    }else{
        if (goods.prodCount.intValue <= goods.stocks.intValue) {
            if (goods.stocks.intValue < goods.limitSum.intValue) {
                self.numberButton.maxValue = goods.stocks.intValue;
                self.limitSumLabel.text = @"";

//                
            }
            else{
                
                if (goods.limitSum.intValue != 0) {
                    self.numberButton.maxValue = goods.limitSum.intValue;
                    self.limitSumLabel.text =[NSString stringWithFormat:@"(1回の購入は%d点まで)",goods.limitSum.intValue];
                }else{
                    self.numberButton.maxValue = goods.stocks.intValue;
                    self.limitSumLabel.text = @"";
                }
            }
        }else{
            self.numberButton.maxValue = goods.prodCount.intValue;
            if (goods.limitSum.intValue != 0) {
                self.limitSumLabel.text =[NSString stringWithFormat:@"(1回の購入は%d点まで)",goods.limitSum.intValue];
            }
        }
    }
  
}
-(void)updateNumBer:(NSInteger)page{
    self.numberButton.currentNumber = page;
}
#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <BEMCheckBoxDelegate>

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    NSLog(@"勾选：%d",checkBox.on);
    self.goods.selectedState = @(checkBox.on);
    if (self.selectGoodsBlock) {
        self.selectGoodsBlock(checkBox.on,self.goods);
    }
}

#pragma mark - <PPNumberButtonDelegate>
-(void)pp_CustomNumberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
   
    ExecBlock(self.customNumberClickBlock,self.goods,number);
}
- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus {
    
    if (self.updateNumberClickBlock) {
        if (increaseStatus) {
            ExecBlock(self.updateNumberClickBlock,self.goods,number,self.numberButton.currentNumber-1);
        }
        else{
            ExecBlock(self.updateNumberClickBlock,self.goods,number,self.numberButton.currentNumber + 1);
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end

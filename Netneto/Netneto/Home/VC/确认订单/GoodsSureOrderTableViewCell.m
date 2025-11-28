//
//  GoodsSureOrderTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import "GoodsSureOrderTableViewCell.h"

@implementation GoodsSureOrderTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        }
    
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSArray *arrs =dataDic[@"shopCartItemDiscounts"];

    NSArray *arr =arrs.firstObject[@"shopCartItems"];
    
    self.backgroundColor =RGB(0xF9F9F9);
    self.contentView.backgroundColor =RGB(0xF9F9F9);
   
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(15);

        make.bottom.mas_offset(0);
    }];
    
    for (int i = 0 ; i <arr.count; i++) {
        OrderModel *itemModel = [OrderModel mj_objectWithKeyValues:arr[i]];
        MineOrderItemView *vi = [MineOrderItemView initViewNIB];
        
        vi.status = @"";
        vi.model = itemModel;
        vi.layer.cornerRadius = 5;
        vi.clipsToBounds = YES;
        vi.layer.borderColor = RGB(0xE1E1E1).CGColor;
        vi.layer.borderWidth = 0.5;
        [bgView addSubview:vi];
        [vi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.height.mas_offset(98);
            make.top.mas_offset(98 * i );
        }];
    }
    
    
    
    self.tx = [[UITextView alloc] init];
    self.tx.layer.cornerRadius = 5;
    self.tx.clipsToBounds = YES;
    self.tx.layer.borderWidth = 0.5;
    self.tx.layer.borderColor = RGB(0xCACACA).CGColor;
    self.tx.font = [UIFont systemFontOfSize:14];
    [self.tx setPlaceholderWithText:TransOutput(@"备注(最多输入200个字)") Color:RGB(0xCACACA)];
    [bgView addSubview:self.tx];
    self.tx.delegate = self;
    
    [self.tx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(10);
        make.trailing.mas_offset(-10);
        make.bottom.mas_offset(-10);
        make.height.mas_offset(100);
    }];
    if ([dataDic[@"coupons"] count] > 0) {
        UIView *quanView = [[UIView alloc] init];
        [bgView addSubview:quanView];
        [quanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(10);
            make.trailing.mas_offset(-10);
            make.bottom.mas_equalTo(self.tx.mas_top).offset(-10);
            make.height.mas_offset(40);
        }];
        @weakify(self);
        [quanView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self pushShow];
        }];
        CGFloat ws = [Tool getLabelWidthWithText:TransOutput(@"优惠券金额") height:20 font:12];
        UILabel *quanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ws, 20)];
        quanLabel.text = TransOutput(@"优惠券金额");
        quanLabel.font = [UIFont systemFontOfSize:12];
        [quanView addSubview:quanLabel];
        NSDictionary *dic;
        
        self.quanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 0;
        if ([dataDic[@"coupon"] isKindOfClass:[NSDictionary class]]) {
            dic= dataDic[@"coupon"];
            self.couponDic = dic;
            NSString *price = [NSString ChangePriceStr:[NSString stringWithFormat:@"%@",self.dataDic[@"couponReduce"]]];

            NSString *str = [NSString stringWithFormat:@"%@%@",TransOutput(@"¥"),price];
            w = [Tool getLabelWidthWithText:str height:22 font:14] +10;
            [self.quanBtn setTitle:str forState:UIControlStateNormal];
            [self.quanBtn setTitleColor:RGB(0xF80402) forState:UIControlStateNormal];
            
        }
        else{
           w = [Tool getLabelWidthWithText:TransOutput(@"去选择") height:22 font:14] + 10;
            self.couponDic = @{};
            [self.quanBtn setTitle:TransOutput(@"去选择") forState:UIControlStateNormal];
            [self.quanBtn setTitleColor:RGB(0x585757) forState:UIControlStateNormal];
            
            
        }
        
       
        [self.quanBtn.titleLabel setFont: [UIFont systemFontOfSize:14]];
        
        [self.quanBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self pushShow];
        }];

        [quanView addSubview:self.quanBtn];
        [self.quanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-20);
            make.bottom.mas_offset(-9);
            make.height.mas_offset(22);
            make.width.mas_offset(w);
            
        }];
        
        
        UIImageView *button = [[UIImageView alloc] init];
        button.image =[UIImage imageNamed:@"push"];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self pushShow];
        }];

        [quanView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.trailing.mas_offset(0);
           make.bottom.mas_offset(-11);
           make.height.mas_offset(15);
            make.width.mas_offset(15);
       }];
    }
   
}

-(void)pushShow{
    
    ExecBlock(self.couponClickBlock,self.dataDic[@"coupons"],self.couponDic);
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        NSUInteger newLength = textView.text.length + text.length - range.length;
       
        
        return newLength <= 200;

  
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

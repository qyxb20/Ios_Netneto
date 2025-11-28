//
//  MineHeaderView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import "MineHeaderView.h"
@interface MineHeaderView ()
{
    NSInteger num;
    NSInteger Lnum;
    NSInteger Xnum;
}
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UIImageView *whiteView;
@property(nonatomic, strong)UIImageView *orderImageView;
@property(nonatomic, strong)UIImageView *btnBgImageView;
@property(nonatomic, strong)UIButton *btnColl;
@property(nonatomic, strong)UIButton *btnMsg;
@property(nonatomic, strong)UIButton *btnFoot;
//
@end
@implementation MineHeaderView

-(void)updateMsg{
      if (account.isLogin) {
          if (account.userInfo.userId.length > 0 ) {
              [NetwortTool getfindImCountsWithParm:@{@"userId":account.userInfo.userId} Success:^(id  _Nonnull responseObject) {
                  
                  NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%ld\n%@",(long)[responseObject integerValue],TransOutput(@"我的消息")] titleStr:TransOutput(@"我的消息")];
                  [self.btnMsg setAttributedTitle:msgAtt forState:UIControlStateNormal];
              } failure:^(NSError * _Nonnull error) {
                  
              }];
          }
          else{
              NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%d\n%@",0,TransOutput(@"我的消息")] titleStr:TransOutput(@"我的消息")];
              [self.btnMsg setAttributedTitle:msgAtt forState:UIControlStateNormal];
          }
    }
    else{
        NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%d\n%@",0,TransOutput(@"我的消息")] titleStr:TransOutput(@"我的消息")];
        [self.btnMsg setAttributedTitle:msgAtt forState:UIControlStateNormal];
    }
        
    
}
-(void)updateFoot{
   
    if (account.isLogin) {
        [NetwortTool getBorwsingHistoryCountWithParm:@{} Success:^(id  _Nonnull responseObject) {

                NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%ld\n%@",(long)[responseObject[@"borwsingHistoryCount"] integerValue],TransOutput(@"我的足迹")] titleStr:TransOutput(@"我的足迹")];
                [self.btnFoot setAttributedTitle:msgAtt forState:UIControlStateNormal];
           
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    else{
        NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%d\n%@",0,TransOutput(@"我的足迹")] titleStr:TransOutput(@"我的足迹")];
        [self.btnFoot setAttributedTitle:msgAtt forState:UIControlStateNormal];
    }
        
}
-(void)updateCollect{
    
    
      if (account.isLogin) {
        [NetwortTool getCollNumListWithParm:@{} Success:^(id  _Nonnull responseObject) {
            [self checkShopUp:[responseObject integerValue]];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    else{
        NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%d\n%@",0,TransOutput(@"我的收藏")] titleStr:TransOutput(@"我的收藏")];
        [self.btnColl setAttributedTitle:msgAtt forState:UIControlStateNormal];
    }
        

}

-(void)checkShopUp:(NSInteger)num{
    [NetwortTool getCollNumShopWithParm:@{} Success:^(id  _Nonnull responseObject) {
         
        NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%ld\n%@",(long)(num + [responseObject integerValue]),TransOutput(@"我的收藏")] titleStr:TransOutput(@"我的收藏")];
        [self.btnColl setAttributedTitle:msgAtt forState:UIControlStateNormal];
    } failure:^(NSError * _Nonnull error) {
       
    }];
}


-(void)CreateView{
    
//    [self CreateViewUI:0];
    [self addSubview:self.bgHeaderView];
    [self addSubview:self.whiteView];
    [self addSubview:self.orderImageView];
    [self addSubview:self.avatarBtn];
    [self addSubview:self.nameLabel];
    [self addSubview:self.typeImageView];
    [self addSubview:self.btnBgImageView];
   
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(177);
    }];

    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(164);
        make.height.mas_offset(47);
    }];
   
    [self.orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(7);
        make.height.mas_offset(165);
    }];
    [self.btnBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.orderImageView.mas_bottom).offset(12);
        make.height.mas_offset(76);
    }];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(67);
        make.leading.mas_offset(37.5);
        make.width.height.mas_offset(70);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarBtn.mas_trailing).offset(10);
        make.top.mas_offset(64);
       
    }];
    CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"商家") height:24 font:14];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarBtn.mas_trailing).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
        make.height.mas_offset(24);
        make.width.mas_offset(w + 20);
    }];
    
    UILabel *myOrder = [[UILabel alloc] init];
    myOrder.text = TransOutput(@"我的订单");
    myOrder.font = [UIFont fontWithName:@"Source Han Sans SC" size:14];
    [self.orderImageView addSubview:myOrder];
    [myOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(18);
        make.top.mas_offset(9);
        make.height.mas_offset(20);
    }];
    UIButton *allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allOrderBtn setTitle:TransOutput(@"查看订单") forState:UIControlStateNormal];
    [allOrderBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [allOrderBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    
    [allOrderBtn setTitleColor:RGB(0xACABAB) forState:UIControlStateNormal];
    [allOrderBtn.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:14]];
    [self.orderImageView addSubview:allOrderBtn];
    @weakify(self)
    [allOrderBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.pushOrderBlock,1000);
    }];
    [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(9);
        make.trailing.mas_offset(-18);
        make.height.mas_offset(20);
    }];
    
    NSArray *buttonArr = @[@{@"img":@"组合 241",@"title":TransOutput(@"待支付")},
                           @{@"img":@"组合 242",@"title":TransOutput(@"待发货")},
                           @{@"img":@"组合 243",@"title":TransOutput(@"待收货")},
                           @{@"img":@"组合 244",@"title":TransOutput(@"已完成")}];
    CGFloat btnW = (WIDTH - 32 - 90) / 4;
    for (int i = 0; i <buttonArr.count; i++) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(18 + (18 + btnW) * i, 46, btnW , btnW +35)];
//
        vi.tag = i;
        @weakify(self)
        [vi addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.pushOrderBlock,i);
        }];
        [self.orderImageView addSubview: vi];
        
        UIImageView *button = [[UIImageView alloc] init];
        button.image =[UIImage imageNamed:buttonArr[i][@"img"]];
        button.frame = CGRectMake(0, 0, btnW , btnW);
        button.userInteractionEnabled = YES;
        [vi addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btnW + 5, btnW, 35)];
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = buttonArr[i][@"title"];
        [vi addSubview:titleLabel];
//        
     
    }
    
    
    NSArray *buttonArr2 = @[@{@"title":TransOutput(@"我的收藏"),@"num":@(0)},
                            @{@"title":TransOutput(@"我的消息"),@"num":@(0)},
                            @{@"title":TransOutput(@"我的足迹"),@"num":@(0)}];
//收藏
    self.btnColl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnColl.frame =CGRectMake((WIDTH - 16*buttonArr2.count) /buttonArr2.count *0 , 0, (WIDTH - 16*buttonArr2.count) /buttonArr2.count, 76);
    self.btnColl.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    NSMutableAttributedString *collAtt = [self getAttStr:[NSString stringWithFormat:@"%@\n%@",buttonArr2[0][@"num"],buttonArr2[0][@"title"]] titleStr:buttonArr2[0][@"title"]];
    self.btnColl.tag = 0;
    self.btnColl.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.btnColl setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
    [self.btnColl setAttributedTitle:collAtt forState:UIControlStateNormal];
    self.btnColl.titleLabel.numberOfLines = 2;
    self.btnColl.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnBgImageView addSubview:self.btnColl];
   
    [self.btnColl addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.buttonBlock,view.tag);
    }];
 //私信
    self.btnMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMsg.frame =CGRectMake((WIDTH - 16*buttonArr2.count) /buttonArr2.count , 0, (WIDTH - 16*buttonArr2.count) /buttonArr2.count, 76);
    self.btnMsg.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    NSMutableAttributedString *msgAtt = [self getAttStr:[NSString stringWithFormat:@"%@\n%@",buttonArr2[1][@"num"],buttonArr2[1][@"title"]] titleStr:buttonArr2[1][@"title"]];
    self.btnMsg.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.btnMsg setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
    self.btnMsg.tag = 1;
    [self.btnMsg setAttributedTitle:msgAtt forState:UIControlStateNormal];
    self.btnMsg.titleLabel.numberOfLines = 2;
    self.btnMsg.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnBgImageView addSubview:self.btnMsg];
   
    [self.btnMsg addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.buttonBlock,view.tag);
    }];
    
    //浏览记录
    self.btnFoot = [UIButton buttonWithType:UIButtonTypeCustom];
       self.btnFoot.frame =CGRectMake((WIDTH - 16*buttonArr2.count) /buttonArr2.count *2 , 0, (WIDTH - 16*buttonArr2.count) /buttonArr2.count, 76);
       self.btnFoot.titleLabel.font = [UIFont boldSystemFontOfSize:24];
       NSMutableAttributedString *footAtt = [self getAttStr:[NSString stringWithFormat:@"%@\n%@",buttonArr2[2][@"num"],buttonArr2[2][@"title"]] titleStr:buttonArr2[2][@"title"]];
    self.btnFoot.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.btnFoot setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
       self.btnFoot.tag = 2;
       [self.btnFoot setAttributedTitle:footAtt forState:UIControlStateNormal];
       self.btnFoot.titleLabel.numberOfLines = 2;
       self.btnFoot.titleLabel.textAlignment = NSTextAlignmentCenter;
       [self.btnBgImageView addSubview:self.btnFoot];
      
       [self.btnFoot addTapAction:^(UIView * _Nonnull view) {
           @strongify(self);
           ExecBlock(self.buttonBlock,view.tag);
       }];
       
    
     
    
//    [self loadData];
}
-(NSMutableAttributedString *)getAttStr:(NSString *)str titleStr:(NSString *)titleStr{
//    NSString *str =[NSString stringWithFormat:@"%@\n%@",buttonArr2[i][@"num"],buttonArr2[i][@"title"]];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:RGB(0x797878),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(str.length - [titleStr length], [titleStr length])];
    return attstr;
    
}
-(UIImageView *)btnBgImageView{
    if (!_btnBgImageView) {
        _btnBgImageView =[[UIImageView alloc] init];
        _btnBgImageView.image = [UIImage imageNamed:@"矩形 1447-2"];
        _btnBgImageView.userInteractionEnabled = YES;
    }
    return _btnBgImageView;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.backgroundColor = [UIColor gradientColorArr:@[RGB(0x0060FD),RGB(0x009FFD)] withWidth:WIDTH];
        _bgHeaderView.contentMode = UIViewContentModeScaleToFill;
        _bgHeaderView.image = [UIImage imageNamed:@"组合 245"];
        
    }
    return _bgHeaderView;
}

-(UIImageView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIImageView alloc] init];
        _whiteView.image = [UIImage imageNamed:@"矩形 1447"];
        _whiteView.userInteractionEnabled = YES;
    }
    return _whiteView;
}
-(UIImageView *)orderImageView{
    if (!_orderImageView) {
        _orderImageView = [[UIImageView alloc] init];
        _orderImageView.image = [UIImage imageNamed:@""];
        _orderImageView.userInteractionEnabled = YES;
    }
    return _orderImageView;
}

-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.layer.cornerRadius = 35;
        _avatarBtn.clipsToBounds = YES;
        _avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarBtn.layer.borderWidth = 5;
        
        @weakify(self);
        [_avatarBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
             ExecBlock(self.loginBlock);
        }];
    }
    return _avatarBtn;
}
-(UIButton *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameLabel.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [_nameLabel setTitleColor:RGB(0xFFFCA6) forState:UIControlStateNormal];
        @weakify(self);
        [_nameLabel addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
             ExecBlock(self.loginBlock);
        }];
    }
    return _nameLabel;
}
-(UIButton *)typeImageView{
    if (!_typeImageView) {
        _typeImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeImageView.layer.cornerRadius = 12;
        _typeImageView.clipsToBounds = YES;
        _typeImageView.titleLabel.font = [UIFont systemFontOfSize:14];
        [_typeImageView setTitle:TransOutput(@"商家") forState:UIControlStateNormal];
        _typeImageView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xEA8A2F),RGB(0xEFB675)] withWidth:157];
    }
    return _typeImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

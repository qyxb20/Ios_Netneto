//
//  HomeQuanView.m
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import "HomeQuanView.h"
@interface HomeQuanView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic, strong)NSMutableArray *indexPathArr;

@end
@implementation HomeQuanView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
   
   
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    self.titleLabel.text = TransOutput(@"优惠券");
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    self.indexPathArr = [NSMutableArray array];
    [self.tableVIew reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GouponChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GouponChildTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GouponChildTableViewCell" owner:self options:nil].lastObject;
    }
    
    NSDictionary *itemDic = self.dataArray[indexPath.row];
    cell.img1.image = [UIImage imageNamed:@"矩形 5127-2"];
    cell.img2.image = [UIImage imageNamed:@"矩形 5128-2"];
    cell.nameLabel.textColor = RGB(0xFF3344);
    cell.title.textColor = RGB(0x333333);
    cell.timeLabel.textColor = RGB(0xFF3344);
    if ([itemDic[@"isReceive"] intValue] == 0) {
        cell.lingBtn.backgroundColor = RGB(0xFF3344);
        cell.lingBtn.layer.borderColor = [UIColor clearColor].CGColor;
        cell.lingBtn.layer.borderWidth = 0;
        [cell.lingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.lingBtn setTitle:TransOutput(@"立即领取") forState:UIControlStateNormal];
        cell.lingBtn.tag = indexPath.row;
        [cell.lingBtn addTarget:self action:@selector(lingCouponClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.lingBtn.backgroundColor = [UIColor clearColor];
        cell.lingBtn.layer.borderColor = RGB(0xFF3344).CGColor;
        cell.lingBtn.layer.borderWidth = 0;
        [cell.lingBtn setTitleColor:RGB(0xFF3344) forState:UIControlStateNormal];
        
        [cell.lingBtn setTitle:TransOutput(@"已领取") forState:UIControlStateNormal];
    }
    NSString *price = [NSString ChangePriceStr:[NSString stringWithFormat:@"%@",itemDic[@"value"]]];

    if ([itemDic[@"type"] intValue] == 2) {

        NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text = str;
    }
    
  else  if ([itemDic[@"type"] intValue] == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text =str;
      
    }
    
  else{
      NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,@"%"];
      cell.nameLabel.text =str;

  }
    cell.timeLabel.text = [NSString stringWithFormat:@"%@%@",itemDic[@"endTime"],TransOutput(@"到期")];
    cell.title.text = itemDic[@"name"];
   
    cell.desLabel.text =itemDic[@"description"];
    if ([_indexPathArr containsObject:indexPath]) {
        [cell openCell:YES];
        [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
        [cell.indureBtn setImage:[UIImage imageNamed:@"path-29"] forState:UIControlStateNormal];
        [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    }else {
        [cell openCell:NO];
        [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
        [cell.indureBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
        [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    }
    
    
    __block UITableView *tempTable = _tableVIew;
       __block NSIndexPath *tempIndexPath = indexPath;
    @weakify(self);
       cell.moreInfo = ^(BOOL open){
           @strongify(self);
           if (open) {
               [self.indexPathArr addObject:tempIndexPath];
           }else
           {
               [self.indexPathArr removeObject:tempIndexPath];
           }
           [tempTable reloadData];
       };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma mark - 领取优惠券
-(void)lingCouponClick:(UIButton *)sender{
    if (!account.isLogin) {
        
        ExecBlock(self.loginClickBlock);
        return;
    }
    NSDictionary *itemDic = self.dataArray[sender.tag];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:itemDic];
    
    [NetwortTool getCouponsWithParm:@{@"couponId":itemDic[@"couponId"]} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"领取成功"), @"chenggong", RGB(0x36D053));
                    [dataDic setObject:@"1" forKey:@"isReceive"];
                    [self.dataArray replaceObjectAtIndex:sender.tag withObject:dataDic];

            [self.tableVIew reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updataCoupon" object:nil userInfo:nil];

        });
        } failure:^(NSError * _Nonnull error) {
            
        }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //这里应该做高度缓存的，我这里只是demo就省略了，你自己做高度缓存
    
    if ([_indexPathArr containsObject:indexPath]) {
        NSDictionary *itemDic = self.dataArray[indexPath.row];
        
        CGFloat h = [Tool getLabelHeightWithText:itemDic[@"description"] width:WIDTH - 58 font:8];
        
        return 120 + h;
    }else {
        return 93;
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

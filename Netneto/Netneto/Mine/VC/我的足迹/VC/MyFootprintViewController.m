//
//  MyFootprintViewController.m
//  Netneto
//
//  Created by apple on 2024/11/18.
//

#import "MyFootprintViewController.h"

@interface MyFootprintViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) NothingView *nothingView;

@end

@implementation MyFootprintViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
}


-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
  
    
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的足迹");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(HeightNavBar + 16);
        make.bottom.mas_offset(-10);
    }];

}
#pragma mark -获取浏览记录数据
-(void)loadData{
    [HudView showHudForView:self.view];
    [NetwortTool getBorwsingHistoryWithParm:@{@"userId":account.userInfo.userId,@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
        NSLog(@"获取浏览记录数据：%@",responseObject);
        [HudView hideHudForView:self.view];
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:responseObject[@"records"]];
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
      
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
      }
      else{
          self.tableView.backgroundView = nil;
      }
        
       
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
    }];
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyFootprintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFootprintTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyFootprintTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.whiteView.layer.cornerRadius = 5;
    cell.whiteView.clipsToBounds = YES;
    cell.whiteView.layer.borderColor = rgb(225, 225, 225).CGColor;
    cell.whiteView.layer.borderWidth = 0.5;
    cell.timeLabel.text = [NSString isNullStr:dic[@"clickDate"]];
    [cell.pic sd_setImageWithURL: [NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    cell.pic.layer.cornerRadius = 5;
    cell.pic.clipsToBounds = YES;
    cell.nameLabel.text = [NSString isNullStr:dic[@"prodName"]];
    cell.numLabel.text = [NSString stringWithFormat:@"%@：%@",TransOutput(@"浏览次数"),[NSString isNullStr:dic[@"clickCount"]]];
  
    if ([dic[@"nowPrice"] floatValue] != [dic[@"nowOriPrice"] floatValue]) {
        
        cell.priceLabel.textColor = RGB(0xF80402);
        NSString *priceStr =[NSString stringWithFormat:@"¥%@ %@\n¥%@ %@",[NSString ChangePriceStr:dic[@"nowPrice"]],TransOutput(@"含税"),[NSString ChangePriceStr:dic[@"nowOriPrice"]],TransOutput(@"含税")];
        NSString *oldPriceStr =[NSString stringWithFormat:@"¥%@ %@",[NSString ChangePriceStr:dic[@"nowOriPrice"]],TransOutput(@"含税")];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange([[NSString ChangePriceStr:dic[@"nowPrice"]] length] + 2 +[TransOutput(@"含税") length], oldPriceStr.length +1 )];// 如果不加这个，横线的颜色跟随label字体颜色改变
        [attri addAttribute:NSStrikethroughColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange([[NSString ChangePriceStr:dic[@"nowPrice"]] length] + 2 +[TransOutput(@"含税") length], oldPriceStr.length + 1)];
        [attri addAttribute:NSForegroundColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange([[NSString ChangePriceStr:dic[@"nowPrice"]] length] + 2  +[TransOutput(@"含税") length], oldPriceStr.length + 1)];
    
        cell.priceLabel.attributedText = attri;
    }else{
        cell.priceLabel.textColor = RGB(0xF80402);
        cell.priceLabel.text =[NSString stringWithFormat:@"¥%@%@",[NSString ChangePriceStr:dic[@"nowPrice"]],TransOutput(@"含税")];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId =dic[@"prodId"];
    [self pushController:vc];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 147;
}
#pragma mark - lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        _tableView.showsVerticalScrollIndicator = NO;
        @weakify(self)
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData];
        }];
    }
    return _tableView;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无浏览数据");
    }
    return _nothingView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

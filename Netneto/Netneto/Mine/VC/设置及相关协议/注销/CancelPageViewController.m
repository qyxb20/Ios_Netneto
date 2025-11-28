//
//  CancelPageViewController.m
//  Netneto
//
//  Created by apple on 2024/12/18.
//

#import "CancelPageViewController.h"

@interface CancelPageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *prodIdsArr;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)UILabel *subtitleLabel;
@property(nonatomic, strong)UILabel *numLabel;
@property(nonatomic, strong)UITextView *otherTextView;
@end

@implementation CancelPageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
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
    self.navigationItem.title = TransOutput(@"注销账户");
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = TransOutput(@"注销理由");
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:16];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.height.mas_offset(24);
            make.top.mas_offset(107);
    }];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.height.mas_offset(273);
        make.top.mas_offset(139);
       }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = TransOutput(@"其他意见");
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(30);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(38);
        make.height.mas_offset(16);
    }];
    
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.text = @"0/200";
    self.numLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-28);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(38);
        make.height.mas_offset(16);
    }];
    
    self.otherTextView = [[UITextView alloc] init];

    [self.otherTextView setPlaceholderWithText:TransOutput(@"请输入问题描述") Color:RGB(0xBBB8B8)];
    self.otherTextView.font = [UIFont systemFontOfSize:12];
    self.otherTextView.delegate = self;
    self.otherTextView.layer.borderWidth =0.5;
    self.otherTextView.layer.borderColor = RGB(0xE1E1E1).CGColor;
    self.otherTextView.layer.cornerRadius = 5;
    self.otherTextView.clipsToBounds = YES;
    [self.view addSubview:self.otherTextView];
    [self.otherTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.numLabel.mas_bottom).offset(8);
        make.height.mas_offset(141);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGB(0x197CF5);
    button.layer.cornerRadius = 22;
    button.clipsToBounds = YES;
    [button setTitle:TransOutput(@"下一步") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(44);
        make.bottom.mas_offset(-29);
    }];
    @weakify(self);
    [button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self nextClick];
    }];
    
    self.prodIdsArr = [NSMutableArray array];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)nextClick{
    if (self.prodIdsArr.count == 0) {
        ToastShow(TransOutput(@"请选择注销理由"), errImg,RGB(0xFF830F));
        return;
    }
    
    NSDictionary *parm =@{@"dictCode":self.prodIdsArr[0],@"userMemo":self.otherTextView.text};
    CancelAccountViewController *vc =[[CancelAccountViewController alloc] init];
    vc.parm = parm;
    [self pushController:vc];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = textView.text.length + text.length - range.length;
   
    self.numLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)newLength];
    
    return newLength <= 200;
    
}
-(void)loadData{
    [NetwortTool getCancelMsgWithParm:@{} Success:^(id  _Nonnull responseObject) {
        
        self.dataArr =responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
 
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CancelPageTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CancelPageTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count == 0) {
        return cell;
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.dic = dic;
   
    cell.titleLabel.text = [NSString isNullStr:dic[@"dictLabel"]];
     if ([self.prodIdsArr containsObject:dic[@"dictCode"]]) {
        cell.choseBtn.selected = YES;
    }
    [cell setChoseItemBlock:^(NSDictionary * _Nonnull dic) {
        [self.prodIdsArr removeAllObjects];
        [self.prodIdsArr addObject:dic[@"dictCode"]];
        [self.tableView reloadData];
    }];
    
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
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

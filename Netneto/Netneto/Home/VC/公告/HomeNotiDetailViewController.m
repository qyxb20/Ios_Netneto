//
//  HomeNotiDetailViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/20.
//

#import "HomeNotiDetailViewController.h"

@interface HomeNotiDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, strong)UIImageView *bgTableViewImge;
@end

@implementation HomeNotiDetailViewController
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
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"平台通知");
    [self.view addSubview:self.bgTableViewImge];
    [self.bgTableViewImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(16);
        make.trailing.bottom.mas_offset(-16);
    }];
    [self.bgTableViewImge addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(5);
        make.top.mas_offset(22);
        
        make.bottom.trailing.mas_offset(-5);
        
    }];
    
}
-(void)GetData{
    [NetwortTool getHomeNotificationDetail:self.idStr Success:^(id  _Nonnull responseObject) {
        self.dataDic = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
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
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(UIImageView *)bgTableViewImge{
    if (!_bgTableViewImge) {
        _bgTableViewImge = [[UIImageView alloc] init];
        _bgTableViewImge.image = [UIImage imageNamed:@"矩形 1450"];
        
    }
    return _bgTableViewImge;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[[NSString isNullStr:self.dataDic[@"content"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
     
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

        cell.textLabel.attributedText = attrString;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h =[Tool getAttHtmHeight:self.dataDic[@"content"] width:WIDTH - 32-10 font:14];
    
       return h;
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

//
//  xieyiViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "xieyiViewController.h"

@interface xieyiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;

@end

@implementation xieyiViewController
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
    self.navigationItem.title = TransOutput(@"相关协议");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(44 * 10);
    }];
    
}
-(void)GetData{
    self.dataArr = @[TransOutput(@"用户协议"),TransOutput(@"隐私政策"),TransOutput(@"商户入驻协议"),TransOutput(@"平台规则"),TransOutput(@"使用指南"),TransOutput(@"配送政策"),TransOutput(@"退款政策"),TransOutput(@"卖家政策"),TransOutput(@"优惠券政策"),TransOutput(@"直播协议")];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];

    return cell;
}
- (NSString*) calculateCacheSize {

    //计算结果
       CGFloat totalSize = 0;
       
       // 构建需要计算大小的文件或文件夹的路径，这里以Documents为例
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
       // 1.获得文件夹管理者
       NSFileManager *mgr = [NSFileManager defaultManager];
       
       // 2.检测路径的合理性
       BOOL dir = NO;
       BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
       if (!exits) return 0;
       
       // 3.判断是否为文件夹
       if (dir)//文件夹, 遍历文件夹里面的所有文件
       {
           //这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径),包括子文件夹下面的所有文件及文件夹
           NSArray *subPaths = [mgr subpathsAtPath:path];
           
           //遍历所有子路径
           for (NSString *subPath in subPaths)
           {
               //拼成全路径
               NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
               
               BOOL dir = NO;
               [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
               if (!dir)//子路径是个文件
               {
                   //如果是数据库文件，不加入计算
                   if ([subPath isEqualToString:@"mySql.sqlite"])
                   {
                       continue;
                   }
                   NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                   totalSize += [attrs[NSFileSize] intValue];
               }
           }
           totalSize = totalSize / (1024 * 1024.0);//单位M
       }
       else//文件
       {
           NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
           totalSize = [attrs[NSFileSize] floatValue] / (1024 * 1024.0);//单位M
       }
    return [NSString stringWithFormat:@"%.1f MB",totalSize];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];

   if (indexPath.row == 0){
        

       vc.url = @"https://netneto.com/user_protocol.html";



    }
    else  if (indexPath.row == 1){
        

        vc.url = @"https://netneto.com/privacy_policy.html";
   
    }
    else  if (indexPath.row == 2){
        
        vc.url = @"https://netneto.com/merchant_registration_agreement.html";
        
   
    }
    
    else  if (indexPath.row == 3){
        
        vc.url = @"https://netneto.com/platform_rules.html";
        
   
    }
    else  if (indexPath.row == 4){
        vc.url = @"https://netneto.com/usage_guide.html";
       }
    else  if (indexPath.row == 5){
        vc.url = @"https://netneto.com/delivery_policy_more.html";
    }
    else  if (indexPath.row == 6){
        vc.url = @"https://netneto.com/refund_policy_more.html";
    }
    else  if (indexPath.row == 7){
        vc.url = @"https://netneto.com/seller_policy.html";
    }
    else  if (indexPath.row == 8){
        vc.url = @"https://netneto.com/coupon_policy.html";
    }
    else  if (indexPath.row == 9){
        vc.url = @"https://netneto.com/live_streaming_policy.html";
    }
    
    [self pushController:vc];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.layer.cornerRadius = 5;
        _tableView.clipsToBounds = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.borderColor = RGB(0xE1E1E1).CGColor;
        _tableView.layer.borderWidth = 0.5;
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

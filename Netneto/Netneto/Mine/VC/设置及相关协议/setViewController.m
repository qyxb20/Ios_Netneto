//
//  setViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/21.
//

#import "setViewController.h"

@interface setViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;
@end

@implementation setViewController

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
    self.navigationItem.title = TransOutput(@"设置");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(44 * 4);
    }];
    
}
-(void)GetData{
    self.dataArr = @[TransOutput(@"修改密码"),TransOutput(@"清除缓存"),TransOutput(@"版本信息"),TransOutput(@"注销账户")];
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
    if (indexPath.row == 1) {
        UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 72 - 100, 0, 100, 44)];
        labe.textAlignment = NSTextAlignmentRight;
        labe.font = [UIFont systemFontOfSize:12];
        labe.text = [self calculateCacheSize];
        [cell.contentView addSubview:labe];
    }
    if (indexPath.row == 2) {
        UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 72 - 100, 0, 100, 44)];
        labe.textAlignment = NSTextAlignmentRight;
        labe.font = [UIFont systemFontOfSize:12];
        labe.text = versionNum;
        [cell.contentView addSubview:labe];
    }
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
    if (indexPath.row == 0) {
        ModyPassViewController *vc = [[ModyPassViewController alloc] init];
        [self pushController:vc];
    }
   else if (indexPath.row == 1) {
        NSString *message = nil;//提示文字
           BOOL clearSuccess = YES;//是否删除成功
           NSError *error = nil;//错误信息
           
           //构建需要删除的文件或文件夹的路径，这里以Documents为例
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
         
           //拿到path路径的下一级目录的子文件夹
           NSArray *subPathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
           
           for (NSString *subPath in subPathArray)
           {
               //如果是数据库文件，不做操作
               if ([subPath isEqualToString:@"mySql.sqlite"])
               {
                   continue;
               }
               
               NSString *filePath = [path stringByAppendingPathComponent:subPath];
               //删除子文件夹
               [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
               if (error)
               {
                   message = [NSString stringWithFormat:@"%@这个路径的文件夹删除失败了",filePath];
                   clearSuccess = NO;
               }
               else
               {
                   message = @"成功了";
                   ToastShow(TransOutput(@"已删除缓存数据"), @"chenggong", RGB(0x36D053));
               }
           }
        [self.tableView reloadData];
    }
   else if(indexPath.row == 3){
       if (account.isLogin) {
           CancelPageViewController *vc = [[CancelPageViewController alloc] init];
           [self pushController:vc];
          
       }else{
               LoginViewController *vc = [[LoginViewController alloc] init];
               [self pushController:vc];
           }
   }
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

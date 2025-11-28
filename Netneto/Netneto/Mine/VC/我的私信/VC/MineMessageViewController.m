//
//  MineMessageViewController.m
//  Netneto
//
//  Created by apple on 2024/12/23.
//

#import "MineMessageViewController.h"

@interface MineMessageViewController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic,strong)SRWebSocket *socket;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation MineMessageViewController

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [self getListData];
    
}
#pragma mark - 接收消息
-(void)receiveData:(NSData *)data{
    ImMsgBody *body = [ImMsgBody parseFromData:data error:nil];
    int msgType = body.msgType;

if (msgType == 101) {
    MsgListResp *resp = [MsgListResp parseFromData:body.bytesData error:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArray = [NSMutableArray array];
        
        [self.dataArray addObjectsFromArray:resp.imMsgListArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if (self.dataArray.count == 0) {
                self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                  self.tableView.backgroundView = self.nothingView;
                 
              }
              else{
                 
                  self.tableView.backgroundView = nil;
              }
        });
        
    });
    
    
   
        
       
        
        
    
   
    NSLog(@"收到消息%@",resp.imMsgListArray);
    
}

if (msgType == 107 || msgType == 110) {

        [self loadData];

}

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
#pragma  mark - 获取消息数据
-(void)getListData{
    
    [[Socket sharedSocketTool] getImmsgList];
    @weakify(self);
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        [self receiveData:data];
    }];
}

-(void)CreateView{
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的消息");

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_offset(109);
    }];

    // Do any additional setup after loading the view.
}
#pragma mark -获取聊天列表
-(void)loadData{

    [[Socket sharedSocketTool] getImmsgList];
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMessageTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MineMessageTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ImMsgList *dic = self.dataArray[indexPath.row];
    
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:dic.userImg] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
    cell.nameLabel.text = dic.name;
    cell.timeLabel.text = dic.endMsgTime;
    if (dic.contentType == 1) {

        NSData *jsonData = [dic.endMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        cell.desLabel.text =dict[@"prodName"];
    }else{
        cell.desLabel.text = dic.endMsg;
    }
    if (dic.unReadSize > 0) {
        cell.numlabel.hidden = NO;
        cell.numlabel.text = [NSString stringWithFormat:@"%d",dic.unReadSize];
    }
    else{
        cell.numlabel.hidden =YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineMessDetailViewController *vc = [[MineMessDetailViewController alloc] init];
    ImMsgList *dic = self.dataArray[indexPath.row];
    NSString *shopUserId;
    if ([dic.toUserId isEqual:account.userInfo.userId]) {
        shopUserId = dic.fromUserId;
    }
    else{
        shopUserId = dic.toUserId;
    }
    NSDictionary *dataDic = @{@"shopImg":dic.userImg,@"shopName":dic.name,@"shopUserId":shopUserId,@"shopId":[NSString stringWithFormat:@"%lld",dic.shopId]};
    vc.dataDic = dataDic;
    vc.ImsgChannel = dic.imChannel;
    vc.FromUserId = dic.fromUserId;
    vc.ToUserId = dic.toUserId;
    [self pushController:vc];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete; // 指定侧滑出现的按钮类型为删除
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建一个删除按钮
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
           // 执行删除操作
        @weakify(self);
        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除聊天记录？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            @strongify(self)
            ImMsgList *imMsgList = self.dataArray[indexPath.row];
            [[Socket sharedSocketTool] deleMsgList:imMsgList.imChannel userId:account.userInfo.userId];
           
          [self.dataArray removeObjectAtIndex:indexPath.row];
          [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
        } cancelBlock:^{
            
        }];
        [alert show];
        
          }];
    deleteAction.backgroundColor = [UIColor clearColor];
    return @[deleteAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

        return YES; // 允许所有行侧滑删除

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
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无消息");
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

//
//  askAndQuestionViewController.m
//  Netneto
//
//  Created by apple on 2025/3/14.
//

#import "askAndQuestionViewController.h"

@interface askAndQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSMutableArray *Cellstates;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation askAndQuestionViewController
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
   
    self.navigationItem.title = TransOutput(@"常见问题");
    [self.view addSubview:self.bgView];
   
    [self.bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(-10);
        
    }];
    
}
- (void)GetData{
    
    NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"ask" ofType:@"json"];
    NSData *exampleJSON = [NSData dataWithContentsOfFile:examplePath];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:exampleJSON options:NSJSONReadingMutableContainers error:&error];
    self.titleArray = dic[@"data"];

    self.Cellstates = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    for(int i=0; i<self.titleArray.count; i++)
        {
            NSNumber *state = [NSNumber numberWithBool:NO];
            [self.Cellstates addObject:state];
         }
   
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     if([self.Cellstates[section] boolValue]) //展开的
     {
   
         NSArray *array = self.titleArray[section][@"list"];
         return array.count;
    }
     else //折叠的
     {
         return 0;
     }
 }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    vi.backgroundColor = [UIColor whiteColor];
    vi.tag = section;
    CGFloat w = [Tool getLabelWidthWithText:self.titleArray[section][@"title"] height:16 font:14] + 20;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 14, w, 16)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text =[NSString stringWithFormat:@"%ld.%@",(long)(section +1),self.titleArray[section][@"title"]];
    [vi addSubview:titleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(WIDTH - 37, 37/2, 14, 7);
    if([self.Cellstates[section] boolValue]){
        [button setBackgroundImage:[UIImage imageNamed:@"path-29"] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
    }
        //添加事件
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
   
        //记住button的tag
        button.tag = section;
  
    [vi addSubview:button];
    @weakify(self);
    [vi addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        NSNumber *oldState = [self.Cellstates objectAtIndex:view.tag];

        //2.创建新状态
        NSNumber *newState = [NSNumber numberWithDouble:![oldState boolValue]];

        //3.删除旧状态
        [self.Cellstates removeObjectAtIndex:view.tag];

        //4.添加新状态
        [self.Cellstates insertObject:newState atIndex:view.tag];

        //刷新表格
        [self.tableView reloadData];
    }];
    
    return vi;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.01)];
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)buttonClicked:(UIButton*)sender
 {
     //1.取出旧状态
     NSNumber *oldState = [self.Cellstates objectAtIndex:sender.tag];

     //2.创建新状态
     NSNumber *newState = [NSNumber numberWithDouble:![oldState boolValue]];

     //3.删除旧状态
     [self.Cellstates removeObjectAtIndex:sender.tag];

     //4.添加新状态
     [self.Cellstates insertObject:newState atIndex:sender.tag];

     //刷新表格
     [self.tableView reloadData];
 }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {

     askAndQuestionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 
     if(!cell)
     {
         cell = [[askAndQuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
     NSArray *array = self.titleArray[indexPath.section][@"list"];
     cell.qLabel.text = array[indexPath.row][@"question"];

     if (indexPath.row == array.count -1) {
         cell.line.hidden = YES;
     }
     cell.aLabel.text = array[indexPath.row][@"answer"];

     return cell;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.titleArray[indexPath.section][@"list"];
    
    CGFloat qH = [Tool getLabelHeightWithText:array[indexPath.row][@"question"] width:WIDTH - 59 font:14];
    if (qH < 16) {
        qH = 16;
    }
    CGFloat aH = [Tool getLabelHeightWithText:array[indexPath.row][@"answer"] width:WIDTH - 59 font:12];
    if (aH < 16) {
        aH = 16;
    }
    CGFloat bgH = 14 + qH + 6 + aH + 14;
    
    return bgH;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, WIDTH, HEIGHT - 105)];
        _bgView.backgroundColor = [UIColor whiteColor];

        _bgView.clipsToBounds = YES;
        
    }
    return _bgView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

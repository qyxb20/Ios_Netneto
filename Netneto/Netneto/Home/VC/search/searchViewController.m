//
//  searchViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "searchViewController.h"

@interface searchViewController () <UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) searchTagView *tagView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UILabel *label;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic,strong) UIButton *delBtn;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation searchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tagView.userInteractionEnabled = YES;
}
-(void)initData{
    self.dataSource = [NSMutableArray array];
}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title  = TransOutput(@"商品搜索");
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(16, 110, WIDTH - 32 , 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 32, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = TransOutput(@"请输入商品关键字");
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.font = [UIFont systemFontOfSize:14];
    } else {
        // Fallback on earlier versions
    }
    self.searchBar.showsCancelButton = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行任何必要的异步操作
        // 当所有必要操作完成后，返回主线程设置searchTextField为第一响应者
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 13.0, *)) {
                [self.searchBar.searchTextField becomeFirstResponder];
            } else {
                // Fallback on earlier versions
            }
        });
    });
    
    // 键盘确认按钮的名字
    self.searchBar.returnKeyType = UIReturnKeySearch;
    // 把默认灰色背景浮层给去掉
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    UITextField *searBarTextField;
    if (@available(iOS 13.0, *)) {
        searBarTextField =[_searchBar valueForKey:@"_searchTextField"];
               }else{
                   searBarTextField = [_searchBar valueForKey:@"_searchField"];
           }
    if (searBarTextField)
    {
        [searBarTextField setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
        searBarTextField.borderStyle = UITextBorderStyleRoundedRect;
        searBarTextField.layer.cornerRadius = 5.0f;
    }
    else
    {
        // 通过颜色画一个Image出来
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1] size:CGSizeMake(28, 28)];
        [self.searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    }
    [titleView addSubview:self.searchBar];

    [self.view addSubview:titleView];

   
}

-(void)GetData{
    if (account.userInfo.userId.length > 0) {
        
    
    [NetwortTool getHomeSearchHistorySuccess:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        [self.dataSource addObjectsFromArray:responseObject];
        [self configTagView];
        
  } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    }
}
-(void)clearHistory{
    [NetwortTool getClearSearchHistoryDataSuccess:^(id  _Nonnull responseObject) {
        [self.dataSource removeAllObjects];
        [self GetData];
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
}
// 配置
- (void)configTagView
{
    [self.label removeFromSuperview];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 164, 100, 30)];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.text = TransOutput(@"搜索历史");
    [self.view addSubview:self.label];
    [self.delBtn removeFromSuperview];
    self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delBtn.frame = CGRectMake(WIDTH - 46, 164, 30, 30);
    [self.delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    @weakify(self)
    [self.delBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        
        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除全部历史记录？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            @strongify(self)
            [self clearHistory];
        } cancelBlock:^{
            
        }];
        [alert show];
        
    }];
    [self.view addSubview:self.delBtn];
    [self.tagView removeAllTags];
    self.tagView = [[searchTagView alloc] init];
    // 整个tagView对应其SuperView的上左下右距离
    self.tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    // 上下行之间的距离
    self.tagView.lineSpacing = 10;
    // item之间的距离
    self.tagView.interitemSpacing = 20;
    // 最大宽度
    self.tagView.preferredMaxLayoutWidth = 375;

    // 开始加载
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       // 初始化标签
        searchTag *tag = [[searchTag alloc] initWithText:self.dataSource[idx][@"title"]];
        // 标签相对于自己容器的上左下右的距离
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        // 弧度
        tag.cornerRadius = 3.0f;
        // 字体
        tag.font = [UIFont boldSystemFontOfSize:12];
        // 边框宽度
        tag.borderWidth = 0;
        // 背景
        tag.bgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        // 边框颜色
        tag.borderColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        // 字体颜色
        tag.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
        // 是否可点击
        tag.enable = YES;
        // 加入到tagView
        [self.tagView addTag:tag];
    }];
    // 点击事件回调
 
    self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
        @strongify(self)
        NSLog(@"点击了第%ld个",idx);
        self.tagView.userInteractionEnabled = NO;
        self.searchBar.text =self.dataSource[idx][@"title"];
        [self showSearchRes];
    };
    
   
    
    
    // 获取刚才加入所有tag之后的内在高度
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    NSLog(@"高度%lf",tagHeight);
    self.tagView.frame = CGRectMake(0, 194, WIDTH, tagHeight);
    [self.tagView layoutSubviews];
    [self.view addSubview:self.tagView];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    if (searchText.length == 0) {
        // 没有文字了
        self.label.hidden = NO;
        self.tagView.hidden = NO;
    }
    else
    {
        self.label.hidden = YES;
        self.tagView.hidden = YES;
    }
    

}
-(void)showSearchRes{
    NSString *useridStr = @"";
    if (account.isLogin) {
        useridStr =[NSString stringWithFormat:@"%@",account.userInfo.userId];
    }
    
    [NetwortTool getHomeSearchData:@{@"prodName":self.searchBar.text,@"sort":@"0",@"orderBy":@"0",@"userId":useridStr} Success:^(id  _Nonnull responseObject) {
        NSLog(@"搜索结果%@",responseObject);
        self.searchBar.userInteractionEnabled = YES;
        if ([responseObject[@"records"] count] != 0) {
            searchResoutViewController *vc = [[searchResoutViewController alloc] init];
            vc.dataArr = responseObject[@"records"];
            vc.searStr =self.searchBar.text;
            [self pushController:vc];
        }
        else{
            ToastShow(TransOutput(@"没有找到结果"), errImg,RGB(0xFF830F));
            
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
 
    }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.userInteractionEnabled = NO;
    [self showSearchRes];
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
        _nothingView.titleLabel.text = TransOutput(@"暂无搜索数据");
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

//
//  addManagerListView.m
//  Netneto
//
//  Created by apple on 2024/10/15.
//

#import "addManagerListView.h"
@interface addManagerListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@end
@implementation addManagerListView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    @weakify(self)
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        self.dataArr = [NSMutableArray array];
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.page ++;
        [self loadData];
    }];
 
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    self.nothingView.topCustom.constant = 10;
    self.nothingView.frame = CGRectMake(0, 70, WIDTH, 450 - 100);
  
}
-(void)loadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
        self.page = 1;
        self.dataArr = [NSMutableArray array];
        [NetwortTool getManagerListWithParm:@{@"shopId":self.shopId,@"pageNum":@(self.page),@"pageSize":@10} Success:^(id  _Nonnull responseObject) {
            
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            
            [self.dataArr addObjectsFromArray: responseObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                if (self.dataArr.count == 0) {
                    self.tableView.backgroundView = self.nothingView;
                    
                }
                else{
                    self.tableView.backgroundView = nil;
                    
                }
            });
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArr.count;
}
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        addManagerListViewTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"addManagerListViewTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.dataArr[indexPath.row];
     [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:[NSString isNullStr:dic[@"pic"]]]] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
     cell.name.text = [NSString isNullStr:dic[@"nickName"]];
        @weakify(self);
        [cell.delBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.setManagerBlock,dic);
            [self.dataArr removeObject:dic];
            
            [self.tableView reloadData];
        
           
        }];
        return cell;
    }
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无管理员数据");
    }
    return _nothingView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

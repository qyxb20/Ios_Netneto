//
//  SearchLiveViewController.m
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "SearchLiveViewController.h"
#import "SearchLiveCollectionViewCell.h"
#import "SearchLiveResultViewController.h"
@interface SearchLiveViewController () <UICollectionViewDelegate,
UICollectionViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIImageView *bgHeaderView;
@property(nonatomic, strong) UIView *searchView;
@property(nonatomic, strong) UIImageView *SearchImageView;
@property(nonatomic, strong) UITextField *searchTF;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSArray *arr;
@property(nonatomic, strong) UIView *whiteView;
@property(nonatomic, strong) UIButton *moreBtn;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) UIButton *clearBtn;
@property(nonatomic, strong) UILabel *seaLabel;
@property(nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation SearchLiveViewController
- (void)returnClick {
    [self popViewControllerAnimate];
}
- (void)initData {
    UIView *leftButtonView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn =
    [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButtonView addSubview:returnBtn];
    [returnBtn setImage:[UIImage imageNamed:@"white_back"]
               forState:UIControlStateNormal];
    [returnBtn addTarget:self
                  action:@selector(returnClick)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView =
    [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
}
- (void)CreateView {
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    [self.view addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(99);
        make.leading.mas_offset(0);
        make.trailing.mas_offset(0);
        make.height.mas_offset(133);
    }];
    self.navigationItem.title = TransOutput(@"直播搜索");
    [self.whiteView addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(11);
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(37);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_offset(11);
        make.width.height.mas_offset(15);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(self.SearchImageView.mas_leading).offset(-10);
        make.top.mas_offset(8.5);
        make.height.mas_offset(20);
    }];
    self.seaLabel = [[UILabel alloc] init];
    self.seaLabel.text = TransOutput(@"搜索历史");
    self.seaLabel.font = [UIFont systemFontOfSize:14];
    self.seaLabel.textColor = RGB(0x807F7F);
    [self.whiteView addSubview:self.seaLabel];
    [self.seaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(29);
        make.height.mas_offset(16);
    }];
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn setTitle:TransOutput(@"展开") forState:UIControlStateNormal];
    [self.moreBtn setTitle:TransOutput(@"收起")
                  forState:UIControlStateSelected];
    [self.moreBtn setImage:[UIImage imageNamed:@"path-28"]
                  forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"path-29"]
                  forState:UIControlStateSelected];
    [self.moreBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft
                              imageTitleSpace:5];
    [self.moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.moreBtn addTarget:self
                     action:@selector(moreClick:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:RGB(0x807F7F) forState:UIControlStateNormal];
    [self.whiteView addSubview:self.moreBtn];
    
    self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [self.delBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self.whiteView addSubview:self.delBtn];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(29);
        make.height.mas_offset(16);
        make.width.mas_offset(16);
    }];
    
   
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = RGB(0xEAEAEB);
    [self.whiteView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.delBtn.mas_leading).offset(-10);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(30);
        make.height.mas_offset(14);
        make.width.mas_offset(1);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.lineLabel.mas_leading).offset(-20);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(29);
        make.height.mas_offset(16);
    }];
    [self.delBtn addTarget:self action:@selector(delClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearBtn setTitle:TransOutput(@"清空") forState:UIControlStateNormal];
    [self.clearBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.clearBtn setTitleColor:RGB(0xFF0101) forState:UIControlStateNormal];
    self.clearBtn.hidden = YES;
    [self.whiteView addSubview:self.clearBtn];
    @weakify(self);
   
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.delBtn.mas_leading).offset(-20);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(29);
        make.height.mas_offset(16);
      
    }];
   
    [self.clearBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        
        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除全部历史记录？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            @strongify(self)
            [self delRecode:@"0"];
            self.delBtn.selected = NO;
            self.delBtn.backgroundColor = [UIColor clearColor];
            self.clearBtn.hidden = YES;
            if (self.arr.count > 6) {
                self.moreBtn.hidden = NO;
                self.lineLabel.hidden = NO;
            }
            [self.delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
            [self.delBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           
                make.width.mas_offset(16);
            }];
        } cancelBlock:^{
            
        }];
        [alert show];
        
    }];
   
    [self.whiteView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.seaLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-10);
    }];
    [self loadData:30];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadSearchResult" object:nil queue:nil usingBlock:^(NSNotification *notification) {
       
            [self loadData:30];
        self.delBtn.selected = NO;
        self.delBtn.backgroundColor = [UIColor clearColor];
        self.clearBtn.hidden = YES;
        if (self.arr.count > 6) {
            self.moreBtn.hidden = NO;
            self.lineLabel.hidden = NO;
        }
        [self.delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        [self.delBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
            make.width.mas_offset(16);
        }];
        
    }];
    
    // Do any additional setup after loading the view.
}
-(void)delClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        self.clearBtn.hidden = NO;
        if (self.arr.count > 6) {
            self.moreBtn.hidden = YES;
            self.lineLabel.hidden = YES;
        }
        [self.delBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [self.delBtn setTitle:TransOutput(@"完成") forState:UIControlStateSelected];
        self.delBtn.backgroundColor = RGB(0x0F7CFD);
        CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"完成") height:16 font:12];
        [self.delBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
            make.width.mas_offset(w+10);
        }];
    }else{
        sender.selected = NO;
        self.delBtn.backgroundColor = [UIColor clearColor];
        self.clearBtn.hidden = YES;
        if (self.arr.count > 6) {
            self.moreBtn.hidden = NO;
            self.lineLabel.hidden = NO;
        }
        [self.delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        [self.delBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
            make.width.mas_offset(16);
        }];
    }
    [self.collectionView reloadData];
}
- (void)moreClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
       
        [self loadData:30];
    } else {
        sender.selected = NO;

        [self loadData:30];
    }
}
- (void)loadData:(NSInteger)num {
    NSString *userId = @"";
    if (account.isLogin) {
        userId = account.userInfo.userId;
    }
    self.dataArray = [NSMutableArray array];
    [NetwortTool getRoomQueryListWithParm:@{@"userId":userId,@"pageNum":@(1),@"pageSize":@(num)}  Success:^(id _Nonnull responseObject) {
       self.arr = responseObject;
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
     
        if (self.arr.count < 7) {
            self.moreBtn.hidden = YES;
            self.lineLabel.hidden = YES;
            self.dataArray = [self.arr mutableCopy];
        }
        else{
            
            if (self.delBtn.selected) {
                self.moreBtn.hidden = YES;
                self.lineLabel.hidden = YES;
            }else{
                self.moreBtn.hidden = NO;
                self.lineLabel.hidden = NO;
            }
            if (self.moreBtn.selected) {
                self.dataArray = [self.arr mutableCopy];
            }else{
                for (int i = 0; i < 6; i++) {
                    [self.dataArray addObject:self.arr[i]];
                }
            }
        }
        
        
        
        if(self.dataArray.count == 0){
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(183);
            }];
        }
     
        else{

                [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                    NSInteger c = self.dataArray.count;
                    if ( c < 2) {
                        if ( c == 0) {
                            make.height.mas_offset(183);
                        }
                        else{
                            make.height.mas_offset(36 + 123);
                        }
                    }
                    else{
                        
                        if (self.dataArray.count % 2 == 0) {
                            make.height.mas_offset(36 * ((self.dataArray.count -2) / 2 ) + 36 + 123);
                        }else{
                            make.height.mas_offset(36 * ((self.dataArray.count -2) / 2 +1) + 36 + 123);
                        }
                    }
                }];

        }
        [self.collectionView reloadData];
        
        if (self.arr.count == 0) {
            self.collectionView.backgroundView = self.nothingView;
           
        }
        else{
           
            self.collectionView.backgroundView = nil;
        }
    }
                                  failure:^(NSError *_Nonnull error){

    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:
(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SearchLiveCollectionViewCell *cell = [collectionView
                                          dequeueReusableCellWithReuseIdentifier:@"SearchLiveCollectionViewCell"
                                          forIndexPath:indexPath];
    if (!cell) {
        cell =
        [[NSBundle mainBundle] loadNibNamed:@"SearchLiveCollectionViewCell"
                                      owner:self
                                    options:nil]
            .lastObject;
    }
    cell.titleLabel.text = self.dataArray[indexPath.row][@"content"];
    if (self.delBtn.selected) {
        cell.contentView.backgroundColor =  RGB(0xF7F7F7);
        cell.delBn.hidden = NO;
    }else{
        cell.contentView.backgroundColor =  [UIColor clearColor];
        cell.delBn.hidden = YES;
    }
    @weakify(self);
    [cell.delBn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self delRecode:self.dataArray[indexPath.row][@"showQueryRecordId"] ];
        
    }];
    return cell;
}
-(void)delRecode:(NSString *)showQueryRecordIds{
    NSString *userId = @"";
    if (account.isLogin) {
        userId = account.userInfo.userId;
    }
    
    [NetwortTool getDeleteLiveQueryRecordWithParm:@{@"userId":userId,@"showQueryRecordId":showQueryRecordIds} Success:^(id  _Nonnull responseObject) {
        
        ToastShow(TransOutput(@"删除成功") , @"chenggong", RGB(0x36D053));
        [self.dataArray removeAllObjects];
        [self loadData:30];
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchTF resignFirstResponder];
    SearchLiveResultViewController *vc = [[SearchLiveResultViewController alloc] init];
    vc.queryParam = self.dataArray[indexPath.row][@"content"];
    [self pushController:vc];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        [self.searchTF resignFirstResponder];
        SearchLiveResultViewController *vc = [[SearchLiveResultViewController alloc] init];
        vc.queryParam = textField.text;
        [self pushController:vc];
        return YES;
   
}
#pragma mark - lazy
- (UIImageView *)bgHeaderView {
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
    }
    return _bgHeaderView;
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        _searchView.backgroundColor =
        [UIColor gradientColorArr:@[ RGB(0xF7F7F7), RGB(0xF7F7F7) ]
                        withWidth:WIDTH - 32];
    }
    return _searchView;
}
- (UIImageView *)SearchImageView {
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_SearchImageView addTapAction:^(UIView *_Nonnull view) {
            @strongify(self);
           
                SearchLiveResultViewController *vc = [[SearchLiveResultViewController alloc] init];
                vc.queryParam = self.searchTF.text;
                [self pushController:vc];
            
            
        }];
    }
    return _SearchImageView;
    ;
}
- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = YES;
        _searchTF.delegate = self;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.placeholder = TransOutput(@"搜索");
    }
    return _searchTF;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =
        [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2, 24);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 12;
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:
                                      @"SearchLiveCollectionViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"SearchLiveCollectionViewCell"];
    }
    return _collectionView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.topCustom.constant = 10;
        _nothingView.imaHeigh.constant = 0;
        _nothingView.labelTop.constant = 6;
        _nothingView.titleLabel.text = TransOutput(@"没有最近在搜内容");
        _nothingView.titleLabel.textColor = RGB(0x807F7F);
        _nothingView.titleLabel.font = [UIFont systemFontOfSize:14];
        _nothingView.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nothingView;
}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

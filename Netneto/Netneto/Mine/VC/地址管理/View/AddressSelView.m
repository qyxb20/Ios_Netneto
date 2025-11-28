//
//  AddressSelView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/27.
//

#import "AddressSelView.h"
@interface AddressSelView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *casncleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong)UITableView *provTableView;
@property (nonatomic, strong)UITableView *cityTableView;
@property (nonatomic, strong)UITableView *areaTableView;
@property (nonatomic, strong)NSMutableArray *provArray;
@property (nonatomic, strong)NSMutableArray *cityArray;
@property (nonatomic, strong)NSMutableArray *areaArray;
@property (nonatomic, assign)NSInteger selectPage;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong)NSString *provStr;
@property (nonatomic, strong)NSString *cityStr;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (nonatomic, strong)NSString *areaStr;
@property (nonatomic, strong)NSString *postalCode;
@property (nonatomic, assign)NSInteger proAreId;
@property (nonatomic, assign)NSInteger cityAreId;
@property (nonatomic, assign)NSInteger AreId;
@end
@implementation AddressSelView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.provTableView];
    [self addSubview:self.cityTableView];
    [self addSubview:self.areaTableView];
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        [self removeFromSuperview];
    }];
    self.selectPage = 1;
    self.provArray = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
    
    [self loadData:0];

    [self.casncleBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
}
-(void)upshow:(NSString *)addStr areId:(NSInteger )areId cityAreId:(NSInteger )cityareId{
    
   
    [HudView showHudForView:self];
    [self uploadData:0 addStr:addStr selPage:1];

}
- (void)uploadData:(NSInteger)index addStr:(NSString *)addstr selPage:(NSInteger )selectPage{
    NSArray *array = [addstr componentsSeparatedByString:@"-"];
    
    
    [NetwortTool getAddAreaListWithParm:@{@"pid":@(index)} Success:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        if (selectPage == 1) {
            self.provArray = [NSMutableArray array];
            NSInteger selIndex = 0;
            for ( int i = 0;i <arr.count;i++ ) {
                NSDictionary *dic =arr[i];
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                if ([model.areaName isEqual:array[0]]) {
                    model.selectedState = YES;
                    selIndex = i;
                    [self uploadData:model.areaId addStr:addstr selPage:2];
                    self.provStr = [NSString isNullStr:model.areaName];
                }else{
                    model.selectedState = NO;
                }
                [self.provArray addObject:model];
            }
            
            
            [self.provTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
            [self.provTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        if (selectPage == 2) {
            self.cityArray = [NSMutableArray array];
            NSInteger selIndex = 0;
            for ( int i = 0;i <arr.count;i++ ) {
                NSDictionary *dic =arr[i];
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                if ([model.areaName isEqual:array[1]]) {
                    model.selectedState = YES;
                    selIndex = i;
                    self.cityStr = [NSString isNullStr:model.areaName];
                    [self uploadData:model.areaId addStr:addstr selPage:3];
                }else{
                    model.selectedState = NO;
                }
                [self.cityArray addObject:model];
            }
            
            
            [self.cityTableView reloadData];
        }
        if (selectPage == 3) {
            self.areaArray = [NSMutableArray array];
            NSInteger selIndex = 0;
            for ( int i = 0;i <arr.count;i++ ) {
                NSDictionary *dic =arr[i];
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                if (array.count > 2) {
                    if ([model.areaName isEqual:array[2]]) {
                        selIndex = i;
                        self.areaStr = [NSString isNullStr:model.areaName];
                        model.selectedState = YES;
                    }else{
                        model.selectedState = NO;
                    }
                }
                [self.areaArray addObject:model];
            }
            
            [HudView hideHudForView:self];
            [self.areaTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (void)loadData:(NSInteger)index{
    [NetwortTool getAddAreaListWithParm:@{@"pid":@(index)} Success:^(id  _Nonnull responseObject) {
        if (self.selectPage == 1) {
           
            for (NSDictionary *dic in responseObject) {
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                [self.provArray addObject:model];
            }
            
            
            [self.provTableView reloadData];
        }
        if (self.selectPage == 2) {
           
            for (NSDictionary *dic in responseObject) {
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                [self.cityArray addObject:model];
            }
            
            
            [self.cityTableView reloadData];
        }
        if (self.selectPage == 3) {
            
            for (NSDictionary *dic in responseObject) {
                AddressSelModel *model = [[AddressSelModel alloc] initWithDic:dic];
                [self.areaArray addObject:model];
            }
            
            
            [self.areaTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.provTableView) {
        return self.provArray.count;
    }
    else if (tableView == self.cityTableView){
        return self.cityArray.count;
    }
    else{
        return self.areaArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr;
    AddressSelModel *model;
    if (tableView == self.provTableView) {
        arr = self.provArray;
        
    }
    else if (tableView == self.cityTableView){
        arr =self.cityArray;
        
    }
    else{
        arr =self.areaArray;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (arr.count < indexPath.row) {
        return cell;
    }
    model = arr[indexPath.row];
    if (model.selectedState) {
        cell.textLabel.textColor = RGB(0x197CF5);
    }
    cell.textLabel.text = [NSString isNullStr:model.areaName];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.provTableView) {
        AddressSelModel *model = self.provArray[indexPath.row];
       
        
        for (int i = 0; i <self.provArray.count ; i++) {
            AddressSelModel *model = self.provArray[i];
            
            if (i == indexPath.row) {
                model.selectedState = YES;
                self.provStr = [NSString isNullStr:model.areaName];
                self.cityStr = @"";
                self.areaStr = @"";
                self.postalCode = @"";
                self.addLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[NSString isNullStr:self.provStr],[NSString isNullStr:self.cityStr],[NSString isNullStr:self.areaStr]];
            }else{
                model.selectedState = NO;
            }
            [self.provArray replaceObjectAtIndex:i withObject:model];
        }
       
        [self.provTableView reloadData];
        self.selectPage = 2;
        [self.cityArray removeAllObjects];
        [self.areaArray removeAllObjects];
        [self.areaTableView reloadData];
        [self loadData:model.areaId];
        self.cityAreId =model.areaId;
    }
    if (tableView == self.cityTableView) {
        AddressSelModel *model = self.cityArray[indexPath.row];
       
      
        
        for (int i = 0; i <self.cityArray.count ; i++) {
            AddressSelModel *model = self.cityArray[i];
            
            if (i == indexPath.row) {
                model.selectedState = YES;
                self.cityStr = model.areaName;
                self.areaStr = @"";
                self.postalCode = [NSString isNullStr:model.postalCode];
                self.addLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.provStr,self.cityStr,self.areaStr];
            }else{
                model.selectedState = NO;
            }
            
            [self.cityArray replaceObjectAtIndex:i withObject:model];
        }
       
        [self.cityTableView reloadData];
        self.selectPage = 3;
        [self.areaArray removeAllObjects];
        [self loadData:model.areaId];
        self.AreId = model.areaId;
    }
    if (tableView == self.areaTableView) {
        
      
        
        for (int i = 0; i <self.areaArray.count ; i++) {
            AddressSelModel *model = self.areaArray[i];
            
            if (i == indexPath.row) {
                model.selectedState = YES;
                self.areaStr = [NSString isNullStr:model.areaName];
                self.postalCode = [NSString isNullStr:model.postalCode];
                
                
                if ([[NSString isNullStr:self.areaStr] length] == 0) {
                    
                    self.addLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString isNullStr:self.provStr],[NSString isNullStr:self.cityStr]];
                }
                else{
                    self.addLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[NSString isNullStr:self.provStr],[NSString isNullStr:self.cityStr],[NSString isNullStr:self.areaStr]];
                }
                
                ExecBlock(self.sureBlock,self.addLabel.text,self.postalCode,self.cityAreId,self.AreId);
//                [self cleanModel];
                [self removeFromSuperview];
                
            }else{
                model.selectedState = NO;
            }
            
            [self.areaArray replaceObjectAtIndex:i withObject:model];
        }
       
        [self.areaTableView reloadData];
        
    }
}
-(void)cleanModel{
    for (int i = 0 ; i < self.provArray.count; i++) {
        AddressSelModel *model = self.provArray[i];
        model.selectedState = NO;
    }
    for (int i = 0 ; i < self.cityArray.count; i++) {
        AddressSelModel *model = self.cityArray[i];
        model.selectedState = NO;
    }
    for (int i = 0 ; i < self.areaArray.count; i++) {
        AddressSelModel *model = self.areaArray[i];
        model.selectedState = NO;
    }
}
-(UITableView *)provTableView{
    if (!_provTableView) {
        _provTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 267, WIDTH / 3, HEIGHT - 277) style:UITableViewStylePlain];
        _provTableView.delegate = self;
        _provTableView.dataSource = self;
        _provTableView.backgroundColor = [UIColor clearColor];
        _provTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provTableView.showsVerticalScrollIndicator = NO;
        _provTableView.showsHorizontalScrollIndicator = NO;
    }
    return _provTableView;
}
-(UITableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView  = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH / 3, 267, WIDTH / 3, HEIGHT - 277) style:UITableViewStylePlain];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.backgroundColor = [UIColor clearColor];
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTableView.showsVerticalScrollIndicator = NO;
        _cityTableView.showsHorizontalScrollIndicator = NO;
    }
    return _cityTableView;
}
-(UITableView *)areaTableView{
    if (!_areaTableView) {
        _areaTableView  = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH / 3 * 2, 267, WIDTH / 3,HEIGHT - 277) style:UITableViewStylePlain];
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
        _areaTableView.backgroundColor = [UIColor clearColor];
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaTableView.showsVerticalScrollIndicator = NO;
        _areaTableView.showsHorizontalScrollIndicator = NO;
    }
    return _areaTableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

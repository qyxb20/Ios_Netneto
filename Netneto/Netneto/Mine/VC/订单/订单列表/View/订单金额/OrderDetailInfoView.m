//
//  OrderDetailInfoView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderDetailInfoView.h"
@interface OrderDetailInfoView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end
@implementation OrderDetailInfoView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = self.titleStr;
}
-(void)setRemodel:(OrderDetailInfoRefunModel *)remodel{
    _remodel = remodel;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = RGB(0xD7EDFD);
    self.layer.borderColor = RGB(0x22A0FB).CGColor;
    if ([self.titleStr isEqual:TransOutput(@"订单价格")]) {
        if ([remodel.refundSts isEqual:@"3"]) {
            self.dataArr = @[@{@"title":TransOutput(@"订单总额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.productTotalAmount]]},@{@"title":TransOutput(@"运费"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.freightAmount]]},@{@"title":TransOutput(@"优惠金额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:remodel.reduceAmount]]},@{@"title":TransOutput(@"退款金额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.refundAmount]]},@{@"title":TransOutput(@"退货原因"),@"price":[NSString isNullStr:remodel.buyerMsg]}];

        }else{
            self.dataArr = @[@{@"title":TransOutput(@"订单总额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.productTotalAmount]]},@{@"title":TransOutput(@"运费"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.freightAmount]]},@{@"title":TransOutput(@"优惠金额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:remodel.reduceAmount]]},@{@"title":TransOutput(@"退款金额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:remodel.refundAmount]]},@{@"title":TransOutput(@"退货原因"),@"price":[NSString isNullStr:remodel.buyerMsg]}];
        }
        [self.tableView reloadData];
    }
    else if ([self.titleStr isEqual:TransOutput(@"订单信息")]){
        if (remodel.expressNo.length != 0) {
            self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":remodel.orderNumber},@{@"title":TransOutput(@"申请时间"),@"price":[NSString isNullStr:remodel.applyTime]},@{@"title":TransOutput(@"买家发货时间"),@"price":[NSString isNullStr:remodel.shipTime]},@{@"title":TransOutput(@"卖家处理时间"),@"price":[NSString isNullStr:remodel.handelTime]}];

        }else{
            if([remodel.refundSts isEqual:@"1"]){
                self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":remodel.orderNumber},@{@"title":TransOutput(@"申请时间"),@"price":[NSString isNullStr:remodel.applyTime]}];
            }
            else{
                self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":remodel.orderNumber},@{@"title":TransOutput(@"申请时间"),@"price":[NSString isNullStr:remodel.applyTime]},@{@"title":TransOutput(@"卖家处理时间"),@"price":[NSString isNullStr:remodel.handelTime]}];
            }
            
        }
        [self.tableView reloadData];
    }
    else if([self.titleStr isEqual:TransOutput(@"拒绝退款原因")]){
        
        self.dataArr = @[@{@"title":@"",@"price":[NSString isNullStr:remodel.rejectMessage]}];
        [self.tableView reloadData];
    }
    else{
        self.dataArr = @[@{@"title":TransOutput(@"物流公司名称"),@"price":[NSString stringWithFormat:@"%@",[NSString isNullStr:remodel.expressName]]},@{@"title":TransOutput(@"物流单号"),@"price":[NSString stringWithFormat:@"%@",[NSString isNullStr:remodel.expressNo]]}];
        [self.tableView reloadData];

    }
}
- (void)setModel:(OrderDetailModel *)model{
    _model = model;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = RGB(0xD7EDFD);
    self.layer.borderColor = RGB(0x22A0FB).CGColor;
    if ([self.titleStr isEqual:TransOutput(@"订单价格")]) {
        self.dataArr = @[@{@"title":TransOutput(@"运费"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:model.transfee]]},@{@"title":TransOutput(@"优惠金额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:model.reduceAmount]]},@{@"title":TransOutput(@"订单总额"),@"price":[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:model.actualTotal]]}];
        [self.tableView reloadData];
    }
    else if ([self.titleStr isEqual:TransOutput(@"订单信息")]){
        if ([model.status isEqual:@"2"]) {
            self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"付款时间"),@"price":[NSString isNullStr:model.payTime]},@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
        }
        
       else if ([model.status isEqual:@"1"]) {
            self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
        }
       else if ([model.status isEqual:@"6"]){
           NSString *cancelTime = [NSString stringWithFormat:@"%@",[NSString isNullStr:model.cancelTime]];
           
           if (cancelTime.length > 0) {
               
               self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"订单取消时间"),@"price":[NSString isNullStr:model.cancelTime]},@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
           }
           else{
               self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"付款时间"),@"price":[NSString isNullStr:model.payTime]},@{@"title":TransOutput(@"发货时间"),@"price":[NSString isNullStr:model.dvyTime] },@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
           }
       }
       else if ([model.status isEqual:@"5"]){
            self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"付款时间"),@"price":[NSString isNullStr:model.payTime]},@{@"title":TransOutput(@"发货时间"),@"price":[NSString isNullStr:model.dvyTime] } ,@{@"title":TransOutput(@"收货时间"),@"price":[NSString isNullStr:model.finallyTime] }  ,@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
        }
       else{
            self.dataArr = @[@{@"title":TransOutput(@"订单编号"),@"price":self.orderNumber},@{@"title":TransOutput(@"下单时间"),@"price":[NSString isNullStr:model.createTime]},@{@"title":TransOutput(@"付款时间"),@"price":[NSString isNullStr:model.payTime]},@{@"title":TransOutput(@"发货时间"),@"price":[NSString isNullStr:model.dvyTime] },@{@"title":TransOutput(@"订单备注"),@"price":[NSString isNullStr:model.remarks]}];
        }
        
        
        [self.tableView reloadData];
    }
   
}
-(void)CreateView{
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    if ([dic[@"title"] length] ==0) {
        OrderDetailInfoResaonViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailInfoResaonViewTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailInfoResaonViewTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = dic[@"price"];
       
        cell.textLabel.textColor =RGB(0xF80402);
        return cell;
    }else{
        OrderDetailInfoViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailInfoViewTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailInfoViewTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
        if ([self.dataArr[indexPath.row][@"title"] isEqual: TransOutput(@"订单备注")] || [self.dataArr[indexPath.row][@"title"] isEqual: TransOutput(@"退货原因")] || [self.dataArr[indexPath.row][@"title"] isEqual: TransOutput(@"拒绝退款原因")]) {
            cell.otherLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            cell.otherLabel.textAlignment = NSTextAlignmentRight;
        }
        cell.otherLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"price"]];
        if ([self.dataArr[indexPath.row][@"price"] containsString:@"¥"]) {
            cell.otherLabel.textColor = RGB(0xF80402);
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"price"]];
   
    CGFloat h = [Tool getLabelHeightWithText:str width:self.width - 91 - 25 - 15  font:12];
    if (h < 33) {
        h = 33;
    }
    return h;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

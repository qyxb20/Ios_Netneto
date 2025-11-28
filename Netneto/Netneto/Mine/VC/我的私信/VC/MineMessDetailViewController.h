//
//  MineMessDetailViewController.h
//  Netneto
//
//  Created by apple on 2024/12/23.
//

#import "BaseViewController.h"
#import "MineMsgBottomView.h"

NS_ASSUME_NONNULL_BEGIN
//@class ImMsgList;
@interface MineMessDetailViewController : UIViewController
//@property(nonatomic, strong)ImMsgList *dataDic;
@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, strong)NSDictionary *selDic;
@property(nonatomic, assign)BOOL isDetail;
@property(nonatomic, strong)NSString *ImsgChannel;
@property(nonatomic, strong)NSString *ToUserId;
@property(nonatomic, strong)NSString *FromUserId;
@end

NS_ASSUME_NONNULL_END

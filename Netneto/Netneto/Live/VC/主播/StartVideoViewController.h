//
//  StartVideoViewController.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/8.
//

#import "BaseViewController.h"
#import "NoticeLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StartVideoViewController : BaseViewController
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSDictionary *getLiveDic;
@end

NS_ASSUME_NONNULL_END

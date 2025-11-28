//
//  TMSInputView.h
//  TMSStickerView
//
//  Created by TMS on 2019/1/17.
//  Copyright © 2019年 TMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMSInputView : BaseView
@property(nonatomic, copy) void(^sendMsgText) (NSString * text);
//
- (void)stickerButttonBackToOriginalState;
@end

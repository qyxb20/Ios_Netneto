//
//  TMSInputView.m
//  TMSStickerView
//
//  Created by TMS on 2019/1/17.
//  Copyright © 2019年 TMS. All rights reserved.
//

#import "TMSInputView.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "TMSStickerView.h"
#import <IQKeyboardManager.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface TMSInputView ()<UITextViewDelegate, TMSEmojiViewDelegate>
@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;
@property (nonatomic, strong) UIButton *stickerBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) TMSStickerView *stickerView;
@property (nonatomic, strong) UITapGestureRecognizer *textViewTap;
@end

@implementation TMSInputView

- (instancetype)init {
    
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configViews];

    }
    return self;
}

- (void)stickerButttonBackToOriginalState {
    self.stickerView.textView = nil;
    [self.textView resignFirstResponder];
    self.stickerBtn.selected = NO;
    self.textView.inputView = nil;

}

- (void)backToTextInput {
    [self btnAction:self.stickerBtn];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)sendCustomEmojiItem:(TMSCustomEmoji *)emojiItem {
    
    NSLog(@"发送自定义表情");
}

- (void)textDidChanged:(NSNotification *)info {
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 9, 5, 6);

        [self layoutIfNeeded];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;

    offset.x = MAX(0, offset.x);
        offset.y = MAX(-5, offset.y);
        scrollView.contentOffset = offset;
}
 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   
    return YES;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        NSLog(@"发送了");
        ExecBlock(self.sendMsgText,textView.text);
        textView.text = nil;
        [self textDidChanged:nil];
        return NO;
    }
    
    return YES;
}

- (void)btnAction:(UIButton *)sender {
    
    [self.textView resignFirstResponder];
    
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 显示表情键盘

        __weak typeof(self) weakSelf = self;
            
            self.stickerView.sendActionBlock = ^(id emoji) {
                NSLog(@"%@", weakSelf.textView.text);
                ExecBlock(weakSelf.sendMsgText,weakSelf.textView.text);
                weakSelf.textView.text = nil;
                weakSelf.stickerView.textView = nil;
                [weakSelf.textView resignFirstResponder];
                [weakSelf textDidChanged:nil];
            };
            [self.stickerView setTextView:self.textView];
      
        
    } else {
        self.stickerView.textView = nil;
        self.textView.inputView = nil;

    }

    [self.textView becomeFirstResponder];
}

#pragma mark - Initialize
- (void)configViews {
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 70, 35)];

    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];;

    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 9, 5, 6);
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;

    [self.textView resignFirstResponder];
    
    self.textView.text = nil;
    self.textView.scrollsToTop = YES;
    self.textView.textAlignment = NSTextAlignmentLeft;
    
    self.textView.automaticallyAdjustsScrollIndicatorInsets = NO;
    
    [self.textView setPlaceholderWithText:TransOutput(@"请输入你的问题") Color:RGB(0x666666)];
    [self addSubview:self.textView];

    UIButton *stickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stickerBtn setBackgroundImage:[UIImage imageNamed:@"q_chat_emoji_black_normal"] forState:UIControlStateNormal];
    [stickerBtn setBackgroundImage:[UIImage imageNamed:@"q_chat_keyboard_black_normal"] forState:UIControlStateSelected];
    [stickerBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stickerBtn];
    self.stickerBtn = stickerBtn;
    [stickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.bottom.equalTo(self.textView).offset(-4);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        static CGFloat statusBarFrameHeight;
        dispatch_once(&onceToken, ^{
            statusBarFrameHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        });
        if (statusBarFrameHeight == 20) {
            return UIEdgeInsetsZero;
        }
        return [AppDelegate sharedDelegate].window.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (TMSStickerView *)stickerView {
    
    if (!_stickerView) {
      
        _stickerView = [TMSStickerView showEmojiViewWithoutCustomEmoji];
        _stickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190 + self.safeAreaInsets.bottom + 5);
    }
    _stickerView.delegate = self;
    
    return _stickerView;
}


@end

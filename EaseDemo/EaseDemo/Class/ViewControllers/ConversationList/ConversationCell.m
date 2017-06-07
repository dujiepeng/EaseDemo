//
//  ConversationCell.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "ConversationCell.h"
#import <UIImageView+WebCache.h>

@interface ConversationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;
@end

@implementation ConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 这里做了未读角标的圆角，同样可以做头像的圆角。以下的实现方式可能影响渲染速度，可以自己去画一个圆角或者用贴图来遮盖达到圆角效果。
    self.unreadCountLabel.layer.cornerRadius = CGRectGetWidth(self.unreadCountLabel.frame) / 2;
    self.unreadCountLabel.layer.masksToBounds = YES;
    
    self.headImageView.layer.cornerRadius = CGRectGetWidth(self.headImageView.frame) / 2;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setModel:(ConversationModel *)model {
    _model = model;
    self.nickLabel.text = [model nick];
    self.timeLabel.text = [model latestMsgTimeStr];
    self.infoLabel.text = [model msgInfo];
    self.unreadCountLabel.text = [model unreadCountStr];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[model avatarPath]] placeholderImage:nil];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.unreadCountLabel.backgroundColor = [UIColor redColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.unreadCountLabel.backgroundColor = [UIColor redColor];
}

@end

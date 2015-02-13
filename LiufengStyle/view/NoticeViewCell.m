//
//  NoticeViewCell.m
//  LiufengStyle
//
//  Created by lfs on 14-12-27.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "NoticeViewCell.h"

@implementation NoticeViewCell

@synthesize noticeCTR;
@synthesize keyword;
@synthesize noticeTitle;
@synthesize publishedTime;

-(NSString *) reuseIdentifier
{
    return NoticeCellIdentifier;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews

{
    
    [super layoutSubviews];
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

@end

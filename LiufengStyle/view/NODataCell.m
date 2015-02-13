//
//  NODataCell.m
//  LiufengStyle
//
//  Created by lfs on 15-1-16.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "NODataCell.h"
#import "NSLayoutConstraint+ClassMethodPriority.h"

@implementation NODataCell

@synthesize labeltext;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

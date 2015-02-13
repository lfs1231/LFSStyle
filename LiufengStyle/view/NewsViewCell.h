//
//  NewsViewCell.h
//  LiufengStyle
//
//  Created by lfs on 15-1-26.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIImageView *homePhotoURL;
@property (weak, nonatomic) IBOutlet UILabel *newsCTR;
@property (weak, nonatomic) IBOutlet UILabel *publishedTime;
@property (weak, nonatomic) IBOutlet UILabel *summary;



@end

//
//  WriteBlogForm.h
//  LiufengStyle
//
//  Created by lfs on 15-1-30.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface WriteBlogForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *blogtitle;
@property (nonatomic, copy) NSString *blogContent;
@property (nonatomic, copy) NSString *categoryid;
@property (nonatomic, strong) UIImage *uploadImageByteData;


@end

//
//  WriteBlogForm.m
//  LiufengStyle
//
//  Created by lfs on 15-1-30.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "WriteBlogForm.h"
#import "CustomButtonCell.h"

@interface WriteBlogForm ()

@end

@implementation WriteBlogForm



-(NSArray *)fields
{
    return @[
             
             
             @{FXFormFieldKey: @"categoryid",FXFormFieldTitle: @"类别",
               FXFormFieldOptions: @[@"us", @"ca", @"gb", @"sa", @"be"]},
             @{FXFormFieldKey: @"blogContent", FXFormFieldTitle: @"博文内容",FXFormFieldType: FXFormFieldTypeLongText},
             @{FXFormFieldKey: @"blogtitle", FXFormFieldTitle: @"博文标题",FXFormFieldType: FXFormFieldTypeText},
             @{FXFormFieldKey: @"uploadImageByteData", FXFormFieldTitle: @"博文图片",FXFormFieldType: FXFormFieldTypeImage},
             
             @{FXFormFieldCell: [CustomButtonCell class], FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm"}
             ];
}



@end

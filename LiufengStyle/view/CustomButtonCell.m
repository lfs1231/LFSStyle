//
//  CustomButtonCell.m
//  CustomButtonExample
//
//  Created by Nick Lockwood on 07/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "CustomButtonCell.h"


@interface CustomButtonCell ()

@property (nonatomic, strong)  UIButton *cellButton;

@end


@implementation CustomButtonCell

//note: we could override -awakeFromNib or -initWithCoder: if we wanted
//to do any customisation in code, but in this case we don't need to

//if we were creating the cell programamtically instead of using a nib
//we would override -initWithStyle:reuseIdentifier: to do the configuration


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        //这里创建一个圆角矩形的按钮
        self.cellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //    能够定义的button类型有以下6种，
        //    typedef enum {
        //        UIButtonTypeCustom = 0,          自定义风格
        //        UIButtonTypeRoundedRect,         圆角矩形
        //        UIButtonTypeDetailDisclosure,    蓝色小箭头按钮，主要做详细说明用
        //        UIButtonTypeInfoLight,           亮色感叹号
        //        UIButtonTypeInfoDark,            暗色感叹号
        //        UIButtonTypeContactAdd,          十字加号按钮
        //    } UIButtonType;
        
        //给定button在view上的位置
        self.cellButton.frame = CGRectMake(0, 0, 200, 40);
        self.cellButton.layer.cornerRadius=10.0;
        
        self.cellButton.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
        self.cellButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        //button背景色
        self.cellButton.backgroundColor = [UIColor greenColor];
        self.cellButton.layer.borderWidth = 1.0;
        self.cellButton.layer.borderColor = [UIColor blackColor].CGColor;
        
        //设置button填充图片
        //[self.cellButton setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
        
        //设置button标题
        [self.cellButton setTitle:@"提交" forState:UIControlStateNormal];
        
        /* forState: 这个参数的作用是定义按钮的文字或图片在何种状态下才会显现*/
        //以下是几种状态
        //    enum {
        //        UIControlStateNormal       = 0,         常规状态显现
        //        UIControlStateHighlighted  = 1 << 0,    高亮状态显现
        //        UIControlStateDisabled     = 1 << 1,    禁用的状态才会显现
        //        UIControlStateSelected     = 1 << 2,    选中状态
        //        UIControlStateApplication  = 0x00FF0000, 当应用程序标志时
        //        UIControlStateReserved     = 0xFF000000  为内部框架预留，可以不管他
        //    };
        
        /*
         * 默认情况下，当按钮高亮的情况下，图像的颜色会被画深一点，如果这下面的这个属性设置为no，
         * 那么可以去掉这个功能
         */
        self.cellButton.adjustsImageWhenHighlighted = NO;
        /*跟上面的情况一样，默认情况下，当按钮禁用的时候，图像会被画得深一点，设置NO可以取消设置*/
        self.cellButton.adjustsImageWhenDisabled = NO;
        /* 下面的这个属性设置为yes的状态下，按钮按下会发光*/
        self.cellButton.showsTouchWhenHighlighted = YES;
        
        /* 给button添加事件，事件有很多种，我会单独开一篇博文介绍它们，下面这个时间的意思是
         按下按钮，并且手指离开屏幕的时候触发这个事件，跟web中的click事件一样。
         触发了这个事件以后，执行butClick:这个方法，addTarget:self 的意思是说，这个方法在本类中
         也可以传入其他类的指针*/
        [self.cellButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        //显示控件
        [self.contentView  addSubview:self.cellButton];
    }
    
    return self;
}

- (IBAction)buttonAction
{
    if (self.field.action) self.field.action(self);
}

@end

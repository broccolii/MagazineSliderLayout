//
// MagazineSliderCell.m
// LiangCang
//
// Created by ZhJian on 15/6/3.
// Copyright (c) 2015年 ZhJian. All rights reserved.
//

#import "MagazineSliderCell.h"
#import "PrefixHeader.pch"

@interface MagazineSliderCell()
{
    BOOL hasLayout;
}

@property(nonatomic, strong) NSURL *currentBackURL;
@property(nonatomic) NSUInteger cellIndex;

@end

@implementation MagazineSliderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hasLayout = NO;
        self.clipsToBounds = YES;
        //根据当前CELL所在屏幕的不同位置，初始化IMAGEVIEW的相对位置，为了配合滚动时的IMAGEVIEW偏移动画
        //(screen_y-attributes.frame.origin.y)/56880
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, IMAGEVIEW_ORIGIN_Y-self.frame.origin.y/HEIGHT*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_CURRHEIGHT)];
        self.maskView.backgroundColor = [UIColor redColor];
        self.maskView.alpha = 0.6;
        [self addSubview:self.maskView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2, CELL_WIDTH, TITLE_HEIGHT)];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:20];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.contentMode = UIViewContentModeCenter;
        self.title.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        self.title.center = self.contentView.center;
        [self.title setBackgroundColor:[UIColor clearColor]];
        
        self.desc = [[UILabel alloc] initWithFrame:CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2+30, 300, 0)];
        self.desc.textColor = [UIColor whiteColor];
        self.desc.font = [UIFont systemFontOfSize:14];
        self.desc.alpha = 0;
        self.desc.textAlignment = NSTextAlignmentCenter;
        self.desc.backgroundColor = [UIColor clearColor];
        [self addSubview:self.desc];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)revisePositionAtFirstCell
{
    if(self.tag == 1){
        self.desc.frame = CGRectMake(0, 85+60, WIDTH, self.desc.frame.size.height);
        self.title.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        self.desc.alpha = 0.85;
        self.title.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.contentView.center.y);
    }
}

-(void)setIndex:(NSUInteger)index
{
    self.cellIndex = index;
    if (self.cellIndex == 0) {
        
        self.maskView.alpha = 0;
        self.backgroundColor = [UIColor lightGrayColor];
        
    }else if(self.cellIndex == 1){
        
        self.maskView.alpha = 0.2;
        self.backgroundColor = [UIColor redColor];
        
    }else{
        
        self.maskView.alpha = 0.6;
        self.backgroundColor = [UIColor blueColor];
        
    }
    [self setImageViewPostion];
}

-(void)setImageViewPostion
{
    if (self.imageView) {
        self.imageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y-64-self.frame.origin.y/HEIGHT*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT);
    }
}

-(void)setTitleLabel:(NSString *)string
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    self.title.attributedText = str;
}

-(void)setDescLabel:(NSString *)string
{
    if(string == nil || [string isEqualToString:@""]){
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    self.desc.attributedText = str;
    self.desc.frame = CGRectMake(10, self.desc.frame.origin.y, 300, 30);
}

/**
 
 重置属性 */
-(void)reset {
    self.imageView.image = nil;
    self.title.text = @"";
    self.desc.text = @"";
}

-(void)dealloc
{
    self.imageView = nil;
    self.maskView = nil;
    self.title = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了cell");
}

@end

//
//  LBSettingCell.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSettingCell.h"

@implementation LBSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubView];
        self.selectionStyle = UITableViewCellEditingStyleNone;
    }
    return self;
}

- (void)createSubView{
    self.customLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.customLabel.width = 300;
    self.customLabel.backgroundColor = [UIColor clearColor];
    self.customLabel.textAlignment = UITextAlignmentRight;
    self.customLabel.font = [UIFont systemFontOfSize:14.0f];
    self.customLabel.textColor = [UIColor grayColor];
    self.customLabel.hidden = YES;
    [self addSubview:self.customLabel];
    
    self.customSwich = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [self.customSwich setOnTintColor:RGB(191, 8, 8)];
    [self.customSwich addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.customSwich.right = self.right - 10;
    self.customSwich.centerY = self.centerY;
    self.customSwich.hidden = YES;
    [self addSubview:self.customSwich];
}

- (void)switchChangeValue:(UISwitch *)mSwitch{
    if (mSwitch.tag == 100) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:mSwitch.isOn] forKey:AutoPlay];

    }else if (mSwitch.tag == 101){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:mSwitch.isOn] forKey:DailyPush];
        [LocalPushHelper performSelectorInBackground:@selector(setLocationPush) withObject:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

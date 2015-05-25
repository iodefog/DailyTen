//
//  LBLayoutLayer.m
//  LeBo
//
//  Created by 乐播 on 13-3-21.
//
//

#import "LBLayoutLayer.h"

@implementation LBLayoutLayer

- (void)layoutSublayers
{
    if([self.layoutDelegate respondsToSelector:_layoutMethod])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.layoutDelegate performSelector:_layoutMethod withObject:self];
#pragma clang diagnostic pop

    }
}

- (void)setLayoutMethod:(SEL)method
{
    _layoutMethod = method;
}
@end

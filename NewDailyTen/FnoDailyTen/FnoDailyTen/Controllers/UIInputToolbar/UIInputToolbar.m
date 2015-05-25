/*
 *  UIInputToolbar.m
 *
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"

@implementation UIInputToolbar

@synthesize textView;
@synthesize inputButton;
@synthesize delegate;
@synthesize audioTime;
@synthesize currentIsText;


-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar:@""];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:@""];
    }
    return self;
}

-(void)inputButtonMoviePressed
{    
    if (!button.currentTitle) {
        [button setTitle:@"文字" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"text_comment"] forState:UIControlStateNormal];
        if (!voiceButton) {
            UILongPressGestureRecognizer *longGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)] autorelease];
            longGesture.minimumPressDuration = 0.1;
            longGesture.delegate = self;
            
            voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            voiceButton.frame = CGRectMake(textView.frame.origin.x, 1.5 , 116 , 41);
            [voiceButton setTitle:@"按住说话" forState:UIControlStateNormal];
            [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg.png"] forState:UIControlStateNormal];
            [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg_selected.png"] forState:UIControlStateSelected];
            [voiceButton addGestureRecognizer:longGesture];
            [self addSubview:voiceButton];
        }

        if (!movieButton) {
            movieButton = [UIButton buttonWithType:UIButtonTypeCustom];
            movieButton.frame = CGRectMake(voiceButton.frame.origin.x + voiceButton.frame.size.width + 10, voiceButton.frame.origin.y , 116 , 41);
            [movieButton setTitle:@"视频评论" forState:UIControlStateNormal];
            [movieButton setBackgroundImage:[[UIImage imageNamed:@"comment_bg.png"] stretchableImageWithLeftCapWidth:[UIImage imageNamed:@"comment_bg.png"].size.width/2 topCapHeight:[UIImage imageNamed:@"comment_bg.png"].size.height/2] forState:UIControlStateNormal];
            [movieButton setBackgroundImage:[[UIImage imageNamed:@"comment_bg_selected.png"] stretchableImageWithLeftCapWidth:[UIImage imageNamed:@"comment_bg_selected.png"].size.width/2 topCapHeight:[UIImage imageNamed:@"comment_bg_selected.png"].size.height/2] forState:UIControlStateSelected];
            [movieButton addTarget:self action:@selector(movieBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:movieButton];
        }
        
        textView.hidden = YES;
        movieButton.hidden = NO;
        voiceButton.hidden = movieButton.hidden;
        [textView resignFirstResponder];
        self.currentIsText = NO;
    }else{
        self.currentIsText = YES;
        [button setImage:[UIImage imageNamed:@"comment_audio"] forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateNormal];
        textView.hidden = NO;
        movieButton.hidden = YES;
        voiceButton.hidden = movieButton.hidden;
        [self.textView focus];
    }
}

- (void)longGesture:(UILongPressGestureRecognizer *)gestrure{
    //长按开始
    if(gestrure.state == UIGestureRecognizerStateBegan) {
        [self voiceBtnDownClicked:nil];
    }
    //长按结束
    //    else if(gestrure.state == UIGestureRecognizerStateEnded || gestrure.state == UIGestureRecognizerStateCancelled){
    //        
    //    }
}

- (void)movieBtnClicked:(UIButton *)sender{
    if (delegate && [delegate respondsToSelector:@selector(inputMovieButtonPressed)]){
        [delegate performSelector:@selector(inputMovieButtonPressed)];
    }
}

- (void)voiceBtnDragClicked:(UIControl *)c withEvent:(UIEvent *)ev {
    CGPoint point = [[[ev allTouches] anyObject] locationInView:c];
    if(point.y > 120 && point.y <366)
    {
        c.center = CGPointMake(237, point.y - c.bounds.size.height/2 -5);
    }
}

- (void)voiceBtnDragClicked:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(voicebtnDragClicked)]){
        if (cancelAudioSender == NO) {
            [self.delegate performSelector:@selector(voicebtnDragClicked)];
            cancelAudioSender = YES;
//            [[AMRObject shareInstance] endVoiceRecorderIsNeedSend:NO];
//            [[AMRObject shareInstance] deleteAllAudio];
            [sender setTitle:@"按住说话" forState:UIControlStateNormal];
        }
    }
}

- (void)voiceBtnUpClicked:(UIButton *)sender{
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg.png"] forState:UIControlStateHighlighted];
    [sender setBackgroundImage:[UIImage imageNamed:@"comment_bg.png"] forState:UIControlStateNormal];
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.0];
}

- (void)endRecord{
//    [[AMRObject shareInstance] endVoiceRecorderIsNeedSend:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(voiceBtnUpClicked)])
    {
        [self.delegate performSelector:@selector(voiceBtnUpClicked)];
    }
}

- (void)voiceBtnDownClicked:(UIButton *)sender{
    NSLog(@"down");
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg_selected.png"] forState:UIControlStateNormal];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg_selected.png"] forState:UIControlStateSelected];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg_selected.png"] forState:UIControlStateHighlighted];
    [sender setUserInteractionEnabled:NO];
    [voiceButton setTitle:@"松开结束" forState:UIControlStateNormal];
//    [[AMRObject shareInstance] startVoiceRecorderTarget:self];
    cancelAudioSender = NO;
}

- (void)audioPlayerFinished{
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg.png"] forState:UIControlStateHighlighted];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"comment_bg.png"] forState:UIControlStateNormal];
    [voiceButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [voiceButton setUserInteractionEnabled:YES];
}

- (void)recoderFinishedFileName:(NSString *)fileName baseFilePath:(NSString *)basePath{
//    AMRObject *amrObject = [AMRObject shareInstance];
//    self.audioTime = amrObject.audioTime;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(recoderFinishedFileName:baseFilePath:)]){
        [self.delegate performSelector:@selector(recoderFinishedFileName:baseFilePath:) withObject:fileName withObject:basePath];
    }
}


- (void)inputButtonPressed
{
    if ([delegate respondsToSelector:@selector(inputButtonPressed:)] && ![textView.text isEqualToString:@""])
    {
        NSString *temp = nil;
        int j = 0;
        for(int i =0; i < [textView.text length]; i++)
        {
            temp = [textView.text substringWithRange:NSMakeRange(i, 1)];
            NSLog(@"第%d个字是:%@",i,temp);
            if (![temp isEqualToString:@" "]) {
                j = 1;
            }
        }
        
        if (j == 1) {
            [delegate inputButtonPressed:self.textView.text];
            [textView resignFirstResponder];
        }
    }
    NSLog(@"评论");
}

-(void)setupToolbar:(NSString *)buttonLabel
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.tintColor = [UIColor lightGrayColor];
    
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"text_comment"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    
    
    button                         = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font         = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    //button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
//    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    [button setImage:buttonImage forState:UIControlStateNormal];
    //[button setTitle:buttonLabel forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inputButtonMoviePressed) forControlEvents:UIControlEventTouchDown];
    [button sizeToFit];
    
    CGRect r = button.frame;
    button.frame = CGRectMake(r.origin.x,
                              r.origin.y,
                              r.size.width+10,
                              40.0);
  
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"firstConmentMoiveTape"])
    {
        UIImageView *imageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0 , 20, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:@"firstTip4s.png"]];
        
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewOverlayTapped:)]];
        [[UIApplication sharedApplication].windows[0] addSubview:imageView];
        [[NSUserDefaults standardUserDefaults] setObject:@"firstConmentMoiveTape" forKey:@"firstConmentMoiveTape"];
    }
    
    inputButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButton.enabled = YES;
    
    /* Create UIExpandingTextView input */
    //    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(7, 7, 236, 26)];
    textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(70, 7, 236, 30)];
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(54.0f, 0.0f, 10.0f, 0.0f);
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    NSArray *items = [NSArray arrayWithObjects:  self.inputButton,flexItem, nil];
    [self setItems:items animated:NO];
    
    [self inputButtonMoviePressed];
    self.backgroundColor = [UIColor colorWithRed:241.0/255.f green:241.0/255.f blue:241.0/255.f alpha:1.0f];
    self.tintColor = [UIColor colorWithRed:241.0/255.f green:241.0/255.f blue:241.0/255.f alpha:1.0f];
}

- (void)removeViewOverlayTapped:(UIGestureRecognizer*)gestureRecognizer
{
    [gestureRecognizer.view removeFromSuperview];
}

#pragma changeToolBar delegate
- (void)changeToolbarSend
{
//    UIImage *buttonImage = [UIImage imageNamed:@"searchBar_cancel.png"];
//    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"发送" forState:UIControlStateNormal];
}

- (void)changeToolbarMovie
{
//    UIImage *buttonImage = [UIImage imageNamed:@"comment_button"];
//    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"" forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect
{
    /* Draw custon toolbar background */
    // 评论背景图片
    CGRect i = self.inputButton.customView.frame;
    i.origin.y = self.frame.size.height - i.size.height ;    
    self.inputButton.customView.frame = i;
    button.center = CGPointMake(button.center.x , textView.center.y);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([delegate respondsToSelector: @selector(expandingToolbar:)]) {
        [delegate expandingToolbar: self];
    }
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r ;
    
    //    if ([delegate respondsToSelector: @selector(expandingToolbar:diff:)]) {
    //    if ([delegate respondsToSelector: @selector(expandingToolbar:)]) {
    //        //        [delegate expandingToolbar: self];
    //    }
    
    if ([button.currentTitle isEqualToString:@"文字"]) {
        [self inputButtonMoviePressed];
    }
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    /*
    if ([expandingTextView.text length] > 0)
        self.inputButton.enabled = YES;
    else
        self.inputButton.enabled = NO;
     */
}


#pragma mark -
- (void)focus
{    
    [textView focus];
}

@end

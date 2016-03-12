//
//  PAViewController.m
//  PAGestureAssistant
//
//  Created by Pedro Almeida on 03/12/2016.
//  Copyright (c) 2016 Pedro Almeida. All rights reserved.
//

#import "PAViewController.h"
#import "PAGestureAssistant.h"

@interface PAViewController ()
@property (weak, nonatomic) IBOutlet    UIButton *button1;
@property (weak, nonatomic) IBOutlet    UIButton *button2;
@property (weak, nonatomic) IBOutlet    UIButton *button3;
@property (weak, nonatomic) IBOutlet    UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet    UISlider *slider;
@property (weak, nonatomic) IBOutlet    UILabel  *sliderLabel;

@property (assign, nonatomic)           NSUInteger delay;

@end

@implementation PAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self changeDelay:self.slider];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupAssistant];
    
}

- (void)setupAssistant
{
    // Customize colors
    
    /* Sets a custom overlay color */
    [[PAGestureAssistant appearance] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.75f]];
    
    /* Sets a custom text color */
    [[PAGestureAssistant appearance] setTextColor:self.view.tintColor];
    
    /* Sets the gesture view color */
    [[PAGestureAssistant appearance] setTapColor:self.view.tintColor];
    
    /* Sets a custom image for the gesture view. Overrides the `tapColor`.
     Image credits: https://dribbble.com/shots/1904249-Handy-Gestures */
    [[PAGestureAssistant appearance] setTapImage:[[UIImage imageNamed:@"hand"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    [self showGestureAssistantForTap:PAGestureAssistantTapSingle
                                view:self.optionsButton
                                text:@"Tap to begin"
                   afterIdleInterval:0];
}

- (IBAction)showOptions:(id)sender
{
    [self stopGestureAssistant];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Demo Options" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *singleTap = [UIAlertAction actionWithTitle:@"Tap" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showGestureAssistantForTap:PAGestureAssistantTapSingle
                                    view:self.button1
                                    text:@"Tap me"
                       afterIdleInterval:self.delay];
    }];
    
    UIAlertAction *longPress = [UIAlertAction actionWithTitle:@"Long Press" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showGestureAssistantForTap:PAGestureAssistantTapLongPress
                                    view:self.button3
                                    text:@"Long press me"
                       afterIdleInterval:self.delay];
    }];
    
    UIAlertAction *doubleTap = [UIAlertAction actionWithTitle:@"Custom Text Style" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"Create custom text styles"
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia-Italic" size:16],
                                                                                NSBackgroundColorAttributeName: [UIColor yellowColor]}];
        
        [self showGestureAssistantForTap:PAGestureAssistantTapDouble
                                    view:self.button2
                          attributedText:attr
                       afterIdleInterval:self.delay
                              completion:nil];
    }];
    
    UIAlertAction *swipe = [UIAlertAction actionWithTitle:@"Swipe" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PAGestureAssistantSwipeDirectons options = arc4random_uniform(4);
        NSString *title;
        
        switch (options) {
            case PAGestureAssistantSwipeDirectonUp:     title = @"Swipe up";    break;
            case PAGestureAssistantSwipeDirectonDown:   title = @"Swipe down";  break;
            case PAGestureAssistantSwipeDirectonLeft:   title = @"Swipe left";  break;
            case PAGestureAssistantSwipeDirectonRight:  title = @"Swipe right"; break;
        }
        
        [self showGestureAssistantForSwipeDirection:options
                                               text:title
                                  afterIdleInterval:self.delay];
        
    }];
    
    UIAlertAction *swipe2 = [UIAlertAction actionWithTitle:@"Custom Swipe" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showGestureAssistantForSwipeWithStartPoint:CGPointMake(300, 60) endPoint:CGPointMake(60, 300)
                                                    text:@"You can create custom swipes"
                                       afterIdleInterval:self.delay];
    }];
    
    UIAlertAction *tutorial = [UIAlertAction actionWithTitle:@"Tutorial Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        /* Chain multiple calls to achieve a tutorial efect */
        [self showGestureAssistantForSwipeWithStartPoint:CGPointMake(60, 60) endPoint:self.view.center text:@"You can create custom swipes" afterIdleInterval:0 completion:^(BOOL finished) {
            
            [self showGestureAssistantForTap:PAGestureAssistantTapDouble view:self.button3 text:@"Tap twice" afterIdleInterval:0 completion:^(BOOL finished) {
                
                [self showGestureAssistantForSwipeDirection:PAGestureAssistantSwipeDirectonUp text:@"Swipe up" afterIdleInterval:0 completion:^(BOOL finished) {
                    
                    NSLog(@"[%@] Chain completed", NSStringFromClass([self class]));
                    
                }];
            }];
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self setupAssistant];
    }];
    
    [alertController addAction:singleTap];
    [alertController addAction:longPress];
    [alertController addAction:doubleTap];
    [alertController addAction:swipe];
    [alertController addAction:swipe2];
    [alertController addAction:tutorial];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)changeDelay:(UISlider *)sender
{
    self.delay = round(sender.value);
    self.sliderLabel.text = [NSString stringWithFormat:@"%d second delay", (int)self.delay];
}

- (IBAction)buttonTap:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Yo" message:sender.titleLabel.text preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismiss];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
//
//  ViewController.m
//  AdjustTask
//
//  Created by Sonal Kachare on 04/11/21.
//

#import "ViewController.h"
#import "TimeHandlerViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogResponse;

@end

@implementation ViewController

TimeHandlerViewModel *timeHandlerVM;
NSString *previousSecond;

- (void)viewDidLoad {
    [super viewDidLoad];
    timeHandlerVM = [[TimeHandlerViewModel alloc] init];
    // Do any additional setup after loading the view.
}

- (IBAction)actionLogResponse:(id)sender {
    
    NSString *secondString = [timeHandlerVM getSecondsString];
    self.labelCurrentTime.text = [NSString stringWithFormat: @"for %@ seconds", secondString];
    
    if (previousSecond == secondString) {
        NSLog(@"API already called for %@", secondString);
        return;
    }
    previousSecond = secondString;
    [timeHandlerVM fetchAPIDataWithSeconds:secondString];
}
@end

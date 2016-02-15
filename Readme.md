# ElasticTransition ObjC Version
This is the Objective-C Version of Elastic Transition written in Swift by lkzhao https://github.com/lkzhao/ElasticTransition

A UIKit custom modal transition that simulates an elastic drag. Written in Objective-C. Feel free to contribute!

![demo](https://github.com/lkzhao/ElasticTransition/blob/master/imgs/demo.gif?raw=true)

## Usage

First of all, in your view controller, create an instance of ElasticTransition

```objective-c


- (void)viewDidLoad {

//...

    ElasticTransition *transition = [[ElasticTransition alloc] init];

    // customization
    transition.sticky           = YES;
    transition.showShadow       = YES;
    transition.panThreshold     = 0.4;
    transition.transformType    = TRANSLATEMID;

//...

}
```

- [Navigation Controller Delegate](#use-as-navigation-controllers-delegate)
- [Modal](#present-as-modal)
- [Interactive Present](#interactive-transition-for-modal-transition)
- [Interactive Dismiss](#interactive-transition-for-dismissing-the-modal)

------------------------

#### Use as navigation controller's delegate

Simply assign the transition to your navigation controller's delegate

```objective-c
    navigationController.delegate =transition
```

------------------------

#### Present as modal

In prepareForSegue, assign the transition to be the transitioningDelegate of the destinationViewController.
Also, dont forget to set the modalPresentationStyle to UIModalPresentationCustom

```objective-c
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    segue.destinationViewController.transitioningDelegate = transition;
    segue.destinationViewController.modalPresentationStyle = UIModalPresentationCustom;

}
```

In your modal view controller .h implement the ElasticMenuTransitionDelegate
```objective-c

@interface MenuViewController: UIViewController <ElasticMenuTransitionDelegate>

@end
```

Then in your .m file synthesize the property and provide the contentLength value
```objective-c
@implementation MenuViewController

@synthesize contentLength;

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];

    if (self) {

        self.contentLength = 320.0;

        //...
    }

    return self;
}

@end
```


##### Interactive transition for modal transition

First, construct a pan gesture recognizer

```objective-c
UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] init];
[panGR addTarget:self action:@selector(handlePan:)];
[self.view addGestureRecognizer:panGR];
```

Then implement your gesture handler and fo the following:

```objective-c
-(void)handlePan:(UIPanGestureRecognizer*)pan{

    if (pan.state == UIGestureRecognizerStateBegan){
        // Here, you can do one of two things
        // 1. show a viewcontroller directly
        UIViewController *nextViewController = // construct your VC ...
        [transition startInteractiveTransitionFromViewController:self ToViewController:nextViewController GestureRecognizer:pan];
        // 2. perform a segue
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"menu" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}
```

##### Interactive transition for dismissing the modal

1. Implement ElasticMenuTransitionDelegate in your modal view controller and set

```objective-c
    self.dismissByBackgroundTouch   = YES;
    self.dismissByBackgroundDrag    = YES;
    self.dismissByForegroundDrag    = YES;
```

2. Or use your own panGestureRecognizer and call dissmissInteractiveTransition in your handler
```objective-c
-(void)handlePan:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan){
        [transition dismissInteractiveTransitionViewController:vc GestureRecognizer:pan Completion:nil];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}
```


## License

ElasticTransition-ObjC is available under the MIT license. See the LICENSE file for more info.


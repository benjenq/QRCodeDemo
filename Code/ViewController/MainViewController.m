//
//  MainViewController.m
//  EmptyProject
//
//  Created by Administrator on 16/2/25.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface MainViewController (){
    IBOutlet UIView *_previewView;
    IBOutlet UITextView *_resultContent;
    
    UIView *_highlightView;
    
    dispatch_queue_t _captureQueue;
    
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    
    AVCaptureDevicePosition _deFaultDevicePosition;
    
    BOOL _isReading;
    SystemSoundID alertSound;

}
@end

@implementation MainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"QRCode Demo";
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [_previewView addSubview:_highlightView];
    
    _deFaultDevicePosition = AVCaptureDevicePositionBack;
    _isReading = NO;
    
    
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL URLWithString:[[UIApplication GetBundlePath] stringByAppendingPathComponent:@"beep.wav"]], &alertSound);
    
    [self createCaptureSession:_deFaultDevicePosition];

    [self createPreviewLayer];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    if (_captureSession && _videoPreviewLayer) {
        [self resizePreviewLayer];
        [self startReading:_deFaultDevicePosition];
        
    }
}

- (void)startReading:(AVCaptureDevicePosition)inPosition{
    if (!_captureSession) {
        [self createCaptureSession:inPosition];
    }
    
    if (!_videoPreviewLayer) {
        [self createPreviewLayer];
    }
    
    [_captureSession startRunning];
    NSLog(@"啟用攝影機");
    _isReading = YES;
    [_previewView bringSubviewToFront:_highlightView];
}

- (void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    //_captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    //[_videoPreviewLayer removeFromSuperlayer];
    
}

#pragma mark - Prepare Session & PreviewLayer
-(void)createCaptureSession:(AVCaptureDevicePosition)inPosition{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self chooseDevicePosition:inPosition];
    }
    
    
    if (!_captureQueue) {
        _captureQueue = dispatch_queue_create("captureQueue", NULL);
    }
    AVCaptureMetadataOutput *_metaOutput = [[AVCaptureMetadataOutput alloc] init];
    [_metaOutput setMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)self queue:_captureQueue];
    [_captureSession addOutput:_metaOutput];
    _metaOutput.metadataObjectTypes = [_metaOutput availableMetadataObjectTypes];
    
    NSArray *myDevices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in myDevices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            NSLog(@"後攝影機硬體名稱: %@", [device localizedName]);
        }
        
        if ([device position] == AVCaptureDevicePositionFront) {
            NSLog(@"前攝影機硬體名稱: %@", [device localizedName]);
        }
        
        if ([device hasMediaType:AVMediaTypeAudio]) {
            NSLog(@"麥克風硬體名稱: %@", [device localizedName]);
        }
    }
    
}

- (void)chooseDevicePosition:(AVCaptureDevicePosition)inPosition{
    NSArray *myDevices = [AVCaptureDevice devices];
    __block BOOL isFound = NO;
    
    
    [myDevices enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([device position] == inPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *myDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error!= nil) {
                NSLog(@"取得影像裝置失敗:%@",error);
                return;
            }
            [_captureSession addInput:myDeviceInput];
            NSLog(@"取得影像裝置:%@",[device localizedName]);
            isFound = YES;
        }
        
    }];
    if (!isFound) {
        NSLog(@"沒有錄影裝置");
    }
    else
    {
        NSLog(@"裝置:%@",[_captureSession inputs] );
    }
}

- (void)removeDevicePosition{
    NSLog(@"removeDevicePosition裝置:%@",[_captureSession inputs] );
    [[_captureSession inputs] enumerateObjectsUsingBlock:^(AVCaptureDeviceInput *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_captureSession removeInput:obj];
    }];
    
}


- (void)createPreviewLayer{
    if (!_captureSession) {
        [self createCaptureSession:_deFaultDevicePosition];
    }
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    }
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
    
    //[self resizePreviewLayer];
    
    [_previewView.layer addSublayer:_videoPreviewLayer];

}

- (void)resizePreviewLayer{
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
}

#pragma mark - @protocol AVCaptureMetadataOutputObjectsDelegate <NSObject>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // Check if the metadataObjects array is not nil and it contains at least one object.
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect highlightViewRect = CGRectZero;
        AVMetadataMachineReadableCodeObject *barCodeObject;
        NSString *detectionString = nil;
        NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                  AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barCodeTypes) {
                if ([metadata.type isEqualToString:type])
                {
                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[_videoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    break;
                }
            }
            
            if (detectionString != nil)
            {
                if (![_resultContent.text isEqualToString:detectionString]) {
                    AudioServicesPlaySystemSound (alertSound);
                }
                _resultContent.text = detectionString;
            }
            else
                _resultContent.text = @"(none)";
            
            
        }
        _highlightView.frame = highlightViewRect;
        if (CGRectEqualToRect(highlightViewRect, CGRectZero)) {
            _resultContent.text = @"";
        }

        
    });
    
   
}



#pragma mark 旋轉iOS6.0
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown );//| UIInterfaceOrientationMaskLandscape);
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskPortrait );//| UIInterfaceOrientationMaskLandscape);
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) );//|| (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

@end

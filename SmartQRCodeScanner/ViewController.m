//
//  ViewController.m
//  SmartQRCodeScanner
//
//  Created by Sheeban Shaikh on 5/22/16.
//  Copyright © 2016 SJSU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
-(BOOL)startReading;
-(void)stopReading;


@end

@implementation ViewController

Boolean isReading = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    _captureSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)QRBtnChanged:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [sender setTitle:@"Stop Code Scanning" forState:UIControlStateNormal];
        }
        
        isReading = YES;
    }
    else {
        [self stopReading];
        [sender setTitle:@"Start Code Scanning" forState:UIControlStateNormal];
    }
    _isReading = !_isReading;
    
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
    [_previewView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _qrResult.text = metadataObj.stringValue;
            });
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

-(void)stopReading{
    AVCaptureInput* input = [_captureSession.inputs objectAtIndex:0];
    [_captureSession removeInput:input];
    AVCaptureVideoDataOutput* output = [_captureSession.outputs objectAtIndex:0];
    [_captureSession removeOutput:output];
    [_captureSession stopRunning];
    _captureSession = nil;
    [_startQRBtn setTitle:@"Scan QR Code" forState:UIControlStateNormal];
    
    [_videoPreviewLayer removeFromSuperlayer];
}


@end
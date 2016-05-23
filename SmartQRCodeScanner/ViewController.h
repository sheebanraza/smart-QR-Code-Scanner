//
//  ViewController.h
//  SmartQRCodeScanner
//
//  Created by Sheeban Shaikh on 5/22/16.
//  Copyright © 2016 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startQRBtn;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UILabel *qrResult;

@end


//
//  ViewController.h
//  DownloadTask
//
//  Created by Oscar Rodriguez Garrucho on 23/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSURLSession *session;
@end


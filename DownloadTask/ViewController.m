//
//  ViewController.m
//  DownloadTask
//
//  Created by Oscar Rodriguez Garrucho on 23/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize session;
NSUInteger taskIdentifier;
NSURLSessionDownloadTask *downloadTask;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *str = @"testFolder/download.png";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullImgNm=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
    [self.imageView setImage:[UIImage imageWithContentsOfFile:fullImgNm]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadButtonPressed:(id)sender {
    NSLog(@"download pressed");
    [self downloadImageTask];
    
}

- (IBAction)deleteButtonPressed:(id)sender {
    NSLog(@"delete pressed");
    self.imageView.image = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //getting application's document directory path
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    //adding a new folder to the documents directory path
    NSString *fileName = [docsDir stringByAppendingPathComponent:@"/testFolder/download.png"];
    if ([fileManager fileExistsAtPath:fileName]) {
        
        BOOL isDeleted = [fileManager removeItemAtPath:fileName error:&error];
        NSLog(@"file removed correctly? %@", isDeleted? @"Yes" : @"No");
    }
    else {
        NSLog(@"There isn't anything to remove");
    }
}

-(void)downloadImageTask{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"es.oscargarrucho.DownloadTask"];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://www.compulab.com/wp-content/uploads/2015/09/Support_resources_icon.png"]];
    downloadTask.priority=NSURLSessionTaskPriorityLow;
    
    // Keep the new task identifier.
    taskIdentifier = downloadTask.taskIdentifier;
    NSLog(@"Start download with task: %lu", (unsigned long)taskIdentifier);
    
    // Start the task.
    [downloadTask resume];
}



// While is downloading...
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            double downloaded = ((double)totalBytesWritten / (double)totalBytesExpectedToWrite) * 100;
            self.infoLabel.text = [NSString stringWithFormat:@"Download... %f %%", downloaded];
            NSLog(@"Download... %f %%", downloaded);
        }];
    }
}

// Finish downloading...
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.infoLabel.text = [NSString stringWithFormat:@"www.oscargarrucho.com"];
    }];
    
    //getting application's document directory path
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    //adding a new folder to the documents directory path
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/testFolder/"];
    
    NSString *fileName = @"download.png";
    
    //Checking for directory existence and creating if not already exists
    if(![fileManager fileExistsAtPath:appDir])
    {
        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    //retrieving the filename from the response and appending it again to the path
    //this path "appDir" will be used as the target path
    //appDir =  [appDir stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]]; // We can change the name here
    appDir =  [appDir stringByAppendingFormat:@"/%@",fileName];
    
    //checking for file existence and deleting if already present.
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
    }
    
    //moving the file from temp location to app's own directory
    BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:appDir error:&error];
    NSLog(fileCopied ? @"Yes" : @"No");
    NSLog(@"%@", appDir);
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       // Main thread work (UI usually)
                       NSString *str = @"testFolder/download.png";
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                       NSString *documentsDirectory = [paths objectAtIndex:0];
                       NSString *fullImgNm=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                       [self.imageView setImage:[UIImage imageWithContentsOfFile:fullImgNm]];
                       NSLog(@"Image loaded successfully -> %@", fullImgNm);
                   });
    
}




@end

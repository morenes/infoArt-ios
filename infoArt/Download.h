//
//  Download.h
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Res.h"
@protocol DownloadHelperDelegate <NSObject>
@optional
- (void) didReceiveData: (NSData *) theData;
- (void) didReceiveFilename: (NSString *) aName;
- (void) dataDownloadFailed: (NSString *) reason;
- (void) dataDownloadAtPercent: (NSNumber *) aPercent;
@end

@interface Download : NSObject
{
    NSURLResponse *response;
    NSMutableData *data;
    NSString *urlString;
    NSURLConnection *urlconnection;
    id <DownloadHelperDelegate> delegate;
    BOOL isDownloading;
    
    float expectedLength;
    float currentLength;
}
@property (retain) NSURLResponse *response;
@property (retain) NSOutputStream * stream;
@property (retain) NSURLConnection *urlconnection;
@property (retain) NSMutableData *data;
@property (retain) NSString *urlString;
@property (retain) NSString *path;
@property (retain) id delegate;
@property (assign) BOOL isDownloading;

+ (Download *) sharedInstance;
+ (void) download:(NSString *) aURLString withPath:(NSString *) pathString;
+ (void) cancel;
@end
//
//  Download.m
//  infoArt
//
//  Created by mac mini on 5/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "Download.h"
#define DELEGATE_CALLBACK(X, Y) if (sharedInstance.delegate && [sharedInstance.delegate respondsToSelector:@selector(X)]) [sharedInstance.delegate performSelector:@selector(X) withObject:Y];
#define NUMBER(X) [NSNumber numberWithFloat:X]

static Download *sharedInstance = nil;

@implementation Download
@synthesize response;
@synthesize data;
@synthesize delegate;
@synthesize urlString;
@synthesize urlconnection;
@synthesize isDownloading;
@synthesize path;

- (void) start
{
    self.stream = [[NSOutputStream alloc] initToFileAtPath:path append:YES];
    [self.stream open];
    //
    self.isDownloading = NO;
    NSLog(@"Start");
    NSURL *url = [NSURL URLWithString:self.urlString];
    if (!url)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", self.urlString];
        NSLog(@"%@",reason);
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    if (!theRequest)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", self.urlString];
        NSLog(@"%@",reason);
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    self.urlconnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!self.urlconnection)
    {
        NSString *reason = [NSString stringWithFormat:@"URL connection failed for string %@", self.urlString];
        NSLog(@"%@",reason);
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        return;
    }
    
    self.isDownloading = YES;
    NSLog(@"esta descargando");
    // Create the new data object
    self.data = [NSMutableData data];
    self.response = nil;
    
    [self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) cleanup
{
    self.data = nil;
    self.response = nil;
    self.urlconnection = nil;
    self.urlString = nil;
    self.isDownloading = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    // store the response information
    self.response = aResponse;
    expectedLength = [self.response expectedContentLength];
    currentLength =0;
    NSLog(@"response: %@",response);
    // Check for bad connection
    if ([aResponse expectedContentLength] < 0)
    {
        NSString *reason = [NSString stringWithFormat:@"Invalid URL [%@]", self.urlString];
        DELEGATE_CALLBACK(dataDownloadFailed:, reason);
        [connection cancel];
        [self cleanup];
        return;
    }
    
    if ([aResponse suggestedFilename])
        DELEGATE_CALLBACK(didReceiveFilename:, [aResponse suggestedFilename]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    // append the new data and update the delegate
    NSUInteger left = [theData length];
    
    if (self.response)
    {
        currentLength+=left;
        //float currentLength = self.data.length;
        float percent = currentLength / expectedLength;
        DELEGATE_CALLBACK(dataDownloadAtPercent:, NUMBER(percent));
    }
    
    NSUInteger nwr = 0;
    do {
        nwr = [self.stream write:[theData bytes] maxLength:left];
        if (-1 == nwr) break;
        left -= nwr;
    } while (left > 0);
    if (left) {
        NSLog(@"stream error: %@", [self.stream streamError]);
    }
    
    //[self.data appendData:theData];
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // finished downloading the data, cleaning up
    
    NSString* aux=[self.response description];
    self.response = nil;
    [self.stream close];
    [self.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self cleanup];
    
    if (self.delegate)
    {
        //NSData *theData = self.data;
        DELEGATE_CALLBACK(didReceiveData:,aux);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.isDownloading = NO;
    NSLog(@"Error: Failed connection, %@", [error localizedDescription]);
    DELEGATE_CALLBACK(dataDownloadFailed:, @"Failed Connection");
    [self cleanup];
}

+ (Download *) sharedInstance
{
    if(!sharedInstance) sharedInstance = [[self alloc] init];
    return sharedInstance;
}

+ (void) download:(NSString *) aURLString withPath:(NSString *) pathString
{
    sharedInstance.path=[Res getDirWithString:pathString];
    if (sharedInstance.isDownloading)
    {
        NSLog(@"Error: Cannot start new download until current download finishes");
        DELEGATE_CALLBACK(dataDownloadFailed:, @"");
        return;
    }
    
    sharedInstance.urlString = aURLString;
    [sharedInstance start];
}

+ (void) cancel
{
    Download * s=sharedInstance;
    if (s.isDownloading) [sharedInstance.urlconnection cancel];
    s.response = nil;
    [s.stream close];
    [s.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [s cleanup];
}
@end
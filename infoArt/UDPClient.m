#import "UDPClient.h"
#import "GCD/GCDAsyncUdpSocket.h"

static UDPClient *sharedInstance = nil;


@interface UDPClient ()
{
    long tag;
    GCDAsyncUdpSocket *udpSocket;
    NSMutableString *log;
}

@end


@implementation UDPClient
@synthesize delegate;
+ (UDPClient *) sharedInstance
{
    if(!sharedInstance) sharedInstance = [[self alloc] init];
    return sharedInstance;
}
- (void)setupSocket
{
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![udpSocket beginReceiving:&error])
    {
        return;
    }
    
}


- (void)send:(NSString *)string withType:(int)mTipo
{
    
    [self setupSocket];
    //NSString *host=@"192.168.0.134";
    NSString * host=@"www.obtcontrol.com";
    int port=8009;
    
    char array[6]={'O','B','I','A','N','D',};
    char array2[6]={'O','B','F','A','N','D',};
    
    
    int size=sizeof(array)/sizeof(char);
    NSMutableData* data=[[NSMutableData alloc] initWithBytes:array length:size];
    NSData * mensaje=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    short l=[mensaje length];
    short tipo=mTipo;
    char bytes1[sizeof(short)];
    memcpy(bytes1,&l,sizeof(l));
    char bytes2[sizeof(short)];
    memcpy(bytes2,&tipo,sizeof(tipo));
    size=sizeof(bytes1)/sizeof(char);
    [data appendBytes:bytes1 length:size];
    size=sizeof(bytes2)/sizeof(char);
    [data appendBytes:bytes2 length:size];
    [data appendData:mensaje];
    size=sizeof(array2)/sizeof(char);
    [data appendBytes:array2 length:size];
    
    [udpSocket sendData:data toHost:host port:port withTimeout:1 tag:tag];
    tag++;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"hey2");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"hey1");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    
    NSString *msg;
    short lenght=[data length];
    int num=CFSwapInt16LittleToHost(*(int*)([[data subdataWithRange:NSMakeRange(8,2)] bytes]));
    // NSLog(@"tipo: %d",num);
    int len=CFSwapInt16LittleToHost(*(int*)([[data subdataWithRange:NSMakeRange(6,2)] bytes]));
    //NSLog(@"longitud1: %d",len);
    //NSLog(@"longitud2: %d",lenght-17);
    if (len==(lenght-17)){
        data=[data subdataWithRange:NSMakeRange(10,len)];
        msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"1 %@",msg);
    } else{
        len=(len<(lenght-17)) ? (lenght-10) : len;
        data=[data subdataWithRange:NSMakeRange(10,len)];
        msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"2 %@",msg);
        NSInteger last=[msg rangeOfString:@"OBFAND"].location;
        if ((last!=-1)&&(last<[msg length]))
            msg=[msg substringToIndex:last];
        //NSLog(@"2 %@",msg);
        
    }
    [delegate didReceiveString:msg ofType:num];
}

@end
//
//  KPHDialogueEngine.m
//  keepasshttp-objc
//
//  Created by Tim Kretschmer on 4/28/14.
//  Copyright (c) 2014 xbigtk13x. All rights reserved.
//

#import "KPHDialogueEngine.h"

@implementation KPHDialogueEngine
- (id)init
{
    self = [super init];
    if(self){
        self.handlers = [KPHHandlers new];
    }
    return self;
}
- (KPHResponse*) respond:(NSString*)requestJSON
{
    NSError *error = NULL;
    NSDictionary *requestDictionary = [NSDictionary dictionaryWithJSONString:requestJSON error:&error];
    DDLogVerbose(@"===========================================");
    DDLogVerbose(@"Received request: %@",requestJSON);
    KPHRequest* pluginRequest = [[KPHRequest alloc] init :requestDictionary];
    
    NSString* rootUuid =[[[KPHUtil client] rootGroup].Uuid UUIDString];
    NSString* recycleUuid = [[[KPHUtil client] recycleGroup].Uuid UUIDString];
    NSString* hash = [[NSString stringWithFormat:@"%@%@", rootUuid, recycleUuid] sha1];
    KPHResponse* handlerResponse = [[KPHResponse alloc] init:pluginRequest.RequestType hash:hash];
    
    NSObject<KPHRequestHandler> *handler = [self.handlers forRequest:pluginRequest.RequestType];
    if(handler == nil){
        DDLogError(@"No handler is registered for request: [%@]",pluginRequest.RequestType);
    }
    else{
        DDLogVerbose(@"Handling request type: %@",pluginRequest.RequestType);
        KPHAes* aes = [KPHAes new];
        BOOL requestIsValid = [pluginRequest.RequestType isEqual:@"associate"] || [KPHProtocol verifyRequestt:pluginRequest aes:aes];
        if (requestIsValid)
        {
            [handler handle:pluginRequest response:handlerResponse aes:aes];
            [KPHProtocol setResponseVerifier:handlerResponse aes:aes];
        }
        else
        {
            DDLogError(@"Unable to verify request. No handler called");
        }
    }
    DDLogVerbose(@"Responding with: %@",[handlerResponse toJson]);
    return handlerResponse;
}
- (NSString*) respondAsJSON:(NSString*)requestJSON
{
    KPHResponse* handlerResponse = [self respond:requestJSON];
    return [handlerResponse toJson];
}
@end

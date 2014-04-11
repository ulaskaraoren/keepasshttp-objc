//
//  KeyPassHttpEntryConfig.h
//  keypasshttp
//
//  Created by Tim Kretschmer on 4/1/14.
//  Copyright (c) 2014 xbigtk13x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPHEntryConfig : NSObject
//Set of strings
@property (nonatomic) NSSet* Allow;
//Set of string
@property (nonatomic) NSSet* Deny;
@property (nonatomic) NSString* Realm;

- (id) initWithJson:(NSString*)json;
@end

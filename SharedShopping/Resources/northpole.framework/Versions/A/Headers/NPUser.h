//
//  NPUser.h
//  NorthPole
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@interface NPUser : NSObject

// Initialization
- (id)initWithParams:(NSDictionary *)params;

// Public methods
- (void)createWithCompletionBlock:(void (^)(id responseObject))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)findWithCompletionBlock:(void (^)(id responseObject))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;

@end
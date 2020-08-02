//
//  NSObject+WGExtension.m
//  Test1
//
//  Created by Veeco on 2020/8/2.
//  Copyright © 2020 Chance. All rights reserved.
//

#import "NSObject+WGExtension.h"
#import <objc/runtime.h>

@implementation NSObject (WGExtension)

+ (void)load {
    
    Method old = class_getInstanceMethod(self, @selector(methodSignatureForSelector:));
    Method new = class_getInstanceMethod(self, @selector(wg_methodSignatureForSelector:));
    method_exchangeImplementations(old, new);
    
    old = class_getInstanceMethod(self, @selector(forwardInvocation:));
    new = class_getInstanceMethod(self, @selector(wg_forwardInvocation:));
    method_exchangeImplementations(old, new);
}

- (NSMethodSignature *)wg_methodSignatureForSelector:(SEL)aSelector {
    
    if ([self isKindOfClass:NSDictionary.class] || [self isKindOfClass:NSArray.class] || [self isKindOfClass:NSString.class] || [self isKindOfClass:NSNumber.class] || [self isKindOfClass:NSNull.class]) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [self wg_methodSignatureForSelector:aSelector];
}

- (void)wg_forwardInvocation:(NSInvocation *)anInvocation {
    
    __block id target = nil;
    NSArray *arr = @[@{}, @[], @"", @0, [NSNull new]];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj respondsToSelector:anInvocation.selector]) {

            target = obj;
            *stop = YES;
        }
    }];
    [anInvocation invokeWithTarget:target];
}

@end

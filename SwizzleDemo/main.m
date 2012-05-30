//
//  main.m
//  SwizzleDemo
//
//  Created by Christopher Miller on 5/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSContainers+DebugPrint.h"

@interface ExObj : NSObject
@property (strong) NSString *     ivar0;
@property (assign) size_t         ivar1;
@property (strong) NSArray *      ivar2;
@property (strong) NSDictionary * ivar3;
@property (strong) NSSet *        ivar4;
@property (strong) NSOrderedSet * ivar5;
+ (id)exObjWithString:(NSString *)ivar0 uinteger:(size_t)ivar1 array:(NSArray *)ivar2 dictionary:(NSDictionary *)ivar3 set:(NSSet *)ivar4 orderedSet:(NSOrderedSet *)ivar5;
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ExObj * e1 = [ExObj exObjWithString:@"bar"
                                   uinteger:argc
                                      array:[NSArray arrayWithObjects:@"baaz", [NSNumber numberWithFloat:3.141592654], nil]
                                 dictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"baaz", @"string", [NSNumber numberWithFloat:3.141592654], @"number", nil]
                                        set:[NSSet setWithObjects:@"baaz", [NSNumber numberWithFloat:3.141592654], nil]
                                 orderedSet:[NSOrderedSet orderedSetWithObjects:[NSNumber numberWithFloat:3.141592654], @"baaz", nil]];
        ExObj * e0 = [ExObj exObjWithString:@"foo"
                                   uinteger:42
                                      array:[NSArray arrayWithObjects:@"something", [NSNumber numberWithFloat:3.141592654], @"something else", nil]
                                 dictionary:[NSDictionary dictionaryWithObjectsAndKeys:e1, @"e1", @"The quick brown fox jumped over the lazy dog.", @"string", [NSNumber numberWithFloat:3.141592654], @"pi", nil]
                                        set:[NSSet setWithObjects:e1, [NSNumber numberWithFloat:3.141592654], @"something", nil]
                                 orderedSet:[NSOrderedSet orderedSetWithObjects:[NSNumber numberWithFloat:3.141592654], e1, @"something", nil]];

        NSCAssert(fspp_on()==false, @"Swizzle state should be OFF.");
        printf("Before swizzling:\n%s\n", [[e0 description] UTF8String]);
        fflush(stdout);
        NSError * error;
        if (!fspp_swizzleContainerPrinters(&error)) {
            NSLog(@"Error: %@", error);
        }
        NSCAssert(fspp_on()==true, @"Swizzle state should be ON.");
        printf("\nAfter swizzling:\n%s\n", [[e0 description] UTF8String]);
        printf("\nfspp_spacesPerIndent = 2\n");
        fspp_spacesPerIndent = 2;
        printf("%s\n", [[e0 description] UTF8String]);
        if (!fspp_swizzleContainerPrinters(&error)) {
            NSLog(@"Error: %@", error);
        }
        NSCAssert(fspp_on()==false, @"Swizzle state should be OFF.");
    }
    return 0;
}

@implementation ExObj
@synthesize ivar0=_ivar0,ivar1=_ivar1,ivar2=_ivar2,ivar3=_ivar3,ivar4=_ivar4,ivar5=_ivar5;
+ (id)exObjWithString:(NSString *)ivar0 uinteger:(size_t)ivar1 array:(NSArray *)ivar2 dictionary:(NSDictionary *)ivar3 set:(NSSet *)ivar4 orderedSet:(NSOrderedSet *)ivar5
{
    ExObj * e = [[self alloc] init];
    if (e) {
        e.ivar0=ivar0;
        e.ivar1=ivar1;
        e.ivar2=ivar2;
        e.ivar3=ivar3;
        e.ivar4=ivar4;
        e.ivar5=ivar5;
    }
    return e;
}
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];
    NSString * sub_indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent];
    
    [str appendFormat:@"%@<%@:%p\n",indent, NSStringFromClass([self class]), (const void*)self];
    [str appendFormat:@"%@%@ivar0: %@\n",indent,sub_indent,[_ivar0 fs_stringByEscaping]];
    [str appendFormat:@"%@%@ivar1: %lu\n",indent,sub_indent,_ivar1];
    [str appendFormat:@"%@%@ivar2: %@\n",indent,sub_indent,[[_ivar2 descriptionWithLocale:locale indent:level+2] fs_stringByTrimmingWhitespace]];
    [str appendFormat:@"%@%@ivar3: %@\n",indent,sub_indent,[[_ivar3 descriptionWithLocale:locale indent:level+2] fs_stringByTrimmingWhitespace]];
    [str appendFormat:@"%@%@ivar4: %@\n",indent,sub_indent,[[_ivar4 descriptionWithLocale:locale indent:level+2] fs_stringByTrimmingWhitespace]];
    [str appendFormat:@"%@%@ivar5: %@>",indent, sub_indent,[[_ivar5 descriptionWithLocale:locale indent:level+2] fs_stringByTrimmingWhitespace]];
    
    return str;
}
- (NSString *)description { return [self descriptionWithLocale:nil indent:0]; }
@end

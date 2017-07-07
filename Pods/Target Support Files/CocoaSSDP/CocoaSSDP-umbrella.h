#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SSDPService.h"
#import "SSDPServiceBrowser.h"
#import "SSDPServiceTypes.h"

FOUNDATION_EXPORT double CocoaSSDPVersionNumber;
FOUNDATION_EXPORT const unsigned char CocoaSSDPVersionString[];


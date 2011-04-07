//
//	URINSStringAdditions.m
//	Skyrock.com
//
//	Created by Frank Denis on 06/01/11.
//	Copyright 2011 Skyrock / C9X. All rights reserved.
//

#import "URINSStringAdditions.h"


@implementation NSString (URINSStringAdditions)

- (NSString *) urlEncode {
	NSString *newString = NSMakeCollectable
	([(NSString *) CFURLCreateStringByAddingPercentEscapes
	  (kCFAllocatorDefault, (CFStringRef)self, NULL,
	   CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
	   CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease]);
	if (newString) {
		return newString;
	}
	return @"";
}

@end


#import "SimpleAd.h"

@implementation SimpleAd

@synthesize pageId;
@synthesize bannerId, bannerUrl, extendedBannerUrl, redirectionUrl;
@synthesize bannerImage, extendedBannerImage;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (qualifiedName) {
		elementName = qualifiedName;
	}
	if (![elementName isEqualToString: @"banner"]) {
		return;
	}
	[bannerId release];
	[bannerUrl release];
	[extendedBannerUrl release];
	[redirectionUrl release];
	bannerId = [attributeDict valueForKey: @"id"];
	bannerUrl = [attributeDict valueForKey: @"bannerUrl"];	
	extendedBannerUrl = [attributeDict valueForKey: @"extendedBannerUrl"];
	redirectionUrl = [attributeDict valueForKey: @"redirectionUrl"];
	
	// Workaround for invalid (unescaped) URIs
	redirectionUrl = [redirectionUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	[bannerId retain];
	[bannerUrl retain]; 
	[extendedBannerUrl retain]; 
	[redirectionUrl retain];
}

@end

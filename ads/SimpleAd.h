
#import <Foundation/Foundation.h>

@interface SimpleAd : NSObject <NSXMLParserDelegate> {
	NSString *pageId;
	NSString *bannerId, *bannerUrl, *extendedBannerUrl, *redirectionUrl;
	UIImage *bannerImage, *extendedBannerImage;	
}

@property(nonatomic, retain) NSString *pageId;
@property(nonatomic, retain) NSString *bannerId, *bannerUrl, *extendedBannerUrl, *redirectionUrl;
@property(nonatomic, retain) UIImage *bannerImage, *extendedBannerImage;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;

@end

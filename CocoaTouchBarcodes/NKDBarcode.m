// -----------------------------------------------------------------------------------
//  NKDBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDBarcode.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@implementation NKDBarcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
// -----------------------------------------------------------------------------------
{
    return [self initWithContent: inContent
                   printsCaption: YES];
}
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    return [self initWithContent:inContent
                   printsCaption:inPrints
                     andBarWidth:.013*screenResolution()
                       andHeight:.5*screenResolution()
                     andFontSize:6.0
                   andCheckDigit:(char)-1];
}
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
         andBarWidth: (float)inBarWidth
           andHeight: (float)inHeight
         andFontSize: (float)inFontSize
       andCheckDigit: (char)inDigit
// -----------------------------------------------------------------------------------
{
    if (self = [super init])
    {
        if (!inContent)
        {
            return nil;
        }
        [self setContent:inContent];

        [self setBarWidth:inBarWidth];
        [self setPrintsCaption:inPrints];
		
        //if (![self printsCaption])
            [self setHeight:inHeight];
        //else
            [self setHeight:inHeight + (captionHeight*screenResolution())];

        // Calculate width based on number of bars needed to encode this content
        [self calculateWidth];

        [self setFontSize: inFontSize];

        // Check digit of -1 means no check digit - couldn't use 0 because
        // 0 could be a valid check digit. Typically calculated, not set
        // outside of the class
        [self setCheckDigit: inDigit];
    }
    return self;
}
// -----------------------------------------------------------------------------------
float screenResolution()
// -----------------------------------------------------------------------------------
{
	struct utsname systemInfo;
	uname(&systemInfo);
	char *name = systemInfo.machine;

	float ppi;
	if ((strstr(name, "iPod") != NULL) && (strstr(name, "iPod4") == NULL)) {
		// older ipod touches
		ppi = 163;
	} else if ((strstr(name, "iPhone") != NULL) && (strstr(name, "iPhone3") == NULL)) {
		// older non-retina iphones
		ppi = 163;
	} else if ((strstr(name, "iPad") != NULL) && (strstr(name, "iPad3") == NULL)) {
		// ipad 1, ipad 2
		ppi = 132;
	} else if (strstr(name, "iPad3") != NULL) {
		// ipad 3
		ppi = 264;
	} else {
		// iphone 4/4s, ipod touch 4g or simulator
		ppi = 326;
	}
	return ppi;
}
// -----------------------------------------------------------------------------------
-(void)setContent:(NSString *)inContent
// -----------------------------------------------------------------------------------
{
    content = inContent;
}
// -----------------------------------------------------------------------------------
-(void)setHeight:(float)inHeight
// -----------------------------------------------------------------------------------
{
    height = inHeight;
}
// -----------------------------------------------------------------------------------
-(void)setWidth:(float)inWidth
// -----------------------------------------------------------------------------------
{
    width = inWidth;
}
// -----------------------------------------------------------------------------------
-(void)calculateWidth
// -----------------------------------------------------------------------------------
{
    [self setWidth:[[self completeBarcode] length] * [self barWidth]];
}
// -----------------------------------------------------------------------------------
-(void)setCheckDigit:(char)inCheckDigit
// -----------------------------------------------------------------------------------
{
    checkDigit = inCheckDigit;
}
// -----------------------------------------------------------------------------------
-(void)setPrintsCaption:(BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    printsCaption = inPrints;
}
// -----------------------------------------------------------------------------------
-(void)setBarWidth:(float)inBarWidth
// -----------------------------------------------------------------------------------
{
    barWidth = inBarWidth;
}
// -----------------------------------------------------------------------------------
-(NSString *)content
// -----------------------------------------------------------------------------------
{
    return content;
}
// -----------------------------------------------------------------------------------
-(float)height
// -----------------------------------------------------------------------------------
{
    return height;
}
// -----------------------------------------------------------------------------------
-(float)width
// -----------------------------------------------------------------------------------
{
    return width;
}
// -----------------------------------------------------------------------------------
-(char)checkDigit
// -----------------------------------------------------------------------------------
{
    return checkDigit;
}
// -----------------------------------------------------------------------------------
-(BOOL)printsCaption
// -----------------------------------------------------------------------------------
{
    return printsCaption;
}
// -----------------------------------------------------------------------------------
-(float)barWidth
// -----------------------------------------------------------------------------------
{
    return barWidth;
}
// -----------------------------------------------------------------------------------
-(BOOL)isSizeValid
// -----------------------------------------------------------------------------------
{
    return YES;
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    // Stub
}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    int			i;
    char		*contentString;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(contentString); i++)
        if ([[self _encodeChar:contentString[i]] isEqual:@""])
            return NO;

    return YES;
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    // Subclasses MUST override - we'll encode dummy character for testing
    return @"1010";
}
// -----------------------------------------------------------------------------------
-(NSString *)barcode
// -----------------------------------------------------------------------------------
{
    NSMutableString 	*theReturn = [NSMutableString stringWithString:@""];
    int			i;
    char		*contentString;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(contentString); i++)
        [theReturn appendString:[self _encodeChar:contentString[i]]];

    if (checkDigit != -1)
        [theReturn appendString:[self _encodeChar:checkDigit]];

    return theReturn;

}
// -----------------------------------------------------------------------------------
-(NSString *)completeBarcode
// -----------------------------------------------------------------------------------
{
    return  [NSString stringWithFormat:@"%@%@%@", [self initiator], [self barcode], [self terminator]];
}
// -----------------------------------------------------------------------------------
-(void)setCaptionHeight:(float)inHeight
// -----------------------------------------------------------------------------------
{
    captionHeight = inHeight;
}
// -----------------------------------------------------------------------------------
-(float)captionHeight
// -----------------------------------------------------------------------------------
{
    return captionHeight;
}
// -----------------------------------------------------------------------------------
-(void)setFontSize:(float)inSize
// -----------------------------------------------------------------------------------
{
    UIFont *font;
    
    fontSize = inSize;

	font = [UIFont systemFontOfSize:[self fontSize]];
	
    [self setCaptionHeight: ([font capHeight]/72) + (.35 * ([font capHeight]/72))];  
}
// -----------------------------------------------------------------------------------
-(float) fontSize
// -----------------------------------------------------------------------------------
{
    return fontSize;
}
// -----------------------------------------------------------------------------------
-(int)digitsToLeft
// -----------------------------------------------------------------------------------
{
    return 0;
}
// -----------------------------------------------------------------------------------
-(int)digitsToRight
// -----------------------------------------------------------------------------------
{
    return 0;
}
// -----------------------------------------------------------------------------------
-(NSString *)leftCaption
// -----------------------------------------------------------------------------------
{
    return [content substringWithRange:NSMakeRange(0, [self digitsToLeft])];
}
// -----------------------------------------------------------------------------------
-(NSString *)rightCaption
// -----------------------------------------------------------------------------------
{
    return [content substringWithRange:NSMakeRange([content length] - [self digitsToRight], [self digitsToRight])];
}
// -----------------------------------------------------------------------------------
-(NSString *)caption
// -----------------------------------------------------------------------------------
{
    if ( ([self digitsToRight] == 0) && ([self digitsToLeft] == 0))
        return content;
    else
        return [content substringWithRange:NSMakeRange([self digitsToLeft],
                                                       [content length] - [self digitsToLeft] - [self digitsToRight])];
}
// -----------------------------------------------------------------------------------
-(float)barBottom:(int)index
// -----------------------------------------------------------------------------------
{
    if ([self printsCaption])
        return  captionHeight * screenResolution();
    else
        return 0.0;
}
// -----------------------------------------------------------------------------------
-(float)barTop:(int)index
// -----------------------------------------------------------------------------------
{
        return [self height];
}
// -----------------------------------------------------------------------------------
-(float)firstBar
// -----------------------------------------------------------------------------------
{
    return 0;
}
// -----------------------------------------------------------------------------------
-(float)lastBar
// -----------------------------------------------------------------------------------
{
    return [self width] - [self barWidth];
}
// -----------------------------------------------------------------------------------
-(NSString *)description
// -----------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"\n\tBarcode Class: %@\n\tContent: %@\n\tCheck Digit:%c\n\tWidth:%f\n\tHeight:%f\n\tBar Width:%f\n\tFont Size:%f\n\tCaption Height:%f",
        [self class],
        [self content],
        [self checkDigit],
        [self width],
        [self height],
        [self barWidth],
        [self fontSize],
        [self captionHeight]];
}
// -----------------------------------------------------------------------------------
- (BOOL)isEqual:(id)anObject
// -----------------------------------------------------------------------------------
{
    NKDBarcode	*compare;

    compare = anObject;

    return  ([[self content] isEqual:[compare content]]);
}
// -----------------------------------------------------------------------------------
- (id)copyWithZone:(NSZone *)zone
// -----------------------------------------------------------------------------------
{
    NKDBarcode *ret =  [[[self class] alloc] initWithContent: [self content]
                                   printsCaption: [self printsCaption]
                                     andBarWidth: [self barWidth]
                                       andHeight: [self height]
                                     andFontSize: [self fontSize]
                                   andCheckDigit: [self checkDigit]];
    [ret calculateWidth];
    return ret;
}
// -----------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder
// -----------------------------------------------------------------------------------
{


    // Since we subclass NSObject, this call to super
    // init is not necessary, but it's good form to
    // include it, as it is possible that someday
    // NSObject's -init method will do something
    // -----------------------------------------------
    self = 	[super init];

    [self setContent:[coder decodeObject]];
    [coder decodeValueOfObjCType:@encode(BOOL)  at:&printsCaption];
    [coder decodeValueOfObjCType:@encode(float) at:&barWidth];
    [coder decodeValueOfObjCType:@encode(float) at:&width];
    [coder decodeValueOfObjCType:@encode(float) at:&height];
    [coder decodeValueOfObjCType:@encode(float) at:&fontSize];
    [coder decodeValueOfObjCType:@encode(float) at:&captionHeight];
    [coder decodeValueOfObjCType:@encode(char)  at:&checkDigit];

    return self;
}
//----------------------------------------------------------------------
- (void) encodeWithCoder: (NSCoder *)coder
//----------------------------------------------------------------------
{
    [coder encodeObject:[self content]];
    [coder encodeValueOfObjCType:@encode(BOOL) at:&printsCaption];
    [coder encodeValueOfObjCType:@encode(float) at:&barWidth];
    [coder encodeValueOfObjCType:@encode(float) at:&width];
    [coder encodeValueOfObjCType:@encode(float) at:&height];
    [coder encodeValueOfObjCType:@encode(float) at:&fontSize];
    [coder encodeValueOfObjCType:@encode(float) at:&captionHeight];
    [coder encodeValueOfObjCType:@encode(char) at:&checkDigit];

}
@end

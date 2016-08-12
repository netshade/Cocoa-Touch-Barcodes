// -----------------------------------------------------------------------------------
// NKDEAN8Barcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 29 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDEAN8Barcode.h"


@implementation NKDEAN8Barcode

// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    self = [super initWithContent:inContent printsCaption:inPrints];

    // If 7 digits provided, calculate check-digit, if 8 provided, trust them
    if ([[self content] length] == 7)
    {
        [self setContent:inContent];
        [self generateChecksum];
    }
    else if ([[self content] length] == 8)
    {
        [self setCheckDigit:[[self content] characterAtIndex:7]];
        [self setContent:[[self content] substringWithRange:NSMakeRange(0,7)]];
    }

    [self calculateWidth];
    return self;
}
// -----------------------------------------------------------------------------------
-(NSString *)barcode
// -----------------------------------------------------------------------------------
{
    /*
     2.	Two number system characters, encoded as left-hand odd-parity characters.
     3.	First two message characters, encoded as left-hand odd-parity characters.
     4.	Center guard bars, encoded as 01010.
     5.	Last three message characters, encoded as right-hand characters.
     6.	Check digit, encoded as right-hand character.
         */
    NSMutableString 	*theReturn = [NSMutableString stringWithString:@""];
    char		*contentString;
    char		numSystem;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    numSystem = contentString[0];

    [theReturn appendString:[self _encodeChar:contentString[0]]];
    [theReturn appendString:[self _encodeChar:contentString[1]]];
    [theReturn appendString:[self _encodeChar:contentString[2]]];
    [theReturn appendString:[self _encodeChar:contentString[3]]];
    [theReturn appendString:@"01010"];
    [theReturn appendString:[[self _encodeChar:contentString[4]] swapHandedness]];
    [theReturn appendString:[[self _encodeChar:contentString[5]] swapHandedness]];
    [theReturn appendString:[[self _encodeChar:contentString[6]] swapHandedness]];
    [theReturn appendString:[[self _encodeChar:checkDigit] swapHandedness]];

    return theReturn;
}
// -----------------------------------------------------------------------------------
-(NSString *)caption
// -----------------------------------------------------------------------------------
{
	return [NSString stringWithFormat:@" %@\t%@%c", [content substringWithRange:NSMakeRange(0,4)],
                                                       [content substringWithRange:NSMakeRange(4,3)],
                                                       [self checkDigit]];

}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    return ([[self content] length] ==7);
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int 	oddSum = 0;
    int 	evenSum = 0;
    int		checkInt;
    char *	code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    oddSum += (code[0] - '0') + (code[2] - '0') + (code[4] - '0') + (code[6] - '0');
    evenSum += (code[1] - '0') + (code[3] - '0') + (code[5] - '0');
    checkInt = 10 - (((oddSum * 3) + evenSum) % 10);

    if (checkInt == 10)
        checkInt = 0;

    checkDigit = checkInt + '0';
}
// -----------------------------------------------------------------------------------
-(float)barBottom:(int)index
// -----------------------------------------------------------------------------------
{
    if ( (index < 4) || (index > ([[self completeBarcode] length] - 4)) || (index == 33) || (index == 35))
        return 0.05*screenResolution();
    else
        return [self captionHeight] * screenResolution();
}
// -----------------------------------------------------------------------------------
-(int)digitsToRight
// -----------------------------------------------------------------------------------
{
    return 0;
}
// -----------------------------------------------------------------------------------
-(int)digitsToLeft
// -----------------------------------------------------------------------------------
{
    return 0;
}
@end

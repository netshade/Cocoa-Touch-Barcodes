// -----------------------------------------------------------------------------------
//  NKDUPCABarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDUPCABarcode.h"

@implementation NKDUPCABarcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;
// -----------------------------------------------------------------------------------
{
    NSRange	range = NSMakeRange(0, 11);
    char	*tempString;
    self = [super initWithContent: inContent
                    printsCaption:inPrints];

    if ([content length] >= 12)
    {
        tempString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
        checkDigit = tempString[11];
        [self setContent:[[self content] substringWithRange:range]];
		//[self generateChecksum];
    }
    else
        [self generateChecksum];
    
    [self calculateWidth];
    return self;
}


// -----------------------------------------------------------------------------------
-(NSString *)barcode
// -----------------------------------------------------------------------------------
{
    NSMutableString 	*theReturn = [NSMutableString stringWithString:@""];
    int			i;
    char		*contentString;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    // First six characters (number system character plus first
    // five digits) encoded with left hand (odd) parity.
    // --------------------------------------------------------
    for (i = 0; i < 6; i++)
        [theReturn appendString:[self _encodeChar:contentString[i]]];

    // Center guard bars
    // -----------------
    [theReturn appendString:@"01010"];

    // Next six characters (next five digits plus check digit)
    // are encoded with right hand parity.
    // --------------------------------------------------------
    for (i = 6; i < 11; i++)
        [theReturn appendString:[[self _encodeChar:contentString[i]] swapHandedness]];

    // And encode the check digit
    // --------------------------
    [theReturn appendString:[[self _encodeChar:checkDigit] swapHandedness]];
    
    return theReturn;
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
	int     oddSum = 0;
	int     evenSum = 0;
	int        i, checkInt;
	int     even = 1;
	char *    code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
	if (strlen(code) == 11)
	{
		i = strlen(code);
		while (i-- > 0) {
			if (even) evenSum += code[i]-'0';
			else      oddSum += code[i]-'0';
			even = !even;
		}

		i = (3*evenSum + oddSum) % 10;
		checkInt = (10-i) % 10; /* complement to 10 */

		checkDigit =  checkInt + '0';
	}
}
/*
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int 	oddSum = 0;
    int 	evenSum = 0;
    int		i, checkInt;
    char *	code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    if (strlen(code) == 11)
    {
        for (i=10; i > 0; i-=2)
        {
            oddSum += (code[i] - '0');
            evenSum += (code[i-1] - '0');
        }

        checkInt = 10 - (((oddSum * 3) + evenSum) % 10);
        if (checkInt == 10)
            checkInt = 0;

        checkDigit = checkInt + '0';
    }
}
*/
// -----------------------------------------------------------------------------------
-(NSString *)caption
// -----------------------------------------------------------------------------------
{
	/*
    // This needs a more elegant solution - the spaces separating the left and right
    // halves of the caption is a hack.
    return [NSString stringWithFormat: @" %@           %@", [content substringWithRange:NSMakeRange([self digitsToLeft], 5)],
                                                   [content substringWithRange:NSMakeRange(6, 5)]];
	 */
	/* A more elegant solution, offered by Sato Akira */
	return [NSString stringWithFormat: @"%@\t%@", [content substringWithRange:NSMakeRange([self digitsToLeft], 5)],[content substringWithRange:NSMakeRange(6, 5)]];
}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    int			i;
    char		*contentString;
	char		tempCheck;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    if (strlen(contentString) != 11)
        return NO;
    
    for (i = 0; i < strlen(contentString); i++)
        if ([[self _encodeChar:contentString[i]] isEqual:@""])
            return NO;

	tempCheck = [self checkDigit];
	[self generateChecksum];
	if (tempCheck != [self checkDigit])
	{
		[self setCheckDigit:tempCheck];
		return NO;
	}

    return YES;
}
@end

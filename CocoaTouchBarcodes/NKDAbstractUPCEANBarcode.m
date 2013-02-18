// -----------------------------------------------------------------------------------
//  NKDAbstractUPCEANBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 11 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDAbstractUPCEANBarcode.h"


@implementation NKDAbstractUPCEANBarcode
// -----------------------------------------------------------------------------------
-(void)calculateWidth
// -----------------------------------------------------------------------------------
{
    // We need to add additional width for the characters to the left and right
    if ([[self content] length] != 0)
        [self setWidth:([[self completeBarcode] length] * [self barWidth]) * 1.2];
    else
        [self setWidth:0.0];
}
// -----------------------------------------------------------------------------------
-(float)firstBar
// -----------------------------------------------------------------------------------
{
    return [self width] * .1;
}
// -----------------------------------------------------------------------------------
-(float)lastBar
// -----------------------------------------------------------------------------------
{
    return ([self width] * .9) - [self barWidth];
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    switch (inChar)
    {
        case '0':
            return @"0001101";
        case '1':
            return @"0011001";
        case '2':
            return @"0010011";
        case '3':
            return @"0111101";
        case '4':
            return @"0100011";
        case '5':
            return @"0110001";
        case '6':
            return @"0101111";
        case '7':
            return @"0111011";
        case '8':
            return @"0110111";
        case '9':
            return @"0001011";
        default:
            return @"";
            break;
    }
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    return @"101";
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return @"101";
}
// -----------------------------------------------------------------------------------
-(int)digitsToRight
// -----------------------------------------------------------------------------------
{
    return 1;
}
// -----------------------------------------------------------------------------------
-(float)barBottom:(int)index
// -----------------------------------------------------------------------------------
{

    if ( (index < 7) || (index > ([[self completeBarcode] length] - 7)) || ( (index >= 45) && (index <= 49)))
        return 0.05*kScreenResolution;
    else
        return [self captionHeight] * kScreenResolution;

}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
	int     oddSum = 0;
	int     evenSum = 0;
	int        i, checkInt;
	int     even = 1;
	//char *    code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
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
		checkInt = (10-i) % 10; // complement to 10

		checkDigit =  checkInt + '0';
	}
}
// -----------------------------------------------------------------------------------
-(int)digitsToLeft
// -----------------------------------------------------------------------------------
{
    return 1;
}
// -----------------------------------------------------------------------------------
-(NSString *)rightCaption
// -----------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"%c", checkDigit];
}

@end

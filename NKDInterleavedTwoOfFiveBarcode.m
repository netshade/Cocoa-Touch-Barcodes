// -----------------------------------------------------------------------------------
//  NKDInterleavedTwoOfFiveBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// ----------------------------------------------------------------------------------
#import "NKDInterleavedTwoOfFiveBarcode.h"


@implementation NKDInterleavedTwoOfFiveBarcode
// -----------------------------------------------------------------------------------
-(NSString *)barcode
// -----------------------------------------------------------------------------------
{
    int				i,j;
    char 			*barcode;
    NSMutableString		*theReturn = [NSMutableString stringWithString:@""];

    // Include the checkdigit if appropriate
    NSMutableString		*encodeTemp = (checkDigit == -1) ? [NSMutableString stringWithString:content]
                                                       : [NSMutableString stringWithFormat:@"%@%c", content, checkDigit];
    
    if ([encodeTemp length] %2 != 0)
        [encodeTemp insertString:@"0" atIndex:0];

    barcode = (char *)[encodeTemp cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    for (i = 0; i < strlen(barcode); i+=2)
    {
        for (j=0;j<5;j++)
        {
            [theReturn appendString:([self _getBarForDigit:barcode[i] forBarNumber:j] == NARROW_BAR) ? @"1" : @"111"];
            [theReturn appendString:([self _getBarForDigit:barcode[i+1] forBarNumber:j] == NARROW_BAR) ? @"0" : @"000"];
        }
    }

    return theReturn;

}
// -----------------------------------------------------------------------------------
-(BOOL)_getBarForDigit:(char)inChar forBarNumber:(int)theBar
// -----------------------------------------------------------------------------------
{
    char *theLookup;
    
    switch (inChar)
    {
        case '0':
            theLookup = "NNWWN";
            break;
        case '1':
            theLookup = "WNNNW";
            break;
        case '2':
            theLookup = "NWNNW";
            break;
        case '3':
            theLookup = "WWNNN";
            break;
        case '4':
            theLookup = "NNWNW";
            break;
        case '5':
            theLookup = "WNWNN";
            break;
        case '6':
            theLookup = "NWWNN";
            break;
        case '7':
            theLookup = "NNNWW";
            break;
        case '8':
            theLookup = "WNNWN";
            break;
        case '9':
            theLookup = "NWNWN";
            break;
        default:
            theLookup = "NNNNN";
            break;
    }
    return ( theLookup[theBar] == 'W') ? WIDE_BAR : NARROW_BAR;
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    return @"1010";
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return @"11101";
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int totalValue = 0;
    int i;
    
    NSMutableString 	*tempContent = ([content length] %2 == 0) ? [NSMutableString stringWithString:content]
                                                               : [NSMutableString stringWithFormat:@"0%@", content];
    char		*encodeString = (char *)[tempContent cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    for (i = 0; i < strlen(encodeString); i += 2)
    {
        totalValue += (encodeString[i] - '0') * 3;
        totalValue += encodeString[i+1] - '0';

    }

    checkDigit = (10 - totalValue % 10) + '0';
}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    // Interleaved 2 of 5 can only encode numbers
    int 	i;
    char	*code = (char *)[content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i=0; i < strlen(code);i++)
    {
        if ( (code[i]  < '0') || (code[i] > '9'))
            return NO;
    }
    return YES;
}
@end

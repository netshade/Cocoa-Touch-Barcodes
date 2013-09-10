// -----------------------------------------------------------------------------------
//  NKDIndustrialTwoOfFiveBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 10 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDIndustrialTwoOfFiveBarcode.h"


@implementation NKDIndustrialTwoOfFiveBarcode
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
    barcode = (char *)[encodeTemp cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(barcode); i++)
    {
        for (j=0;j<5;j++)
        {
            [theReturn appendString:([self _getBarForDigit:barcode[i] forBarNumber:j] == NARROW_BAR) ? @"100" : @"11100"];
        }
    }

    return theReturn;

}
@end

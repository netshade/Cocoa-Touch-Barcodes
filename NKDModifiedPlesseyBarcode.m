// -----------------------------------------------------------------------------------
//  NKDModifiedPlesseyBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Tue May 07 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDModifiedPlesseyBarcode.h"


@implementation NKDModifiedPlesseyBarcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    if ([super initWithContent:[inContent uppercaseString] printsCaption:inPrints])
    {
        // CRC is required for Plessey
        [self generateChecksum];

        // Recalculate width based with check digit
        [self calculateWidth];
    }
    return self;
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    switch (inChar)
    {
        case '0':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT , ZERO_BIT , ZERO_BIT , ZERO_BIT];
        case '1':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT , ZERO_BIT , ZERO_BIT , ZERO_BIT];
        case '2':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT , ONE_BIT , ZERO_BIT , ZERO_BIT];
        case '3':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT , ONE_BIT , ZERO_BIT , ZERO_BIT];
        case '4':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT , ZERO_BIT , ONE_BIT , ZERO_BIT];
        case '5':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT , ZERO_BIT , ONE_BIT , ZERO_BIT];
        case '6':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT , ONE_BIT , ONE_BIT , ZERO_BIT];
        case '7':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT , ONE_BIT , ONE_BIT , ZERO_BIT];
        case '8':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT , ZERO_BIT , ZERO_BIT , ONE_BIT];
        case '9':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT , ZERO_BIT , ZERO_BIT , ONE_BIT];
        default:
            break;
    }
    
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT, ONE_BIT, ZERO_BIT, ONE_BIT];
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"111%@%@%@%@", ZERO_BIT, ZERO_BIT, ONE_BIT, ONE_BIT];
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    NSMutableString *newNum = [NSMutableString stringWithString:@""];
    char 	*code = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy], *productString;
    NSNumber	*product;
    int 	i, productSum=0;

    // Starting from the units position, create a new number with all of
    // the odd position digits in their original sequence.

    for (i = strlen(code)-1; i >=0; i-=2)
        [newNum appendString:[NSString stringWithFormat:@"%c", code[i]]];

    // Multiply this new number by 2
    product = [NSNumber numberWithInt:[newNum intValue] * 2];

    // Add all of the digits of the product from step two.
    productString = (char *)[[product stringValue] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    for (i = 0; i < strlen(productString); i++)
        productSum += (productString[i] - '0');

   //  Add all of the digits not used in step one to the result in step three.
    for (i = strlen(code -2); i >=0; i-=2)
        productSum += (code[i] - '0');

    // Determine the smallest number which when added to the result in step four
    // will result in a multiple of 10. This is the check character
    checkDigit = (productSum%10 == 0) ? '0' : 10 - (productSum%10) + '0';
}
@end

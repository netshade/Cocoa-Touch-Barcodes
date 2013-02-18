// -----------------------------------------------------------------------------------
// NKDUPCEBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 24 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDUPCEBarcode.h"


@implementation NKDUPCEBarcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    self = [super initWithContent:inContent printsCaption:inPrints];

    [self setContent:inContent];
    if([[self content] length] == 11)
        [self setContent:[NKDUPCEBarcode UPCAToUPCE:[NSString stringWithFormat:@"%@%c", [self content], [self checkDigit]]]];
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
    NSMutableString 	*theReturn = [NSMutableString stringWithString:@""];
    int			i;
    char		*contentString;
    char		numSystem;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    numSystem = contentString[0];

    // We skip over number system digit and encode the middle six, using the check digit
    // and number system to decide on the parity, we use only left-hand encoding
    for (i = 1; i < 8; i++)
    {
        if ([self parityForDigit:i] == ODD_PARITY)
            [theReturn appendString:[self _encodeChar:contentString[i]]];
        else
            [theReturn appendString:[[self _encodeChar:contentString[i]] swapParity]];
    }
    return theReturn;
}
// -----------------------------------------------------------------------------------
-(Parity)parityForDigit:(int)index
// -----------------------------------------------------------------------------------
{
    Parity ret = ODD_PARITY;
    switch(index)
    {
        case 1:
            ret = EVEN_PARITY;
            break;
        case 2:
            ret = ([self checkDigit] < '4');
            break;
        case 3:
            ret = ( ([self checkDigit] == '0') || ([self checkDigit] == '4') || ([self checkDigit] == '7') || ([self checkDigit] == '8'));
            break;
        case 4:
            ret = ( ([self checkDigit] == '2') || ([self checkDigit] == '4') || ([self checkDigit] == '5') || ([self checkDigit] == '9'));
            break;
        case 5:
            ret = ( ([self checkDigit] == '2') || ([self checkDigit] == '5') || ([self checkDigit] == '6') || ([self checkDigit] == '7'));
            break;
        case 6:
            ret = ( ([self checkDigit] == '3') || ([self checkDigit] == '6') || ([self checkDigit] == '8') || ([self checkDigit] == '9'));
            break;
    }
    return ([[self content] characterAtIndex:0] == '0') ? ret : !ret;
    
}
// -----------------------------------------------------------------------------------
-(float)barBottom:(int)index
// -----------------------------------------------------------------------------------
{
    if ( (index < 7) || (index > ([[self completeBarcode] length] - 4)))
        return 0.05*kScreenResolution;
    else
        return [self captionHeight] * kScreenResolution;
}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    char		*contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    // Number System must be 0 or 1, elsewise it's an EAN-8 value and needs to be
    // instantiated as an NKDEAN8Barcode
    if ((contentString[0] != '0') && (contentString[0] != '1'))
        return NO;

    // We need to have eight characters, six of which we encode, and one of which is
    // represented by the check digit.
    if (strlen(contentString) != 7)
        return NO;

    return YES;
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return @"010101";
}
// -----------------------------------------------------------------------------------
-(NSString *)caption
// -----------------------------------------------------------------------------------
{

    return [NSString stringWithFormat: @"%@", [content substringWithRange:NSMakeRange(1, 6)]];
}
// -----------------------------------------------------------------------------------
+(NSString *)UPCAToUPCE:(NSString *)UPCA
// -----------------------------------------------------------------------------------
{
    NSMutableString	*tmp;
    NSMutableString	*UPCE = [NSMutableString stringWithString:@""];
    
    if ([UPCA length] >= 12)
    {

        tmp = [NSMutableString stringWithString:[UPCA substringWithRange: NSMakeRange(3,3)]];
        if ( ([tmp isEqual:@"000"]) || ([tmp isEqual:@"100"]) || ([tmp isEqual:@"200"]))
            UPCE = [NSMutableString stringWithFormat:@"%@%@%@", [UPCA substringWithRange:NSMakeRange(1,2)],
                                                                [UPCA substringWithRange:NSMakeRange(8,3)],
                                                                [UPCA substringWithRange:NSMakeRange(3,1)]];
        else if ([[UPCA substringWithRange: NSMakeRange(4,2)] isEqual:@"00"])
            UPCE = [NSMutableString stringWithFormat:@"%@%@%@", [UPCA substringWithRange:NSMakeRange(1,3)],
                                                                [UPCA substringWithRange:NSMakeRange(9,2)],
                                                                @"3"];
        else if ([[UPCA substringWithRange: NSMakeRange(5,1)] isEqual:@"0"])
            UPCE = [NSMutableString stringWithFormat:@"%@%@%@", [UPCA substringWithRange:NSMakeRange(1,4)],
                                                                [UPCA substringWithRange:NSMakeRange(10,1)],
                                                                @"4"];
        else if ([UPCA characterAtIndex:10] >= '5')
            UPCE = [NSMutableString stringWithFormat:@"%@%@", [UPCA substringWithRange:NSMakeRange(1,5)],
                                                              [UPCA substringWithRange:NSMakeRange(10,1)]];
    }                          
    return UPCE;
}
@end

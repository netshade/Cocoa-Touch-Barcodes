// -----------------------------------------------------------------------------------
//  NKDEAN13Barcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Fri May 10 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDEAN13Barcode.h"


@implementation NKDEAN13Barcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;
// -----------------------------------------------------------------------------------
{

    NSRange	range = NSMakeRange(0, 12);
    char	*tempString;

    self = [super initWithContent: inContent
                    printsCaption:inPrints];
    
    [self setContent:inContent];
    
    if ([[self content] length] >= 13)
    {
        tempString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
        checkDigit = tempString[12];
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

 
    // First six characters after system digit encoded with left-hand encoding,
    // parity based on value of system digit
    // --------------------------------------------------------
    for (i = 1; i < 7; i++)
    {
        if ([self _parityForSystemDigit:contentString[0] forIndex: i] == ODD_PARITY)
            [theReturn appendString:[self _encodeChar:contentString[i]]];
        else
            [theReturn appendString:[[self _encodeChar:contentString[i]] swapParity]];
    }
    // Center guard bars
    // -----------------
    [theReturn appendString:@"01010"];

    // Next six characters (next five digits plus check digit)
    // are encoded with right hand encoding.
    // --------------------------------------------------------
    for (i = 7; i < 12; i++)
        [theReturn appendString:[[self _encodeChar:contentString[i]] swapHandedness]];

    // And encode the check digit
    // --------------------------
    [theReturn appendString:[[self _encodeChar:checkDigit] swapHandedness]];

    return theReturn;
}
// -----------------------------------------------------------------------------------
-(BOOL)_parityForSystemDigit: (char) systemDigit
                    forIndex: (int) index
// -----------------------------------------------------------------------------------
{

    switch (systemDigit)
    {
        case '0':
            return ODD_PARITY;
        case '1':
            switch (index)
            {
                case 1:
                case 2:
                case 4:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '2':
            switch (index)
            {
                case 1:
                case 2:
                case 5:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '3':
            switch (index)
            {
                case 1:
                case 2:
                case 6:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '4':
            switch (index)
            {
                case 1:
                case 3:
                case 4:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '5':
            switch (index)
            {
                case 1:
                case 4:
                case 5:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '6':
            switch (index)
            {
                case 1:
                case 5:
                case 6:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '7':
            switch (index)
            {
                case 1:
                case 3:
                case 5:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '8':
            switch (index)
            {
                case 1:
                case 3:
                case 6:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
        case '9':
            switch (index)
            {
                case 1:
                case 4:
                case 6:
                    return ODD_PARITY;
                default:
                    return EVEN_PARITY;
            }
            break;
    }
    // shouldn't ever get here, but...
    return ODD_PARITY;
 }
// -----------------------------------------------------------------------------------
-(int)digitsToRight
// -----------------------------------------------------------------------------------
{
    return 0;
}
// -----------------------------------------------------------------------------------
-(NSString *)rightCaption
// -----------------------------------------------------------------------------------
{
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)caption
// -----------------------------------------------------------------------------------
{
    return [NSString stringWithFormat: @"  %@\t%@%c", [content substringWithRange:NSMakeRange(1, 6)],
        [content substringWithRange:NSMakeRange(7, 5)], [self checkDigit]];
}
/*
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{

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
	

	
    int 	oddSum = 0;
    int 	evenSum = 0;
    int		i, checkInt;
    char *	code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    if (strlen(code) == 12)
    {
        for (i=11; i > 1; i-=2)
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
 -(void)generateChecksum
 // -----------------------------------------------------------------------------------
 {
	 int     oddSum = 0;
	 int     evenSum = 0;
	 int        i, checkInt;
	 int     even = 1;
	 //char *    code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
	 char *    code = (char *) [content cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
	 if (strlen(code) == 12)
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
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{

    int			i;
    char		*contentString;
	char		tempCheck=0;

    contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    if (strlen(contentString) != 12)
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

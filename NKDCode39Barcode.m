// -----------------------------------------------------------------------------------
//  NKDCode39Barcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDCode39Barcode.h"

@implementation NKDCode39Barcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    return [super initWithContent:[inContent uppercaseString]
                    printsCaption:inPrints];
}  
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    switch (inChar)
    {
        case '0':
            return @"1010011011010";
        case '1':
            return @"1101001010110";
        case '2':
            return @"1011001010110"; 
        case '3':
            return @"1101100101010";
        case '4':
            return @"1010011010110";  
        case '5':
            return @"1101001101010";
        case '6':
            return @"1011001101010";   
        case '7':
            return @"1010010110110";  
        case '8':
            return @"1101001011010"; 
        case '9':
            return @"1011001011010";   
        case 'A':
            return @"1101010010110";
        case 'B':
            return @"1011010010110";  
        case 'C':
            return @"1101101001010"; 
        case 'D':
            return @"1010110010110";   
        case 'E':
            return @"1101011001010";
        case 'F':
            return @"1011011001010"; 
        case 'G':
            return @"1010100110110";  
        case 'H':
            return @"1101010011010"; 
        case 'I':
            return @"1011010011010";  
        case 'J':
            return @"1010110011010";
        case 'K':
            return @"1101010100110"; 
        case 'L':
            return @"1011010100110"; 
        case 'M':
            return @"1101101010010"; 
        case 'N':
            return @"1010110100110"; 
        case 'O':
            return @"1101011010010";
        case 'P':
            return @"1011011010010";
        case 'Q':
            return @"1010101100110"; 
        case 'R':
            return @"1101010110010"; 
        case 'S':
            return @"1011010110010";
        case 'T':
            return @"1010110110010";
        case 'U':
            return @"1100101010110";
        case 'V':
            return @"1001101010110";   
        case 'W':
            return @"1100110101010";
        case 'X':
            return @"1001011010110";
        case 'Y':
            return @"1100101101010"; 
        case 'Z':
            return @"1001101101010"; 
        case ' ':
            return @"1001101011010";
        case '-':
            return @"1001010110110";
        case '.':
            return @"1100101011010"; 
        case '$':
            return @"1001001001010";
        case '/':
            return @"1001001010010";
        case '+':
            return @"1001010010010";
        case '%':
            return @"1010010010010";
        case '*':
            return @"1001011011010";
        default:
           break;
    }
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    return [self _encodeChar:'*']; 
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return [self _encodeChar:'*']; 
}
// -----------------------------------------------------------------------------------
-(BOOL) isContentValid
// -----------------------------------------------------------------------------------
{
    int			i;
    char		*contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(contentString); i++)
    {
        if ([[self _encodeChar:contentString[i]] isEqual: @""])
            return NO;            
    }
    return YES;
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int 		theSum=0;
    int 		i, checkValue;
    char		*contentString = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(contentString); i++)
    {
        if ((contentString[i] >= '0') && (contentString[i] <= '9'))
            theSum += contentString[i] - '0';
        else if ( (contentString[i] >= 'A') && (contentString[i] <= 'Z'))
            theSum += contentString[i] - 'A' + 10;
        else switch (contentString[i])
        {
            case '-':
                theSum += 36;
                break;
            case '.':
                theSum += 37;
                break;
            case ' ':
                theSum += 38;
                break;
            case '$':
                theSum += 39;
                break;
            case '/':
                theSum += 40;
                break;
            case '+':
                theSum += 41;
                break;
            case '%':
                theSum += 42;
                break;
            default:
                break;
        }
    }
        // Calculate the sum modulus 43
        // ----------------------------
        checkValue = theSum % 43;

        // Convert to the appropriate check character
        // ------------------------------------------
        if ( (checkValue >=0) && (checkValue <=9))
            checkDigit = (char)('0' + checkValue);
        else if ((checkValue >= 10) && (checkValue <= 35) )
            checkDigit = (char)('A' + checkValue);
        else if (checkValue == 36) checkDigit = '-';
        else if (checkValue == 37) checkDigit = '.';
        else if (checkValue == 38) checkDigit = ' ';
        else if (checkValue == 39) checkDigit = '$';
        else if (checkValue == 40) checkDigit = '/';
        else if (checkValue == 41) checkDigit = '+';
        else if (checkValue == 42) checkDigit = '%';

        // Adjust the width to accommodate one additional character
        [self calculateWidth];
}
@end

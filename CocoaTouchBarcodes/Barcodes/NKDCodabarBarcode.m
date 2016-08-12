// -----------------------------------------------------------------------------------
//  NKDCodabarBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 12 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDCodabarBarcode.h"

@implementation NKDCodabarBarcode
// -----------------------------------------------------------------------------------
-(NSString *) _encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    switch (inChar)
    {

        case '0':
            return @"1010100110";
        case '1':
            return @"1010110010";
        case '2':
            return @"1010010110";
        case '3':
            return @"1100101010";
        case '4':
            return @"1011010010";
        case '5':
            return @"1101010010";
        case '6':
            return @"1001010110";
        case '7':
            return @"1001011010";
        case '8':
            return @"100110101";
        case '9':
            return @"1101001010";
        case '-':
            return @"1010011010";
        case '$':
            return @"1011001010";
        case ':':
            return @"11010110110";
        case '/':
            return @"11011010110";
        case '.':
            return @"11011011010";
        case '+':
            return @"1011001100110";
        case 'A':
            return @"10110010010";
        case 'B':
            return @"10100100110";
        case 'C':
            return @"10010010110";
        case 'D':
            return @"10100110010";
    }
    return @"";
}

@end
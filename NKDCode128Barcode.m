// -----------------------------------------------------------------------------------
//  NKDCode128Barcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 11 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDCode128Barcode.h"


@implementation NKDCode128Barcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    self = [super initWithContent:inContent printsCaption:inPrints];
    if (self)
    {
        [self setCodeSet:[self _bestCodeSetForContent]];
        [self generateChecksum];
        [self calculateWidth];
    }
    return self;
}
// -----------------------------------------------------------------------------------
-(CodeSet)codeSet
// -----------------------------------------------------------------------------------
{
    return codeSet;
}
// -----------------------------------------------------------------------------------
-(void)setCodeSet:(CodeSet)inSet
// -----------------------------------------------------------------------------------
{
    codeSet = inSet;
}
// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int startCode=0, sum=0;
    char *code = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    switch (codeSet)
    {
        case SET_A:
            startCode = 103;
            break;
        case SET_B:
            startCode = 104;
            break;
        case SET_C:
            startCode = 105;
            break;
    }
	sum += startCode;
	int codeLen = strlen(code);
    if (codeSet != SET_C)
        for (int i=0, j = 1; i < codeLen; i++, j++)
            sum += j * [self _valueForChar:code[i]];
    else { // SET_C
		if(codeLen % 2 != 0){
			code = (char *)[[NSString stringWithFormat:@"0%@", [self content]] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
			codeLen ++;
		}
        for (int i=0, j = 1; i < codeLen; i+=2, j++){
			NSString * pair = [NSString stringWithFormat:@"%c%c", code[i], code[i+1]];
            sum += j * [pair intValue];
		}
	}
    checkDigit = (char)(sum%103);

}
// -----------------------------------------------------------------------------------
-(int)_valueForChar:(int)inChar
// -----------------------------------------------------------------------------------
{
	if(inChar == 128){
		return 0;
	} else if(inChar >= 33 && inChar <= 126){
		return inChar - 32;
	} else if(inChar > 126){
		return inChar - 50;
	}
    // If it gets here, error condition...
    NSLog(@"_valueForChar: received Unrecognized character %c", inChar);
    return -1;
}
-(int)_charForValue:(int)inValue
{
	if(inValue == 0){
		return 128;
	} else if(inValue >= 1 && inValue <= 94){
		return inValue + 32;
	} else if(inValue > 94){
		return inValue + 50;
	}
    NSLog(@"_charForValue: received Unrecognized value %i", inValue);
	return -1;
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
// -----------------------------------------------------------------------------------
{
    switch (codeSet)
    {
        case SET_A:
            return @"11010000100";
        case SET_B:
            return @"11010010000";
        case SET_C:
            return @"11010011100";
        default:
            NSLog(@"Invalid codeSet value: %c", codeSet);
    }
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
// -----------------------------------------------------------------------------------
{
    return @"1100011101011";
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{
    int 	useSet = codeSet;	// Specifies the code on a per-character basis;
    NSString 	*prefix;
    
    // *** We currently only switch from A to B and vice versa
    if (![self _canEncodeChar:inChar withSet:codeSet])
    {
        useSet = (codeSet == SET_A) ? SET_B : SET_A;
        prefix = [self _shiftCharacterForSet:useSet];
    }
    else
        prefix = @"";

    return [NSString stringWithFormat:@"%@%@",prefix, [self _encodeChar:inChar withSet:codeSet]];
}
// -----------------------------------------------------------------------------------
-(BOOL)_canEncodeChar:(char)inChar withSet:(CodeSet)theSet
// -----------------------------------------------------------------------------------
{
    return (![[self _encodeChar:inChar withSet:theSet] isEqual:@""]);
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar withSet:(CodeSet)inSet
// -----------------------------------------------------------------------------------
{
    // SET_A and SET_B have a lot of characters in common, SET_C uses a
    // separate encoding method.
	
	if(inSet == SET_B) {
		switch (inChar) {
			case ' ':
				return @"11011001100";
			case '!':
				return @"11001101100";
			case '"':
				return @"11001100110";
			case '#':
				return @"10010011000";
			case '$':
				return @"10010001100";
			case '%':
				return @"10001001100";
			case '&':
				return @"10011001000";
			case '\'':
				return @"10011000100";
			case '(':
				return @"10001100100";
			case ')':
				return @"11001001000";
			case '*':
				return @"11001000100";
			case '+':
				return @"11000100100";
			case ',':
				return @"10110011100";
			case '-':
				return @"10011011100";
			case '.':
				return @"10011001110";
			case '/':
				return @"10111001100";
			case '0':
				return @"10011101100";
			case '1':
				return @"10011100110";
			case '2':
				return @"11001110010";
			case '3':
				return @"11001011100";
			case '4':
				return @"11001001110";
			case '5':
				return @"11011100100";
			case '6':
				return @"11001110100";
			case '7':
				return @"11101101110";
			case '8':
				return @"11101001100";
			case '9':
				return @"11100101100";
			case ':':
				return @"11100100110";
			case ';':
				return @"11101100100";
			case '<':
				return @"11100110100";
			case '=':
				return @"11100110010";
			case '>':
				return @"11011011000";
			case '?':
				return @"11011000110";
			case '@':
				return @"11000110110";
			case 'A':
				return @"10100011000";
			case 'B':
				return @"10001011000";
			case 'C':
				return @"10001000110";
			case 'D':
				return @"10110001000";
			case 'E':
				return @"10001101000";
			case 'F':
				return @"10001100010";
			case 'G':
				return @"11010001000";
			case 'H':
				return @"11000101000";
			case 'I':
				return @"11000100010";
			case 'J':
				return @"10110111000";
			case 'K':
				return @"10110001110";
			case 'L':
				return @"10001101110";
			case 'M':
				return @"10111011000";
			case 'N':
				return @"10111000110";
			case 'O':
				return @"10001110110";
			case 'P':
				return @"11101110110";
			case 'Q':
				return @"11010001110";
			case 'R':
				return @"11000101110";
			case 'S':
				return @"11011101000";
			case 'T':
				return @"11011100010";
			case 'U':
				return @"11011101110";
			case 'V':
				return @"11101011000";
			case 'W':
				return @"11101000110";
			case 'X':
				return @"11100010110";
			case 'Y':
				return @"11101101000";
			case 'Z':
				return @"11101100010";
			case '[':
				return @"11100011010";
			case '\\':
				return @"11101111010";
			case ']':
				return @"11001000010";
			case '^':
				return @"11110001010";
			case '_':
				return @"10100110000";
			case '`':
				return @"10100001100";
			case 'a':
				return @"10010110000";
			case 'b':
				return @"10010000110";
			case 'c':
				return @"10000101100";
			case 'd':
				return @"10000100110";
			case 'e':
				return @"10110010000";
			case 'f':
				return @"10110000100";
			case 'g':
				return @"10011010000";
			case 'h':
				return @"10011000010";
			case 'i':
				return @"10000110100";
			case 'j':
				return @"10000110010";
			case 'k':
				return @"11000010010";
			case 'l':
				return @"11001010000";
			case 'm':
				return @"11110111010";
			case 'n':
				return @"11000010100";
			case 'o':
				return @"10001111010";
			case 'p':
				return @"10100111100";
			case 'q':
				return @"10010111100";
			case 'r':
				return @"10010011110";
			case 's':
				return @"10111100100";
			case 't':
				return @"10011110100";
			case 'u':
				return @"10011110010";
			case 'v':
				return @"11110100100";
			case 'w':
				return @"11110010100";
			case 'x':
				return @"11110010010";
			case 'y':
				return @"11011011110";
			case 'z':
				return @"11011110110";
			case '{':
				return @"11110110110";
			case '|':
				return @"10101111000";
			case '}':
				return @"10100011110";
			case '~':
				return @"10001011110";
		}
	} else {
		switch(inChar)
		{
			case ' ':
				return @"11011001100";
			case '!':
				return @"11001101100";
			case '"':
				return @"11001100110";
			case '#':
				return @"10010011000";
			case '$':
				return @"10010001100";
			case '%':
				return @"10001001100";
			case '&':
				return @"10011001000";
			case '\'':
				return @"10011000100";
			case '(':
				return @"10001100100";
			case ')':
				return @"11001001000";
			case '*':
				return @"11001000100";
			case '+':
				return @"11000100100";
			case ',':
				return @"10110011100";
			case '-':
				return @"10011011100";
			case '.':
				return @"10011001110";
			case '/':
				return @"10111001100";
			case '0':
				return @"10011101100";
			case '1':
				return @"10011100110";
			case '2':
				return @"11001110010";
			case '3':
				return @"11001011100";
			case '4':
				return @"11001001110";
			case '5':
				return @"11011100100";
			case '6':
				return @"11001110100";
			case '7':
				return @"11101101110";
			case '8':
				return @"11101001100";
			case '9':
				return @"11100101100";
			case ':':
				return @"11100100110";
			case '<':
				return @"11100110100";
			case '=':
				return @"11100110010";
			case '>':
				return @"11011011000";
			case '?':
				return @"11011000110";
			case '@':
				return @"11000110110";
			case 'A':
				return @"10100011000";
			case 'B':
				return @"10001011000";
			case 'C':
				return @"10001000110";
			case 'D':
				return @"10110001000";
			case 'E':
				return @"10001101000";
			case 'F':
				return @"10001100010";
			case 'G':
				return @"11010001000";
			case 'H':
				return @"11000101000";
			case 'I':
				return @"11000100010";
			case 'J':
				return @"10110111000";
			case 'K':
				return @"10110001110";
			case 'L':
				return @"10001101110";
			case 'M':
				return @"10111011000";
			case 'N':
				return @"10111000110";
			case 'O':
				return @"10001110110";
			case 'P':
				return @"11101110110";
			case 'Q':
				return @"11010001110";
			case 'R':
				return @"11000101110";
			case 'S':
				return @"11011101000";
			case 'T':
				return @"11011100010";
			case 'U':
				return @"11011101110";
			case 'V':
				return @"11101011000";
			case 'W':
				return @"11101000110";
			case 'X':
				return @"11100010110";
			case 'Y':
				return @"11101101000";
			case 'Z':
				return @"11101100010";
			case '[':
				return @"11100011010";
			case '\\':
				return @"11101111010";
			case ']':
				return @"11001000010";
			case '^':
				return @"11110001010";
			case '_':
				return @"10100110000";
			case '`':
				return (inSet == SET_B) ? @"10100001100" : @"";
			case 0:		// NUL
				return (inSet == SET_A) ? @"10100001100" : @"";
			case 'a':
				return (inSet == SET_B) ? @"10010110000" : @"";
			case 1:		// SOH
				return (inSet == SET_A) ? @"10010110000" : @"";
			case 'b':
				return (inSet == SET_B) ? @"10010000110" : @"";
			case 2:		// STX
				return (inSet == SET_A) ? @"10010000110" : @"";
			case 'c':
				return (inSet == SET_B) ? @"10000101100" : @"";
			case 3:		// ETX
				return (inSet == SET_A) ? @"10000101100" : @"";
			case 'd':
				return (inSet == SET_B) ? @"10000100110" : @"";
			case 4:		// EOT
				return (inSet == SET_A) ? @"10000100110" : @"";
			case 'e':
				return (inSet == SET_B) ? @"10110010000" : @"";
			case 5:		// ENQ
				return (inSet == SET_A) ? @"10110010000" : @"";
			case 'f':
				return (inSet == SET_B) ? @"10110000100" : @"";
			case 6:		// ACK
				return (inSet == SET_A) ? @"10110000100" : @"";
			case 'g':
				return (inSet == SET_B) ? @"10011010000" : @"";
			case 7:		// BEL
				return (inSet == SET_A) ? @"10011010000" : @"";
			case 'h':
				return (inSet == SET_B) ? @"10011000010" : @"";
			case 8:		// BS
				return (inSet == SET_A) ? @"10011000010" : @"";
			case 'i':
				return (inSet == SET_B) ? @"10000110100" : @"";
			case 9:		// HT
				return (inSet == SET_A) ? @"10000110100" : @"";
			case 'j':
				return (inSet == SET_B) ? @"10000110010" : @"";
			case 10:	// LF
				return (inSet == SET_A) ? @"10000110010" : @"";
			case 'k':
				return (inSet == SET_B) ? @"11000010010" : @"";
			case 11:	// VT
				return (inSet == SET_A) ? @"11000010010" : @"";
			case 'l':
				return (inSet == SET_B) ? @"11001010000" : @"";
			case 12:	// FF
				return (inSet == SET_A) ? @"11001010000" : @"";
			case 'm':
				return (inSet == SET_B) ? @"11110111010" : @"";
			case 13: 	// CR
				return (inSet == SET_A) ? @"11110111010" : @"";
			case 'n':
				return (inSet == SET_B) ? @"11000010100" : @"";
			case 14:	// SO
				return (inSet == SET_A) ? @"11000010100" : @"";
			case 'o':
				return (inSet == SET_B) ? @"10001111010" : @"";
			case 15:	// SI
				return (inSet == SET_A) ? @"10001111010" : @"";
			case 'p':
				return (inSet == SET_B) ? @"10100111100" : @"";
			case 16:	// DLE
				return (inSet == SET_A) ? @"10100111100" : @"";
			case 'q':
				return (inSet == SET_B) ? @"10010111100" : @"";
			case 17:	// DC1
				return (inSet == SET_A) ? @"10010111100" : @"";
			case 'r':
				return (inSet == SET_B) ? @"10010011110" : @"";
			case 18:	// DC2
				return (inSet == SET_A) ? @"10010011110" : @"";
			case 's':
				return (inSet == SET_B) ? @"10111100100" : @"";
			case 19:	// DC3
				return (inSet == SET_A) ? @"10111100100" : @"";
			case 't':
				return (inSet == SET_B) ? @"10111100100" : @"";
			case 20:	// DC4
				return (inSet == SET_A) ? @"10111100100" : @"";
			case 'u':
				return (inSet == SET_B) ? @"10011110010" : @"";
			case 21:	// NAK
				return (inSet == SET_A) ? @"10011110010" : @"";
			case 'v':
				return (inSet == SET_B) ? @"11110100100" : @"";
			case 22:	// SYN
				return (inSet == SET_A) ? @"11110100100" : @"";
			case 'w':
				return (inSet == SET_B) ? @"11110010100" : @"";
			case 23:	// ETB
				return (inSet == SET_A) ? @"11110010100" : @"";
			case 'x':
				return (inSet == SET_B) ? @"11110010010" : @"";
			case 24:	// CAN
				return (inSet == SET_A) ? @"11110010010" : @"";
			case 'y':
				return (inSet == SET_B) ? @"11011011110" : @"";
			case 25:	// EM
				return (inSet == SET_A) ? @"11011011110" : @"";
			case 'z':
				return (inSet == SET_B) ? @"11011110110" : @"";
			case 26:	// SUB
				return (inSet == SET_A) ? @"11011110110" : @"";
			case '{':
				return (inSet == SET_B) ? @"11110110110" : @"";
			case 27:	// ESC
				return (inSet == SET_A) ? @"11110110110" : @"";
			case '|':
				return (inSet == SET_B) ? @"10101111000" : @"";
			case 28:	// FS
				return (inSet == SET_A) ? @"10101111000" : @"";
			case '}':
				return (inSet == SET_B) ? @"10100011110" : @"";
			case 29:	// GS
				return (inSet == SET_A) ? @"10100011110" : @"";
		}
	}
	
	return @"";
}
// -----------------------------------------------------------------------------------
-(CodeSet)_bestCodeSetForContent
// -----------------------------------------------------------------------------------
{
    int 	numNumbers = 0,
                numNonPrinting = 0,
                numLowerCase = 0,
                i;
    char 	*code = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    for (i=0; i < strlen(code); i++)
    {
        
        if ((code[i] >= '0') && (code[i] <= '9'))
            numNumbers++;
        else if ((code[i] < 32) || (code[i] == 127))
            numNonPrinting++;
        else if ((code[i] >= 'a') && (code[i] <= 'z'))
            numLowerCase++;
    }

    if (numNumbers == strlen(code))
        return SET_C;

    return (numNonPrinting > numLowerCase) ? SET_A : SET_B;
}
// -----------------------------------------------------------------------------------
-(NSString *)_shiftCharacterForSet:(CodeSet)inSet
// -----------------------------------------------------------------------------------
{
    switch (inSet)
    {
        case SET_A:
            return @"1111010001011101011110";
        case SET_B:
            return @"1111010001010111101110";
        case SET_C:
            return @"1111010001010111011110";
        default:
            NSLog(@"Invalid CodeSet value Supplied: %c", inSet);
    }
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeNumberPair:(NSString *)inPair
// -----------------------------------------------------------------------------------
{
    int	pair = [inPair intValue];

    switch (pair)
    {
        case 0:
			return @"11011001100";
		case 1:
			return @"11001101100";
		case 2:
			return @"11001100110";
		case 3:
			return @"10010011000";
		case 4:
			return @"10010001100";
		case 5:
			return @"10001001100";
		case 6:
			return @"10011001000";
		case 7:
			return @"10011000100";
		case 8:
			return @"10001100100";
		case 9:
			return @"11001001000";
		case 10:
			return @"11001000100";
		case 11:
			return @"11000100100";
		case 12:
			return @"10110011100";
		case 13:
			return @"10011011100";
		case 14:
			return @"10011001110";
		case 15:
			return @"10111001100";
		case 16:
			return @"10011101100";
		case 17:
			return @"10011100110";
		case 18:
			return @"11001110010";
		case 19:
			return @"11001011100";
		case 20:
			return @"11001001110";
		case 21:
			return @"11011100100";
		case 22:
			return @"11001110100";
		case 23:
			return @"11101101110";
		case 24:
			return @"11101001100";
		case 25:
			return @"11100101100";
		case 26:
			return @"11100100110";
		case 27:
			return @"11101100100";
		case 28:
			return @"11100110100";
		case 29:
			return @"11100110010";
		case 30:
			return @"11011011000";
		case 31:
			return @"11011000110";
		case 32:
			return @"11000110110";
		case 33:
			return @"10100011000";
		case 34:
			return @"10001011000";
		case 35:
			return @"10001000110";
		case 36:
			return @"10110001000";
		case 37:
			return @"10001101000";
		case 38:
			return @"10001100010";
		case 39:
			return @"11010001000";
		case 40:
			return @"11000101000";
		case 41:
			return @"11000100010";
		case 42:
			return @"10110111000";
		case 43:
			return @"10110001110";
		case 44:
			return @"10001101110";
		case 45:
			return @"10111011000";
		case 46:
			return @"10111000110";
		case 47:
			return @"10001110110";
		case 48:
			return @"11101110110";
		case 49:
			return @"11010001110";
		case 50:
			return @"11000101110";
		case 51:
			return @"11011101000";
		case 52:
			return @"11011100010";
		case 53:
			return @"11011101110";
		case 54:
			return @"11101011000";
		case 55:
			return @"11101000110";
		case 56:
			return @"11100010110";
		case 57:
			return @"11101101000";
		case 58:
			return @"11101100010";
		case 59:
			return @"11100011010";
		case 60:
			return @"11101111010";
		case 61:
			return @"11001000010";
		case 62:
			return @"11110001010";
		case 63:
			return @"10100110000";
		case 64:
			return @"10100001100";
		case 65:
			return @"10010110000";
		case 66:
			return @"10010000110";
		case 67:
			return @"10000101100";
		case 68:
			return @"10000100110";
		case 69:
			return @"10110010000";
		case 70:
			return @"10110000100";
		case 71:
			return @"10011010000";
		case 72:
			return @"10011000010";
		case 73:
			return @"10000110100";
		case 74:
			return @"10000110010";
		case 75:
			return @"11000010010";
		case 76:
			return @"11001010000";
		case 77:
			return @"11110111010";
		case 78:
			return @"11000010100";
		case 79:
			return @"10001111010";
		case 80:
			return @"10100111100";
		case 81:
			return @"10010111100";
		case 82:
			return @"10010011110";
		case 83:
			return @"10111100100";
		case 84:
			return @"10011110100";
		case 85:
			return @"10011110010";
		case 86:
			return @"11110100100";
		case 87:
			return @"11110010100";
		case 88:
			return @"11110010010";
		case 89:
			return @"11011011110";
		case 90:
			return @"11011110110";
		case 91:
			return @"11110110110";
		case 92:
			return @"10101111000";
		case 93:
			return @"10100011110";
		case 94:
			return @"10001011110";
		case 95:
			return @"10111101000";
		case 96:
			return @"10111100010";
		case 97:
			return @"11110101000";
		case 98:
			return @"11110100010";
		case 99:
			return @"10111011110";
		case 100:
			return @"10111101110";
		case 101:
			return @"11101011110";
		case 102:
			return @"11110101110";
    }
    return @"";
}
// -----------------------------------------------------------------------------------
-(NSString *)barcode
// -----------------------------------------------------------------------------------
{
    NSMutableString 	*theReturn = [NSMutableString stringWithString:@""];
    char *	code = (char *)[[self content] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    int		i;
    
    if (codeSet == SET_C)
    {
        // Left-pad with zero if odd number of characters
        if (strlen(code)%2 != 0)
            code = (char *)[[NSString stringWithFormat:@"0%@",[NSString stringWithCString:code encoding:NSStringEncodingConversionAllowLossy]] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

        // Encode character pairs
        for (i=0; i < strlen(code); i+=2)
            [theReturn appendString:[self _encodeNumberPair:[NSString stringWithFormat:@"%c%c", code[i], code[i+1]]]];
    }
    else
        for (i=0; i < strlen(code); i++)
            [theReturn appendString:[self _encodeChar:code[i]]];

    [theReturn appendString:[self _encodeNumberPair:[[NSNumber numberWithInt:(int)checkDigit] stringValue]]];

    return theReturn;
}
@end

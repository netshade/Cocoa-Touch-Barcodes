//
//  JapanPostBarcode.m
//  BarcodePod
//
//  Created by 佐藤 昭 on Mon Jun 30 2003.
//  Copyright (c) 2003 SatoAkira. All rights reserved.
//

#import "JapanPostBarcode.h"

@implementation JapanPostBarcode

#define MILLIMETERPERPOINT 0.3527777777777777 // base72.0 //
#define JP_DESCENDER_BOTTOM 0.0	// 最下段基準線(mm) //
#define JP_TRACK_BOTTOM 1.2		// 中段下基準線(mm) //
#define JP_TRACK_TOP 2.4		// 中段上基準線(mm) //
#define JP_ASCENDER_TOP 3.6		// 最上段基準線(mm) //
#define JP_ASCENDER_MASK (0x222)
#define JP_DESCENDER_MASK (0x111)

// -----------------------------------------------------------------------------------
// Constants
// -----------------------------------------------------------------------------------

// Each hex constant represents a 4-bar code of the barcode corresponding to a single number or letter.  The digits represent bars in this fashion: //
//     0 - タイミングバー (JP_TRACK_BOTTOM to JP_TRACK_TOP) //
//     1 - 下セミロングバー (JP_DESCENDER_BOTTOM to JP_TRACK_TOP) //
//     2 - 上セミロングバー  (JP_TRACK_BOTTOM to JP_ASCENDER_TOP) //
//     3 - ロングバー  (JP_DESCENDER_BOTTOM to JP_ASCENDER_TOP) //
unsigned int openBracketLength = 2;
unsigned int openBracket = 0x31; // スタートコード //
unsigned int closeBracketLength = 2;
unsigned int closeBracket = 0x13; // ストップコード //
NSString *barFormat = @"101010101010101010101010";
unsigned int numberLength = 3;
unsigned int numberCodesOfJapan[] = {
	0x030, // -     //
	0x003, // CC7 . //
	0x333, // CC8 / //
    0x300, // 0     //
    0x330, // 1     //
    0x312, // 2     //
    0x132, // 3     //
    0x321, // 4     //
    0x303, // 5     //
    0x123, // 6     //
    0x231, // 7     //
    0x213, // 8     //
    0x033, // 9     //
    0x120, // CC1 : //
    0x102, // CC2 ; //
    0x210, // CC3 < //
    0x012, // CC4 = //
    0x201, // CC5 > //
    0x021  // CC6 ? //
};

double japanpost_barTop(unsigned int hexDigit,double size) { // mm単位で返す。 //
	return (hexDigit & JP_ASCENDER_MASK) ? JP_ASCENDER_TOP * size / 10.0 : JP_TRACK_TOP * size / 10.0;
}
double japanpost_barBottom(unsigned int hexDigit,double size) { // mm単位で返す。 //
	return (hexDigit & JP_DESCENDER_MASK) ? JP_DESCENDER_BOTTOM * size / 10.0 : JP_TRACK_BOTTOM * size / 10.0;
}
unsigned int japanpost_characterDescriptor(unichar character) {
	return numberCodesOfJapan[character - '-'];
}

unsigned int japanpost_barDescriptor(unsigned int descriptor,unsigned int bar,unsigned int bars)
{
	unsigned int shift = (bars - 1 - (bar / 2)) * 4; // 4ビットずつで1つのバーを表す。bar / 2 番目 //
	unsigned int mask = 0xF << shift; // 0xfは4ビット分 //

	return (descriptor & mask) >> shift;
}

- (unsigned int)_barDescriptor:(unsigned int)index
// barcode is [self initiator][self barcode][self terminator] //
// 2 * numberLength がほぼ定数に近い働きをしており、これを変数にすることが難しい。よって'A'~'Z'は2文字の扱いをした。 //
{
	unsigned int bar;
    unsigned int hexDigit;
    unsigned int descriptor;
    unsigned int contentLength = [_japanpostContents length];

    if ([[self initiator] length] > index) {
		bar = index % [[self initiator] length];
		hexDigit = openBracket;
		descriptor = japanpost_barDescriptor(hexDigit,bar,openBracketLength);
	}
	else {
		if (index >= (contentLength + 1) * (2 * numberLength) + [[self initiator] length]) {
			bar = (index - [[self initiator] length] - (contentLength + 1) * (2 * numberLength)) % [[self terminator] length];
			hexDigit = closeBracket;
			descriptor = japanpost_barDescriptor(hexDigit,bar,closeBracketLength);
		}
		else {
			unsigned int digit = (index - [[self initiator] length]) / (2 * numberLength); // 何文字目か //

			bar = (index - [[self initiator] length]) % (2 * numberLength); // 1文字の中の何番目のバーになるか //
			if (digit != contentLength) {
				hexDigit = japanpost_characterDescriptor( [_japanpostContents characterAtIndex:digit] );
				descriptor = japanpost_barDescriptor( hexDigit, bar,numberLength);
			}
			else { // last digit is checksum
				hexDigit = japanpost_characterDescriptor( [self checkDigit] );
				descriptor = japanpost_barDescriptor( hexDigit, bar,numberLength);
			}
		}
	}
	return descriptor;
}

// override //

- (id)initWithContent:(NSString *)inContent printsCaption:(BOOL)inPrints andBarWidth:(float)inBarWidth andHeight:(float)inHeight andFontSize:(float)inFontSize andCheckDigit:(char)inDigit
// inPrints,inBarWidth,inFontSize,inDigitは意味を持たない。 //
{
	if ((nil != inContent) && (nil != (self = [super init]))) {
		[self setContent:inContent];
		if ((8.0 <= inHeight) && (11.5 >= inHeight))
			[self setHeight:inHeight];
		else
			[self setHeight:10.0];
	}
	return self;
}

- (void)setHeight:(float)inHeight
// inHeight:ポイント単位 //
{
	if (8.5 > inHeight)
		height = 8.5;
	else {
		if (11.5 < inHeight)
			height = 11.5;
		else
			height = inHeight;
	}
	barWidth = (float)((double)height / (double)6.0);
	[self calculateWidth];
}

- (void)setBarWidth:(float)inBarWidth
// inBarWidth:point単位 //
{
	if (1.3333333333333333 > inBarWidth) // 8.0 / 6.0 //
		barWidth = 1.3333333333333333;
	else {
		if (1.9166666666667 < inBarWidth) // 11.5 / 6.0 //
			barWidth = 1.9166666666667;
		else
			barWidth = inBarWidth;
	}
	height = (float)((double)6.0 * (double)barWidth);
	[self calculateWidth];
}

- (void)generateChecksum
{
	unsigned int i,cd;
	unichar uChar,character;
	unsigned int checkValue = 0;

	for (i = 0; i < _japanpostContents.length; i++) {
		uChar = [_japanpostContents characterAtIndex:i];
		if ('-' == uChar)
			checkValue += 10; // 10 //
		else {
			if ((',' == uChar) || ('/' == uChar))
				checkValue += (uChar - '-') + 16; // 17 or 18 //
			else {
				if (('0' <= uChar) && ('9' >= uChar))
					checkValue += uChar - '0'; // 0 ~ 9 //
				else {
					checkValue += uChar - ':' + 11; // 11 ~ 16 //
				}
			}
		}
	}
	cd = 19 * (checkValue / 19 + 1) - checkValue;
	if (10 > cd)
		character = '0' + cd;
	else {
		if (10 == cd)
			character = '-';
		else {
			if ((10 < cd) && (16 >= cd))
				character = ':' + cd - 11;
			else
				character = '-' + cd - 16;
		}
	}
	[self setCheckDigit:character];
}

- (void)setContent:(NSString *)inContent
// 大文字化する。20文字に揃える。使用できない文字を排除する。郵便番号の整合性はチェックしない。 //
{
	unichar uChar;
	unsigned int i;
	NSString *uppercaseString = [inContent uppercaseString];
	NSMutableString *tempStr = [NSMutableString string];
	NSMutableString *tempContents = [NSMutableString string];
	NSString *tenStr = @"0123456789";
	unsigned int maxLength = 20; // 郵便番号7文字+住居表示番号13文字 //

	for (i = 0; i < [uppercaseString length]; i++) {
		uChar = [uppercaseString characterAtIndex:i];
		if (('A' <= uChar) && ('Z' >= uChar)) {
			if ('K' > uChar) {
				[tempStr appendString:@":"]; // CC1 //
				[tempStr appendString:[tenStr substringWithRange:NSMakeRange((unsigned int)(uChar - 'A'),1)]];
				[tempContents appendString:[NSString stringWithCharacters:&uChar length:1]];
			}
			else {
				if ('U' > uChar) {
					[tempStr appendString:@";"]; // CC2 //
					[tempStr appendString:[tenStr substringWithRange:NSMakeRange((unsigned int)(uChar - 'K'),1)]];
					[tempContents appendString:[NSString stringWithCharacters:&uChar length:1]];
				}
				else { // ('Z' >= uChar) //
					[tempStr appendString:@"<"]; // CC3 //
					[tempStr appendString:[tenStr substringWithRange:NSMakeRange((unsigned int)(uChar - 'U'),1)]];
					[tempContents appendString:[NSString stringWithCharacters:&uChar length:1]];
				}
			}
		}
		else {
			if (('-' == uChar) || (('0' <= uChar) && ('9' >= uChar))) {
				[tempStr appendString:[NSString stringWithCharacters:&uChar length:1]];
				[tempContents appendString:[NSString stringWithCharacters:&uChar length:1]];
			} // 使用できない文字を排除する。 //
		}
	}
	if (maxLength > [tempStr length]) {
		for (i = [tempStr length]; i < maxLength; i++)
			[tempStr appendString:@"="]; // CC4 //
	}
	else {
		if (maxLength < [tempStr length]) {
			unsigned int validCount;
			unsigned int tempL = [tempStr length];
			NSString *tempCStr = [NSString stringWithString:tempContents];

			[tempStr deleteCharactersInRange:NSMakeRange(maxLength,tempL - maxLength)];
			tempL = [tempStr length];
			validCount = 0;
			for (i = 0; i < [tempStr length]; i++) {
				uChar = [tempStr characterAtIndex:i];
				if (('-' == uChar) || (('0' <= uChar) && ('9' >= uChar))) // 'A'~'Z'も制御文字+数字文字になっているのでカウントできる。 //
					validCount++;
			}
			tempContents = [NSMutableString stringWithString:[tempCStr substringWithRange:NSMakeRange(0,validCount)]];
		}
	}
	_japanpostContents = [[NSString alloc] initWithString:tempStr];
    content = [[NSString alloc] initWithString:tempContents];
	[self generateChecksum];
}

- (BOOL)isContentValid
{
	unsigned int i;
	unichar uChar;
	BOOL result = YES;

	for (i = 0; i < 7; i++) {
		uChar = [content characterAtIndex:i];
		if (('0' > uChar) || ('9' < uChar)) {
			result = NO;
			break;
		}
	}
	return result;
}

- (NSString *)barcode
// japanpostContentsを参照するところがNKDBarcodeと異なる。 //
{
	unsigned int i;
	NSMutableString *theReturn = [NSMutableString string];

	for (i = 0; i < _japanpostContents.length; i++)
		[theReturn appendString:[self _encodeChar:[_japanpostContents characterAtIndex:i]]];
	if (checkDigit != -1)
		[theReturn appendString:[self _encodeChar:checkDigit]];
	return theReturn;
}

- (BOOL)printsCaption {
	return NO;
}

- (NSString *)initiator {
	return [barFormat substringToIndex:2 * openBracketLength];
}
- (NSString *)terminator {
	return [barFormat substringToIndex:2 * closeBracketLength - 1]; // 最後の"0"は不要 //
}

- (float)barTop:(int)index {
    return (float)(japanpost_barTop([self _barDescriptor:(unsigned int)index],(double)height) / (double)MILLIMETERPERPOINT);
}
- (float)barBottom:(int)index {
    return (float)(japanpost_barBottom([self _barDescriptor:(unsigned int)index],(double)height) / (double)MILLIMETERPERPOINT);    
}

- (NSString *)_encodeChar:(char)inChar {
	return [barFormat substringToIndex:2 * numberLength];
}

- (void)calculateWidth
{
    [self setWidth:(float)((double)[[self completeBarcode] length] * (double)[self barWidth])];
}

@end

// -----------------------------------------------------------------------------------
//  NKDPostnetBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Trevor Strohman <trevor@ampersandbox.com> on Sun Apr 20 2003.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDRoyalMailBarcode.h"

// -----------------------------------------------------------------------------------
// Constants
// -----------------------------------------------------------------------------------

// Each hex constant represents a 4-bar code of the barcode corresponding to a single
// number or letter.  The digits represent bars in this fashion:
//     0 - track bar (CBC_TRACK_BOTTOM to CBC_TRACK_TOP)
//     1 - descender (CBC_DESCENDER_BOTTOM to CBC_TRACK_TOP)
//     2 - ascender  (CBC_TRACK_BOTTOM to CBC_ASCENDER_TOP)
//     3 - full bar  (CBC_DESCENDER_BOTTOM to CBC_ASCENDER_TOP)

int numberCodes[] = {
    0x0033, // 0
    0x0123, // 1
    0x0132, // 2
    0x1023, // 3
    0x1032, // 4
    0x1122, // 5
    0x0213, // 6
    0x0303, // 7
    0x0312, // 8
    0x1203 // 9
};

int letterCodes[] = {
    0x1212, // A
    0x1302, // B
    0x0231, // C
    0x0321, // D
    0x0330, // E
    0x1221, // F
    0x1230, // G
    0x1320, // H
    0x2013, // I
    0x2103, // J
    0x2112, // K
    0x3003, // L
    0x3012, // M
    0x3102, // N
    0x2031, // O
    0x2121, // P
    0x2130, // Q
    0x3021, // R
    0x3030, // S
    0x3120, // T
    0x2211, // U
    0x2301, // V
    0x2310, // W
    0x3201, // X
    0x3210, // Y
    0x3300  // Z
};

#define CBC_OPEN_BRACKET (0x2)
#define CBC_CLOSE_BRACKET (0x3)

#define CBC_ASCENDER_MASK (0x2222)
#define CBC_DESCENDER_MASK (0x1111)

// ----------------------------------------------------------------------------------
// Internal Functions
// ----------------------------------------------------------------------------------

//
// Returns the descender bits of each bar, collapsed into a binary number.
// For instance, for the letter X (0x3201), the descender bits are 0x1001, which when
// collapsed become 0x9.
//

static int royalmail_collapseDescenders( int hexDigit ) {
    int descenders = (hexDigit & 0x0001)        |
                     (hexDigit & 0x0010)>>(4-1) |
                     (hexDigit & 0x0100)>>(8-2) |
                     (hexDigit & 0x1000)>>(12-3);

    return descenders;
}

//
// Returns the descender bits of each bar, collapsed into a binary number.
// For instance, for the letter X (0x3201), the descender bits are 0x1100, which when
// collapsed become 0xC.
//

static int royalmail_collapseAscenders( int hexDigit ) {
    int ascenders = (hexDigit & 0x0002)>>1  |
                     (hexDigit & 0x0020)>>(5-1) |
                     (hexDigit & 0x0200)>>(9-2) |
                     (hexDigit & 0x2000)>>(13-3);

    return ascenders;
}

static int royalmail_characterDescriptor( unichar character ) {
    int descriptor;
    
    if( character >= 'A' && character <= 'Z' ) {
        descriptor = letterCodes[character-'A'];
    } else if ( character >= '0' && character <= '9' ) {
        descriptor = numberCodes[character-'0'];
    } else {
        descriptor = 0;
    }

    return descriptor;
}

static int royalmail_barDescriptor( int descriptor, int bar ) {
    int mask;
    int shift;
    int hexDigit = 0;

    shift = (3-(bar/2))*4;
    mask = ( 0xF << shift );
    hexDigit = ( descriptor & mask ) >> shift;

    return hexDigit;
}

static float royalmail_barTop( int hexDigit ) {
    if( hexDigit & CBC_ASCENDER_MASK ) {
        return CBC_ASCENDER_TOP;
    } else {
        return CBC_TRACK_TOP;
    }
}

static float royalmail_barBottom( int hexDigit ) {
    if( hexDigit & CBC_DESCENDER_MASK ) {
        return CBC_DESCENDER_BOTTOM;
    } else {
        return CBC_TRACK_BOTTOM;
    }
}

@implementation NKDRoyalMailBarcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    if (self = [super init])
    {
        if (!inContent)
        {
            [self release];
            return nil;
        }
        [self setContent:inContent];

        [self setBarWidth:CBC_BAR_WIDTH*CBC_INCHES_PER_MILLIMETER*kScreenResolution];
        [self setPrintsCaption:NO];

        // RM4SCC has a mandatory check digit
        [self generateChecksum];
        [self setHeight:CBC_ASCENDER_TOP*CBC_INCHES_PER_MILLIMETER*kScreenResolution];

        // Calculate width based on number of bars needed to encode this content
        [self calculateWidth];
    }
    return self;
}
// -----------------------------------------------------------------------------------
-(BOOL)printsCaption
// -----------------------------------------------------------------------------------
{
    // RM4SCC barcodes NEVER,EVER use a caption
    return NO;
}
// -----------------------------------------------------------------------------------
-(NSString *)initiator
    // -----------------------------------------------------------------------------------
{
    return @"10";
}
// -----------------------------------------------------------------------------------
-(NSString *)terminator
    // -----------------------------------------------------------------------------------
{
    return @"1";
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
    // -----------------------------------------------------------------------------------
{
    // Each RM4SCC character takes up 4 bars
    return @"10101010";
}

// -----------------------------------------------------------------------------------
-(int)_barDescriptor:(int)index
// -----------------------------------------------------------------------------------
{
    // barcode is 10(10101010){contentLength}(10101010)1
    // 10 - initiator
    // (10101010)* - digits
    // (10101010) - checksum
    // 1 - terminator

    int contentLength = [[self content] length];
    int hexDigit;
    int descriptor = 0;

    if( index == 0 ) {
        descriptor = CBC_OPEN_BRACKET;
    } else if ( index >= (contentLength+1)*8+2 ) {
        descriptor = CBC_CLOSE_BRACKET;
    } else {
        int digit = (index-2)/8;
        int bar = (index-2)%8;

        if( digit != contentLength ) {
            // regular content digit
            hexDigit = royalmail_characterDescriptor( [[self content] characterAtIndex:digit] );
            descriptor = royalmail_barDescriptor( hexDigit, bar );
        } else {
            // last digit is checksum
            hexDigit = royalmail_characterDescriptor( [self checkDigit] );
            descriptor = royalmail_barDescriptor( hexDigit, bar );
        }
    }

    return descriptor;
}

// -----------------------------------------------------------------------------------
-(float)barTop:(int)index
// -----------------------------------------------------------------------------------
{
    return royalmail_barTop( [self _barDescriptor:index] ) *
              CBC_INCHES_PER_MILLIMETER *
              kScreenResolution;
}

// -----------------------------------------------------------------------------------
-(float)barBottom:(int)index
    // -----------------------------------------------------------------------------------
{
    return royalmail_barBottom( [self _barDescriptor:index] ) *
              CBC_INCHES_PER_MILLIMETER *
              kScreenResolution;    
}

// -----------------------------------------------------------------------------------
-(void)generateChecksum
// -----------------------------------------------------------------------------------
{
    int i;
    int ascenders = 0;
    int descenders = 0;
    int digitIndex = 0;
    unichar character;
    
    for( i=0; i<[[self content] length]; i++ ) {
        unichar current = [[self content] characterAtIndex:i];
        int descriptor = royalmail_characterDescriptor( current );

        ascenders += royalmail_collapseAscenders( descriptor ) >> 1;
        descenders += royalmail_collapseDescenders( descriptor ) >> 1;

        ascenders %= 6;
        descenders %= 6;
    }

    // The table in the Mailsort 700 publication lists indices as 1, 2, 3, 4, 5, 0 (6).
    // The following computation is easier if we rotate the index order from 0, 1, 2, 3, 4, 5
    // so we'll subtract one from each index and rotate the 0 around to the 5 position.
    
    ascenders--;
    descenders--;

    if( ascenders < 0 )
        ascenders = 5;

    if( descenders < 0 )
        descenders = 5;
    
    digitIndex = (ascenders * 6) + descenders;
    
    
    if( digitIndex < 10 ) {
        character = digitIndex + '0';
    } else {
        character = digitIndex - 10 + 'A';
    }

    [self setCheckDigit:character];
}

@end

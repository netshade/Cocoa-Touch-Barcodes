// -----------------------------------------------------------------------------------
//  NKDExtendedCode39Barcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDExtendedCode39Barcode.h"


@implementation NKDExtendedCode39Barcode
// -----------------------------------------------------------------------------------
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints
// -----------------------------------------------------------------------------------
{
    // We have to override super's behavior after calling it.
    self = [super initWithContent:inContent
                    printsCaption:inPrints];
    if (self != nil)
        [self setContent:inContent];

    return self;
}
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{

    if (!( (inChar == '$') || (inChar == '%') || (inChar == '+')))
        if (![[super _encodeChar:inChar] isEqual:@""])
             return [super _encodeChar:inChar];
 
    switch (inChar)
    {
        // Extended 3 of 9 supports non-printing characters
        // like ACK and NUL. We are not going to bother with
        // those...
        // -------------------------------------------------
        case '!':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'],  [super _encodeChar:'A']];
        case '"':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'B']];
        case '#':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'C']];
        case '$':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'D']];
        case '%':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'E']];
        case '&':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'F']];
        case '\'':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'G']];
        case '(':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'H']];
        case ')':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'I']];
        case '*':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'J']];
        case '+':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'K']];
        case ',':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'L']];
        case '/':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'O']];
        case ':':
            return [NSString stringWithFormat:@"%@%@",[super _encodeChar:'/'], [super _encodeChar:'Z']];
        case ';':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'F']];
        case '<':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'G']];
        case '=':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'H']];
        case '>':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'I']];
        case '?':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'J']];
        case '@':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'V']];
        case '[':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'K']];
        case '\\':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'L']];
        case ']':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'M']];
        case '^':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'N']];
        case '_':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'0']];
        case '`':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'W']];
        case 'a':
        case 'b':
        case 'c':
        case 'd':
        case 'e':
        case 'f':
        case 'g':
        case 'h':
        case 'i':
        case 'j':
        case 'k':
        case 'l':
        case 'm':
        case 'n':
        case 'o':
        case 'p':
        case 'q':
        case 'r':
        case 's':
        case 't':
        case 'u':
        case 'v':
        case 'w':
        case 'x':
        case 'y':
        case 'z':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'+'], [super _encodeChar:toupper(inChar)]];
        case '{':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'P']];
        case '|':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'Q']];
        case '}':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'R']];
        case '~':
            return [NSString stringWithFormat:@"%@%@", [super _encodeChar:'%'], [super _encodeChar:'S']];
        case '\n':
            [NSString stringWithFormat:@"%@%@", [super _encodeChar:'$'], [super _encodeChar:'M']];
        case '\t':
            [NSString stringWithFormat:@"%@%@", [super _encodeChar:'$'], [super _encodeChar:'I']];
        default:
            break;
    }
    return @"";
}
@end

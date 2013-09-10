// -----------------------------------------------------------------------------------
// NSString-UPCEAN.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Thu May 30 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NSString-UPCEAN.h"


@implementation NSString (UPCEAN)
// -----------------------------------------------------------------------------------
-(NSString *)swapHandedness
// -----------------------------------------------------------------------------------
{
    int 		i;
    NSMutableString	*ret = [NSMutableString stringWithString:@""];
    char 		*code = (char *) [self cStringUsingEncoding:NSStringEncodingConversionAllowLossy];

    for (i = 0; i < strlen(code); i++)
    {
        if (code[i] == '0')
            [ret appendString:@"1"];
        else
            [ret appendString:@"0"];
    }
    return ret;
}
// -----------------------------------------------------------------------------------
-(NSString *)swapParity
// -----------------------------------------------------------------------------------
{
    /*
     To arrive at the even encoding, work from the left encoding and do the following: 1) Change all the 1's to 0's and 0's to 1. 2) Read the resulting encoding in reverse order (from right to left). The result is the "left-hand even" encoding pattern.
     */
    char		*tmp = (char *)[[self swapHandedness] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
    NSMutableString	*ret = [NSMutableString stringWithString:@""];
    int			i;

    for (i = strlen(tmp)-1; i >= 0; i--)
        [ret appendString:[NSString stringWithFormat:@"%c", tmp[i]]];

    return ret;
}
@end

//////////////////////////////////////////////////////////////////////////////
/// Copyright (c) 2013, Jahanzeb Ahmad
/// All rights reserved.
///
/// Redistribution and use in source and binary forms, with or without modification, 
/// are permitted provided that the following conditions are met:
///
///  * Redistributions of source code must retain the above copyright notice, 
///    this list of conditions and the following disclaimer.
///  * Redistributions in binary form must reproduce the above copyright notice, 
///    this list of conditions and the following disclaimer in the documentation and/or 
///    other materials provided with the distribution.
///
///    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
///    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
///    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
///    SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
///    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
///    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
///    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
///    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
///    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
///   POSSIBILITY OF SUCH DAMAGE.
///
///
///  * http://opensource.org/licenses/MIT
///  * http://copyfree.org/licenses/mit/license.txt
///
//////////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <stdlib.h>
 
int main(void)
{
    int buffer,bufferFF;  /* initialized to zeroes */
    int i=0,j=0, rc;
	char st[16];
    FILE *fp = fopen("hw6.txt", "r");
	FILE *fp2 = fopen("jpeg.jpg", "wb");
 
    if (fp == NULL) {
        perror("Failed to open file");
        return 1;
    }
	 // while(bufferFF!=255 || buffer!=217)
	 while(j < 1024)
	{	
		if (i == 0)		
		{
			fscanf(fp,"%08x",&rc);
			printf("\n");
			i=i+1;
		}
		else if(i == 17)
		{
			for (i=0;i<18;i++)
			rc = fgetc(fp);
			i=0;
		}
		else
		{	
			fscanf(fp,"%02x",&rc);
			printf("%02x ",rc);
			
			bufferFF = buffer;
			buffer = rc;
			fputc(rc,fp2);
			i=i+1;
				
		}
	j = j+1;

		
	}
	
    
	fclose(fp);
    fclose(fp2);
}
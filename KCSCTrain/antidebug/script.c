#include <stdio.h>
// http://tpforums.org/forum/threads/2158-XTEA-Encryption-Decryption-Code/page4
void process_decrypt(unsigned  int *v, unsigned  int *k){
	unsigned  int v0 = v[0],	v1 = v[1], i, 
		delta = 0x61C88647,
		sum = 0xC6EF3720;
	for(i = 0; i < 32; i++){   
		v1 -= (k[3] + (v0 >> 5)) ^ (sum + v0) ^ (k[2] + 16 * v0);
		v0 -= (k[1] + (v1 >> 5)) ^ (sum + v1) ^ (*k + 16 * v1);
		sum += delta;
	}
	v[0] = v0;
	v[1] = v1;
}

void print(unsigned  int x){
	printf("%c%c%c%c", x&0xFF, (x&0xFF00)>>8,
			(x&0xFF0000)>>16, (x&0xFF000000)>>24);
}


int main(){
	unsigned  int key[]={0x4B6C6456,0x70753965 ,0x6B464266 ,0x4C304F6B};
	printf("\n");
	unsigned  int matrix[]={
		  0x2a302c19,0x254f979,0xd66ca9b3,0x4958091,0xa3e85929,0x86bd790f,0x6c1305af,0x2bdb75fe,0x5df0e0ae,0x89864b88,0x45ac6633,0xa6786c9a
	};
	for(int i=0;i<6;i++){
		process_decrypt(matrix+2*i, key);
	}
	for(int i=0;i<12;i++){
		print(matrix[i]);
	}
}

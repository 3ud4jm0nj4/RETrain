#include <stdio.h>
#include <windows.h>
#include <wincrypt.h>
int Init(char *RR){
    
HCRYPTPROV hProv;

if(!CryptAcquireContext(&hProv,NULL,NULL,PROV_RSA_FULL,0)){ //https://learn.microsoft.com/en-us/windows/win32/seccrypto/cryptographic-provider-types
    printf("CryptAcquireContext failed: %d\n", GetLastError());
    return 1;
} 
HCRYPTHASH hHash ;
if(!CryptCreateHash(hProv,CALG_SHA,0,0,&hHash)){ //https://learn.microsoft.com/en-us/windows/win32/seccrypto/alg-id
    printf("CryptCreateHash failed: %d \n", GetLastError());
}
DWORD len = strlen(RR);
if (!CryptHashData(hHash, RR, len, 0)) {
        printf("Error %d during CryptHashData!\n", GetLastError());
        CryptDestroyHash(hHash);
        CryptReleaseContext(hProv, 0);
        return 1;
    }
HCRYPTKEY  phKey;
if( !CryptDeriveKey(hProv,CALG_RC4, hHash,0, &phKey ))
 {
        CryptReleaseContext(hProv, 0);
        CryptDestroyHash(hHash);
        return 1;
  }

CryptDestroyHash(hHash);
if (!CryptEncrypt(phKey, 0, TRUE, 0, 0, &len, 0x400)) {
        return 1;
    }
LPVOID memalloc = VirtualAlloc(0,len+1,0x1000,4); //MEM_COMMIT

memset(memalloc,0,len);

char flag[]={  0xF8, 0x50, 0xCC, 0xEF, 0xE6, 0x3C, 0x35, 0x96, 0x1D, 0x61, 
  0xAE, 0xC0, 0xC5, 0x31, 0xCE, 0xB0, 0xE7, 0x1D, 0xED, 0xBC, 
	0x5D, 0x81, 0x69, 0x8A, 0x35, 0x74, 0x57, 0xB6};
len = strlen(flag);
CryptDecrypt(phKey,0,1,0,flag,&len);
 for(int i =0 ;i<len;i++){
  printf("%c",flag[i]);
 }

CryptReleaseContext(hProv, 0);

  return 0;
}
int main(){
	char key[]="https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  Init(key);
}
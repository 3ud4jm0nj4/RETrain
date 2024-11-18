#include <stdio.h>
#include <windows.h>
#include <wincrypt.h>

int Init(char *RR){
    
HCRYPTPROV hProv;

if(!CryptAcquireContext(&hProv,NULL,NULL,PROV_RSA_AES,0)){
    printf("CryptAcquireContext failed: %d\n", GetLastError());
    return 1;
} 
HCRYPTHASH hHash ;
if(!CryptCreateHash(hProv,CALG_SHA_256,0,0,&hHash)){
    printf("CryptCreateHash failed: %d \n", GetLastError());
}
DWORD len = strlen(RR);

if (!CryptHashData(hHash, RR, len, 0)) {
        printf("Error %d during CryptHashData!\n", GetLastError());
        CryptDestroyHash(hHash);
        CryptReleaseContext(hProv, 0);
        return 1;
    }

  if (!CryptGetHashParam(hHash, HP_HASHVAL, RR, &len, 0)) {
        printf("Error %d during CryptGetHashParam!\n", GetLastError());
        CryptDestroyHash(hHash);
        CryptReleaseContext(hProv, 0);
        return 1;
    }
CryptDestroyHash(hHash);
CryptReleaseContext(hProv, 0);

  return 0;
}

int EncFlag(char *flag){
    char hash[] = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    Init(hash);
DWORD dwDataLen = strlen(flag);
  for(int i= 0; i<strlen(hash);i++){
    hash[i] = hash[i] & 0xff;
  }
  BYTE hihi [] = "aMicrosoft Enhanced RSA and AES Cryptographic Provider";
    HCRYPTPROV hProv;
HCRYPTKEY hKey;
if(!CryptAcquireContext(&hProv,NULL,NULL,PROV_RSA_AES,0)){
    printf("CryptAcquireContext failed: %d\n", GetLastError());
    return 1;
} 
memset(hihi+11,0,32);
char dump[]= {0x08, 0x02, 0x00, 0x00, 0x10, 0x66, 0x00, 0x00, 0x20, 0x00, 
  0x00, 0x00};
memcpy(hihi,dump,12);
memcpy(hihi+12,hash,0x20);
DWORD dwKeyLen = 44;
if (!CryptImportKey(hProv, hihi, dwKeyLen, 0, 0, &hKey)) {
        printf("Error %d during CryptImportKey!\n", GetLastError());
        CryptReleaseContext(hProv, 0);
        return 1;
    }
DWORD dwMode = 1;//CRYPT_MODE_CBC
if (!CryptSetKeyParam(hKey, 4, (BYTE*)&dwMode, 0)) { //4= KP_MODE
    printf("Error %d during CryptSetKeyParam1!\n", GetLastError());
    CryptDestroyKey(hKey);
    CryptReleaseContext(hProv, 0);
    return 1;
}
BYTE pbIV[16] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,0x10};

if (!CryptSetKeyParam(hKey, 1, pbIV, 0)) { //1=KP_IV
    printf("Error %d during CryptSetKeyParam2!\n", GetLastError());
    CryptDestroyKey(hKey);
    CryptReleaseContext(hProv, 0);
    return 1;
}
if (!CryptEncrypt(hKey, 0, TRUE, 0, flag, &dwDataLen, 0x400)) {
        printf("Error %d during CryptEncrypt!\n", GetLastError());
        return 1;
    }
CryptDestroyKey(hKey);
CryptReleaseContext(hProv, 0);

return 0 ;

}

int main()
{
    BYTE flag[256];
    memset(flag, 0, 256*sizeof(char));
    printf("Enter Flag:");
    scanf("%s",&flag);
    BYTE cipher[] = {0xE5, 0x60, 0x44, 0x09, 0x42, 0xC4, 0xBB, 0xDE, 0xF6, 0xA1, 
  0x2D, 0x93, 0xD9, 0x1D, 0x13, 0x72, 0xAF, 0x8D, 0x4C, 0xF7, 
  0xA7, 0x9F, 0x1F, 0xB9, 0x99, 0x68, 0x9C, 0xB8, 0xC2, 0x4C, 
  0x4F, 0x85};
    EncFlag(flag);

    for(int i =0;i<32;i++){
        printf("%x ",flag[i]&0xff);
        if((flag[i]&0xff)!=cipher[i]){
            printf("[+] Wrong!");
            return 1;
        }
    }
    printf("[+] Correct!");


    return 0;
}
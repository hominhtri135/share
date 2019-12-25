#include <stdio.h>
#include <algorithm>
void NhapMang(int a[], int n) {
	printf("\n=======NHAP MANG======\n");
	printf("\n* Nhap mang A[]: \n");
	for (int i=0; i<n; i++) {
		printf("	Nhap A[%d]: ",i);
		scanf("%d",&a[i]);
	}
}
void XuatMang(int a[], int n) {

	for (int i=0; i<n; i++) {
		printf("%4d",a[i]);
	}
	printf("\n");
}
void SapXep(int a[], int n) {
	printf("\n=======SAP XEP MANG======\n");
	for (int i=0; i<n-1; i++) {
		for (int j=i+1; j<n; j++) {
			if(a[i] > a[j]) std::swap(a[i],a[j]);
		}
	}
	printf("\n* Mang sau khi sap xep: ");
	XuatMang(a,n);
}
void ThemPhanTu(int a[], int &n, int &k, int &vt) {
	printf("\n=======THEM PHAN TU======\n");
	printf("\n* Nhap k: ");
	scanf("%d",&k);
	printf("* Nhap vi tri can them: ");
	scanf("%d",&vt);
    if(vt < 0) vt = 0;
    else if(vt > n) vt = n;
    
    for(int i = n; i>vt; i--){
        a[i] = a[i-1];
    }
    a[vt] = k;
    ++n;
    printf("* Mang sau khi them: ");
    XuatMang(a,n);
}
void XoaPhanTu(int a[], int &n, int &k){
	printf("\n=======XOA PHAN TU======\n");
	printf("\n* Nhap k: ");
	scanf("%d",&k);
    int dem=0;
    for (int i=0; i<n; i++) {
    	if(a[i] == k) dem++;
	}
	if (dem == 0) {
		printf("Khong ton tai %d trong mang!",k);
	}
	else {
		while(dem>0) {
	    	for (int i=0; i<n; i++) {
	    		if(a[i] == k) {
	    			for (i; i<n-1; i++) {
	    				a[i] = a[i+1];
					}
					--n;
					--dem;;
				}
			}
		}
		printf("* Mang sau khi xoa: ");
    	XuatMang(a,n);
	}
}
void DaoNguoc(int a[], int n) {
	printf("\n=======DAO NGUOC MANG======\n");
	for(int i=0;i<=n/2;i++) std::swap(a[i],a[n-1-i]);
	printf("\n* Mang sau dao nguoc: ");
    XuatMang(a,n);
}
int main() {
	int a[1000], n, k, vt;
	printf("* Nhap n: ");
	scanf("%d",&n);
	NhapMang(a,n);
	printf("\n=======XUAT MANG======\n");
	printf("\n* Mang A[]: ");
	XuatMang(a,n);
	SapXep(a,n);
	ThemPhanTu(a,n,k,vt);
	XoaPhanTu(a,n,k);
	DaoNguoc(a,n);
}

// Bubble sort

#include <stdio.h>

void swap(int* a, int i, int j) {
    int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

void bubbleSortDescending(int* a, int n) {
    int sorted = 1;

    for (int i = 0; i < n - 1; i++) {
        if (a[i] < a[i + 1]) {
            swap(a, i , i + 1);
            sorted = 0;
        }
    }

    if (sorted == 1) return;
    
    bubbleSortDescending(a, n - 1);
}

#define N 100
int nums;
int elems[N];

int main() {
    scanf("%d", &nums);

    for (int i = 0; i < nums; i++) {
        scanf("%d", elems + i);
    }

    bubbleSortDescending(elems, nums);

    for (int i = 0; i < nums; i++) {
        printf("%d ", elems[i]);
    }
    printf("\n");

    return 0;
}

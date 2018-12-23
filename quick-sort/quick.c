// Quick sort

#include <stdio.h>

void swap(int* a, int i, int j) {
    int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

int partition(int* a, int begin, int end) {
    int pivotKey = a[end - 1];
    int j = begin;

    for (int i = begin; i < end - 1; i++) {
        if (a[i] < pivotKey) {
            swap(a, i, j);
            j++;
        }
    }

    swap(a, j, end - 1);

    return j; // pivot
}

void quickSort(int* a, int begin, int end) { // end is exclusive
    if (begin < end - 1) {
        int pivot = partition(a, begin, end);
        quickSort(a, begin, pivot);
        quickSort(a, pivot + 1, end);
    }
}

#define N 100
int nums;
int elems[N];

int main() {
    scanf("%d", &nums);

    for (int i = 0; i < nums; i++) {
        scanf("%d", elems + i);
    }

    quickSort(elems, 0, nums);

    for (int i = 0; i < nums; i++) {
        printf("%d ", elems[i]);
    }
    printf("\n");

    return 0;
}
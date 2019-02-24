#include <iostream>
#include <fstream>
#include <time.h>
#include <string>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <device_functions.h>

#define THREADS_PER_BLOCK 512

using namespace std;

int SBoxInvert(int num) {

	int rsbox[256] =

	{ 0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb

		, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb

		, 0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e

		, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25

		, 0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92

		, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84

		, 0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06

		, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b

		, 0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73

		, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e

		, 0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b

		, 0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4

		, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f

		, 0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef

		, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61

		, 0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d };



	return rsbox[num];

}

int SBoxValue(int num) {

	int sbox[256] = {

		0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,

		0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,

		0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,

		0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,

		0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,

		0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,

		0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,

		0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,

		0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,

		0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,

		0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,

		0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,

		0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,

		0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,

		0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,

		0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 };

	return sbox[num];

}

void subBytes(unsigned char **state) {
	for (int i = 0; i<4; i++)
		for (int j = 0; j<4; j++)
			state[i][j] = SBoxValue(state[i][j]);
}

void invSubBytes(unsigned char **state) {
	for (int i = 0; i<4; i++)
		for (int j = 0; j<4; j++)
			state[i][j] = SBoxInvert(state[i][j]);
}

void addRoundKey(int round, unsigned char **state, unsigned char *roundKey) {
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			state[j][i] ^= roundKey[round * 16 + i * 4 + j];
}

void invShiftRows(unsigned char **state)

{

	unsigned char temp;

	temp = state[1][3];

	state[1][3] = state[1][2];
	state[1][2] = state[1][1];
	state[1][1] = state[1][0];
	state[1][0] = temp;


	temp = state[2][0];

	state[2][0] = state[2][2];
	state[2][2] = temp;

	temp = state[2][1];

	state[2][1] = state[2][3];
	state[2][3] = temp;


	temp = state[3][0];

	state[3][0] = state[3][1];
	state[3][1] = state[3][2];
	state[3][2] = state[3][3];
	state[3][3] = temp;

}

void shiftRows(unsigned char **state) {

	unsigned char temp;

	temp = state[1][0];

	state[1][0] = state[1][1];
	state[1][1] = state[1][2];
	state[1][2] = state[1][3];
	state[1][3] = temp;

	temp = state[2][0];

	state[2][0] = state[2][2];
	state[2][2] = temp;

	temp = state[2][1];

	state[2][1] = state[2][3];
	state[2][3] = temp;

	temp = state[3][3];

	state[3][3] = state[3][2];
	state[3][2] = state[3][1];
	state[3][1] = state[3][0];
	state[3][0] = temp;


}

void showState(unsigned char **state) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			cout << (int)state[j][i] << " ";
		}
		cout << endl;
	}
	cout << endl;
}

void keyExpansion(unsigned char *roundKey, unsigned char key[]) {

	int rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36 };

	unsigned char temp[4], k;
	for (int i = 0; i < 4; i++) {
		roundKey[i * 4] = key[i * 4];
		roundKey[i * 4 + 1] = key[i * 4 + 1];
		roundKey[i * 4 + 2] = key[i * 4 + 2];
		roundKey[i * 4 + 3] = key[i * 4 + 3];
	}
	for (int i = 0; i < 40; i++) {
		for (int j = 0; j < 4; j++) {
			temp[j] = roundKey[i * 4 + j + 16];
		}

		if (i % 4 == 0) {

			k = temp[0];
			temp[0] = temp[1];
			temp[1] = temp[2];
			temp[2] = temp[3];
			temp[3] = k;

			temp[0] = SBoxValue(temp[0]);
			temp[1] = SBoxValue(temp[1]);
			temp[2] = SBoxValue(temp[2]);
			temp[3] = SBoxValue(temp[3]);

			temp[0] = temp[0] ^ rcon[i / 4];

			roundKey[i * 4 + 16] = roundKey[i * 4 + 0] ^ temp[0];
			roundKey[i * 4 + 17] = roundKey[i * 4 + 1] ^ temp[1];
			roundKey[i * 4 + 18] = roundKey[i * 4 + 2] ^ temp[2];
			roundKey[i * 4 + 19] = roundKey[i * 4 + 3] ^ temp[3];
		}
		else {
			roundKey[i * 4 + 16] = roundKey[i * 4 + 12] ^ roundKey[i * 4];
			roundKey[i * 4 + 17] = roundKey[i * 4 + 13] ^ roundKey[i * 4 + 1];
			roundKey[i * 4 + 18] = roundKey[i * 4 + 14] ^ roundKey[i * 4 + 2];
			roundKey[i * 4 + 19] = roundKey[i * 4 + 15] ^ roundKey[i * 4 + 3];
		}
	}
}

__device__ int dSBoxInvert(int num) {

	int rsbox[256] =

	{ 0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb

		, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb

		, 0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e

		, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25

		, 0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92

		, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84

		, 0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06

		, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b

		, 0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73

		, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e

		, 0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b

		, 0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4

		, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f

		, 0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef

		, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61

		, 0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d };



	return rsbox[num];

}

__device__ int dSBoxValue(int num) {

	int sbox[256] = {

		0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,

		0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,

		0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,

		0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,

		0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,

		0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,

		0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,

		0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,

		0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,

		0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,

		0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,

		0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,

		0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,

		0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,

		0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,

		0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 };

	return sbox[num];

}

__device__ void dsubBytes(unsigned char **state) {
	for (int i = 0; i<4; i++)
		for (int j = 0; j<4; j++)
			state[i][j] = dSBoxValue(state[i][j]);
}

__device__ void dinvSubBytes(unsigned char **state) {
	for (int i = 0; i<4; i++)
		for (int j = 0; j<4; j++)
			state[i][j] = dSBoxInvert(state[i][j]);
}

__device__ void daddRoundKey(int round, unsigned char **state, unsigned char *roundKey) {
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			state[j][i] ^= roundKey[round * 16 + i * 4 + j];
}

__device__ void dinvShiftRows(unsigned char **state)

{

	unsigned char temp;

	temp = state[1][3];

	state[1][3] = state[1][2];
	state[1][2] = state[1][1];
	state[1][1] = state[1][0];
	state[1][0] = temp;


	temp = state[2][0];

	state[2][0] = state[2][2];
	state[2][2] = temp;

	temp = state[2][1];

	state[2][1] = state[2][3];
	state[2][3] = temp;


	temp = state[3][0];

	state[3][0] = state[3][1];
	state[3][1] = state[3][2];
	state[3][2] = state[3][3];
	state[3][3] = temp;

}

__device__ void dshiftRows(unsigned char **state) {

	unsigned char temp;

	temp = state[1][0];

	state[1][0] = state[1][1];
	state[1][1] = state[1][2];
	state[1][2] = state[1][3];
	state[1][3] = temp;

	temp = state[2][0];

	state[2][0] = state[2][2];
	state[2][2] = temp;

	temp = state[2][1];

	state[2][1] = state[2][3];
	state[2][3] = temp;

	temp = state[3][3];

	state[3][3] = state[3][2];
	state[3][2] = state[3][1];
	state[3][1] = state[3][0];
	state[3][0] = temp;


}

__global__ void dencryption(unsigned char *dataIn, unsigned char *dataOut, int *size, unsigned char *roundKey) {
	
	int size1 = *size/16;
	unsigned char input[16];
	unsigned char encryptedPartOfData[16];
	
	unsigned char **state = new unsigned char*[4];
	for (int i = 0; i < 4; i++)
		state[i] = new unsigned char[4];
		
	int index = threadIdx.x + blockDim.x * blockIdx.x;

	if (index < size1) {
		for (int i = 0; i < 16; i++)
			input[i] = dataIn[16 * index + i];

		for (int i = 0; i < 4; i++)
			for (int j = 0; j < 4; j++)
				state[j][i] = input[4 * i + j];

		daddRoundKey(0, state, roundKey);

		for (int i = 1; i <= 10; i++) {
			dsubBytes(state);
			dshiftRows(state);
			daddRoundKey(i, state, roundKey);
		}
		for (int i = 0; i < 4; i++)
			for (int j = 0; j < 4; j++)
				encryptedPartOfData[4 * i + j] = state[j][i];

		for (int i = 0; i < 16; i++)
			dataOut[16 * index + i] = encryptedPartOfData[i];
	}

	for (int i = 0; i < 4; i++)
	{
		delete[]state[i];
	}
	delete[] state;
}

__global__ void ddecryption(unsigned char *dataIn, unsigned char *dataOut, int *size, unsigned char *roundKey) {

	int size1 = *size / 16;
	unsigned char input[16];
	unsigned char encryptedPartOfData[16];

	unsigned char **state = new unsigned char*[4];
	for (int i = 0; i < 4; i++)
		state[i] = new unsigned char[4];

	int index = threadIdx.x + blockDim.x * blockIdx.x;

	if (index < size1) {
		for (int i = 0; i < 16; i++)
			input[i] = dataIn[16 * index + i];

		for (int i = 0; i < 4; i++)
			for (int j = 0; j < 4; j++)
				state[j][i] = input[4 * i + j];

		daddRoundKey(10, state, roundKey);

		for (int i = 9; i >= 0; i--) {
			dinvShiftRows(state);
			dinvSubBytes(state);
			daddRoundKey(i, state, roundKey);
		}
		for (int i = 0; i < 4; i++)
			for (int j = 0; j < 4; j++)
				encryptedPartOfData[4 * i + j] = state[j][i];

		for (int i = 0; i < 16; i++)
			dataOut[16 * index + i] = encryptedPartOfData[i];
	}

	for (int i = 0; i < 4; i++)
	{
		delete[]state[i];
	}
	delete[] state;

}

__host__ void dkeyExpansion(unsigned char *roundKey, unsigned char key[]) {

	int rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36 };

	unsigned char temp[4], k;
	for (int i = 0; i < 4; i++) {
		roundKey[i * 4] = key[i * 4];
		roundKey[i * 4 + 1] = key[i * 4 + 1];
		roundKey[i * 4 + 2] = key[i * 4 + 2];
		roundKey[i * 4 + 3] = key[i * 4 + 3];
	}
	for (int i = 0; i < 40; i++) {
		for (int j = 0; j < 4; j++) {
			temp[j] = roundKey[i * 4 + j + 16];
		}

		if (i % 4 == 0) {

			k = temp[0];
			temp[0] = temp[1];
			temp[1] = temp[2];
			temp[2] = temp[3];
			temp[3] = k;

			temp[0] = SBoxValue(temp[0]);
			temp[1] = SBoxValue(temp[1]);
			temp[2] = SBoxValue(temp[2]);
			temp[3] = SBoxValue(temp[3]);

			temp[0] = temp[0] ^ rcon[i / 4];

			roundKey[i * 4 + 16] = roundKey[i * 4 + 0] ^ temp[0];
			roundKey[i * 4 + 17] = roundKey[i * 4 + 1] ^ temp[1];
			roundKey[i * 4 + 18] = roundKey[i * 4 + 2] ^ temp[2];
			roundKey[i * 4 + 19] = roundKey[i * 4 + 3] ^ temp[3];
		}
		else {
			roundKey[i * 4 + 16] = roundKey[i * 4 + 12] ^ roundKey[i * 4];
			roundKey[i * 4 + 17] = roundKey[i * 4 + 13] ^ roundKey[i * 4 + 1];
			roundKey[i * 4 + 18] = roundKey[i * 4 + 14] ^ roundKey[i * 4 + 2];
			roundKey[i * 4 + 19] = roundKey[i * 4 + 15] ^ roundKey[i * 4 + 3];
		}
	}
}

unsigned char* CudaEncryption(unsigned char *data, int width, int height, int whatDoWeDonext) {

	int dataSize = 3 * width*height;
	int numberOfIterations = dataSize / 16;

	unsigned char* roundKey = new unsigned char[176];
	unsigned char key[16] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
	unsigned char *dataIn, *droundKey, *dataOut;
	unsigned char *d_dataIn, *d_dataOut, *d_roundKey;
	int *size, *d_size;
	int keySize = 176;
	dkeyExpansion(roundKey, key);

	size = (int*)malloc(sizeof(int));
	dataIn = (unsigned char*)malloc((dataSize) * sizeof(unsigned char));
	dataOut = (unsigned char*)malloc((dataSize) * sizeof(unsigned char));
	d_dataIn = (unsigned char*)malloc((dataSize) * sizeof(unsigned char));
	d_dataOut = (unsigned char*)malloc((dataSize) * sizeof(unsigned char));
	d_roundKey = (unsigned char*)malloc((keySize) * sizeof(unsigned char));

	dataIn = data;
	*size = dataSize;
	droundKey = roundKey;

	cudaMalloc(&d_dataIn, dataSize * sizeof(unsigned char));
	cudaMalloc(&d_dataOut, dataSize * sizeof(unsigned char));
	cudaMalloc(&d_roundKey, keySize * sizeof(unsigned char));
	cudaMalloc(&d_size, sizeof(int));

	cudaMemcpy(d_dataIn, dataIn, dataSize * sizeof(unsigned char), cudaMemcpyHostToDevice);
	cudaMemcpy(d_roundKey, droundKey, keySize * sizeof(unsigned char), cudaMemcpyHostToDevice);
	cudaMemcpy(d_size, size, sizeof(int), cudaMemcpyHostToDevice);
	
	cout << "Width: "<<  width << " Height: " << height << endl;

	if (whatDoWeDonext == 1) {
		cout << "Trwa kodowanie na GPU." << endl;
		clock_t t;
		t = clock();
		dencryption << < (numberOfIterations+THREADS_PER_BLOCK-1)/THREADS_PER_BLOCK, THREADS_PER_BLOCK >> > (d_dataIn, d_dataOut, d_size, d_roundKey);
		cudaMemcpy(dataOut, d_dataOut, dataSize * sizeof(unsigned char), cudaMemcpyDeviceToHost);
		t = clock() - t;
		cout << "Kodowanie trwalo " << float(t) / CLOCKS_PER_SEC << " sekund." << endl;
		return dataOut;
	}
	else {
		cout << "Trwa dekodowanie na GPU." << endl;
		clock_t t;
		t = clock();
		ddecryption << <(numberOfIterations + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK, THREADS_PER_BLOCK >> > (d_dataIn, d_dataOut, d_size, d_roundKey);
		cudaMemcpy(dataOut, d_dataOut, dataSize * sizeof(unsigned char), cudaMemcpyDeviceToHost);
		t = clock() - t;
		cout << "Dekodowanie trwalo " << float(t) / CLOCKS_PER_SEC << " sekund." << endl;
		return dataOut;
	}
}

void encryptionRound(unsigned char **state, unsigned char *roundKey, unsigned char *encryptedPartOfData) {

	addRoundKey(0, state, roundKey);

	for (int i = 1; i <= 10; i++) {
		subBytes(state);
		shiftRows(state);
		addRoundKey(i, state, roundKey);
	}
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			encryptedPartOfData[4 * i + j] = state[j][i];

}

void decryptionRound(unsigned char **state, unsigned char *roundKey, unsigned char *encryptedPartOfData) {

	addRoundKey(10, state, roundKey);

	for (int i = 9; i >= 0; i--) {
		invShiftRows(state);
		invSubBytes(state);
		addRoundKey(i, state, roundKey);
	}
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			encryptedPartOfData[4 * i + j] = state[j][i];

}

void encryption(unsigned char data[], int width, int height, unsigned char *encryptedData, int whatDoWeDonext) {

	unsigned char input[16];
	unsigned char **state = new unsigned char*[4];
	for (int i = 0; i < 4; i++)
		state[i] = new unsigned char[4];

	int numberOfIterations = width * height * 3 / 16;
	unsigned char* roundKey = new unsigned char[176];
	unsigned char* encryptedPartOfData = new unsigned char[16];
	unsigned char key[16] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };

	keyExpansion(roundKey, key);

	cout << "Width: " << width << " Height: " << height << endl;
	cout << "Trwa kodowanie na CPU." << endl;
	clock_t t;
	t = clock();
	for (int j = 0; j < numberOfIterations; j++) {

		for (int i = 0; i < 16; i++) {
			input[i] = data[16 * j + i];
		}

		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				state[j][i] = input[4 * i + j];
			}
		}
		if (whatDoWeDonext == 1)
			encryptionRound(state, roundKey, encryptedPartOfData);
		else
			decryptionRound(state, roundKey, encryptedPartOfData);

		for (int i = 0; i < 16; i++) {
			encryptedData[16 * j + i] = encryptedPartOfData[i];
		}
	}

	t = clock() - t;

	if (whatDoWeDonext == 1 )
		cout << "Kodowanie trwalo " << float(t) / CLOCKS_PER_SEC << " sekund." << endl;
	else if(whatDoWeDonext ==2)
		cout << "Dekodowanie trwalo " << float(t) / CLOCKS_PER_SEC << " sekund." << endl;

}

unsigned char* loadImage(unsigned char* entireData, unsigned char* info, string name) {

	FILE * filepoint;
	errno_t err;

	if ((err = fopen_s(&filepoint, name.c_str(), "rb+")) != 0) {
		cout << "Argument Exception" << endl;
		return 0;
	}

	else {

		fread(info, sizeof(unsigned char), 54, filepoint);
		int width = *(int*)&info[18];
		int height = *(int*)&info[22];
		int row_padded = (width * 3 + 3) & (~3);
		unsigned char* data = new unsigned char[row_padded];
		entireData = new unsigned char[width*height * 3];

		for (int i = 0; i < height; i++) {
			fread(data, sizeof(unsigned char), row_padded, filepoint);
			for (int j = 0; j < width * 3; j += 3) {
				//cout << "R: " << (int)data[j] << " G: " << (int)data[j + 1] << " B: " << (int)data[j + 2] << endl;
				entireData[3 * i*width + j] = data[j];
				entireData[3 * i*width + j + 1] = data[j + 1];
				entireData[3 * i*width + j + 2] = data[j + 2];
				//cout << 3 * i*width + j + 2 << endl;

			}
		}
		fclose(filepoint);

		//cout << " wyposuje data" << endl;
		//for (int i = 0; i < width*height * 3 ; i ++)
		//cout << i << " " << (int)entireData[i] << endl;
		return entireData;
	}

}

int *getSizeOfImage(string name) {
	FILE * filepoint;
	errno_t err;

	if ((err = fopen_s(&filepoint, name.c_str(), "rb+")) != 0) {
		cout << "Argument Exception" << endl;
		return 0;
	}

	else {
		unsigned char info[54];
		fread(info, sizeof(unsigned char), 54, filepoint);
		int width = *(int*)&info[18];
		int height = *(int*)&info[22];
		int sizeArray[2];
		sizeArray[0] = width;
		sizeArray[1] = height;
		fclose(filepoint);
		return sizeArray;
	}
}

int main() {

	cout << "Program do zakodowania i odkodowania zdjecia za pomoca algorytmu AES." << endl;
	string input;
	string outputGPU;
	string outputCPU;
	unsigned char * info = new unsigned char[54];

	cout << "Wcisnij 1, aby zakodowac zdjecie." << endl;
	cout << "Wcisnij 2, aby odkodowac zdjecie." << endl;
	cout << "Wcisnij 3, aby opuscic program" << endl;

	int whatDoWeDoNext;
	cin >> whatDoWeDoNext;

	while (whatDoWeDoNext != 3) {

		cout << "Wprowadz nazwe pliku." << endl;
		cin >> input;
		outputCPU = input;
		outputGPU = input;
		input.append(".bmp");
		outputGPU.append("GPU");
		int *vectorSize = getSizeOfImage(input);
		int width = vectorSize[0];
		int height = vectorSize[1];
		int size = width * height * 3;
		unsigned char * entireData = new unsigned char[size];
		unsigned char * encryptedData = new unsigned char[size];
		unsigned char * encryptedDataCuda = new unsigned char[size];
		entireData = loadImage(entireData, info, input);

		if (whatDoWeDoNext == 1 || whatDoWeDoNext == 2) {
			encryption(entireData, width, height, encryptedData, whatDoWeDoNext);
			encryptedDataCuda = CudaEncryption(entireData, width, height, whatDoWeDoNext);
		}
		else
			exit(0);

		if (whatDoWeDoNext == 1) {
			outputGPU.append("_enc.bmp");
			outputCPU.append("_enc.bmp");
		}
		else if (whatDoWeDoNext == 2) {
			outputGPU.append("_decrypted.bmp");
			outputCPU.append("_decrypted.bmp");
		}
		ofstream outputImageGPU(outputGPU, ios::binary);

		for (int i = 0; i < 54; i++)
			outputImageGPU << info[i];

		for (auto i = 0; i <= size - 1; i += 1)
			outputImageGPU << encryptedDataCuda[i];

		outputImageGPU.close();

		ofstream outputImageCPU(outputCPU, ios::binary);

		for (int i = 0; i < 54; i++)
			outputImageCPU << info[i];

		for (auto i = 0; i <= size - 1; i += 1)
			outputImageCPU << encryptedData[i];

		outputImageCPU.close();

		cout << "Wcisnij 1, aby zakodowac zdjecie." << endl;
		cout << "Wcisnij 2, aby odkodowac zdjecie." << endl;
		cout << "Wcisnij 3, aby opuscic program" << endl;
		cin >> whatDoWeDoNext;
	}

	return 0;
}

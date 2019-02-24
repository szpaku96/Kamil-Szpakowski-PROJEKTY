// gra snake napisana w języku C działająca na emulatorze gameboya

typedef unsigned short u16; // two type definitions
typedef unsigned long u32;

#include "keypad.h"		//keypad definitions 
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define RGB16(r,g,b)  ((r)+(g<<5)+(b<<10)) 

struct Point{
	int x;
	int y;
};

void checkForPoint(int *headX,int *headY,int *targetX,int *targetY,int *score, struct Point points[],unsigned short* Screen, int*numberOfPoint,struct Point body[]){
	
	if(*headY == *targetY && *headX == *targetX){
		*score += 1;
		*numberOfPoint += 1;
		if ( * numberOfPoint == 45 )
			*numberOfPoint = 0;
	}
	// check for body
	int i;
	for(i=0 ; i < *score+1 ; i++)
		if (points[*numberOfPoint].x == body[i].x && points[*numberOfPoint].y == body[i].y){
			*numberOfPoint += 1;
		}
		// Draw target
	*targetX = points[*numberOfPoint].x;
	*targetY = points[*numberOfPoint].y;
		int x;
		int y;
		for ( x = 0 ; x < 8 ; x++)
			for ( y = 0 ; y < 8 ; y ++ )
				Screen[*targetX+x + 240 * (*targetY+y) ] = RGB16(31,0,0);

}

void wait(int *score){
	unsigned long int i = 0;
	unsigned long int a;
	for(i ; i < 30000-250**score; i++){
		a = i;
	}
}

void drawBody(struct Point body[],int* headX, int *headY,unsigned short* Screen, int *score ){ 
	int i;
	int x;
	int y;	
	
	for ( x = 0 ; x < 8 ; x++)
		for ( y = 0 ; y < 8 ; y ++ )
			Screen[body[*score].x+x + 240 * (body[*score].y+y) ] = RGB16(0,0,0);
	
	for(i = *score; i > 0; i--){
	   body[i].x = body[i-1].x;
	   body[i].y = body[i-1].y;
	}		
	body[0].x = *headX;
		
	body[0].y = *headY;
	for ( x = 0 ; x < 8 ; x++)
			for ( y = 0 ; y < 8 ; y ++ )
				Screen[body[0].x+x + 240 * (body[0].y+y) ] = RGB16(25,31,0);	
		
	for(i=1 ; i < *score+1 ; i++)
		for ( x = 0 ; x < 8 ; x++)
			for ( y = 0 ; y < 8 ; y ++ )
				Screen[body[i].x+x + 240 * (body[i].y+y) ] = RGB16(0,31,0);
		
}

void checkBody(struct Point body[], int*score, int*death){
	
	int y;

	if(*score>0)
		for(y=1; y<*score+1; y++)
			if(body[0].x == body[y].x && body[0].y == body[y].y)
				*death = 1;

}

void deathFun(int* lives, int *headX, int* headY, int* score, int* movedir, int* death,unsigned short* Screen){
	
	*death = 0;
	if(*lives ==1)
	{
		*movedir = 4;
		*score = 0;
		*headX = 64;
		*headY = 64;
		
	}
	else{
		*movedir = 4;
		*lives -= 1;
		*score = 0;
		*headX = 64;
		*headY = 64;

	}	
	int x;
	int y;
	for ( x = 0 ; x < 240 ; x++)
		for ( y = 0 ; y < 160 ; y ++ )
			Screen[x + 240*y ] = RGB16(0,0,0);
}

void move(int* movedir, int* headX, int* headY, int* death){
		
	if(*movedir == 0)
		if(*headY>0)
			*headY-=8;
		else
			*death = 1;
			
	else if (*movedir == 1)
		if(*headY<152)
			*headY+=8; 
		else
			*death = 1;
		
	else if (*movedir == 2)
		if(*headX>0)
			*headX-=8; 
		else
			*death = 1;
			
	else if (*movedir == 3)
		if(*headX < 232)
			*headX+=8; 
		else
			*death = 1;
				
}


int main()
{	
	int headX = 64;
	int headY = 64;
	int lives = 100 ; 
	int score = 0 ;
	int numberOfPoint = 0;
	int length = 3;
	char x,y;  
	unsigned short* Screen = (unsigned short*)0x6000000; 
	*(unsigned long*)0x4000000 = 0x403; // mode3, bg2 on 
	int targetX;
	int targetY;
	int movedir=4;
	int death = 0;
	struct Point points[50];
	struct Point body[200];
	int randomHardcodeY[50] = {13, 14, 2, 1, 9, 6, 8, 1, 4, 12, 6, 9, 6, 15, 11, 13, 12, 14, 6, 14, 7, 5, 14, 19, 6, 11, 16, 19, 15, 11, 5, 12, 10, 10, 19, 9, 1, 7, 16, 11, 14, 15, 18, 3, 5, 3, 6, 13, 5, 8};
	int randomHardcodeX[50] = {4, 8, 9, 6, 6, 11, 10, 12, 16, 6, 8, 6, 22, 24, 5, 8, 24, 28, 5, 28, 20, 1, 25, 20, 7, 25, 27, 18, 23, 5, 5, 7, 11, 16, 9, 19, 18, 24, 20, 13, 19, 22, 24, 2, 9, 19, 10, 22, 19, 1};
	int i;
	int lock;
	
	for(i =0; i < 50; i++){
		points[i].x=randomHardcodeX[i];
		points[i].y=randomHardcodeY[i];
		points[i].x = points[i].x * 8;
		points[i].y = points[i].y * 8;
	}	

	body[0].x = headX;
	body[0].y = headY;
	
	while(1){
		lock = 0;
		targetX = points[numberOfPoint].x;
		targetY = points[numberOfPoint].y;
		if(!((*KEYS) & KEY_UP)) 
			if(movedir!= 1 && lock == 0){
				movedir = 0;
				lock = 1;
			
			}
		if(!((*KEYS) & KEY_DOWN))
			if(movedir!= 0&& lock == 0){
				movedir = 1;
				lock = 1;
			}
		if(!((*KEYS) & KEY_LEFT))
			if(movedir!= 3&& lock == 0){
				movedir = 2;
				lock = 1;
			}
		if(!((*KEYS) & KEY_RIGHT))
			if(movedir!= 2&& lock == 0){
				movedir = 3;
				lock = 1;
			}
		
		move(&movedir,&headX,&headY,&death);
		checkBody(body,&score,&death);
		if(death == 1)
			deathFun(&lives,&headX,&headY,&score,&movedir,&death,Screen);
		
		checkForPoint(&headX,&headY,&targetX,&targetY,&score,points,Screen,&numberOfPoint,body);
		drawBody(body,&headX,&headY,Screen,&score);
		wait(&score);
	
	}
	
	return 0;
}




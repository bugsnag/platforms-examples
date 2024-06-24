// Fill out your copyright notice in the Description page of Project Settings.


#include "MyActor.h"

// Sets default values
AMyActor::AMyActor()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void AMyActor::BeginPlay()
{
	Super::BeginPlay();
    // Run the start method immediately upon starting the game
      StartMethod();

      // Set a timer to call the delayed method after 10 seconds
      GetWorld()->GetTimerManager().SetTimer(TimerHandle, this, &AMyActor::DelayedMethod, 10.0f, false);

}

void AMyActor::StartMethod()
{
    UE_LOG(LogTemp, Warning, TEXT("StartMethod called at startup"));
}

void AMyActor::DelayedMethod()
{
    //crash
    volatile int* ptr = NULL;
    *ptr = 42;
    UE_LOG(LogTemp, Warning, TEXT("DelayedMethod called after 10 seconds"));
}

// Called every frame
void AMyActor::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}


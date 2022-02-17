#include <iostream>
#include "TFile.h"
#include "TTree.h"
#include <fstream>
using namespace std;

void dumpTreeTotxt(){
  TFile *f=new TFile("air.root"); // opens the root file
  TTree *tr=(TTree*)f->Get("Singles"); // creates the TTree object
  tr->Scan(); // prints the content on the screen

   double b; // create variables of the same type as the branches you want to access
   float a;
 //  float c;
  //tr->SetBranchAddress("CrystalLastHitPos_Z",&a); // for all the TTree branches you need this
  //tr->SetBranchAddress("CrystalLastHitEnergy",&b);
 // tr->SetBranchAddress("nserr",&c);
tr->SetBranchAddress("energy",&a);
tr->SetBranchAddress("time",&b);
//tr->SetBranchAddress("globalPosZ",&c);
  ofstream myfile;
  myfile.open ("air.txt");
 // myfile << "CrystalLastHitPos_Z CrystalLastHitEnergy\n";

  for (int i=0;i<tr->GetEntries();i++){
    // loop over the tree
    tr->GetEntry(i);
    //cout << a << " " << b << endl; //print to the screen
   // myfile << a << " " << b <<"\n"; //write to file

  //  cout << a<<endl; //print to the screen
    myfile << b <<" "<< a <<"\n"; //write to file
  }
  myfile.close();
}

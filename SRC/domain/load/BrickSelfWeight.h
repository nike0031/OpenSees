                                                                        
#ifndef BrickSelfWeight_h
#define BrickSelfWeight_h

// Written: ZHYang, UCDavis

// Purpose: This file contains the class definition for 8 node brick self weigth load.

#include <ElementalLoad.h>

class BrickSelfWeight : public ElementalLoad
{
  public:
    BrickSelfWeight(int tag, const ID &theElementTags);
    BrickSelfWeight();    
    ~BrickSelfWeight();

    const Vector &getData(int &type, double loadFactor);

    int sendSelf(int commitTag, Channel &theChannel);  
    int recvSelf(int commitTag, Channel &theChannel,  FEM_ObjectBroker &theBroker);
    void Print(ostream &s, int flag =0);       

  protected:
	
  private:
    static Vector data;
};

#endif


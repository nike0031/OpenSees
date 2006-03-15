/* ****************************************************************** **
**    OpenSees - Open System for Earthquake Engineering Simulation    **
**          Pacific Earthquake Engineering Research Center            **
**                                                                    **
**                                                                    **
** (C) Copyright 1999, The Regents of the University of California    **
** All Rights Reserved.                                               **
**                                                                    **
** Commercial use of this program without express permission of the   **
** University of California, Berkeley, is strictly prohibited.  See   **
** file 'COPYRIGHT'  in main directory for information on usage and   **
** redistribution,  and for a DISCLAIMER OF ALL WARRANTIES.           **
**                                                                    **
** Developed by:                                                      **
**   Frank McKenna (fmckenna@ce.berkeley.edu)                         **
**   Gregory L. Fenves (fenves@ce.berkeley.edu)                       **
**   Filip C. Filippou (filippou@ce.berkeley.edu)                     **
**                                                                    **
** ****************************************************************** */
                                                                        
// $Revision: 1.1 $
// $Date: 2006-03-09 01:54:01 $
// $Source: /usr/local/cvs/OpenSees/SRC/system_of_eqn/linearSOE/mumps/MumpsSOE.h,v $
                                                                        
#ifndef MumpsSOE_h
#define MumpsSOE_h

// Written: fmk 
// Created: 02/06
//
// Description: This file contains the class definition for MumpsSOE
// MumpsSOE is a subclass of LinearSOE. It stores the matrix equation
// Ax=b using the sparse column-compacted storage scheme for storing the 
// matrix A. 
//
// What: "@(#) MumpsSOE.h, revA"

#include <LinearSOE.h>
#include <Vector.h>

class MumpsSolver;

class MumpsSOE : public LinearSOE
{
  public:
    MumpsSOE(MumpsSolver &theSolver);        
    MumpsSOE(MumpsSolver &theSolver, int classTag);        
    MumpsSOE(int N, int NNZ, int *rowStartA, int *colA,
	     MumpsSolver &theSolver);        

    virtual ~MumpsSOE();

    virtual int getNumEqn(void) const;
    virtual int setSize(Graph &theGraph);
    virtual int addA(const Matrix &, const ID &, double fact = 1.0);
    virtual int addB(const Vector &, const ID &, double fact = 1.0);    
    virtual int setB(const Vector &, double fact = 1.0);        
    
    virtual void zeroA(void);
    virtual void zeroB(void);
    
    virtual const Vector &getX(void);
    virtual const Vector &getB(void);    
    virtual double normRHS(void);

    virtual void setX(int loc, double value);        
    virtual void setX(const Vector &x);        
    virtual int setMumpsSolver(MumpsSolver &newSolver);    

    virtual int sendSelf(int commitTag, Channel &theChannel);
    virtual int recvSelf(int commitTag, Channel &theChannel, FEM_ObjectBroker &theBroker);    

    friend class MumpsSolver;    


  protected:
    int size;            // order of A
    int nnz;             // number of non-zeros in A
    double *A, *B, *X;   // 1d arrays containing coefficients of A, B and X
    int *colA, *rowA, *rowB, *colStartA; // int arrays containing info about coeficientss in A
    Vector *vectX;
    Vector *vectB;    
    int Asize, Bsize;    // size of the 1d array holding A
    bool factored;
    
  private:

};


#endif

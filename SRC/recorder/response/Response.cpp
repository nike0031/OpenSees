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
                                                                        
// $Revision: 1.3 $
// $Date: 2001-07-31 18:26:59 $
// $Source: /usr/local/cvs/OpenSees/SRC/recorder/response/Response.cpp,v $
                                                                        
// Written: MHS 
// Created: Oct 2000
//
// Description: This file contains the Response class implementation

#include <Response.h>

Response::Response(void):myInfo()
{

}

Response::Response(int val):myInfo(val)
{

}

Response::Response(double val):myInfo(val)
{

}

Response::Response(const ID &val):myInfo(val)
{

}

Response::Response(const Vector &val):myInfo(val)
{

}

Response::Response(const Matrix &val):myInfo(val)
{

}

Response::Response(const Tensor &val):myInfo(val)
{

}

Response::~Response()
{

}

void
Response::Print(ostream &s, int flag)
{
	myInfo.Print(s, flag);
}

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

// $Revision: 1.5 $
// $Date: 2007-10-26 04:49:08 $
// $Source: /usr/local/cvs/OpenSees/SRC/element/forceBeamColumn/UserDefinedBeamIntegration.cpp,v $

#include <UserDefinedBeamIntegration.h>

#include <Vector.h>
#include <Channel.h>
#include <FEM_ObjectBroker.h>
#include <Information.h>
#include <Parameter.h>

UserDefinedBeamIntegration::UserDefinedBeamIntegration(int nIP,
						       const Vector &pt,
						       const Vector &wt):
  BeamIntegration(BEAM_INTEGRATION_TAG_UserDefined),
  pts(nIP), wts(nIP)
{
  for (int i = 0; i < nIP; i++) {
    if (pt(i) < 0.0 || pt(i) > 1.0)
      opserr << "UserDefinedBeamIntegration::UserDefinedBeamIntegration -- point lies outside [0,1]" << endln;
    //if (wt(i) < 0.0 || wt(i) > 1.0)
    //opserr << "UserDefinedBeamIntegration::UserDefinedBeamIntegration -- weight lies outside [0,1]" << endln;
    pts(i) = pt(i);
    wts(i) = wt(i);
  }
}

UserDefinedBeamIntegration::UserDefinedBeamIntegration():
  BeamIntegration(BEAM_INTEGRATION_TAG_UserDefined)
{
 
}

UserDefinedBeamIntegration::~UserDefinedBeamIntegration()
{
  // Nothing to do
}

void
UserDefinedBeamIntegration::getSectionLocations(int numSections,
						double L, double *xi)
{
  int nIP = pts.Size();

  int i;
  for (i = 0; i < nIP; i++)
    xi[i] = pts(i);
  for ( ; i < numSections; i++)
    xi[i] = 0.0;
}

void
UserDefinedBeamIntegration::getSectionWeights(int numSections,
					      double L, double *wt)
{
  int nIP = wts.Size();

  int i;
  for (i = 0; i < nIP; i++)
    wt[i] = wts(i);
  for ( ; i < numSections; i++)
    wt[i] = 1.0;
}

int
UserDefinedBeamIntegration::setParameter(const char **argv, int argc, Parameter &param)
{
  if (argc < 2)
    return -1;

  int point = atoi(argv[1]);
  if (point < 1)
    return -1;

  int Np = wts.Size();

  if (strcmp(argv[0],"pt") == 0 && point <= Np)
    return param.addObject(point, this);

  else if (strcmp(argv[0],"wt") == 0 && point <= Np)
    return param.addObject(10+point, this);

  else
    return -1;
}

int
UserDefinedBeamIntegration::updateParameter(int parameterID, Information &info)
{
  if (parameterID <= 10) { // pt
    pts(parameterID-1) = info.theDouble;
    return 0;
  }
  else if (parameterID <= 20) { // wt
    wts(parameterID-10-1) = info.theDouble;
    return 0;
  }
  else
    return -1;
}

BeamIntegration*
UserDefinedBeamIntegration::getCopy(void)
{
  int nIP = pts.Size();

  return new UserDefinedBeamIntegration(nIP, pts, wts);
}

int
UserDefinedBeamIntegration::sendSelf(int cTag, Channel &theChannel)
{
  return -1;
}

int
UserDefinedBeamIntegration::recvSelf(int cTag, Channel &theChannel,
				     FEM_ObjectBroker &theBroker)
{
  return -1;
}

void
UserDefinedBeamIntegration::Print(OPS_Stream &s, int flag)
{
  s << "UserDefined" << endln;
  s << " Points: " << pts;
  s << " Weights: " << wts;
}

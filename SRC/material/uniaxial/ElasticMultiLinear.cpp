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

// $Revision$
// $Date$
// $URL$

// Written: Andreas Schellenberg (andreas.schellenberg@gmail.com)
// Created: 12/11
// Revision: A
//
// Description: This file contains the implementation of the
// ElasticMultiLinear class.

#include <ElasticMultiLinear.h>

#include <Vector.h>
#include <Channel.h>
#include <elementAPI.h>

#include <math.h>
#include <float.h>
#include <string.h>


void *OPS_NewElasticMultiLinear()
{
    // Pointer to a uniaxial material that will be returned
    UniaxialMaterial *theMaterial = 0;

    int argc = OPS_GetNumRemainingInputArgs();
    if (argc < 7) {
        opserr << "WARNING incorrect num args want: uniaxialMaterial ";
        opserr << "ElasticMultiLinear tag -strain strainPoints ";
        opserr << "-stress stressPoints  ";
        opserr << "(with at least two stress-strain points)\n";
        return 0;
    }

    int tag[1];
    double strainData[64];
    double stressData[64];
    char paraStr[8];

    int numData = 1;
    if (OPS_GetIntInput(&numData,tag) != 0)  {
        opserr << "WARNING invalid uniaxialMaterial ElasticMultiLinear tag\n";
        return 0;
    }

    // get strain data points
    numData = (argc - 3)/2;
    OPS_GetString(paraStr,7);
    if (strcmp(paraStr,"-strain") == 0)  {
        if (OPS_GetDoubleInput(&numData,strainData) != 0)  {
            opserr << "WARNING invalid strainPoints\n";
            opserr << "uniaxialMaterial ElasticMultiLinear: " << tag[0] << endln;
            return 0;
        }
    } else  {
        opserr << "WARNING expecting -strain but got " << paraStr << endln;
        opserr << "uniaxialMaterial ElasticMultiLinear: " << tag[0] << endln;
        return 0;
    }
    Vector strainPts(strainData,numData);

    // get stress data points
    OPS_GetString(paraStr,7);
    if (strcmp(paraStr,"-stress") == 0)  {
        if (OPS_GetDoubleInput(&numData, stressData) != 0)  {
            opserr << "WARNING invalid stressPoints\n";
            opserr << "uniaxialMaterial ElasticMultiLinear: " << tag[0] << endln;
            return 0;
        }
    } else  {
        opserr << "WARNING expecting -stress but got " << paraStr << endln;
        opserr << "uniaxialMaterial ElasticMultiLinear: " << tag[0] << endln;
        return 0;
    }
    Vector stressPts(stressData,numData);

    // Parsing was successful, allocate the material
    theMaterial = new ElasticMultiLinear(tag[0], strainPts, stressPts);

    if (theMaterial == 0) {
        opserr << "WARNING could not create uniaxialMaterial of type ";
        opserr << "ElasticMultiLinear\n";
        return 0;
    }

    return theMaterial;
}


ElasticMultiLinear::ElasticMultiLinear(int tag,
    const Vector &strainPts, const Vector &stressPts)
    : UniaxialMaterial(tag, MAT_TAG_ElasticMultiLinear),
    strainPoints(strainPts), stressPoints(stressPts),
    trialID(0), trialIDmin(0), trialIDmax(0), initTangent(0.0),
    trialStrain(0.0), trialStress(0.0), trialTangent(0.0)
{
    numDataPoints = strainPoints.Size();
    if (numDataPoints != stressPoints.Size())  {
        opserr << "ElasticMultiLinear::ElasticMultiLinear() "
            << "- strain and stress arrays do not have same length.\n";
        exit(-1);        
    }
    trialIDmax = numDataPoints - 2;

    this->revertToStart();

    initTangent = trialTangent;
}


ElasticMultiLinear::ElasticMultiLinear()
    : UniaxialMaterial(0 ,MAT_TAG_ElasticMultiLinear),
    strainPoints(1), stressPoints(1),
    trialID(0), trialIDmin(0), trialIDmax(0), initTangent(0.0),
    trialStrain(0.0), trialStress(0.0), trialTangent(0.0)
{
    // does nothing
}


ElasticMultiLinear::~ElasticMultiLinear()
{
    // destructor does nothing
}


int ElasticMultiLinear::setTrialStrain(double strain, double strainRate)
{
    trialStrain = strain;

    // find the current interval
    double eps1 = strainPoints(trialID);
    double eps2 = strainPoints(trialID+1);
    if (trialStrain >= eps2 && trialID < trialIDmax)  {
        while (trialStrain >= eps2 && trialID < trialIDmax)  {
            trialID++;
            eps1 = eps2;
            eps2 = strainPoints(trialID+1);
        }
    } else if (trialStrain < eps1 && trialID > trialIDmin)  {
        while (trialStrain <= eps1 && trialID > trialIDmin)  {
            trialID--;
            eps2 = eps1;
            eps1 = strainPoints(trialID);
        }
    }
    double sig1 = stressPoints(trialID);
    double sig2 = stressPoints(trialID+1);

    // get the tangent for the selected interval
    trialTangent = (sig2-sig1)/(eps2-eps1);

    // get the stress for the selected interval
    trialStress = sig1 + trialTangent*(trialStrain-eps1);

    return 0;
}


double ElasticMultiLinear::getStrain()
{
    return trialStrain;
}


double ElasticMultiLinear::getStress()
{
    return trialStress;
}


double ElasticMultiLinear::getTangent()
{
    return trialTangent;
}


int ElasticMultiLinear::commitState()
{
    return 0;
}	


int ElasticMultiLinear::revertToLastCommit()
{
    return 0;
}


int ElasticMultiLinear::revertToStart()
{
    trialID = 0;
    trialStrain = 0;
    trialStress = 0;

    // find the current interval
    double eps1 = strainPoints(trialID);
    double eps2 = strainPoints(trialID+1);
    if (trialStrain >= eps2 && trialID < trialIDmax)  {
        while (trialStrain >= eps2 && trialID < trialIDmax)  {
            trialID++;
            eps1 = eps2;
            eps2 = strainPoints(trialID+1);
        }
    } else if (trialStrain < eps1 && trialID > trialIDmin)  {
        while (trialStrain <= eps1 && trialID > trialIDmin)  {
            trialID--;
            eps2 = eps1;
            eps1 = strainPoints(trialID);
        }
    }
    double sig1 = stressPoints(trialID);
    double sig2 = stressPoints(trialID+1);

    // get the tangent for the selected interval
    trialTangent = (sig2-sig1)/(eps2-eps1);

    return 0;
}


UniaxialMaterial *ElasticMultiLinear::getCopy()
{
    ElasticMultiLinear *theCopy =
        new ElasticMultiLinear(this->getTag(), strainPoints, stressPoints);

    return theCopy;
}


int ElasticMultiLinear::sendSelf(int cTag, Channel &theChannel)
{
    int res = 0;
    static Vector data(5);
    data(0) = this->getTag();
    data(1) = trialIDmin;
    data(2) = trialIDmax;
    data(3) = numDataPoints;
    data(4) = initTangent;

    res = theChannel.sendVector(this->getDbTag(), cTag, data);
    res += theChannel.sendVector(this->getDbTag(), cTag, strainPoints);
    res += theChannel.sendVector(this->getDbTag(), cTag, stressPoints);
    if (res < 0) 
        opserr << "ElasticMultiLinear::sendSelf() - failed to send data.\n";

    return res;
}


int ElasticMultiLinear::recvSelf(int cTag, Channel &theChannel, 
    FEM_ObjectBroker &theBroker)
{
    int res = 0;
    static Vector data(5);
    res = theChannel.recvVector(this->getDbTag(), cTag, data);
    if (res < 0) 
        opserr << "ElasticMultiLinear::recvSelf() - failed to recv data.\n";
    else {
        this->setTag((int)data(0));
        trialIDmin    = (int)data(1);
        trialIDmax    = (int)data(2);
        numDataPoints = (int)data(3);
        initTangent   = data(4);

        // receive the strain and stress arrays
        strainPoints.resize(numDataPoints);
        stressPoints.resize(numDataPoints);
        res += theChannel.recvVector(this->getDbTag(), cTag, strainPoints);
        res += theChannel.recvVector(this->getDbTag(), cTag, stressPoints);
        if (res < 0) 
            opserr << "ElasticMultiLinear::recvSelf() - failed to recv arrays.\n";
    }

    return res;
}


void ElasticMultiLinear::Print(OPS_Stream &s, int flag)
{
    s << "ElasticMultiLinear tag: " << this->getTag() << endln;
    s << "Input Parameter: strainPoints: " << strainPoints << endln;
    s << "Input Parameter: stressPoints: " << stressPoints << endln;
    s << "Current State: strain: "<< trialStrain << " stress: ";
    s << trialStress << " tangent: " << trialTangent << endln;
}

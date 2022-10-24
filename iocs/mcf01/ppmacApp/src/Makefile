TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = ppmac
# ppmac.dbd will be created and installed
DBD += ppmac.dbd

# ppmac.dbd will be made up from these files:
ppmac_DBD += base.dbd

# Include dbd files from all support applications:
ppmac_DBD += asyn.dbd drvAsynPowerPMACPort.dbd motorSupport.dbd devSoftMotor.dbd pmacAsynMotorPort.dbd busySupport.dbd calcSupport.dbd stream.dbd
ppmac_DBD += asSupport.dbd system.dbd devIocStats.dbd

# Add all the support libraries needed by this IOC
ppmac_LIBS += asyn calc busy pmacAsynMotorPort softMotor motor powerPmacAsynPort  
ppmac_LIBS += autosave stream devIocStats

# ppmac_registerRecordDeviceDriver.cpp derives from ppmac.dbd
ppmac_SRCS += ppmac_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
ppmac_SRCS_DEFAULT += ppmacMain.cpp
ppmac_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#ppmac_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
ppmac_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE


#!../../bin/linux-x86_64/ppmac

< envPaths
< /epics/common/xf27id1-ioc1-netsetup.cmd

epicsEnvSet("ENGINEER"l,  " @")
epicsEnvSet("LOCATION",  "27IDHUTCH__-hutchRG:F2")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(EPICS_BASE)/protocol:/epics/support/protocol:${TOP}/protocol:.CS_BASE)/protocol:/epics/support/protocol:${TOP}/protocol:.")

epicsEnvSet("SYS",           "XF:27IDF-CT")
epicsEnvSet("IOC_ASYN",      "$(SYS){MC:01}")
epicsEnvSet("IOC_PREFIX",    "$(SYS){IOC:MC01}")
epicsEnvSet("CONTROLLER_IP", "xf27id1-mc4")

cd ${TOP}

## Register all support components
dbLoadDatabase("dbd/ppmac.dbd",0,0)
ppmac_registerRecordDeviceDriver(pdbbase) 

# Create SSH Port (PortName, IPAddress, Username, Password, Priority, DisableAutoConnect, noProcessEos)
drvAsynPowerPMACPortConfigure("P0", "$(CONTROLLER_IP)", "root", "deltatau", "0", "0", "0")

# WARNING: a trace-mask of containing 0x10 will TRACE_FLOW (v. noisy!!)
#asynSetTraceMask("P0",-1,0x9)
#asynSetTraceIOMask("P0",-1,0x2)

# Configure Model 3 Controller Driver (ControlerPort, LowLevelDriverPort, Address, Axes, MovingPoll, IdlePoll)
pmacCreateController("M0", "P0", 0, 8, 100, 1000)

# Configure Model 3 Axes Driver (Controler Port, Axis Count)
pmacCreateAxes("M0", 8)

# Disable the limits disabled check for some axes (normally this should be left enabled)
# pmacDisableLimitsCheck(string portname, int axis, int allAxes)
#### disable limit check for all axes
#pmacDisableLimitsCheck("M0", 0, 1)
#### disable limit check for axis 3
#pmacDisableLimitsCheck("M0", 3, 0)

# Set up for running coordinate system
#pmacCreateCS(coordinate_system_port, controller_port_name, coordinate_system_number, motion_program_number)
pmacCreateCS("CS2","M0",2,10)
pmacCreateCS("CS3","M0",3,10)

# Create the coordinate system axes
#pmacCreateCSAxes(coordinate_system_port, num_coordinate_system_axes)
pmacCreateCSAxes("CS2", 9)
pmacCreateCSAxes("CS3", 9)

# change poll rates (card, poll-period in ms)
#pmacSetMovingPollPeriod(1, 100)
#pmacSetIdlePollPeriod(1, 1000)
#pmacSetCoordMovingPollPeriod(5,200)
#pmacSetCoordIdlePollPeriod(5,2000)

# Define coordinate step resolution
#pmacSetCoordStepsPerUnit(coordinate_system_port, cs_axis, counts_per_egu)
pmacSetCoordStepsPerUnit("CS2", 7, 10000)
pmacSetCoordStepsPerUnit("CS2", 8, 10000)
pmacSetCoordStepsPerUnit("CS3", 7, 10000)
pmacSetCoordStepsPerUnit("CS3", 8, 10000)

## Load record instances
dbLoadTemplate("db/motor.substitutions")
dbLoadTemplate("db/motorstatus.substitutions")
dbLoadTemplate("db/pmacStatus.substitutions")
dbLoadTemplate("db/pmac_asyn_motor.substitutions")
dbLoadTemplate("db/pmacaux.substitutions", PORT=P0)
dbLoadTemplate("db/pmac_physical_limit.substitutions", PORT=P0)
dbLoadTemplate("db/autohome.substitutions")
dbLoadTemplate("db/cs.substitutions")
dbLoadRecords("db/asynComm.db","P=$(IOC_ASYN),PORT=P0,ADDR=0")
dbLoadRecords("db/kill_all.db","Sys=${SYS},Dev={${MC01}},Port=P0")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

system("install -m 777 -d ${TOP}/as/save")
system("install -m 777 -d ${TOP}/as/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

dbLoadRecords("$(EPICS_BASE)/db/save_restoreStatus.db","P=$(IOC_PREFIX)")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db","IOC=$(IOC_PREFIX)")
save_restoreSet_status_prefix("$(IOC_PREFIX)")
# asSetFilename("/cf-update/acf/default.acf")

iocInit()

# caPutLogInit("xf04id-ca1.nsls2.bnl.local:7004", 1)

## more autosave/restore machinery
cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

cd ${TOP}
dbl > ./records.dbl


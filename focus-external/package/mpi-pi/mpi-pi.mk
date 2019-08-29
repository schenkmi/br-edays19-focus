################################################################################
#
# MPI PI :-)
#
################################################################################

MPI_PI_VERSION = 1.0
MPI_PI_SITE = $(BR2_EXTERNAL)/package/mpi-pi/src
MPI_PI_SITE_METHOD = local

define MPI_PI_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/mpi-pi $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))


GPFSDIR=$(shell dirname $(shell which mmlscluster))
CURDIR=$(shell pwd)
INSTALL_DIR=/usr/local/bin/

install: checK_quota     

checK_quota:   .FORCE
	cp -pf $(CURDIR)/ncsa-checkquota.sh $(INSTALL_DIR)/ncsa-checkquota.sh

clean:
	rm -f $(INSTALL_DIR)/ncsa-checkquota.sh

.FORCE:



COL_RED="\033[0;31m"
COL_GRN="\033[0;32m"
COL_END="\033[0m"

UID=$(shell id -u)
GID=$(shell id -g)
VM_DISK_SIZE_MB?=1024
ARCH?=amd

REPO=docker-to-linux

.PHONY:
debian: debian.img

.PHONY:
ubuntu: ubuntu.img

.PHONY:
alpine: alpine.img

.PHONY:
manjaro: manjaro.img

%.tar:
	@echo ${COL_GRN}"[Dump $* directory structure to tar archive]"${COL_END}
	cp $*/${ARCH}.Dockerfile $*/Dockerfile
	docker build --platform linux/${ARCH}64 -f $*/Dockerfile -t ${REPO}/$* .
	docker export -o $*.tar `docker run --privileged -d ${REPO}/$* /bin/true`

%.dir: %.tar
	@echo ${COL_GRN}"[Extract $* tar archive]"${COL_END}
	docker run -it --privileged \
		-v `pwd`:/os:rw \
		${REPO}/builder bash -c 'mkdir -p /os/$*.dir && tar --exclude="etc/ca-certificates/extracted/cadir" -C /os/$*.dir --numeric-owner -xf /os/$*.tar'

%.img: builder %.dir
	@echo ${COL_GRN}"[Create $* disk image]"${COL_END}
	docker run -it --privileged \
		-v `pwd`:/os:rw \
		-e DISTR=$* \
		--privileged \
		--cap-add SYS_ADMIN \
		${REPO}/builder bash /os/create_image.sh ${UID} ${GID} ${VM_DISK_SIZE_MB} ${ARCH}

.PHONY:
builder:
	@echo ${COL_GRN}"[Ensure builder is ready]"${COL_END}
	@if [ "`docker images -q ${REPO}/builder`" = '' ]; then\
		cp ${ARCH}.Dockerfile Dockerfile; \
		docker build -f Dockerfile -t ${REPO}/builder .;\
	fi

.PHONY:
builder-interactive:
	docker run --privileged -it \
		-v `pwd`:/os:rw \
		--cap-add SYS_ADMIN \
		${REPO}/builder bash

.PHONY:
clean: clean-docker-procs clean-docker-images
	@echo ${COL_GRN}"[Remove leftovers]"${COL_END}
	rm -rf Dockerfile debian/Dockerfile manjaro/Dockerfile manjaro_builder/Dockerfile
	rm -rf mnt debian.* alpine.* ubuntu.* manjaro.*

.PHONY:
clean-docker-procs:
	@echo ${COL_GRN}"[Remove Docker Processes]"${COL_END}
	@if [ "`docker ps -qa -f=label=com.iximiuz-project=${REPO}`" != '' ]; then\
		docker rm `docker ps -qa -f=label=com.iximiuz-project=${REPO}`;\
	else\
		echo "<noop>";\
	fi

.PHONY:
clean-docker-images:
	@echo ${COL_GRN}"[Remove Docker Images]"${COL_END}
	@if [ "`docker images -q ${REPO}/*`" != '' ]; then\
		docker rmi `docker images -q ${REPO}/*`;\
	else\
		echo "<noop>";\
	fi


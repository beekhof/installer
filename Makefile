clean-%:
	sudo virsh destroy $* || true
	sudo virsh undefine $* || true

./bin/openshift-install:
	TAGS=libvirt hack/build.sh

%/install-config.yaml: install-config-%.yaml ./bin/openshift-install
	rm -rf $*
	mkdir $*
	cp ./install-config-$*.yaml $*/install-config.yaml

generate-%: %/install-config.yaml
	ls -al $*
	./bin/openshift-install create aio-config --dir=$*


start-%: clean-% generate-%
	@echo Starting $*
	sudo ./hack/virt-install-aio-ign.sh ./$*/aio.ign $*

start: start-cluster1 start-cluster2

clean: clean-cluster1 clean-cluster2

network:
	sudo ./hack/virt-create-net.sh

ssh-%:
	chmod 400 ./hack/ssh/key
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ./hack/ssh/key core@api.$*.redhat.com

nodes-%:
	kubectl --kubeconfig=./$*/auth/kubeconfig get nodes 

image:
	curl -O -L https://releases-art-rhcos.svc.ci.openshift.org/art/storage/releases/rhcos-4.6/46.82.202007051540-0/x86_64/rhcos-46.82.202007051540-0-qemu.x86_64.qcow2.gz
	mv rhcos-46.82.202007051540-0-qemu.x86_64.qcow2.gz /tmp
	sudo gunzip /tmp/rhcos-46.82.202007051540-0-qemu.x86_64.qcow2.gz

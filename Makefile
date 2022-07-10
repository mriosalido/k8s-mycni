
.PHONY: build deploy clean

GOBUILD=CGO_ENABLED=0 go build -mod=vendor
build:
	$(GOBUILD) -o bin/mycnid cmd/mycnid/main.go
	$(GOBUILD) -o bin/mycni cmd/mycni/main.go

VERSION=v1.0
docker-build: build
	podman build -t mriosalido/k8s-cni-mycni:$(VERSION) .

deploy:
	kubectl apply -f deploy/mycni.yaml

clean:
	rm -rf bin
	go mod tidy
	go mod vendor

kind-cluster:
	kind create cluster --config deploy/kind.yaml

kind-image-load: docker-build
	kind load docker-image mycni:$(VERSION) 

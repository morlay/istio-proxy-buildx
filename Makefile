build:
	docker buildx build --platform=linux/amd64,linux/arm64 --push -t morlay/istio-proxy-buildx:latest .

test:
	docker run -it -v=/home/morlay/proxy:/proxy -w=/proxy morlay/istio-proxy-buildx:latest bash

debug:
	docker run -it -v=/home/morlay/proxy:/proxy -w=/proxy envoyproxy/envoy-build-ubuntu@sha256:d19ddcb8f06de3895242fd182c4d3fb3c41c6a14037e0de4cf2605e0edad829f bash
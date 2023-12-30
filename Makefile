IMAGES := ubuntu22 ubuntu22-gcc
BUILD_TARGETS := $(addprefix build-,$(IMAGES))
BUILDX_TARGETS := $(addprefix buildx-,$(IMAGES))
META_BUILD_TARGETS := $(addprefix .meta-build-,$(IMAGES))
META_BUILDX_TARGETS := $(addprefix .meta-buildx-,$(IMAGES))
TEST_TARGETS := $(addprefix test-,$(IMAGES))
PUBLISH_TARGETS := $(addprefix publish-,$(IMAGES))
PUBLISHX_TARGETS := $(addprefix publishx-,$(IMAGES))

PHIX_VERSION := $(shell cat PHIX_VERSION)
DOCKER_TAG_PREFIX := rzuckerm/phix:$(PHIX_VERSION)-
DOCKER_TAG_SUFFIX ?= -dev

INSTALL_SCRIPT := install_phix.sh

META_CREATE_BUILDER_TARGET := .meta-create-builder
BUILDER := mybuilder
PLATFORMS := linux/amd64 linux/arm64
COMMA := ,
SPACE := $(NOTHING) $(NOTHING)

BUILDX = docker buildx build \
	--builder=$(BUILDER) \
	--platform $(subst $(SPACE),$(COMMA),$(PLATFORMS)) \
	-t $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) \
	--build-arg PHIX_VERSION=$(PHIX_VERSION) \
	-f Dockerfile.$* .

.PHONY: help
help:
	@echo "build          - Build all docker images"
	@echo "build-<image>  - Build a specific docker image"
	@echo "buildx         - Build all multi-arch docker images"
	@echo "buildx-<image> - Build a specific multi-arch docker images"
	@echo "clean          - Clean build output"
	@echo "test           - Test all docker images"
	@echo "test-<image>   - Test a specific docker image"
	@echo "publish        - Publish docker images"
	@echo "publishx       - Publish mult-arch docker images"
	@echo ""

.PHONY: build
build: $(BUILD_TARGETS)
$(BUILD_TARGETS): build-%: Dockerfile.% .meta-build-% $(INSTALL_SCRIPT)
$(META_BUILD_TARGETS): .meta-build-%:
	@echo "*** Building $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) ***"
	docker rmi -f $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX)
	docker build -t $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) --build-arg PHIX_VERSION=$(PHIX_VERSION) -f Dockerfile.$* .
	touch .meta-build-$*
	rm -f .meta-buildx-$*
	@echo ""

.PHONY: buildx
buildx: $(BUILDX_TARGETS)
$(BUILDX_TARGETS): buildx-%: Dockerfile.% .meta-buildx-% $(META_CREATE_BUILDER_TARGET) $(INSTALL_SCRIPT)
$(META_BUILDX_TARGETS): .meta-buildx-%:
	@echo "*** Building multi-arch $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) ***"
	docker rmi -f $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX)
	$(BUILDX)
	touch .meta-buildx-$*
	rm -f .meta-build-$*
	@echo ""

.PHONY: create-builder
create-builder: $(META_CREATE_BUILDER_TARGET)
$(META_CREATE_BUILDER_TARGET):
	@echo "*** Creating builder if does not exist ***"
	@if ! (docker buildx ls | grep -sq $(BUILDER)); then docker buildx create --name $(BUILDER); fi
	touch $@
	@echo ""


.PHONY: clean
clean:
	rm -f .meta*

.PHONY: test
test: $(TEST_TARGETS)
$(TEST_TARGETS): test-%: .meta-build-%
	@echo "*** Testing $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) ***"
	./test.sh $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX)
	@echo ""


.PHONY: publish
publish: $(PUBLISH_TARGETS)
$(PUBLISH_TARGETS): publish-%: .meta-build-%
	@echo "*** Publishing $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) ***"
	docker push $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX)
	@echo ""

.PHONY: publishx
publishx: $(PUBLISHX_TARGETS)
$(PUBLISHX_TARGETS): publishx-%: $(META_CREATE_BUILDER_TARGET)
	@echo "*** Publishing multi-arch $(DOCKER_TAG_PREFIX)$*$(DOCKER_TAG_SUFFIX) ***"
	$(BUILDX) --push
	@echo ""

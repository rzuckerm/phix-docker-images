IMAGES := ubuntu22 ubuntu22-gcc
BUILD_TARGETS := $(addprefix build-,$(IMAGES))
META_BUILD_TARGETS := $(addprefix .meta-build-,$(IMAGES))
TEST_TARGETS := $(addprefix test-,$(IMAGES))

PHIX_VERSION ?= 1.0.2
DOCKER_TAG_PREFIX := rzuckerm/phix:$(PHIX_VERSION)

INSTALL_SCRIPT := install_phix.sh

.PHONY: help
help:
	@echo "build         - Build all docker images"
	@echo "build-<image> - Build a specific docker image"
	@echo "clean         - Clean build output"
	@echo "test          - Test all docker images"
	@echo "test-<image>  - Test a specific docker image"
	@echo ""

.PHONY: build
build: $(BUILD_TARGETS)
$(BUILD_TARGETS): build-%: Dockerfile.% .meta-build-% $(INSTALL_SCRIPT)
$(META_BUILD_TARGETS): .meta-build-%:
	@echo "*** Building $(DOCKER_TAG_PREFIX)-$*-dev ***"
	docker rmi -f $(DOCKER_TAG_PREFIX)-$*-dev
	docker build -t $(DOCKER_TAG_PREFIX)-$*-dev --build-arg PHIX_VERSION=$(PHIX_VERSION) -f Dockerfile.$* .
	touch .meta-build-$*
	@echo ""

.PHONY: clean
clean:
	rm -f $(META_BUILD_TARGETS)

.PHONY: test
test: $(TEST_TARGETS)
$(TEST_TARGETS): test-%: .meta-build-%
	@echo "*** Testing $(DOCKER_TAG_PREFIX)-$*-dev ***"
	./test.sh $(DOCKER_TAG_PREFIX)-$*-dev
	@echo ""

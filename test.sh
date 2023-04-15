#!/bin/sh
DOCKER_IMAGE=$1
DOCKER_RUN="docker run --rm -i -v $(pwd):/local -w /local ${DOCKER_IMAGE}"
if echo "${DOCKER_IMAGE}" | grep -qF gcc
then
    CMD="p -norun -c hello_world.e && ./hello_world"
else
    CMD="p hello_world.e"
fi

RESULT="$(${DOCKER_RUN} sh -c "${CMD}")"
echo "${RESULT}"
if [ "${RESULT}" = "Hello, world!" ]
then
    echo "PASSED"
else
    echo "FAILED"
    exit 1
fi

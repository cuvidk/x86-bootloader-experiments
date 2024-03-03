ARG UBUNTU_VERSION="22.04"

ARG COMPILER_TARGET="x86_64-elf"

ARG BINUTILS_VERSION="2.41"
ARG BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz"
ARG BINUTILS_SRC="/binutils-${BINUTILS_VERSION}"
ARG BINUTILS_BUILD="/binutils-${BINUTILS_VERSION}-${COMPILER_TARGET}"
ARG BINUTILS_TAR="binutils-${BINUTILS_VERSION}.tar.gz"

FROM ubuntu:${UBUNTU_VERSION} as mandatory-deps
RUN apt update && apt -y install build-essential

FROM mandatory-deps as cross-compiler-deps
RUN apt -y install bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libisl-dev wget

FROM cross-compiler-deps as binutils-fetch
ARG BINUTILS_URL
ARG BINUTILS_TAR
WORKDIR /
RUN wget "${BINUTILS_URL}" && \
	tar -xzf "${BINUTILS_TAR}"

FROM binutils-fetch as binutils-build
ARG BINUTILS_BUILD
ARG BINUTILS_SRC
ARG COMPILER_TARGET
ENV CROSS_COMPILER_DIR="/xcompiler-${COMPILER_TARGET}"
WORKDIR ${BINUTILS_BUILD}
RUN "${BINUTILS_SRC}/configure" --target=$COMPILER_TARGET --prefix="${CROSS_COMPILER_DIR}" --with-sysroot --disable-nls --disable-werror && \
	make && \
	make install

FROM mandatory-deps as compile-triangle
ARG COMPILER_TARGET
ENV CROSS_COMPILER_DIR="/xcompiler-${COMPILER_TARGET}"
ENV SRC_DIR="/bios-examples-src"
ENV OUT_DIR="/bios-examples-bin"
COPY --from=binutils-build ${CROSS_COMPILER_DIR} ${CROSS_COMPILER_DIR}
WORKDIR ${SRC_DIR}
CMD ["make clean && make"]
	

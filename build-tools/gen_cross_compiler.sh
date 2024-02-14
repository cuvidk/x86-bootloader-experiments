#!/bin/bash

# change the versions bellow to build other gcc compiler / binutils versions
# check https://wiki.osdev.org/Cross-Compiler_Successful_Builds for a list
# of compatible gcc - binutils pairs
BINUTILS_VERSION='2.41'
GCC_VERSION='13.2.0'

export TARGET=x86_64-elf

DEPENDENCIES='build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libisl-dev'
CURRENT_DIR="$(pwd)"
CROSS_COMPILER_DIR="${CURRENT_DIR}/${TARGET}-cross"
CROSS_COMPILER_INSTALLATION_DIR="${CROSS_COMPILER_DIR}/install"

BINUTILS_TAR="${CROSS_COMPILER_DIR}/binutils-${BINUTILS_VERSION}.tar.gz"
BINUTILS_SRC="${CROSS_COMPILER_DIR}/binutils-${BINUTILS_VERSION}"
BINUTILS_BUILD="${CROSS_COMPILER_DIR}/build-binutils-${BINUTILS_VERSION}"
BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz"

GCC_TAR="${CROSS_COMPILER_DIR}/gcc-${GCC_VERSION}.tar.gz"
GCC_SRC="${CROSS_COMPILER_DIR}/gcc-${GCC_VERSION}"
GCC_BUILD="${CROSS_COMPILER_DIR}/build-gcc-${GCC_VERSION}"
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"

export PREFIX="${CROSS_COMPILER_INSTALLATION_DIR}"
export PATH="${PREFIX}/bin:$PATH"

function announce() {
    local sep='---------------------------'
    echo -e "${sep}\n$1\n${sep}"
}

echo "gcc ${GCC_VERSION} will be built and installed"
echo "binutils ${BINUTILS_VERSION} will be built and installed"
echo "libgcc will be built without the redzone feature"
echo "The following packages have to be installed to help with the compilation of the ${TARGET} compiler:"
for dependency in ${DEPENDENCIES}; do
    echo -e "\t* $dependency"
done
echo -n "Proceed ? (y / [n]):"
read consent
if [ 'y' != "${consent}" -a 'Y' != "${consent}" ]; then
    exit 1
fi

mkdir -p ${CROSS_COMPILER_DIR} && cd ${CROSS_COMPILER_DIR}

announce "Downloading binutils ${BINUTILS_VERSION}"
wget "${BINUTILS_URL}" || exit 1
tar -xzf "${BINUTILS_TAR}" || exit 1
rm -rf "${BINUTILS_TAR}"

announce "Downloading gcc ${GCC_VERSION}"
wget "${GCC_URL}" || exit 1
tar -xzf "${GCC_TAR}" || exit 1
rm -rf "${GCC_TAR}"

announce "Installing packages required for building the cross-compiler"
for dependency in ${DEPENDENCIES}; do
    announce "Installing ${dependency}"
    sudo apt -y install ${dependency} || exit 3
done


mkdir -p ${BINUTILS_BUILD} && cd ${BINUTILS_BUILD}
announce "Compiling binutils ${BINUTILS_VERSION}" && sleep 2
"${BINUTILS_SRC}/configure" --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
announce "Installing binutils ${BINUTILS_VERSION}" && sleep 2
make install

rm -rf ${BINUTILS_SRC}
rm -rf ${BINUTILS_BUILD}

which $TARGET-as >/dev/null
if [ $? -ne 0 ]; then
    echo "Missing $TARGET-as. Something went wrong during installation / compilation of binutils ${BINUTILS_VERSION}"
    exit 1
fi

# disabling red-zone feature in libgcc
cat<<EOF >"${GCC_SRC}/gcc/config/i386/t-x86_64-elf"
MULTILIB_OPTIONS += mno-red-zone
MULTILIB_DIRNAMES += no-red-zone
EOF

sed -r -i 's/x86_64-\*-elf\*\)/&\n\ttmake_file="\$\{tmake_file\} i386\/t-x86_64-elf"/' "${GCC_SRC}/gcc/config.gcc"

mkdir -p ${GCC_BUILD} && cd ${GCC_BUILD}
"${GCC_SRC}/configure" --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
announce "Compiling gcc ${GCC_VERSION}" && sleep 2
make all-gcc
make all-target-libgcc
announce "Installing gcc ${GCC_VERSION}" && sleep 2
make install-gcc
make install-target-libgcc

announce "Cleaning stuff"
rm -rf ${GCC_SRC}
rm -rf ${GCC_BUILD}

echo -e "Done. Cross compiler related files were written in ${CROSS_COMPILER_INSTALLATION_DIR}\nBye"

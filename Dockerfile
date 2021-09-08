FROM docker.io/archlinux:latest
# Add archlinux mirror
RUN sed -i '1iServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
# Add msys2 repository
RUN echo -e "\nSigLevel = Never" >> /etc/pacman.conf
RUN echo -e "\n[mingw64]\nInclude = /etc/pacman.d/mirrorlist.mingw" >> /etc/pacman.conf
RUN echo -e "\n[msys]\nInclude = /etc/pacman.d/mirrorlist.msys" >> /etc/pacman.conf
RUN echo -e "Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/msys/\$arch/" > /etc/pacman.d/mirrorlist.msys
RUN echo -e "Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/mingw/\$repo" > /etc/pacman.d/mirrorlist.mingw

# Add multilib repository for wine
RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman -Sy --noconfirm

# Install rust and mingw and mingw_ldd
RUN pacman -S --noconfirm rustup gcc pkgconf
RUN pacman -S --noconfirm mingw-w64-gcc mingw-w64-x86_64-gtk4
RUN pacman -S --noconfirm python-pip wine

ENV RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup
ENV RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static
RUN rustup install stable 
RUN rustup target add x86_64-pc-windows-gnu

RUN pip install -i https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple mingw_ldd

# Prepare Build
ENV PKG_CONFIG_SYSROOT_DIR=/mingw64
ENV PKG_CONFIG_PATH=/mingw64/lib/pkgconfig
ENV RELEASE=release
COPY script.sh .
RUN chmod u+x script.sh
RUN mkdir /app
WORKDIR /app
CMD /script.sh

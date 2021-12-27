FROM docker.io/archlinux:latest
# Add archlinux mirror
RUN sed -i '1iServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
# Add msys2 repository
RUN echo -e "\nSigLevel = Never" >> /etc/pacman.conf
RUN echo -e "\n[mingw64]\nInclude = /etc/pacman.d/mirrorlist.mingw" >> /etc/pacman.conf
RUN echo -e "\n[msys]\nInclude = /etc/pacman.d/mirrorlist.msys" >> /etc/pacman.conf
RUN echo -e "Server = https://repo.msys2.org/msys/\$arch/" > /etc/pacman.d/mirrorlist.msys
RUN echo -e "Server = https://repo.msys2.org/mingw/\$repo" > /etc/pacman.d/mirrorlist.mingw

# Add multilib repository for wine
RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman -Sy --noconfirm

# Install rust and mingw and mingw_ldd
RUN pacman -S --noconfirm go gcc pkgconf
RUN pacman -S --noconfirm mingw-w64-gcc mingw-w64-x86_64-gtk3
RUN pacman -S --noconfirm python-pip wine



RUN pip install -i https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple mingw_ldd

# Prepare Build
ENV PKG_CONFIG_SYSROOT_DIR=/mingw64
ENV PKG_CONFIG_PATH=/mingw64/lib/pkgconfig
ENV RELEASE=release
ENV PATH=/go/bin:$PATH \
    CGO_ENABLED=1 \
    GOOS=windows
COPY script.sh .
RUN chmod u+x script.sh
RUN mkdir /src
WORKDIR /src
CMD /script.sh

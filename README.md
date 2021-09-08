# 说明

这个项目提供一个能够把gtk-rs项目从Linux交叉编译到Windows的Docker容器的Dockerfile以及脚本。

生成文件应当在`项目目录/dist/`下。

不包含对gsettings文件及主题的处理。

请至少准备30G硬盘空间来打包这个容器。

# 运行示范

首先打包容器：

```bash
buildah bud -t cross-build
```

然后挂载项目目录（假设在./mygtk）并运行：

```bash
podman run -v $PWD/mygtk:/app cross-build
```

如果使用debug而非release

```bash
podman run -v $PWD/mygtk:/app -e RELEASE=debug cross-build
```

另外建议使用`-v cargo-cache:/root`的方法进行缓存。也可以更精细地对`/root/.cargo`、`/root/.rustup`、`/root/.cache`进行控制。
# 说明

这个项目提供一个能够把gtk-rs项目从Linux交叉编译到Windows的Docker容器的Dockerfile以及脚本。

生成文件应当在`项目目录/dist/`下。

目前只能保证编译出的exe文件可运行，尚未配上gdk-pixbuf和gsettings相关文件。

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
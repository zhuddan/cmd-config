# Cmd-Config

常用终端命令/别名的配置

> [!NOTE]  
> 请先安装[ni] (https://github.com/antfu-collective/ni)。

## 命令/别名

- `d`/`dev`
```bash
 d  # nr dev
 d a # nr dev:a
 d b # nr dev:b
 dev  # nr dev
 dev a # nr dev:a
 dev b # nr dev:b
```

- `w`/`watch`
```bash
 w  # nr watch
 w a # nr watch:a
 w b # nr watch:b
 watch  # nr watch
 watch a # nr watch:a
 watch b # nr watch:b
```

- `t`/`test`
```bash
 t  # nr test
 t a # nr test:a
 t b # nr test:b
 test  # nr test
 test a # nr test:a
 test b # nr test:b
```

- `b`/`build`
```bash
 b  # nr build
 b a # nr build:a
 b b # nr build:b
 build  # nr build
 build a # nr build:a
 build b # nr build:b
```

- `s`/`server`
 
> [!NOTE]  
> `s/server`命令会检查`package.json`的`server` 和 `start`脚本。 并且`server`的优先级更高。由于`start`是内置的命令，故别名为`server`。你可以手动修改`Microsoft.Powerbash_profile.ps1`调整优先级。

如果你的 `package.json` 只有 `start` 脚本
```bash
 s  # nr start
 s a # nr start:a
 s b # nr start:b
 server  # nr start
 server a # nr start:a
 server b # nr start:b
```

如果你的 `package.json` 有 `server` 脚本，此时 `start` 命令会被忽略。
```bash
 s  # nr server
 s a # nr server:a
 s b # nr server:b
 server  # nr server
 server a # nr server:a
 server b # nr server:b
```
- `hs` (基于[http-server](https://www.npmjs.com/package/http-server)的web服务容器，如需使用请先安装，可选参数`path`为服务路径)
```bash
 hs # http-server $output -c-0 --cors
 hs dist # http-server dist $output -c-0 --cors # 此时 http-server 入口为 dist
```

- `vs` (使用`vscode`打开当前目录, 若存在`package.json`, 自动使用`ni`下载依赖)
``` bash
 vs # vscode 打开当前目录并且自动下载依赖
```

- `g` (`git clone`的简化操作, 参数`repoUrl`为仓库地址, 可选参数`dir`为克隆地址 )
``` bash
g https://github.com/microsoft/TypeScript # git clone https://github.com/microsoft/TypeScript
g https://github.com/microsoft/TypeScript ts # git clone https://github.com/microsoft/TypeScript ts
```
- `go` (`git remote -v`别名)
```bash
 go # git remote -v
```
- `cleanup`  *Windows Only* (删除所有`node_modules`依赖和依赖锁定文件`package-lock.json`, `yarn.lockb`, `bun.lockb`, `.pnpm-lock.yaml`) 
```bash
 cleanup #  清理缓存
```

- `o` (打开目录)
```bash
 o # start . / open .
 o a # start a / start a
```

- `cls` -clear
```bash
 cls # clear
```

- `pub` 
```bash
pub # npm publish --access public
```

- `pubres` 
```bash
pubres # npm publish --access restricted
```

- `rec`  重载配置
```bash
rec
# Mac: source ~/.zshrc 
# Windows: . $PROFILE
```

## 使用

### mac 
1. 复制 `.zshrc` 到 `~/.zshrc` 如果没有此文件请先创建

2. 执行下面命令重载配置
```bash
source ~/.zshrc
```
### windows

1. 复制 `Microsoft.PowerShell_profile.ps1`的内容 到 `你的配置文件内` 即可
使用 `vscode` 打开你的配置
```shell
code $PROFILE
```
或者使用 `txt` 打开
```shell
notepad $PROFILE
```

2. 复制[Microsoft.PowerShell_profile.ps1](https://github.com/zhuddan/WindowsPowerShell/blob/master/Microsoft.PowerShell_profile.ps1)内容到你的配置文件中并且保存。

3. 保存之后需要重载你的配置
```shell
. $PROFILE
```

参考
- [ni](https://github.com/antfu-collective/ni)
- [http-server](https://github.com/http-party/http-server)

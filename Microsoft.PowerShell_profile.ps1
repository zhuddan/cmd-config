
# ============================================================
# 初始化：移除 ni 别名（ni 来自 antfu 的工具集）
# https://github.com/antfu-collective/ni
# ============================================================
if (-not (Test-Path $profile)) {
  New-Item -ItemType File -Path (Split-Path $profile) -Force -Name (Split-Path $profile -Leaf)
}

$profileEntry = 'Remove-Item Alias:ni -Force -ErrorAction Ignore'
$profileContent = Get-Content $profile
if ($profileContent -notcontains $profileEntry) {
  ("`n" + $profileEntry) | Out-File $profile -Append -Force -Encoding UTF8
}
Remove-Item Alias:ni -Force -ErrorAction Ignore


# ============================================================
# npm 脚本别名
# ============================================================

# npm run dev
function d {
    param(
        [string]$projectName  # projectName 是可选参数
    )

    # 如果没有提供 projectName 参数，执行 nr dev
    if (-not $projectName) {
        nr dev
    } else {
        # 如果提供了 projectName，执行 nr dev:$projectName
        nr "dev:$projectName"
    }
}
Set-Alias -Name dev -Value d

# npm run watch
function w {
    param(
        [string]$projectName  # projectName 是可选参数
    )

    # 如果没有提供 projectName 参数，执行 nr watch
    if (-not $projectName) {
        nr watch
    } else {
        # 如果提供了 projectName，执行 nr watch:$projectName
        nr "watch:$projectName"
    }
}
Set-Alias -Name watch -Value w

# npm run test
function t {
    param(
        [string]$projectName  # projectName 是可选参数
    )

    # 如果没有提供 projectName 参数，执行 nr test
    if (-not $projectName) {
        nr test
    } else {
        # 如果提供了 projectName，执行 nr test:$projectName
        nr "test:$projectName"
    }
}
Set-Alias -Name test -Value t

# npm run build
function b {
    param(
        [string]$projectName  # projectName 是可选参数
    )

    # 如果没有提供 projectName 参数，执行 nr build
    if (-not $projectName) {
        nr build
    } else {
        # 如果提供了 projectName，执行 nr build:$projectName
        nr "build:$projectName"
    }
}
Set-Alias -Name build -Value b

# nr serve / nr start，自动在 serve、start、serve:xxx、start:xxx 中查找可用脚本
function s {
    param (
        [string]$projectName  # projectName 参数用于确定要执行的命令
    )

    # 检查当前目录是否有 package.json 文件
    if (Test-Path "package.json") {
        # 读取 package.json 文件
        $packageJson = Get-Content -Raw -Path "package.json" | ConvertFrom-Json

        # 检查 scripts 字段是否存在
        if ($packageJson.scripts) {
            # 默认命令，如果没有提供 projectName，默认执行 serve 或 start
            $defaultCommand = if (-not $projectName) { "serve" } else { "serve:$projectName" }

            # 先查找 serve 命令
            $foundCommand = $packageJson.scripts.PSObject.Properties.Name |
                            Where-Object { $_ -eq $defaultCommand } |
                            Select-Object -First 1

            # 如果没有找到 serve 命令，尝试查找 start 命令
            if (-not $foundCommand) {
                $foundCommand = $packageJson.scripts.PSObject.Properties.Name |
                                Where-Object { $_ -eq "start" } |
                                Select-Object -First 1
            }

            # 如果没有找到任何命令，检查是否有 serve:xxx 或 start:xxx 命令
            if (-not $foundCommand) {
                $foundCommand = $packageJson.scripts.PSObject.Properties.Name |
                                Where-Object { $_ -eq "serve:$projectName" } |
                                Select-Object -First 1
            }

            if (-not $foundCommand) {
                $foundCommand = $packageJson.scripts.PSObject.Properties.Name |
                                Where-Object { $_ -eq "start:$projectName" } |
                                Select-Object -First 1
            }

            # 如果找到命令，则执行
            if ($foundCommand) {
                Write-Host "找到命令 '$foundCommand'，正在执行 'nr $foundCommand'..."
                nr $foundCommand
            } else {
                Write-Host "未在 scripts 中找到匹配的命令（'serve'、'start' 或 'serve:$projectName'、'start:$projectName'）。"
            }
        } else {
            Write-Host "package.json 中没有 scripts 字段。"
        }
    } else {
        Write-Host "当前目录下没有找到 package.json。"
    }
}
Set-Alias -Name serve -Value s

# 特殊的 npm script：nr tag
function tag {
    param(
        [string]$projectName  # projectName 是可选参数
    )

    # 如果没有提供 projectName 参数，执行 nr tag
    if (-not $projectName) {
        nr tag
    } else {
        # 如果提供了 projectName，执行 nr tag:$projectName
        nr "tag:$projectName"
    }
}


# ============================================================
# npm 发布
# ============================================================

# 发布公共包
function pub {
   npm publish --access public
}

# 发布私有包
function pubres {
   npm publish --access restricted
}


# ============================================================
# 常用工具
# ============================================================

# http-server：启动静态服务器（禁用缓存并开启 CORS）
function hs {
    param(
        [string]$path
    )
    if (-not $path) {
        http-server -c-0 --cors
    } else {
        http-server $path -c-0 --cors
    }
}

# vscode 打开当前目录并自动安装依赖
function vs {
    # 使用 VS Code 打开当前目录
    Write-Host "正在打开 VS Code..."
    code .

    # 检查当前目录是否有 package.json 文件
    if (Test-Path "package.json") {
        # 如果有 package.json，执行 ni 安装依赖
        Write-Host "检测到 package.json，正在使用 ni 安装依赖..."
        ni
    } else {
        Write-Host "当前目录下没有找到 package.json。"
    }
}

# 打开当前目录（资源管理器）
function o {
    start .
}

# 强制删除目录（含子目录），删除前需输入 Y 确认
function rmrf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$path  # 要删除的目录
    )

    if (-not (Test-Path $path)) {
        Write-Host "Path not found: $path"
        return
    }

    $confirm = Read-Host "Force delete '$path' (including subfolders)? Type Y to continue"
    if ($confirm -ieq 'Y') {
        Remove-Item $path -Recurse -Force
        Write-Host "Deleted: $path"
    } else {
        Write-Host "Cancelled."
    }
}

# 清理依赖与锁文件缓存
function cleanup {
    del .\package-lock.json, .\yarn.lock, .\bun.lockb, .\pnpm-lock.yaml -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force .\node_modules -ErrorAction SilentlyContinue
}


# ============================================================
# Git 别名（Oh My Zsh 风格，全部定义在 aliases-git.ps1 中）
# ============================================================
. (Join-Path $PSScriptRoot "aliases-git.ps1")


# ============================================================
# 常用目录跳转
# ============================================================

# 返回上级目录（cd ..）
function .. {
    Set-Location ..
}

function pro {
    Set-Location D:\projects
}

function fork {
    Set-Location D:\projects\fork
}

function star {
    Set-Location D:\projects\star
}

function temp {
    Set-Location D:\projects\temp
}

function workspace {
    Set-Location D:\projects\workspace
}

function zhuddan {
    Set-Location D:\projects\zhuddan
}

function zd {
    Set-Location %USERPROFILE%
}


# ============================================================
# 其他
# ============================================================

# 重新加载配置文件（等价于 . $PROFILE）
function reload {
  . $PROFILE
}

# claude
function cc {
    claude
}

# 导入 Chocolatey 配置，启用 choco 的 Tab 补全
# 如果配置中缺少这几行，choco 的 Tab 补全将无法使用
# 详见 https://ch0.co/tab-completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

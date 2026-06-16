# Oh My Zsh git 插件别名 (PowerShell 版本)
# 来源: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# 注意: g (git clone 封装) 已存在故跳过; 含 ! 的别名已重命名 (gc! -> gcf 等)

# --- 辅助函数 ---

function git_current_branch {
    $b = git symbolic-ref --short HEAD 2>$null
    if (-not $b) { $b = git rev-parse --short HEAD 2>$null }
    return $b
}

function git_main_branch {
    if (git branch --list 'main') { return 'main' }
    return 'master'
}

function git_develop_branch {
    foreach ($b in @('develop', 'dev', 'devel', 'development')) {
        if (git branch --list $b) { return $b }
    }
    return 'develop'
}

# --- 通用 ---

# 切换到仓库根目录
function grt {
    $top = git rev-parse --show-toplevel 2>$null
    if ($top) { Set-Location $top } else { Write-Error "Not inside a git repository." }
}

function ghh { git help @args }

# --- 添加 ---

function ga    { git add @args }
function gaa   { git add --all @args }
function gapa  { git add --patch @args }
function gau   { git add --update @args }
function gav   { git add --verbose @args }

# 工作进度存档提交
function gwip {
    git add -A
    $deleted = git ls-files --deleted
    if ($deleted) { git rm $deleted }
    git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
}

# --- AM / Apply ---

function gam    { git am @args }
function gama   { git am --abort }
function gamc   { git am --continue }
function gamscp { git am --show-current-patch }
function gams   { git am --skip }
function gap    { git apply @args }
function gapt   { git apply --3way @args }

# --- Bisect ---

function gbs  { git bisect @args }
function gbsb { git bisect bad @args }
function gbsg { git bisect good @args }
function gbsn { git bisect new @args }
function gbso { git bisect old @args }
function gbsr { git bisect reset }
function gbss { git bisect start @args }

# --- Blame ---

function gbl { git blame -w @args }

# --- 分支 ---

function gb   { git branch @args }
function gba  { git branch --all @args }
function gbd  { git branch --delete @args }
function gbD  { git branch --delete --force @args }
function gbm  { git branch --move @args }
function gbnm { git branch --no-merged @args }
function gbr  { git branch --remote @args }

# 列出已在远端消失的本地追踪分支
function gbg {
    git branch -vv | Where-Object { $_ -match ': gone\]' }
}

# 删除已在远端消失的本地追踪分支
function gbgd {
    $gone = git branch -vv | Where-Object { $_ -match ': gone\]' }
    foreach ($line in $gone) {
        $name = ($line.Trim() -replace '^\*\s+', '') -split '\s+' | Select-Object -First 1
        git branch --delete $name
    }
}

# 强制删除已在远端消失的本地追踪分支
function gbgD {
    $gone = git branch -vv | Where-Object { $_ -match ': gone\]' }
    foreach ($line in $gone) {
        $name = ($line.Trim() -replace '^\*\s+', '') -split '\s+' | Select-Object -First 1
        git branch --delete --force $name
    }
}

# 设置当前分支的上游
function ggsup { git branch --set-upstream-to=origin/$(git_current_branch) }

# --- 检出 / 切换 ---

function gco  { git checkout @args }
function gcor { git checkout --recurse-submodules @args }
function gcb  { git checkout -b @args }
function gcB  { git checkout -B @args }
function gcm  { git checkout $(git_main_branch) }
function gcd  { git checkout $(git_develop_branch) }
function gsw  { git switch @args }
function gswc { git switch --create @args }
function gswm { git switch $(git_main_branch) }
function gswd { git switch $(git_develop_branch) }

# --- 拣选 ---

function gcp  { git cherry-pick @args }
function gcpa { git cherry-pick --abort }
function gcpc { git cherry-pick --continue }

# --- 清理 ---

function gclean   { git clean --interactive -d @args }
function gpristine { git reset --hard; git clean --force -dfx }
function gwipe    { git reset --hard; git clean --force -d }

# --- 克隆 ---

# 注意: g 已有 git clone 封装, gcl 是带 --recurse-submodules 的增强版
function gcl  { git clone --recurse-submodules @args }
function gclf { git clone --recursive --shallow-submodules --filter=blob:none @args }

# --- 提交 ---

function gc    { git commit --verbose @args }
function gca   { git commit --verbose --all @args }
function gcn   { git commit --verbose --no-edit @args }
function gcam  { git commit --all --message @args }
function gcas  { git commit --all --signoff @args }
function gcasm { git commit --all --signoff --message @args }
function gcs   { git commit --gpg-sign @args }
function gcss  { git commit --gpg-sign --signoff @args }
function gcssm { git commit --gpg-sign --signoff --message @args }
function gcmsg { git commit --message @args }
function gcsm  { git commit --signoff --message @args }
function gcfu  { git commit --fixup @args }

# gc!  的替代 (PowerShell 不允许 ! 在函数名中)
function gcf   { git commit --verbose --amend @args }
# gca! 的替代
function gcaf  { git commit --verbose --all --amend @args }
# gcan! 的替代
function gcanf { git commit --verbose --all --no-edit --amend @args }
# gcans! 的替代
function gcansf { git commit --verbose --all --signoff --no-edit --amend @args }
# gcann! 的替代
function gcannf { git commit --verbose --all --no-edit --amend --no-verify @args }
# gcn! 的替代
function gcnf  { git commit --verbose --no-edit --amend @args }

# --- 配置 ---

# gcf 已被 gc! 替代占用, 故改名 gcfl (git config list)
function gcfl { git config --list @args }

# --- 标签 ---

function gdct { git describe --tags $(git rev-list --tags --max-count=1) }
function gta  { git tag --annotate @args }
function gts  { git tag --sign @args }
function gtv  { git tag | Sort-Object }
function gtl  {
    param([string]$pattern = '')
    if ($pattern) { git tag --sort=-version:refname --list "${pattern}*" }
    else { git tag --sort=-version:refname }
}

# --- 差异 ---

function gd   { git diff @args }
function gdca { git diff --cached @args }
function gdcw { git diff --cached --word-diff @args }
function gds  { git diff --staged @args }
function gdw  { git diff --word-diff @args }
function gdup { git diff '@{upstream}' }
function gdt  { git diff-tree --no-commit-id --name-only -r @args }

# --- 拉取远端元数据 ---

function gf  { git fetch @args }
function gfa { git fetch --all --tags --prune --jobs=10 @args }
function gfo { git fetch origin @args }

# --- 日志 ---

function glo   { git log --oneline --decorate @args }
function glog  { git log --oneline --decorate --graph @args }
function gloga { git log --oneline --decorate --graph --all @args }
function glg   { git log --stat @args }
function glgp  { git log --stat --patch @args }
function glgg  { git log --graph @args }
function glgga { git log --graph --decorate --all @args }
function glgm  { git log --graph --max-count=10 @args }
function glods { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short @args }
function glod  { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' @args }
function glola { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all @args }
function glols { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat @args }
function glol  { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' @args }
function glp   {
    param([string]$format)
    if ($format) { git log "--pretty=$format" }
    else { git log --pretty }
}
function gwch  { git whatchanged -p --abbrev-commit --pretty=medium @args }

# --- 合并 ---

function gm      { git merge @args }
function gma     { git merge --abort }
function gmc     { git merge --continue }
function gms     { git merge --squash @args }
function gmff    { git merge --ff-only @args }
function gmom    { git merge origin/$(git_main_branch) @args }
function gmum    { git merge upstream/$(git_main_branch) @args }
function gmtl    { git mergetool --no-prompt @args }
function gmtlvim { git mergetool --no-prompt --tool=vimdiff @args }

# --- 拉取 ---

function gl     { git pull @args }
function gpr    { git pull --rebase @args }
function gprv   { git pull --rebase --verbose @args }
function gpra   { git pull --rebase --autostash @args }
function gprav  { git pull --rebase --autostash --verbose @args }
function gprom  { git pull --rebase origin $(git_main_branch) }
function gpromi { git pull --rebase=interactive origin $(git_main_branch) }
function gprum  { git pull --rebase upstream $(git_main_branch) }
function gprumi { git pull --rebase=interactive upstream $(git_main_branch) }
function ggpull { git pull origin $(git_current_branch) }
function gluc   { git pull upstream $(git_current_branch) }
function glum   { git pull upstream $(git_main_branch) }

# --- 推送 ---

function gp     { git push @args }
function gpd    { git push --dry-run @args }
function gpf    { git push --force-with-lease --force-if-includes @args }
# gpf! 的替代
function gpff   { git push --force @args }
function gpsup  { git push --set-upstream origin $(git_current_branch) }
function gpsupf { git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes }
function gpv    { git push --verbose @args }
function gpoat  { git push origin --all; git push origin --tags }
function gpod   { git push origin --delete @args }
function ggpush { git push origin $(git_current_branch) }
function gpu    { git push upstream @args }

# --- 变基 ---

function grb   { git rebase @args }
function grba  { git rebase --abort }
function grbc  { git rebase --continue }
function grbi  { git rebase --interactive @args }
function grbo  { git rebase --onto @args }
function grbs  { git rebase --skip }
function grbd  { git rebase $(git_develop_branch) }
function grbm  { git rebase $(git_main_branch) }
function grbom { git rebase origin/$(git_main_branch) }
function grbum { git rebase upstream/$(git_main_branch) }

# --- Reflog ---

function grf { git reflog @args }

# --- 远端 ---

function gr    { git remote @args }
function grv   { git remote --verbose @args }
function gra   { git remote add @args }
function grrm  { git remote remove @args }
function grmv  { git remote rename @args }
function grset { git remote set-url @args }
function grup  { git remote update @args }

# --- 重置 ---

function grh  { git reset @args }
function gru  { git reset -- @args }
function grhh { git reset --hard @args }
function grhk { git reset --keep @args }
function grhs { git reset --soft @args }
function groh { git reset origin/$(git_current_branch) --hard }

# 撤销最后一个 --wip-- 提交
function gunwip {
    $last = git log -1 --pretty='%s' 2>$null
    if ($last -match '--wip--') { git reset HEAD~1 }
}

# --- 恢复 ---

function grs  { git restore @args }
function grss { git restore --source @args }
function grst { git restore --staged @args }

# --- 撤销提交 ---

function grev  { git revert @args }
function greva { git revert --abort }
function grevc { git revert --continue }

# --- 删除追踪 ---

function grm  { git rm @args }
function grmc { git rm --cached @args }

# --- 提交统计 ---

function gcount { git shortlog --summary --numbered @args }

# --- 显示 ---

function gsh  { git show @args }
function gsps { git show --pretty=short --show-signature @args }

# --- 储藏 ---

function gsta   { git stash push @args }
function gstaa  { git stash apply @args }
function gstall { git stash --all @args }
function gstc   { git stash clear }
function gstd   { git stash drop @args }
function gstl   { git stash list @args }
function gstp   { git stash pop @args }
function gsts   { git stash show --patch @args }
function gstu   { git stash push --include-untracked @args }

# --- 状态 ---

function gst { git status @args }
function gss { git status --short @args }
function gsb { git status --short --branch @args }

# --- 子模块 ---

function gsi { git submodule init @args }
function gsu { git submodule update @args }

# --- 工作树 ---

function gwt   { git worktree @args }
function gwta  { git worktree add @args }
function gwtls { git worktree list @args }
function gwtmv { git worktree move @args }
function gwtrm { git worktree remove @args }

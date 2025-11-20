# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  # zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_AUTOSUGGEST_STRATEGY=(completion)

source $ZSH/oh-my-zsh.sh

# ------------------------- vscode code cmd 配置  -------------------------
# @see https://github.com/zhuddan/cmd-config.git
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# ------------------------- nvm 配置相关          -------------------------
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------- 我自己的配置           -------------------------

# npm 全局包 pnpm/yarn... 配置
export PATH="$PATH:$(npm config get prefix)/bin"

# npm run dev
function dev() {
  local projectName="$1"
  if [ -z "$projectName" ]; then
    nr dev
  else
    nr "dev:$projectName"
  fi
}
alias d='dev'

# npm run watch
function watch() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr watch
  else
    nr "watch:$projectName"
  fi
}
alias w='watch'

# npm run test
function test() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr test
  else
    nr "test:$projectName"
  fi
}
alias t='test'

# npm run build
function build() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr build
  else
    nr "build:$projectName"
  fi
}
alias b='build'


# npm run sever/start
function s() {
  local projectName="$1"

  if [[ ! -f package.json ]]; then
    echo "❌ No package.json found in the current directory."
    return 1
  fi

  # 安全提取 scripts 名称
  local scripts=($(jq -r '.scripts | keys[]' package.json 2>/dev/null))

  if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "⚠️ No scripts section found in package.json."
    return 1
  fi

  local candidates=()
  if [[ -n "$projectName" ]]; then
    candidates=("serve:$projectName" "start:$projectName")
  else
    candidates=("serve" "start")
  fi

  local found=""
  for cmd in "${candidates[@]}"; do
    for script in "${scripts[@]}"; do
      if [[ "$script" == "$cmd" ]]; then
        found="$cmd"
        break 2
      fi
    done
  done

  if [[ -n "$found" ]]; then
    echo "✅ Found script '$found'. Running: nr $found"
    nr "$found"
  else
    echo "❌ No matching command found. Tried: ${candidates[*]}"
    return 1
  fi
}

# npm run start
function start() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr start
  else
    nr "start:$projectName"
  fi
}

# npm run serve
function serve() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr serve
  else
    nr "serve:$projectName"
  fi
}

# npm run tag
function tag() {
  local projectName="$1"

  if [ -z "$projectName" ]; then
    nr tag
  else
    nr "tag:$projectName"
  fi
}

#  http-server
function hs() {
  local path="$1"
  if [[ -z "$path" ]]; then
    http-server -c-0 --cors
  else
    http-server "$path" -c-0 --cors
  fi
}

# vscode 打开当前目录并且自动下载依赖
# ps mac 端的vscode 需要在 vscode 中 command + shift + p 搜索
# shell command install 'code' command in path
# 并且执行
function vs() {
  echo "Opening VS Code..."
  code .

  if [[ -f package.json ]]; then
    echo "package.json found. Installing dependencies using ni..."
    ni
  else
    echo "No package.json found."
  fi
}

# 克隆
function g() {
  local repoUrl="$1"
  local dir="$2"

  if [[ -z "$repoUrl" ]]; then
    echo "Usage: g <repo-url> [dir]"
    return 1
  fi

  if [[ -z "$dir" ]]; then
    echo "Cloning repository '$repoUrl'..."
    git clone "$repoUrl"
  else
    echo "Cloning repository '$repoUrl' into directory '$dir'..."
    git clone "$repoUrl" "$dir"
  fi
}

# clear
function cls(){ 
  clear
}

# open
function o(){
  local path="$1"
  if [[ -z "$path" ]]; then
    /usr/bin/open .
  else
    /usr/bin/open "$path" 
  fi
}

# 常用目录
function projects() {
    cd ~/projects
}

function labs() {
    cd ~/projects/labs
}

function temporary() {
    cd ~/projects/temporary
}

function workspace() {
    cd ~/projects/workspace
}

function zd() {
    cd ~/projects/zd
}

function data() {
    cd ~/data
}



function rename_with_prefix() {
  if [[ -z "$1" ]]; then
    echo "用法：rename_with_prefix 前缀"
    return 1
  fi

  local prefix="$1"
  local i=0

  for file in *.*; do
    [[ -f "$file" ]] || continue

    local ext="${file##*.}"
    local new_name="${prefix}_${i}.${ext}"
    
    echo "？？？？准备重命名 $file 为 $new_name"

    # 避免重名覆盖
    if [[ -e "$new_name" ]]; then
      echo "⚠️ 已存在文件 $new_name，跳过 $file"
    else
      mv -- "$file" "$new_name"
      echo "✅ $file → $new_name"
      ((i++))
    fi
  done
}

# 发布公共包
function pub (){
   npm publish --access public
}

# 发布私有包
function pubres (){
   npm publish --access restricted
}

# 同步 .zshrc 到用户目录并且 source
function sc(){
  cp .zshrc ~/.zshrc && source ~/.zshrc
  echo "\e[32m✅ “cp .zshrc ~/.zshrc && source ~/.zshrc” 操作成功！\e[0m"
}

# source ~/.zshrc
function rec() {
  source ~/.zshrc
}

# @see https://github.com/zhuddan/cmd-config.git

# vscode code cmd 配置
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# nvm 配置相关
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

  # 提取所有 script 名称（仅从 scripts 部分）
  local scripts=($(sed -n '/"scripts"\s*:/,/^[^ ]*[^,{]*[},]/p' package.json | grep -Eo '"[^"]+"\s*:' | sed 's/"//g;s/://'))

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

# 发布公共包
function pub() {
   npm publish --access public
}

# 发布私有包
function pubres() {
   npm publish --access restricted
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
    local targetBase="$HOME/projects"
    local targetDir="$targetBase/$dir"
    mkdir -p "$targetBase"
    echo "Cloning repository '$repoUrl' into directory '$targetDir'..."
    git clone "$repoUrl" "$targetDir"
  fi
}

# git remote
function go() {
  git remote -v
}

# clear
function cls(){ 
  clear
}

# 发布公共包
function pub (){
   npm publish --access public
}

# 发布私有包
function pubres (){
   npm publish --access restricted
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
    o ~/projects
}

function labs() {
    o ~/projects/labs
}

function temporary() {
    o ~/projects/temporary
}

function workspace() {
    o ~/projects/workspace
}

function zd() {
    o ~/projects/zd
}

function data() {
    o ~/data
}

# source ~/.zshrc
function rec() {
  source ~/.zshrc
}

# sync conf
function sc(){
  cp .zshrc ~/.zshrc && source ~/.zshrc
}

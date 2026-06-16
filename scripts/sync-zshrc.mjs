import { execFileSync } from 'node:child_process'
import { copyFileSync } from 'node:fs'
import { homedir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root = resolve(__dirname, '..')

const src = join(root, '.zshrc')
const dest = join(homedir(), '.zshrc')

copyFileSync(src, dest)
console.log(`✓ .zshrc -> ${dest}`)
console.log('zsh 配置同步完成')

/**
 * 在子进程中执行一次 `source ~/.zshrc`，验证新配置能正常加载。
 * 注意：这只在子进程生效，无法重载调用本脚本的那个终端。
 */
function reloadZshrc() {
  try {
    execFileSync('zsh', ['-c', `source ${dest}`], { stdio: 'inherit' })
    return true
  }
  catch {
    return false
  }
}

if (reloadZshrc())
  console.log('已验证 ~/.zshrc 可正常加载')

console.log('请在当前终端手动执行重载：source ~/.zshrc')

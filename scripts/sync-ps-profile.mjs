import { execFileSync } from 'node:child_process'
import { copyFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root = resolve(__dirname, '..')

const files = ['Microsoft.PowerShell_profile.ps1', 'aliases-git.ps1']

/** 通过 PowerShell 读取当前用户的 $PROFILE 路径 */
function getProfilePath() {
  const candidates = ['pwsh', 'powershell']
  for (const exe of candidates) {
    try {
      const out = execFileSync(exe, ['-NoProfile', '-Command', 'Write-Output $PROFILE'], {
        encoding: 'utf8',
      })
      const path = out.trim()
      if (path)
        return path
    }
    catch {
      // 尝试下一个可执行文件
    }
  }
  throw new Error('未找到 pwsh / powershell，无法获取 $PROFILE 路径')
}

const profilePath = getProfilePath()
const profileDir = dirname(profilePath)

for (const file of files) {
  const src = join(root, file)
  const dest = join(profileDir, file)
  copyFileSync(src, dest)
  console.log(`✓ ${file} -> ${dest}`)
}

console.log('PowerShell 配置同步完成')

/**
 * 在子进程中执行一次 `. $PROFILE`，验证新配置能正常加载。
 * 注意：这只在子进程生效，无法重载调用本脚本的那个终端。
 */
function reloadProfile() {
  const candidates = ['pwsh', 'powershell']
  for (const exe of candidates) {
    try {
      execFileSync(exe, ['-NoProfile', '-Command', '. $PROFILE'], { stdio: 'inherit' })
      return true
    }
    catch {
      // 尝试下一个可执行文件
    }
  }
  return false
}

if (reloadProfile())
  console.log('已验证 $PROFILE 可正常加载')

console.log('请在当前终端手动执行重载：. $PROFILE')

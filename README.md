# WalletApp — iOS 钱包管理 App

## 通过 GitHub Actions 编译 IPA

### 前置条件

1. **苹果开发者账号**（$99/年）— [Apple Developer Program](https://developer.apple.com/programs/)
2. **生成签名证书和描述文件**

### 初次设置（只需要做一次）

#### 第一步：生成签名证书

在 Mac 上打开 **钥匙串访问** → 证书助理 → 从证书颁发机构请求证书 → 保存 `.certSigningRequest`

登录 [Apple Developer](https://developer.apple.com/account) → Certificates → 创建 iOS Development 证书 → 下载双击安装

导出证书为 `.p12`（钥匙串 → 右键证书 → 导出 → 设密码）

#### 第二步：创建描述文件

Apple Developer → Profiles → 创建 iOS Development 描述文件
绑定 App ID（Bundle ID 任意，如 `com.yourname.WalletApp`）和你的证书 → 下载 `.mobileprovision`

#### 第三步：设置 GitHub Secrets

项目的 **Settings → Secrets and variables → Actions → New repository secret**：

| Secret 名称 | 值 |
|---|---|
| `APPLE_PROFILE_BASE64` | 描述文件的 base64 编码 (Mac 终端: `base64 -i profile.mobileprovision \| pbcopy`) |
| `CODE_SIGN_IDENTITY` | 证书名称，通常 `Apple Development: your@email.com` |
| `PROVISIONING_PROFILE` | 描述文件名称（不含.mobileprovision） |
| `TEAM_ID` | 开发者 Team ID（Apple Developer 页面查看） |

### 触发编译

- **自动**：推送代码到 `main` 分支
- **手动**：GitHub → Actions → Build IPA → Run workflow

编译完成后，IPA 文件可以在 **Actions 页面** 下载。

# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "同步" / "sync" / "iCloud" detected → iCloud capability required
- "共享" / "share" / "团队" / "team" → CloudKit shared database
- "通知" / "notification" / "推送" → Push Notifications
- "购买" / "订阅" / "会员" / "premium" → In-App Purchase
- "搜索" / "Spotlight" → Core Spotlight (no capability needed)
- "文件" / "document" / "导入" → Document Picker access

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| iCloud (CloudKit) | ✅ Configured | Xcode Signing & Capabilities |
| Push Notifications | ✅ Configured | Xcode Signing & Capabilities |
| In-App Purchase | ✅ Configured | Xcode Signing & Capabilities |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| CloudKit Container | ⏳ Pending | 1. Open Apple Developer Portal 2. Create CloudKit container: iCloud.com.zzoutuo.DocTrail 3. Create record types: DocVersion, Document, Team 4. Add to Xcode Signing & Capabilities → iCloud → CloudKit |
| App Groups | ⏳ Pending | 1. Open Xcode → Signing & Capabilities 2. Add App Groups capability 3. Create group: group.com.zzoutuo.DocTrail |

## No Configuration Needed
- Core Spotlight (uses NSUserActivity, no capability required)
- File Provider (uses UIDocumentPickerViewController, no capability required)
- CryptoKit (built into iOS 17+, no capability required)
- StoreKit 2 (built into iOS 17+, no capability required beyond IAP)

## Verification
- Build succeeded after configuration: ⏳ Pending
- All entitlements correct: ⏳ Pending

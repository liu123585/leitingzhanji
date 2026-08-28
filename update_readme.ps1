$repo = 'liu123585/leitingzhanji'
$path = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\README.md'
$bytes = [IO.File]::ReadAllBytes($path)
$b64 = [Convert]::ToBase64String($bytes)
$apiUrl = "repos/$repo/contents/README.md"
$sha = (gh api $apiUrl --jq '.sha' 2>$null)
Write-Host "README sha = $sha"
$body = @{ message = "docs: 游戏截图改用 jsDelivr CDN 链接，修复国内网络图片无法显示"; content = $b64; sha = $sha } | ConvertTo-Json -Compress
$out = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\readme_body.json'
[System.IO.File]::WriteAllText($out, $body)
$res = gh api --method PUT $apiUrl --input $out 2>&1
if ($res -like '*"sha"*') { Write-Host "README UPDATED OK" } else { Write-Host "FAIL: $res" }

$repo = 'liu123585/leitingzhanji'
$dir = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\screenshots'
$f = 'shot-menu.png'
$path = Join-Path $dir $f
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($path))
$apiUrl = "repos/$repo/contents/screenshots/$f"
$sha = (gh api $apiUrl --jq '.sha' 2>$null)
Write-Host "sha for $f = $sha"
if (-not $sha) { Write-Host "NO SHA"; exit 1 }
$body = @{ message = "chore: update $f (real gameplay screenshot)"; content = $b64; sha = $sha } | ConvertTo-Json -Compress
$out = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\body.json'
[System.IO.File]::WriteAllText($out, $body)
$res = gh api --method PUT $apiUrl --input $out 2>&1
Write-Host "RESULT: $res"

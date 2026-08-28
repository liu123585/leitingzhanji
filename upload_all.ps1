$repo = 'liu123585/leitingzhanji'
$dir = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\screenshots'
$out = 'c:\Users\admin\CodeBuddy\20260826213651\leitingzhanji-repo\body.json'
$files = @('shot-menu.png','shot-battle.png','shot-boss.png','shot-talent.png','shot-diy.png','shot-level.png')
foreach ($f in $files) {
  $path = Join-Path $dir $f
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($path))
  $apiUrl = "repos/$repo/contents/screenshots/$f"
  $sha = (gh api $apiUrl --jq '.sha' 2>$null)
  if (-not $sha) { Write-Host "SKIP $f (no sha)"; continue }
  $body = @{ message = "chore: update $f (real gameplay screenshot)"; content = $b64; sha = $sha } | ConvertTo-Json -Compress
  [System.IO.File]::WriteAllText($out, $body)
  $res = gh api --method PUT $apiUrl --input $out 2>&1
  if ($res -like '*"sha"*') { Write-Host "OK   $f" } else { Write-Host "FAIL $f -> $res" }
}
Write-Host "DONE"

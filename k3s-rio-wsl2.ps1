#!/usr/bin/env pwsh

Write-Host "Install rio via scoop (also k3d for fun)" -ForegroundColor Yellow
scoop install https://raw.githubusercontent.com/wahmedswl/k8s/master/rio.json
scoop install https://raw.githubusercontent.com/wahmedswl/k8s/master/k3d.json

Write-Host "Create docker image and import it into WSL 2" -Foreground Yellow
iex (new-object net.webclient).downloadstring("https://raw.githubusercontent.com/wahmedswl/k8s/master/k3s-wsl2.ps1")

Write-Host "Run the following line by line" -ForegroundColor Yellow
Write-Host @'
wsl -d wahmed-k3s
k3s server --no-deploy traefik > /dev/null 2>&1 &
exit
'@

Write-Host "Copy paste the following. After ~2 minutes, press ctrl+c to stop watching and complete installation of rio" -ForegroundColor Yellow
Write-Host @'
$env:KUBECONFIG='//wsl$/wahmed-k3s/etc/rancher/k3s/k3s.yaml'
sc //wsl$/wahmed-k3s/etc/rancher/k3s/k3s.yaml ((gc -raw //wsl$/wahmed-k3s/etc/rancher/k3s/k3s.yaml) -replace '127.0.0.1','localhost')
kubectl get po --all-namespaces -w
rio install
rio dashboard
Write-Host "You can point VSCode to //wsl$/wahmed-k3s/etc/rancher/k3s/k3s.yaml"
Write-Host "Done"
'@
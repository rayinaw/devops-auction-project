
## Rancher configuration

```s
sudo apt-get update -y
reboot
sudo apt-get install docker.io
mkdir /var/lib/rancher
docker run -d --name rancher -v /var/lib/rancher:/var/lib/rancher--restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher
docker logs container-id  2>&1 | grep "Bootstrap Password:"
```
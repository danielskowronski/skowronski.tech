---
title: Łączenie się z SSH na webhostingu OVH za pomocą klucza prywatnego
author: Daniel Skowroński
type: post
date: 2015-12-30T19:51:36+00:00
url: /2015/12/laczenie-sie-z-ssh-na-webhostingu-ovh-za-pomoca-klucza-prywatnego/
tags:
  - linux
  - ovh
  - webhosting

---
Proste zadanie &#8211; połączyć się bez hasła (za pomocą klucza RSA) po SSH do webhostingu OVH (jest to dostępne co najmniej w ofercie PRO). Odcisk palca wgrany do świeżo założonego .ssh/authorized_keys (w /homeWXYZ/username). Łączę się, ale odrzuca mój klucz. 

Okazuje się, że zainstalowany na serwerach ftp.clusterXYZ.ovh.net serwer ssh jest bardzo konserwatywny jeśli chodzi i uprawnienia &#8211; wymaga 755 na folderze .ssh i 600 na samym pliku authorized_keys.
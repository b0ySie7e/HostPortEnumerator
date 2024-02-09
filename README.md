# HostPortEnumerator

## Uso

### Ayuda

```shell
[X] Invalid IP address
[*] The necesary arguments are:
        -H  : Host scanning
        -P  : Port scanning
         Example: 
        ./hostPortDiscovery.sh -H 10.10.10.1-254         Active Host 
        ./hostPortDiscovery.sh -P 10.10.10.10    Active Ports 
```
### Enumeración de Hosts

```shell
❯ ./hostPortDiscovery.sh -H 192.168.98.1-255
[*] Host Enumeration, Waiting
 [✓]  192.168.98.1  Host active 
 [✓]  192.168.98.2  Host active 
 [✓]  192.168.98.3  Host active 
 [✓]  192.168.98.6  Host active 
 [✓]  192.168.98.8  Host active
```
### Enumeración de Puertos

```shell
❯ ./hostPortDiscovery.sh -P 192.168.98.1
[*] Port Enumeration    192.168.98.1:
 [✓]  53  Port Active

```
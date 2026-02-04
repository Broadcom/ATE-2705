# ATE-2705 - VCF 9.0.1 Single Site Labs for ATE Deliveries
# Please Reach out to Ben Todd before modifying this repo.

## HOLFY27 VPodRepo Format

## Overview

This is an initial vpodrepo structure for a VCF 9.1 Single Site lab in the
HOLFY27 (FY2027) format.

## Directory Structure

```plain
ATE-2705/
├── config.ini              # Lab configuration (required)
├── README.txt              # This file (required)
├── holorouter/             # Router configuration overrides
│   ├── allowlist           # Additional allowed domains
│   ├── iptablescfg.sh      # Custom firewall rules (optional)
│   └── startlist           # Startup-only allowed domains
├── Startup/                # Startup module overrides
│   ├── prelim.py           # Override core prelim module (optional)
│   └── VCFfinal.py         # Override core VCFfinal module (optional)
├── scripts/                # Custom scripts
│   ├── setup-demo.sh       # Example bash script (optional)
│   └── configure-app.py    # Example Python script (optional)
├── ansible/                # Ansible playbooks (optional)
│   └── configure.yml       # Example playbook (optional)
└── salt/                   # Salt states (optional)
    └── config.sls          # Example salt state (optional)
```

## Configuration

### config.ini

The `config.ini` file defines lab parameters:

- **[VPOD]**: Core settings (SKU, labtype [should set to ATE], timeouts, conky title)
- **[RESOURCES]**: Components to verify (hosts, VMs, services)
- **[VCF]**: VCF-specific component names
- **[VCFFINAL]**: Post-startup tasks
- **[CUSTOM]**: Lab-specific key-value pairs

### Startup Module Overrides

Place Python files in `Startup/` to override core modules:

```python
# Startup/prelim.py - Example override
import lsfunctions as lsf

def main():
    lsf.write_output('Running lab-specific prelim tasks...')
    
    # Your custom initialization code here
    
    lsf.write_output('Lab-specific prelim complete')

if __name__ == '__main__':
    import sys
    sys.path.insert(0, '/home/holuser/hol')
    import lsfunctions as lsf
    lsf.init(router=False)
    main()
```

### Router Configuration

Files in `holorouter/`:

- **allowlist**: Additional domains to allow through proxy (merged with core)
- **startlist**: Domains needed only during startup (temporary access)
- **iptablescfg.sh**: Custom firewall rules (replaces core rules)

## Testing

1. In development vApp, git pulls `dev` branch automatically
2. Override files take effect on labstartup
3. Use status dashboard to monitor: `/lmchol/home/holuser/startup-status.htm` or `ltail` command to tail the labstartup.log file

## Lab Startup Flow

1. Manager VM boots, mounts console and vpodrepo
2. `labstartup.sh` clones/pulls this repository
3. `config.ini` copied to `/tmp/config.ini`
4. Router files pushed via NFS to holorouter
5. `labstartup.py` runs startup sequence using LabType loader
6. Override modules from `Startup/` used when present
7. DNS records imported from `new-dns-records.csv`
8. Status dashboard updated throughout

## Support

Contact the HOL Core Team for assistance with:

- Repository creation
- Custom startup requirements
- Firewall/proxy configuration
- Debugging startup issues

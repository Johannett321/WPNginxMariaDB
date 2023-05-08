# Deploy guide

### Sett opp terraform worker

Start med å kjøre følgende kommandoer fra master

```bash
cd /home/ubuntu/Terraform
terraform plan
terraform apply
```

Og svar “yes” når du blir spurt om det.

### Sett opp wordpress, nginx og mariaDB

Deretter kjører du disse kommandoene

```bash
cd /home/ubuntu/web
./starter.sh
```

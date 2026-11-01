# AWS Infrastructure as Code with Terraform

### Terraform Commands Used

```bash
tf init -backend-config="dev.backend.hcl"
tf fmt
tf validate
tf plan
tf apply -auto-approve

terraform state list

tf providers lock --platform=linux_amd64
```

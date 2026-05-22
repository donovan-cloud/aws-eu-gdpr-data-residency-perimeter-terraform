# AWS EU GDPR Data Residency & Sovereignty Perimeter (Terraform)

An automated Infrastructure-as-Code policy and provisioning deployment baseline explicitly designed to maintain **EU GDPR Chapter V** compliance by enforcing strict regional localization, data residency control boundaries, and automated cryptographic sovereignty.

## 📋 GDPR Compliance Control Mapping

| EU GDPR Framework Target | Infrastructure Automation Strategy | Resource Mapping |
| :--- | :--- | :--- |
| **Chapter V** (International Data Transfers) | Restricts resource allocation capabilities to specific European Economic Area (EEA) hosting hubs using configuration policies. | `aws_config_config_rule` |
| **Article 32** (Security of Processing) | Enforces localized AES-256 KMS key generation boundaries with customer-controlled key parameters. | `aws_kms_key`, `aws_s3_bucket_server_side_encryption_configuration` |
| **Data Residency Minimization** | Establishes a sealed storage perimeter located explicitly inside the `eu-central-1` (Frankfurt) jurisdiction with comprehensive public access locks. | `aws_s3_bucket`, `aws_s3_bucket_public_access_block` |

## 🚀 Data Residency Protections Deployed
* **Sovereign Region Enforcer:** Leverages an active compliance scanner rule that flags or automatically denies the instantiation of any data-bearing infrastructure outside designated European zones.
* **Double-Layer Storage Isolation:** Combines explicit resource tagging matrices, absolute public access block configurations, and localized KMS encryption envelopes to securely block unexpected international data movement.

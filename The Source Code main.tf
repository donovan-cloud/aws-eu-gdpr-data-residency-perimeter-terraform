# ==============================================================================
# ARCHITECTURE: GDPR EU Data Residency & Sovereignty Perimeter Baseline
# COMPLIANCE MAPPING: GDPR Chapter V (Transfer of personal data to third countries)
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Enforce explicit pinning to an EU Sovereign region (Frankfurt)
provider "aws" {
  region = "eu-central-1"
}

variable "environment" {
  type    = string
  default = "production"
}

# ------------------------------------------------------------------------------
# 1. GDPR Chapter V Sovereignty Isolation: Localized Cloud Storage Base
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "gdpr_sovereign_vault" {
  bucket        = "eu-compliance-gdpr-sovereign-vault-data-residency"
  force_destroy = false

  tags = {
    Data_Residency     = "EU_Central_1"
    Legal_Jurisdiction = "GDPR_Compliance_Boundary"
  }
}

# Absolute block on public access states to prevent international leakage
resource "aws_s3_bucket_public_access_block" "gdpr_egress_block" {
  bucket = aws_s3_bucket.gdpr_sovereign_vault.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------------------------------------
# 2. GDPR Art. 32 (Security of Processing): Enforced European Encryption Plane
# ------------------------------------------------------------------------------
resource "aws_kms_key" "gdpr_eu_key" {
  description             = "GDPR Sovereign Key localized strictly within European borders"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Regional_Sovereignty = "EU_Only"
    Compliance_Article   = "GDPR_Art_32"
  }
}

# Enforce server-side bucket encryption using the localized EU key boundary
resource "aws_s3_bucket_server_side_encryption_configuration" "gdpr_encryption_enforcement" {
  bucket = aws_s3_bucket.gdpr_sovereign_vault.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.gdpr_eu_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# ------------------------------------------------------------------------------
# 3. Data Governance Guardrails: AWS Config Region Restrictions
# ------------------------------------------------------------------------------
resource "aws_config_config_rule" "enforce_regional_data_bounds" {
  name = "gdpr-allowed-regions-only"

  source {
    owner             = "AWS"
    source_identifier = "ALLOWED_REGIONS"
  }

  input_parameters = jsonencode({
    # Strictly allow deployments only inside sovereign EU jurisdictions
    "listOfAllowedRegions" = "eu-central-1,eu-west-1,eu-west-2,eu-west-3"
  })
}

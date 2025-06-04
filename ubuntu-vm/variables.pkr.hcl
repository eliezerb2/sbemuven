variable "iso_path" {
  type        = string
  description = "Path to Ubuntu ISO file, can be a URL or local path"
  default     = "https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
}

# checksum taken from https://old-releases.ubuntu.com/releases/22.04.4/SHA256SUMS
variable "iso_checksum" {
  type        = string
  description = "Checksum for the ISO file"
  default     = "sha256:45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
}
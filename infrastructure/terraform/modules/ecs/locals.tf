# ---------------------------------------------
# Port/Service Config (locals.tf)
# ---------------------------------------------
locals {
  services = {
    auth         = 3000
    booking      = 3001
    driver       = 3002
    dispatch     = 3003
    notification = 3004
  }
}
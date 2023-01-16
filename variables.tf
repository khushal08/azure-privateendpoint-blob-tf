variable rg {
  type        = string
  default     = ""
  description = "RG Name"
}

variable location {
  type        = string
  default     = ""
  description = "Location"
}

variable sa {
  type        = string
  default     = ""
  description = "Storage account name"
}

variable sc {
  type        = string
  default     = ""
  description = "storage container name"
}

variable vnet {
  type        = string
  default     = ""
  description = "VNET Name"
}

variable vmsubnet {
  type        = string
  default     = ""
  description = "VM Subnet"
}

variable vmname {
  type        = string
  default     = ""
  description = "description"
}

variable nicname {
  type        = string
  default     = ""
  description = "VM Nic"
}

variable ipconfigname {
  type        = string
  default     = ""
  description = "IP Config for NIC"
}

variable vm {
  type        = string
  default     = ""
  description = "VM Name"
}

variable adminuser {
    type        = string
    default     = ""
    description = "Admin User"
}
 variable adminpassword {
   type        = string
   default     = ""
   description = "Password"
 }

 variable sb {
   type        = string
   default     = ""
   description = "Blob Name"
 }

variable pename {
  type        = string
  default     = ""
  description = "PE for Blob"
}

variable pscname {
  type        = string
  default     = ""
  description = "Private Endpoint attached private service connection for Blob"
}

variable pdzgname {
  type        = string
  default     = ""
  description = "Private DNS Zone Group Name"
}

variable pdzname {
  type        = string
  default     = ""
  description = "Private DNS Zone Name"
}

variable pdzrname {
  type        = string
  default     = ""
  description = "Private DNS Zone Record Name"
}

variable pdzvnlname {
  type        = string
  default     = ""
  description = "Private DNS Zone Virtual Network Link Name"
}






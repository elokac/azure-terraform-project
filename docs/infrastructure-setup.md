# Azure Infrastructure Setup with Terraform

![Infrastructure Diagram](Infra_diagram.png)

This document provides an overview of the infrastructure setup for the "Infrastructure Set Up" using Terraform on Microsoft Azure. It includes details about the architecture, resources created, and step-by-step instructions on how to reproduce this infrastructure.

## Overview: 3-Tier Architecture and Information Flow

The infrastructure embraces a 3-tier architecture that ensures a clear and secure information flow while promoting isolation between different components. Here's how information flows within this setup:

### Tier 1: Resource Group and Azure Virtual Network

**Resource Group and Azure Virtual Network**

**Information Flow:**

- The Azure Resource Group and Azure Virtual Network serve as the foundational components of the infrastructure.
- Azure Virtual Network defines the network topology and subnets within which other resources are created.

**Importance:**

- Resource Group provides logical organization and management of Azure resources.
- Azure Virtual Network defines the network boundaries for the infrastructure setup.

### Tier 2: Virtual Machine Scale Set (VMSS)

**VMSS Instances**

**Information Flow:**

- The Virtual Machine Scale Set (VMSS) instances, including application components, are hosted within Azure Virtual Network's private subnets.
- It manages and scales the application components, providing high availability and resource management.
- Administrators and developers can access VMSS instances via a Bastion Host located in the public subnet.

**Importance:**

- VMSS ensures that application components are efficiently and securely deployed and managed.
- It allows for horizontal scaling to handle varying workloads effectively.

### Tier 3: Azure SQL Database

**Azure SQL Database**

**Information Flow:**

- Azure SQL Database instances, which store application data, reside in a private subnet within Azure Virtual Network.
- They can only be accessed by application instances in the same private subnet or authorized users connecting via the Bastion Host located in the public subnet.

**Importance:**

- Azure SQL Database instances are shielded from external access, ensuring data security and compliance.
- They provide a trusted repository for application data, with controlled access through a secure channel.

### Secure Access via Bastion Host

**Information Flow:**

- Authorized users, including administrators and developers, connect to the Bastion Host in the public subnet.
- The Bastion Host serves as a gateway, allowing secure, controlled access to the VMSS instances and private resources within Azure Virtual Network.

**Importance:**

- The Bastion Host enforces secure access policies, ensuring that only authorized personnel can reach private resources like the VMSS instances and Azure SQL Database.
- It logs access activities for auditing and monitoring purposes, enhancing security and accountability.

In this revised architecture, both application instances within the VMSS and Azure SQL Database instances are placed in Tier 2, as they reside in private subnets within Azure Virtual Network. The Bastion Host and Load Balancers are located in public subnets, serving as the primary entry points for external user traffic and providing secure access to the VMSS and other private resources.

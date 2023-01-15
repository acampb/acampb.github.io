---
title: "Revert Azure Virtual Machine with Snapshots"
date: 2021-04-26
# weight: 1
# aliases: ["/first"]
tags: ["azure"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Learn how to take a snapshot of an Azure virtual machine OS disk, and then quickly revert the machine back to the snapshot using Azure PowerShell."
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "/images/az-snapshots/AzureDiskSnapshot.png" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

I recently prepared a Lightning Demo for the [2021 PowerShell + DevOps Global Summit](https://events.devopscollective.org/event/powershell-devops-global-summit-2021/), which thankfully was a pre-recorded session and not live. This gave me the chance to practice, and rehearse, and fine tune my content. I used a virtual machine in Azure to perform the demo which gave me two great benefits.

* One: I was preparing the demo from a base Windows 10 machine (or pretty close to it), so I was pretty confident that my material would work for anyone else. I didn't want to demo from my machine and forget about some random configuration or setting. Using a fresh machine ensured I had to account for everything.

* Two: I could take a snapshot of the VM, run through my demo, and then revert the VM to it's pre-demo state. This allowed me to practice my demo over and over and over again, make adjustments, and then practice some more. Going through this process a few times led me to creating some PowerShell scripts to automate this process (and create this blog post!).

1. Create VM in Azure
2. Install and configure pre-requisites
3. Take disk snapshot
4. Perform demo
5. Revert VM to pre-demo state
6. Goto step 4

After understanding the steps needed and the PowerShell cmdlets for each, the next step was of course to write scripts to automate all the individual steps.

The scripts are available in my GitHub repo here: **[https://github.com/acampb/AzureVMSnapshots](https://github.com/acampb/AzureVMSnapshots)**

## Creating a snapshot

`Create-DiskSnapshot.ps1` creates an Azure Disk Snapshot in the same location as the source disk.

```powershell
.\Create-DiskSnapshot.ps1
    -SourceDiskName "vm_OS_disk_01"
    -ResourceGroupName "rg-MyVM"
    -SnapshotName "vm_OS_disk_01_snapshot"
```

## Revert VM OS Disk

`Reset-OSDisk.ps1` creates a new disk from the specified snapshot, stops the virtual machine, updates the virtual machine OS disk to utilize the newly created disk, and starts the virtual machine.

```powershell
.\Reset-OSDisk.ps1
    -SnapshotResourceId "resourceId"
    -Location "East US"
    -DiskName "vm_OS_disk_02"
    -VMName "MyVM"
    -ResourceGroupName "rg-MyVM"
```

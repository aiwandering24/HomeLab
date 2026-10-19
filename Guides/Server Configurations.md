#Server A
 
| Pool Name | Storage Type | Physical Disks | Raw Capacity | Usable Capacity | Proxmox Storage Layer | Target AI Workload |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`ai-models-pool`** | ZFS RAIDZ1 *(or RAID10)* | `/dev/sdb`<br>`/dev/sdc`<br>`/dev/sdd`<br>`/dev/sdf` | 4.0 TB | **~2.7 TB** *(~1.8 TB RAID10)* | **ZFS (ZFSPool)** | High-throughput sequential reads for staging large LLM weights (e.g., Ollama/Qwen model blobs). |
| **`ai-data-pool`** | ZFS RAIDZ1 | `/dev/sde`<br>`/dev/sdh`<br>`/dev/sdi` | 2.7 TB | **~1.6 TB** | **ZFS (ZFSPool)** | High random IOPS workspace for scrapers (Crawl4AI), relational tables (n8n pipelines), and Vector DB arrays (Qdrant). |
| **`scratch-backup`** | Standard Linux Directory | `/dev/sdg` | 1.0 TB | **~930 GB** | **Directory** | Cold storage for code repository forks, snapshot points, local logs, and periodic Markdown knowledge base packaging. |



| Target Mount Path (Inside Guest) | Disks | Proxmox Host Storage Path | Physical Disk Size | Target AI Workload Feature / Usage |
| :--- | :--- | :--- | :--- | :--- |
| `/mnt/ai_storage/Storage1/` | `sdb` | `/mnt/pve/Storage1` | 999.65 GB | Staging Raw Extracts |
| `/mnt/ai_storage/Storage2/` | `sdc` | `/mnt/pve/Storage2` | 999.65 GB | Vector Database Shards (Qdrant / Chroma) |
| `/mnt/ai_storage/Storage3/` | `sdd` | `/mnt/pve/Storage3` | 999.65 GB | Model Layer Cache & Ollama Engine Blobs |
| `/mnt/ai_storage/Storage4/` | `sde` | `/mnt/pve/Storage4` | 899.53 GB | Crawl4AI Raw Web Scrapes & Markdown Extracts |
| `/mnt/ai-data-pool/Storage5/` | `sdf` | `/mnt/pve/Storage5` | 999.65 GB | Pipeline Working Data (n8n execution contexts) |
| `/mnt/ai-data-pool/Storage6/` | `sdg` | `/mnt/pve/Storage6` | 999.65 GB | Database Transaction Logs & Index Files |
| `/mnt/ai-data-pool/Storage7/` | `sdh` | `/mnt/pve/Storage7` | 899.53 GB | Active Workspace Tables & Temp Data |
| `/mnt/scratch-backup/Storage8/` | `sdi` | `/mnt/pve/Storage8` | 899.53 GB | Obsidian Knowledge Base & Code Backups |


| Device 		 | StorageDirectory  	| Type  	 | Usage     | Size | GPT | Model | Serial | S.M.A.R.T. | M... | Wearout |
| :--- 			 | :---    	| :---    	 | :---      | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`/dev/sda`** | OS-SSD  | unknown   | partitions | 799.54 GB | Yes | PERC_H710 | 6848f690e9a1a5003241928... | UNKNOWN | No | N/A |
| ↳ `/dev/sda1`  | partition| partition | BIOS boot | 1.03 MB | Yes | | | | No | N/A |
| ↳ `/dev/sda2`  | partition| partition | EFI | 1.07 GB | Yes | | | | Yes | N/A |
| ↳ `/dev/sda3`  | partition| partition | LVM | 797.79 GB | Yes | | | | No | N/A |
| **`/dev/sdb`** | Storage1  | unknown   | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f3cf... | UNKNOWN | No | N/A |
| ↳ `/dev/sdb1`  | Storage1| partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdc`** | Storage2  | unknown   | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f3d8... | UNKNOWN | No | N/A |
| ↳ `/dev/sdc1`  | Storage2| partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdd`** | Storage3  | unknown   | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f3e3... | UNKNOWN | No | N/A |
| ↳ `/dev/sdd1`  | Storage3| partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sde`** | Storage4  | unknown   | partitions | 899.53 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f3f4... | UNKNOWN | No | N/A |
| ↳ `/dev/sde1`  | Storage4| partition | ext4 | 899.53 GB | Yes | | | | Yes | N/A |
| **`/dev/sdf`** | Storage5  | unknown   | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f41f... | UNKNOWN | No | N/A |
| ↳ `/dev/sdf1`  | Storage5| partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdg`** | Storage7  | unknown   | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f438... | UNKNOWN | No | N/A |
| ↳ `/dev/sdg1`  | Storage7| partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdh`** | Storage6  | unknown   | partitions | 899.53 GB | Yes | PERC_H710 | 6848f690e9a1a5003214f444... | UNKNOWN | No | N/A |
| ↳ `/dev/sdh1`  | Storage6| partition | ext4 | 899.53 GB | Yes | | | | Yes | N/A |
| **`/dev/sdi`** | Storage8  | unknown   | partitions | 899.53 GB | Yes | PERC_H710 | 6848f690e9a1a50030eddb2... | UNKNOWN | No | N/A |
| ↳ `/dev/sdi1`  | Storage8| partition | ext4 | 899.53 GB | Yes | | | | Yes | N/A |

#Server C
 | Device | Type | Usage | Size | GPT | Model | Serial | S.M.A.R.T. | M... | Wearout |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`/dev/sda`** | unknown | partitions | 999.65 GB | Yes | PERC_H710 | 6848f690e9a1a500324086c... | UNKNOWN | No | N/A |
| ↳ `/dev/sda1` | partition | BIOS boot | 1.03 MB | Yes | | | | No | N/A |
| ↳ `/dev/sda2` | partition | EFI | 1.07 GB | Yes | | | | Yes | N/A |
| ↳ `/dev/sda3` | partition | LVM | 998.58 GB | Yes | | | | No | N/A |
| **`/dev/sdb`** | unknown | partitions | 999.65 GB | Yes | PERC_H710 | 690b11c005de570032497cc... | UNKNOWN | No | N/A |
| ↳ `/dev/sdb1` | partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdc`** | unknown | partitions | 999.65 GB | Yes | PERC_H710 | 690b11c005de570032497cd... | UNKNOWN | No | N/A |
| ↳ `/dev/sdc1` | partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sdd`** | unknown | partitions | 999.65 GB | Yes | PERC_H710 | 690b11c005de570032497d6... | UNKNOWN | No | N/A |
| ↳ `/dev/sdd1` | partition | ext4 | 999.65 GB | Yes | | | | Yes | N/A |
| **`/dev/sde`** | unknown | partitions | 899.53 GB | Yes | PERC_H710 | 690b11c005de570032497d7... | UNKNOWN | No | N/A |
| ↳ `/dev/sde1` | partition | ext4 | 899.53 GB | Yes | | | | Yes | N/A |
| **`/dev/sdf`** | unknown | partitions | 599.55 GB | Yes | PERC_H710 | 690b11c005de570032497d8... | UNKNOWN | No | N/A |
| ↳ `/dev/sdf1` | partition | ext4 | 599.55 GB | Yes | | | | Yes | N/A |
| **`/dev/sdg`** | unknown | partitions | 299.44 GB | Yes | PERC_H710 | 690b11c005de570032497d9... | UNKNOWN | No | N/A |
| ↳ `/dev/sdg1` | partition | ext4 | 299.44 GB | Yes | | | | Yes | N/A |

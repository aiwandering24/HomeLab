# Four-Node Proxmox AI Platform

Interactive GitHub documentation for the server deployment, technology stack, platform functions, network zones, and end-to-end AI workflow.

> **Interaction:** Select a server node in the diagram to jump to its detailed section. GitHub renders Mermaid diagrams natively. Browser zoom and pan can be used for large diagrams.

## Interactive Server Deployment Map

```mermaid
flowchart TB
    ROOT([Four-Node Proxmox AI Platform])
    SWITCH["Dell X1052 Switch<br/>10 Gb data and storage<br/>1 Gb management"]

    ROOT --> SWITCH
    SWITCH -->|"VLAN 20, 30, 50, 70"| A101
    SWITCH -->|"VLAN 20, 30, 40, 70"| C102
    SWITCH -->|"VLAN 20, 30, 50, 70"| C103
    SWITCH -->|"VLAN 20, 30, 60, 70"| D104

    subgraph CONTROL["Control Plane"]
      A101["PveSrvA-101<br/>Proxmox VE"]
      A_STACK["MLflow and PostgreSQL<br/>Prefect or Airflow<br/>NGINX or HAProxy and OIDC<br/>Prometheus and Grafana<br/>Loki or OpenSearch<br/>Vault, Trivy, Syft, Cosign"]
      A_FUNC["Functions<br/>MLOps and orchestration<br/>Metadata and registry<br/>API gateway<br/>Monitoring and security"]
      A101 --> A_STACK --> A_FUNC
    end

    subgraph TRAINING["Training Plane"]
      C102["PveSrvC-102<br/>Proxmox VE and Ubuntu GPU VM"]
      C102_GPU["Tesla P40 passthrough<br/>Pinned NVIDIA driver and CUDA"]
      C102_STACK["Python and PyTorch<br/>Transformers and Datasets<br/>PEFT, LoRA, QLoRA<br/>bitsandbytes and Accelerate<br/>JupyterLab and MLflow client"]
      C102_FUNC["Functions<br/>GPU training<br/>Fine-tuning and evaluation<br/>Experiment execution<br/>Checkpoint generation"]
      C102 --> C102_GPU --> C102_STACK --> C102_FUNC
    end

    subgraph INFERENCE["Inference Plane"]
      C103["PveSrvC-103<br/>Proxmox VE and Ubuntu GPU VM"]
      C103_GPU["Tesla P40 passthrough<br/>Pinned NVIDIA driver and CUDA"]
      C103_STACK["llama.cpp CUDA<br/>FastAPI<br/>Optional PyTorch and Transformers<br/>Local SSD model cache<br/>GPU and host agents"]
      C103_FUNC["Functions<br/>Quantized LLM inference<br/>OpenAI-compatible backend<br/>Streaming and health endpoints<br/>Runtime telemetry"]
      C103 --> C103_GPU --> C103_STACK --> C103_FUNC
    end

    subgraph DATA["Data Plane"]
      D104["PveSrvD-104<br/>Proxmox VE"]
      D104_STACK["MinIO and S3-compatible storage<br/>Qdrant and embeddings<br/>Python, Polars, DuckDB<br/>Tika and PyMuPDF<br/>OCRmyPDF and Tesseract<br/>Presidio and ClamAV<br/>ZFS and Proxmox Backup"]
      D104_FUNC["Functions<br/>Controlled ingestion<br/>Parsing, OCR, cleaning and redaction<br/>Dataset and artifact storage<br/>RAG retrieval<br/>Backup staging"]
      D104 --> D104_STACK --> D104_FUNC
    end

    APP["Custom Applications"]
    SOURCES["Approved Sources<br/>APIs, websites, repositories<br/>PDFs and internal documents"]

    SOURCES -->|"Controlled ingestion"| D104
    D104 -->|"Curated datasets"| C102
    C102 -->|"Metrics and candidates"| A101
    A101 -->|"Approved model promotion"| C103
    D104 -->|"RAG context and approved models"| C103
    APP -->|"HTTPS"| A101
    A101 -->|"Authenticated inference request"| C103
    C103 -->|"Response"| A101
    A101 -->|"Grounded response"| APP
    C103 -->|"Telemetry"| A101

    classDef control fill:#fff0e6,stroke:#f97316,color:#111827,stroke-width:2px;
    classDef training fill:#eaf2ff,stroke:#2563eb,color:#111827,stroke-width:2px;
    classDef inference fill:#ecfdf3,stroke:#16a34a,color:#111827,stroke-width:2px;
    classDef data fill:#f5efff,stroke:#7c3aed,color:#111827,stroke-width:2px;
    classDef network fill:#e5e7eb,stroke:#334155,color:#111827,stroke-width:2px;
    classDef external fill:#fffbea,stroke:#ca8a04,color:#111827,stroke-width:2px;

    class A101,A_STACK,A_FUNC control;
    class C102,C102_GPU,C102_STACK,C102_FUNC training;
    class C103,C103_GPU,C103_STACK,C103_FUNC inference;
    class D104,D104_STACK,D104_FUNC data;
    class ROOT,SWITCH network;
    class APP,SOURCES external;

    click A101 "#pvesrva-101-control-plane" "Open Control Plane details"
    click C102 "#pvesrvc-102-training-plane" "Open Training Plane details"
    click C103 "#pvesrvc-103-inference-plane" "Open Inference Plane details"
    click D104 "#pvesrvd-104-data-plane" "Open Data Plane details"
    click SWITCH "#network-segmentation" "Open network details"
    click APP "#application-and-inference-flow" "Open application flow"
```

## PveSrvA-101 Control Plane

| Area | Technology stack | Function |
|---|---|---|
| Hypervisor | Proxmox VE | Hosts control-plane services |
| MLOps | MLflow, PostgreSQL | Experiment tracking, metadata, registry, lineage |
| Orchestration | Prefect or Airflow, CI/CD agent | Coordinates data, training, evaluation, and deployment workflows |
| API access | NGINX or HAProxy, OIDC | TLS termination, authentication, routing, and rate limiting |
| Observability | Prometheus, Grafana, Loki or OpenSearch | Metrics, dashboards, logs, and operational visibility |
| Security | Vault, Trivy, Syft, Cosign | Secrets, scanning, SBOM generation, and signing |

[Back to diagram](#interactive-server-deployment-map)

## PveSrvC-102 Training Plane

| Area | Technology stack | Function |
|---|---|---|
| Compute | Tesla P40 PCI passthrough, Ubuntu GPU VM | Dedicated GPU training environment |
| Runtime | Pinned NVIDIA driver and CUDA | Stable Pascal-compatible execution baseline |
| ML framework | Python, PyTorch, Transformers, Datasets, Tokenizers | Model loading, training, tokenization, and evaluation |
| Adaptation | PEFT, LoRA, QLoRA, bitsandbytes | Parameter-efficient fine-tuning and validated quantization |
| Execution | Accelerate, JupyterLab | Job launch and controlled experimentation |
| Tracking | MLflow client | Records metrics, parameters, artifacts, and lineage |
| Storage | Local SSD or NVMe scratch | Tokenized shards, caches, and active checkpoints |

[Back to diagram](#interactive-server-deployment-map)

## PveSrvC-103 Inference Plane

| Area | Technology stack | Function |
|---|---|---|
| Compute | Tesla P40 PCI passthrough, Ubuntu GPU VM | Dedicated inference environment |
| Runtime | llama.cpp CUDA or validated pinned PyTorch | Quantized and approved-model inference |
| API | FastAPI | Private OpenAI-compatible backend and health endpoints |
| Cache | Local SSD model cache | Faster startup and reduced network reads |
| Monitoring | GPU and host agents | VRAM, utilization, temperature, latency, and API telemetry |
| Access | A-101 gateway and approved RAG service only | Prevents direct application access to model workers |

[Back to diagram](#interactive-server-deployment-map)

## PveSrvD-104 Data Plane

| Area | Technology stack | Function |
|---|---|---|
| Object storage | MinIO or S3-compatible storage | Raw, curated, dataset, checkpoint, model, and audit artifacts |
| Data processing | Python, Polars, DuckDB | ETL, validation, cleaning, curation, and analytical transforms |
| Document processing | Tika, PyMuPDF, OCRmyPDF, Tesseract | Parsing and OCR for documents and scanned content |
| Data protection | Presidio, ClamAV | PII detection and redaction, malware scanning, and quarantine |
| RAG | Embedding service, Qdrant, optional reranker | Vector generation, indexing, retrieval, and ranking |
| Recovery | ZFS, Proxmox Backup Server | Backup staging, retained copies, and platform recovery |

[Back to diagram](#interactive-server-deployment-map)

## Application and Inference Flow

```mermaid
sequenceDiagram
    autonumber
    actor App as Custom Application
    participant GW as A-101 API Gateway
    participant RAG as D-104 RAG Service
    participant VDB as Qdrant
    participant LLM as C-103 Inference API
    participant OBS as A-101 Observability

    App->>GW: HTTPS request with identity token
    GW->>GW: Authenticate, authorize, rate-limit
    opt RAG request
        GW->>RAG: Query with requester context
        RAG->>VDB: Access-filtered vector search
        VDB-->>RAG: Authorized chunks and metadata
        RAG->>LLM: Prompt with grounded context
    end
    opt Direct model request
        GW->>LLM: Approved model request
    end
    LLM-->>GW: Streaming model response
    GW-->>App: Controlled response
    GW->>OBS: Request metrics and logs
    LLM->>OBS: GPU and runtime telemetry
```

## Data, Training, and Model Promotion Flow

```mermaid
flowchart LR
    S[Approved Sources] --> I[Ingestion]
    I --> Q[Validation, Malware Scan, Quarantine]
    Q --> E[Parsing and OCR]
    E --> C[Clean, Deduplicate, Classify, Redact]
    C --> CUR[Approved Curated Data]
    CUR --> DS[Versioned Dataset Release]
    CUR --> CH[Chunking and Embeddings]
    CH --> V[Qdrant Vector Index]
    DS --> T[LoRA, QLoRA, or SFT on C-102]
    T --> EV[Evaluation]
    EV --> M[MLflow and Human Approval]
    M --> SG[Signed Model Package and SBOM]
    SG --> INF[Deployment to C-103]
    INF --> MON[Monitored Inference]
    MON --> DEC{Lifecycle Decision}
    DEC -->|Retrain| T
    DEC -->|Rollback| SG
    DEC -->|Continue| MON
```

## Network Segmentation

| VLAN | Zone | Purpose |
|---:|---|---|
| 10 | iDRAC and out-of-band | Hardware management only |
| 20 | Proxmox management | Hypervisor, cluster, SSH, DNS, and NTP |
| 30 | Storage and data | Datasets, models, checkpoints, object storage, and backup |
| 40 | AI training | Training jobs and controlled artifact access |
| 50 | Inference and application | API gateway, RAG, and model serving |
| 60 | Ingestion DMZ | Allow-listed external acquisition and quarantine |
| 70 | Monitoring and backup | Metrics, logs, exporters, and backup traffic |

### Core Network Controls

- Default-deny inter-VLAN firewall rules.
- No direct Internet access from storage, training, or inference zones.
- Allow-listed egress proxy for ingestion workloads.
- TLS for service endpoints and mTLS where required.
- OIDC, least-privilege RBAC, and separate service identities.
- Private PostgreSQL, MinIO, Qdrant, JupyterLab, Proxmox, iDRAC, and model runtime endpoints.

[Back to diagram](#interactive-server-deployment-map)

## Deployment Priorities

- **P0:** Hardware validation, Proxmox, ZFS, networking, firewalling, GPU passthrough, and backup foundation.
- **P1:** Ingestion, MinIO, Qdrant, RAG, training runtime, inference runtime, API gateway, monitoring, and backup.
- **P2:** Central logging, secrets management, scanning, SBOM, signing, security hardening, and lifecycle automation.
- **P3:** Modern GPU workers, secondary inference, redundant 25 Gb connectivity, dedicated storage, and justified Ceph or Kubernetes adoption.

## GitHub Usage

1. Save this document as `README.md` or another file ending in `.md`.
2. Commit the file to a GitHub repository.
3. Open the file in the GitHub web interface to render the Mermaid diagrams.
4. Select the four primary server nodes in the first diagram to navigate to their detail sections.
5. If a GitHub environment blocks Mermaid links, use the section links below the diagram as the navigation fallback.

## Source

Adapted from the Four-Node Proxmox AI Platform complete solution architecture and deployment guide.

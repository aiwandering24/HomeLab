# 🚀 Local LLM Training + Inference + RAG Tech Stack

This technical manifest outlines the architecture for a high-performance "Homelab AI Cluster" optimized for **NVIDIA Tesla P40 (Pascal)** hardware.
![Alt Text](https://github.com/aiwandering24/HomeLab/blob/main/Designer%20(3).png)
---

## 🛠️ Hardware Profile & Constraints


| Component | Specification | Compute Cap | Key Constraint |
| :--- | :--- | :--- | :--- |
| **GPU** | NVIDIA Tesla P40 (24GB) | **6.1 (Pascal)** | No native `vLLM` wheels (requires $\ge$ 7.0) |
| **RAM** | 128GB ECC | N/A | Ideal for Vector DB & heavy ETL |
| **Nodes** | R720, R720xd, HP DL Series | Mixed | Hybrid CUDA/CPU workload |

---

## 🏗️ Cluster Architecture (Role Assignment)

### 🛰️ GPU Node #1: Dell R720
*   **Hardware:** 2× Tesla P40 (48GB Total VRAM)
*   **Primary Roles:** 
    *   [ ] **Inference:** High-throughput serving (7B–13B models).
    *   [ ] **Fine-Tuning:** LoRA adapter training.
    *   [ ] **Gateway:** OpenAI-compatible API entry point.

### 💾 GPU Node #2: Dell R720xd
*   **Hardware:** 1× Tesla P40 (24GB VRAM)
*   **Primary Roles:**
    *   [ ] **Batch Jobs:** Scheduled dataset processing.
    *   [ ] **Experimentation:** Testing new LoRA hyperparameters.

### 🧠 CPU & Storage Pool: HP DL Series
*   **Hardware:** Multiple G5/G6/G7 Servers
*   **Primary Roles:**
    *   [ ] **ETL:** Document parsing (Apache Tika), chunking, and metadata extraction.
    *   [ ] **Vector DB:** Qdrant or pgvector storage.
    *   [ ] **Automation:** n8n workflow engine & Prometheus monitoring.

---

## 📦 Software Stack (Pascal Optimized)

### 1. Inference Engines
*   **[llama.cpp](https://github.com):** Best-in-class for P40. Use GGUF format.
*   **[Ollama](https://ollama.com):** Simplest "Download & Run" experience for local LLMs.
*   **[LocalAI](https://localai.io):** For a unified OpenAI-compatible API across the cluster.

### 2. Fine-Tuning Tools
*   **PEFT + LoRA:** Specifically targeted for Pascal limits.
*   **Unsloth:** (Check compatibility) for faster 4-bit training.
*   **bitsandbytes:** Use for 4-bit/8-bit quantization (Note: some 8-bit paths require CC 7.5+).

### 3. RAG & Data Pipeline
*   **Vector Store:** `Qdrant` (Fast, Rust-based) or `pgvector`.
*   **Orchestration:** `n8n` for visual automated ingestion.
*   **Framework:** `LlamaIndex` or `LangChain` for RAG logic.

---

## 🚦 Deployment Roadmap

### Phase 1: Foundation 🧱
- [x] Install **Ubuntu 22.04 LTS** on GPU nodes.
- [x] Install **NVIDIA Datacenter Drivers** (R535+).
- [x] Setup **NVIDIA Container Toolkit** for Docker.

### Phase 2: Inference ⚡
- [ ] Deploy **llama-server** via Docker Compose.
- [ ] Download quantized **Llama-3-8B** or **Mistral-7B** (GGUF).
- [ ] Verify VRAM utilization via `nvidia-smi`.

### Phase 3: RAG Ingestion 📑
- [ ] Spin up **Qdrant** on the HP Service Node.
- [ ] Configure **n8n** to watch an NFS folder for new PDFs.
- [ ] Build a **FastAPI** wrapper for retrieval-augmented generation.

---

## 📊 Monitoring & Observability
*   **NVIDIA Exporter:** For GPU thermals and memory tracking.
*   **Grafana:** Visualizing inference latency and ingestion queue depth.
*   **Prometheus:** Scraping metrics from all cluster nodes.

---

![Alt Text](https://github.com/aiwandering24/HomeLab/blob/main/ai-architecture-pattern.png)

> **Note:** Because the **Tesla P40** lacks Tensor Cores found in newer architectures, prioritize **GGUF (llama.cpp)** for the most efficient math kernels on Pascal hardware.

```bash
# Quick test for GPU availability in Docker
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

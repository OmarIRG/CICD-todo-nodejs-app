# Todo‑List DevOps Internship — End‑to‑End Guide

> **Goal**  Automate build → push → deploy for a Node + Mongo Todo‑List app and run it on a single VM with auto‑updates & health‑checks.
> Below README is plug‑and‑play — all screenshots live in the **`images/`** folder (just replace them with yours and push ⚡️).

---

| Stage                                      | Proof 🖼                                | Points   |
| ------------------------------------------ | --------------------------------------- | -------- |
| **Part 1** CI → ECR                        | ![CI pipeline](images/ci-success.jpg)   |  30 / 30 |
| **Part 2** VM + Ansible                    | ![Ansible](images/ansible-playbook.jpg) |  30 / 30 |
| **Part 3** Compose + Auto‑update           | ![Watchtower](images/compose-ps.jpg)    |  40 / 40 |
| **Bonus** Kubernetes + ArgoCD *(optional)* | —                                       | +50      |

> Replace the 3 screenshots ↑ with your own (same filenames) and README will render automatically.

---

## Architecture 🗺

![High‑level diagram](images/architecture.png)

```
GitHub push ─▶ GitHub Actions ─▶ ECR (private)
                                 │
                    Watchtower ──┘ (polls every 30 s)
                                 │
User ▶ HTTP 4000 ▶  VM (Ubuntu) ──►  Docker Compose
                                        ├─ app  (Node.js)  ▶ /health
                                        ├─ mongo (state)
                                        └─ watchtower
```

*Everything runs inside **one t3.small**.*  No Mongo downtime; Watchtower restarts **app** container only.

---

## Quick Start 🌱

> **Prereqs** AWS account (ECR + one EC2), GitHub repo, Ansible on laptop.

```bash
# 1) Fork & clone
 git clone <your‑fork>
 cd Todo‑List-nodejs

# 2) Edit .env (locally only)
 echo "MONGO_USER=admin\nMONGO_PASS=pass" > compose/.env

# 3) Push anything → CI builds & pushes :latest
 git commit --allow-empty -m "trigger"
 git push origin main

# 4) Provision VM in < 3 min
 ansible-playbook -i todo-inventory.ini playbooks/setup.yml
# → visits http://<vm-ip>:4000 ; app is live
```

---

## Repository Layout

| Path                       | What is it                                                                                   |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| `Dockerfile`               | Multi‑stage Node 20‑alpine, exposes port 4000, has `HEALTHCHECK`                             |
| `compose/compose.yml`      | app + mongo + watchtower with labels & health‑checks                                         |
| `playbooks/setup.yml`      | One‑shot installer: Docker, compose‑plugin v2, awscli, ECR login service, copy & run compose |
| `.github/workflows/ci.yml` | Buildx → ECR (`latest` + SHA) with OIDC role                                                 |
| `images/`                  | Place all PNG/JPG screenshots & the diagram here                                             |

---

## CI / CD ✈️

1. **Build** with Buildx → cross‑platform manifest list.
2. **Push** to private ECR with both tags.
3. **Deploy** Watchtower pulls `latest`; Mongo unaffected thanks to label filtering.

Key snippet:

```yaml
tags: |
  ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY }}:latest
  ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY }}:${{ github.sha }}
```

---

## Ansible Playbook Highlights

```yaml
shell: curl -fsSL https://get.docker.com | sh -   # installs docker + compose‑plugin v2
copy: src=compose/ dest=/home/ubuntu/compose/      # pushes stack files
command: |
  docker compose -f compose.yml pull && \
  docker compose -f compose.yml up -d
```

* Includes a systemd unit `ecr-login.service` that refreshes token every 6 h.

---

## Health Checks ❤️‍🩹

* **app** — `/health` endpoint via `wget` (interval 30 s).
* **mongo** — `mongo --eval "db.runCommand('ping')"`.

If any fails, container goes **unhealthy** and Watchtower/Compose can react.

---

## Secrets

* **`.env`** ignored by git → lives only on the VM.
* Runtime pulls credentials from Env‑file; can be migrated to **AWS Secrets Manager** later.

---

## Roadmap ✍️

* [ ] Bonus — convert Compose → Helm chart, install on k3s/EKS
* [ ] Add HTTPS with ACM + ALB
* [ ] Use SSM Parameter Store for Mongo credentials

---

> *FortStak DevOps Internship — July 2025*
> Built by **Omar R.G.** with 🖤 & Ansible.

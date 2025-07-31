# CICD-todo-nodejs-app

A production-ready **Todo list REST API** built with **Node.js + Express** and delivered through a fully-automated **CI/CD pipeline** all the way to Kubernetes using **Argo CD**.

> **Two repositories work together**
>
> | Repo | What it holds | Git URL |
> | ---- | ------------- | ------- |
> | **Application / CI pipeline** | Source code, tests, Dockerfile, GitHub Actions workflows | **(this repo)** |
> | **Infrastructure / GitOps**  | Kubernetes manifests, Kustomize overlays, Argo CD config | <https://github.com/OmarIRG/infra-repo> |

---

## Quick start

```bash
git clone https://github.com/<your-org>/CICD-todo-nodejs-app.git
cd CICD-todo-nodejs-app
cp .env.example .env        # adjust variables
npm ci && npm run dev       # Swagger → http://localhost:3000/api-docs
```

---

## What we actually did – step by step

| #  | Milestone | Key commands / notes | Proof of Work |
|--- |-----------|----------------------|---------------|
| 1  | **Add `.dockerignore`** | Removed `node_modules`, docs, etc. from build context. | — |
| 2  | **Create `Dockerfile` & build image** | `docker build -t todo-app:dev .` | ![docker ps output](images/Docker%20ps.jpg) |
| 3  | **Run container locally** | `docker run -p 3000:3000 todo-app:dev` | ![App running locally](images/App.jpg) |
| 4  | **Verify MongoDB connection** | Seeded one todo, confirmed persistence. | ![Database test](images/Database%20test.jpg) |
| 5  | **Wire up GitHub Actions CI** | Lint → test → build stages. | ![CI pipeline success](images/ci-success.jpg) |
| 6  | **Store pipeline secrets** | `DOCKER_USERNAME`, `DOCKER_TOKEN`, `KUBE_CONFIG_DATA`. | ![GitHub Secrets](images/Github%20Secrets.jpg) |
| 7  | **Draft `docker-compose.yml`** | App + Mongo for local dev. | ![Trying docker compose](images/Trying%20docker%20compose.jpg) |
| 8  | **Run Compose stack** | `docker compose up -d` – services healthy. | ![docker compose ps](images/compose-ps.jpg) |
| 9  | **Bootstrap k3s with Ansible** | Idempotent playbooks. | ![Ansible Working](images/Ansible%20Working.jpg)<br>![ansible-playbook run](images/ansible-playbook.jpg)<br>![ansible-playbook 2nd run](images/ansible-playbook%202.jpg) |
| 10 | **Expose K8s Service (NodePort)** | Verified external connectivity. | ![nodeport service](images/nodeport.jpg) |
| 11 | **Set up Argo CD** | Added `Application` CR in *infra-repo*. | ![Argo CD operational](images/argo%20cd%20working.jpg) |
| 12 | **First successful Argo CD sync** | Green ✔️ – app live via Ingress. | ![Argo CD app healthy](images/argo%20cd%20app%20working.jpg) |

---

## High-level architecture

![Architecture](images/Arch.png) 

## CI / CD details

### CI (`.github/workflows/ci.yml`)

| Job | Action |
|-----|--------|
| **install** | `npm ci` |
| **test**    | `npm test --coverage` |
| **build_push** | Build multi-arch image, push to Docker Hub |

### CD (`.github/workflows/cd.yml`)

1. Check out **`infra-repo`**.  
2. Patch image tag in `k8s/base/deployment.yaml`.  
3. Commit back to **`infra-repo`**.  
4. Argo CD auto-syncs and rolls out.

---

## License

MIT – see `LICENSE`.

---

## Authors

*DevOps Internship Member – Summer 2025*  
– **Omar Islam.** (<https://github.com/OmarIRG>)  

# CICD-todo-nodejs-app

A production-ready **Todo list REST API** built with **Node.js + Express** and shipped through a fully-automated **CI/CD pipeline** all the way to Kubernetes using **Argo CD**.

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
cp .env.example .env     # adjust variables
npm ci && npm run dev    # Swagger → http://localhost:3000/api-docs
```

---

## 1 · Project parts & completion status

| Part | What it covers | Status |
|------|----------------|:------:|
| **Application code** | Express API, routing, validation, Swagger docs | ✅ |
| **Unit testing**     | Jest + SuperTest with >80 % coverage         | ✅ |
| **Lint & formatting**| ESLint + Prettier enforced in CI             | ✅ |
| **Dockerisation**    | `Dockerfile`, multi-arch image build         | ✅ |
| **.dockerignore**    | Slim build context → faster layers           | ✅ |
| **Docker Compose**   | Local dev stack (API + Mongo)                | ✅ |
| **CI pipeline**      | GitHub Actions: install → lint → test → build | ✅ |
| **Secrets management** | GitHub encrypted secrets (Docker Hub & K8s) | ✅ |
| **Ansible automation** | Provision k3s single-node lab              | ✅ |
| **Kubernetes manifests** | Deployment, Service, Ingress              | ✅ |
| **NodePort exposure** | Manual smoke test on cluster                | ✅ |
| **GitOps repo**      | All K8s YAML tracked in *infra-repo*         | ✅ |
| **Argo CD setup**    | Application CR + automatic sync              | ✅ |
| **First green sync** | App healthy & reachable via Ingress          | ✅ |

Every checkbox is **done** – the entire pipeline is live end-to-end.

---

## 2 · What we actually did – step by step

| # | Milestone | Key commands / notes | Proof of Work |
|---|-----------|----------------------|---------------|
| 1 | **Add `.dockerignore`** | Removed `node_modules`, docs, etc. from build context. | — |
| 2 | **Create `Dockerfile` & build image** | `docker build -t todo-app:dev .` | ![docker ps](images/Docker%20ps.jpg) |
| 3 | **Run container locally** | `docker run -p 3000:3000 todo-app:dev` | ![App running locally](images/App.jpg) |
| 4 | **Verify MongoDB connection** | Seeded one todo, confirmed persistence. | ![DB test](images/Database%20test.jpg) |
| 5 | **Wire up GitHub Actions CI** | Lint → test → build stages. | ![CI success](images/ci-success.jpg) |
| 6 | **Store pipeline secrets** | `DOCKER_USERNAME`, `DOCKER_TOKEN`, `KUBE_CONFIG_DATA`. | ![Secrets](images/Github%20Secrets.jpg) |
| 7 | **Draft `docker-compose.yml`** | App + Mongo for local dev. | ![Compose draft](images/Trying%20docker%20compose.jpg) |
| 8 | **Run Compose stack** | `docker compose up -d` → services healthy. | ![Compose ps](images/compose-ps.jpg) |
| 9 | **Bootstrap k3s with Ansible** | Idempotent playbooks. | ![Ansible](images/Ansible%20Working.jpg)<br>![Playbook 1](images/ansible-playbook.jpg)<br>![Playbook 2](images/ansible-playbook%202.jpg) |
|10 | **Expose K8s Service (NodePort)** | Verified external connectivity. | ![NodePort](images/nodeport.jpg) |
|11 | **Set up Argo CD** | Added `Application` CR in *infra-repo*. | ![Argo CD](images/argo%20cd%20working.jpg) |
|12 | **First successful Argo CD sync** | Green ✔ – app live via Ingress. | ![Argo CD app](images/argo%20cd%20app%20working.jpg) |

---

## 3 · High-level architecture

![Architecture](images/Arch.png)

---

## 4 · CI / CD details

### CI (`.github/workflows/ci.yml`)

| Job | Action |
|-----|--------|
| **install**   | `npm ci` |
| **lint**      | ESLint + Prettier |
| **test**      | `npm test --coverage` |
| **build_push**| Build multi-arch image, push to Docker Hub |

### CD (`.github/workflows/cd.yml`)

1. Check out **`infra-repo`**.  
2. Patch image tag in `k8s/base/deployment.yaml`.  
3. Commit back to **`infra-repo`**.  
4. Argo CD auto-syncs and rolls out.

---

## 5 · Local recipes

| Task | Command |
|------|---------|
| Run tests   | `npm test` |
| Lint code   | `npm run lint` |
| Build image | `docker build -t todo-app:dev .` |
| Dev stack   | `docker compose up -d` |

---

## License

MIT – see `LICENSE`.

---

## Authors

*DevOps Internship Member – Summer 2025*  
**Omar Islam** – <https://github.com/OmarIRG>

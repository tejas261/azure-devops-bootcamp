# Lab 03 — Jenkins: setup from scratch + debug a broken pipeline
Time: 6-8 h. Cost: one B2s VM (auto-shutdown at 19:00 IST built in).

JD: "Expertise in Jenkins with solid experience setting up CI/CD pipelines from scratch."

## Part A — Setup
```bash
cd terraform
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init
terraform apply -var "my_ip_cidr=$(curl -s ifconfig.me)/32" -var "ssh_public_key_path=~/.ssh/id_rsa.pub"
```
Wait ~4 minutes (cloud-init). Get the admin password:
`ssh azureuser@<ip> 'sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword'`
then open http://<ip>:8080.

Tasks:
1. Finish setup wizard, install: Pipeline, Git, Credentials Binding, Docker Pipeline, Blue Ocean optional, Pipeline: Stage View, Warnings NG.
2. Create credentials (Azure SP or ACR token, GitHub PAT) in Jenkins credentials store. Never in the Jenkinsfile.
3. Put `../sample-app` in your own GitHub repo. Create a **Multibranch Pipeline** job + webhook (or poll SCM if webhook is hard).
4. Write a Jenkinsfile from scratch (declarative): checkout -> unit tests (pytest, publish JUnit) -> build image -> Trivy scan (fail on CRITICAL) -> push to ACR (tag = short SHA) -> deploy to dev on AKS via `kubectl`/kustomize -> smoke test (`curl /healthz`) -> manual approval -> prod only from `main`.
5. Use ephemeral Docker agents for build steps rather than the controller. Explain why builds on the controller are a security and stability problem.
6. Config as code: put the Jenkins config in JCasC YAML. Backup/restore `jenkins_home`.

## Part B — Debug: `broken-pipeline/Jenkinsfile.broken`
Copy it into a repo as `Jenkinsfile` and run. It has at least 10 distinct defects across syntax, credentials, shell quoting, Docker permissions, branching logic and security. Find each from the **console output**, not by staring. Keep a log: error line -> cause -> fix.
Also debug the platform itself: after step 4, run `sudo docker stop jenkins && sudo docker start jenkins` — are your jobs still there? Why/why not? Then fill the disk with a big build workspace; what breaks and how do you reclaim space?

## Known lab shortcut (talking point, not a best practice)
cloud-init runs `chmod 666 /var/run/docker.sock` so the Jenkins container can use Docker. That is effectively root on the host for anyone who can run a job. Write down 3 better alternatives (rootless/ephemeral agents, Kaniko/BuildKit, ACR Tasks) and implement one (`az acr build`).

## Teardown
`terraform destroy -var "my_ip_cidr=0.0.0.0/32"` (value is irrelevant for destroy).

## Deliverable
Working repo + Jenkinsfile + `debug-log.md` + incident report (template) for the most painful failure.

## Free bonus incident
The VM auto-shuts at 19:00 IST. Start it next morning and re-run a build. It will probably fail with `permission denied ... docker.sock`. Why does the `chmod` not survive a reboot? Fix it properly (hint: not by repeating chmod). Write the incident report.

# Lab 03 solutions — Jenkinsfile.broken defects
1. `agent none` + `git` in Checkout: "Required context class hudson.FilePath is missing". Use a top-level agent or stage agent; `checkout scm` in multibranch.
2. `ACR_PASSWORD` hardcoded in `environment`: secret in SCM. Remove; use `credentials('id')` / `withCredentials`. Rotate it (it's in git history).
3. Test stage: `junit 'reports.xml'` but pytest wrote `report.xml` -> "No test report files were found". Also containers run as the jenkins uid: `pip install` may fail on read-only HOME -> `pip install --user` or `args '-e HOME=/tmp'`.
4. Build stage `agent any`: new workspace, no sources checked out -> Dockerfile not found. One agent for the whole pipeline or `stash/unstash`.
5. `$GIT_COMMIT_SHORT` doesn't exist -> empty tag, "invalid reference format". Compute `env.GIT_COMMIT.take(7)` or `git rev-parse --short HEAD`.
6. Push `when { branch 'master' }`: repo uses `main`; `branch` condition works only in multibranch jobs. Also this stage has no agent (global `none`) -> "Required context class... missing"/"docker: command not found".
7. Credentials ID `acr-creds` must exactly match the ID in Jenkins -> "Could not find credentials entry".
8. Deploy: `sh(returnStdout:true)` without `.trim()` -> trailing newline in image tag. No agent, no kubeconfig/credentials, `kubectl` not installed in controller.
9. Approve: `input` inside `steps` holds an executor while waiting; use the `input` directive on the stage (before the agent allocation) with a `timeout` and `submitter`.
10. Prod deploy uses `:latest`: not what was tested; mutable tag. Promote the exact SHA/digest.
11. `post.failure.mail`: no SMTP configured -> silently useless; use Slack/Teams/email extension with configured creds. No `cleanWs()`/`docker image prune` -> disk fills (see lab bonus).
12. No `options { timeout(...); disableConcurrentBuilds(); buildDiscarder(...) }`, no `timestamps()`.
13. Reboot bonus: `chmod 666 /var/run/docker.sock` is reset when the Docker socket is recreated at boot -> `permission denied while trying to connect to the Docker daemon socket`. Proper fix: don't expose the host socket; use ephemeral build agents, rootless BuildKit/Kaniko, or `az acr build`.

## Reference incident report — "Nightly builds failing after VM restart"
| | |
|---|---|
| Severity | SEV3 (no customer impact, delivery blocked) |
| Impact | All Jenkins builds failed from 08:55 to 10:20 (85 min); 3 hotfix deploys delayed |
| Timeline | 08:55 first red build; 09:10 engineer retried; 09:25 console shows `permission denied ... docker.sock`; 09:40 compared `ls -l /var/run/docker.sock` (660 root:docker); 10:05 realised VM auto-shutdown/start recreated the socket; 10:20 temporary chmod, builds green |
| Root cause | Permission was applied once by cloud-init `runcmd` (per-instance) and never persisted. Contributing: the Jenkins container accessed the host Docker socket directly; shutdown schedule not documented; no alert on build failure rate |
| Resolution | Temporary `chmod 666` (restored service, known insecure) |
| Next steps | (1) Replace socket mount with ephemeral Docker/ACR Tasks builds — prevent, owner you, +1 week. (2) Alert if >2 consecutive failed builds on main — detect, +2 days. (3) Document VM schedule + startup checks in README — mitigate, +1 day. (4) Add a nightly synthetic "hello" pipeline run — detect, +3 days |

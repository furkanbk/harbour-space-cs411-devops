# Challenge 1
- how to rename the folder name to app without breaking git references?

- how to make a go build for windows amd64 system?

- check the following binary build for windows versus my original build file ./main, what are the differences?

- Check the stripped build vs original build, explain me the differences, what does strip flags do?

- Scenario. You build ./main on the playground's jenkins machine and it runs perfectly. You copy the binary to a fresh Ubuntu 18.04 VM at a customer site and run ./main. The terminal prints:
./main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by ./main)
Provide me 5 hypotheses that would explain this error.

- What are some options to statically link the binary?

# Challenge 4

- I've got the Docker build and push stages from the previous challenge working. What's the cleanest way to integrate those into my current Kubernetes deployment pipeline?

- My Jenkins pipeline is failing at the kubectl step with an "Authentication required" error. What's the typical pattern for passing credentials to kubectl in a Jenkins declarative pipeline?

- so I need to pass --server, --token, and --insecure-skip-tls-verify to both kubectl commands. Can you show me the updated pipeline syntax?

- I want to add liveness and readiness probes to my Pod spec. Since kubectl run can't generate those, what's the best approach - write the manifest manually or patch the generated YAML?

- kubectl apply is failing because I'm trying to add probes to an existing Pod. Kubernetes doesn't allow updating those fields in-place. What's the right way to handle this - delete and recreate, or use replace --force?

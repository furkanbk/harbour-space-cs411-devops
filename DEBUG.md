# CHALLENGE 1
- After creating hypotheses with claude and deepseek, the following two are the most reasonable causes:
-- Jenkins has its on VM with a certain Ubuntu version. Each Ubuntu comes with a certain glibc version.
  - IF The build is not static then the linker tries to obtain the version from the built machine dynamically on runtime and fails on an older glibc version.
-- Second reason could be due to a third-party .so contaminating our initial glibc version requirement.
  - Due to this, we may ship a glibc requirement much newer than we are aware of.


- I would run ldd --version on our machine. This shows all dynamic listings hence I can
  - Compare whether due to a third party library our glibc requirements changed without noticing

- Seems like CGO_ENABLED=0 flag solves the issue by making the binary bring everything it needs baked in, so it doesn't have to ask the target machine for any libraries at all.
So it can be a good idea to make static baked builds for reproducibility

- It seems important to always be aware of client's OS and glibc version, and if
the high compatibility is important, use static builds, because go libraries seem to use dynamic linking by default.

# CHALLENGE 4

If the image had expired on ttl.sh, the Jenkins machine would have failed to pull it too. 
Because Jenkins pulled it successfully, the image definitely still exists.
Since the image exists, the issue must entirely on the Kubernetes cluster side

Hypothesis 1) Your Jenkins machine has direct outbound internet access, but your Kubernetes worker nodes likely do not. Many enterprise clusters route worker node traffic through an HTTP/HTTPS proxy or a strict firewall.
I would check if kubectl run fails for the known images on other registries first, to see if this issue is specific to ttl.sh domain

Hypothesis 2) The worker nodes might be unable to translate the domain name ttl.sh into an IP address (because they are using internal DNS servers)
I would run: kubectl describe pod <your-pod-name> . I asked llm to what output corresponds to what. and the answer I got is 
"Look at the Events section at the very bottom:If you see connection refused or i/o timeout, it is a network firewall/proxy block.If you see no such host, it is a DNS issue."

Fix: depending on the output, make sure the DNS is properly configured and ttl.sh is properly accessible inside k8s cluster.

LEsson: Just because your machine can access an external registry doesn't mean the cluster's worker nodes share the same network access, DNS routing, or firewall permissions.

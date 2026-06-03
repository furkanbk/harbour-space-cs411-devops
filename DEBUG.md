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


# CHALLENGE 5

**Hypothesis 1 - **EC2 Security Group is not allowing inbound TCP on port 4444 (more likely). The EC2 Security Group is  dropping packets tht target the port 4444 from the internet because no inbound rule permits that traffic; the request leaves my laptop, reaches AWS's and is discarded with no result sent back, which is why curl hangs rather than failing fast.

Verification: I would first go to AWS console and check the Security Group inbound rules.
EC2 → Instances → select instance → Security tab → click the Security Group → Inbound rules (like we did in the course)

**Hypothesis 2 -** A subnet Network ACL (NACL) is blocking traffic on port 4444. unlike Security Groups, NACLs are stateless and evaluate inbound and outbound rules independently; a missing or explicit-DENY inbound rule on port 4444, or a too-narrow outbound ephemeral-port range that blocks the return traffic, causes the SYN to be dropped (or the SYN-ACK to never leave the subnet). As NACLs are subnet-scoped and evaluated BEFORE the SG, so even a perfectly configured SG won't save us if the NACL has a DENY entry that fires first.

Verification: I would first go to AWS console and inspect the subnet's Network ACL rules
VPC → Subnets → select the instance's subnet → Network ACL tab → Inbound rules 

**Fix:** If the issue is hyptohesis 1, then add inbound rule to SG -> Custom TCP -  TCP - 4444 - 0.0.0.0/0
If the issue is hyptohesis to, add inbound and outbound rules for the problematic subnet to allow access on port 4444 and on source 0.0.0.0/0

**One line summary:** A Security Group is a stateful bouncer at the instance door — allow in, return is automatic; a NACL is a stateless checkpoint at the subnet gate — it checks every packet independently, in rule order, before traffic ever reaches your instance.



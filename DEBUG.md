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



# CHALLENGE 3

- 1) Most likely reason that comes to my mind is since the image is built on my laptop, the built binary may have been built with the go args specific to my computer's OS and CHIP, meaning the built itself may not be compatible with x86_64 and hence fails
   -- Verification step: run "uname -m" on VM, it will return "x86_64", and then check it against the binary of ./main (for example using an LLM)  
  2) Second reason could be that since the scenario never says that it ever run on my computer properly, I would assume the dockerfile itself may contain conflicting OS image versus the given binary build. Due to this incompatibility, it would never run.
  -- command "docker buildx imagetools inspect ttl.sh/<your-name>:2h" will enable reviewing the metadat of the remote image and check for its platform. Check if it seems incompatible with the build binary.


     My fix: "docker buildx build --platform linux/amd64 ."

     This way we specifically mention what cpu architecture we are building to.
   

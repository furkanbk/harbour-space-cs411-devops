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
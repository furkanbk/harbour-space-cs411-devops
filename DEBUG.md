# Challenge 1
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

# Challenge 2

Hypothesis 1) The Jenkins deploy step starts the application by ./main attached to the SSH session, meaning that the process itself is foregoround session. Hence when the session ends by any reason (ssh closes) the server dies, hence no longer produces response. In our case, if jenkins stage is an ssh command, then when the command finishes ssh exits, hence server dies. We can no longer ssh and access to same session again.

Verification: ps -ef | grep main , and check if TTY is there. if not, the ssh died.

Hypothesis 2) The app is only binding to localhost (127.0.0.1:4444) instead of all interfaces (0.0.0.0:4444), so external curls get "Connection refused" even though localhost works, so curl localhost:4444 succeeds on target, but remote access fails, which commonly happens when the service is not listening on the external interface.

Verification: ss -ltnp | grep 4444, check if this shows only localhost ip.

My fix: Start the app detached from the SSH session so it survives after Jenkins disconnects. We can use 'nohup ./main > app.log 2>&1 &' 
nohup. nohup means “no hangup.” Here I chatgpt'd it, it says "Normally, when an SSH session or terminal closes, the shell sends a SIGHUP signal to child processes, which usually makes them exit nohup tells the process to ignore that signal, so it keeps running after the session disconnects."

underlying lesson: a process merely “existing” means it happens to be running at the moment, while a supervised process is started independently of user sessions and automatically kept alive or restarted by something managing its lifecycle.

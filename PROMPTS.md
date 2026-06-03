# CHALLENGE 1
- how to rename the folder name to app without breaking git references?

- how to make a go build for windows amd64 system?

- check the following binary build for windows versus my original build file ./main, what are the differences?

- Check the stripped build vs original build, explain me the differences, what does strip flags do?

- Scenario. You build ./main on the playground's jenkins machine and it runs perfectly. You copy the binary to a fresh Ubuntu 18.04 VM at a customer site and run ./main. The terminal prints:
./main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by ./main)
Provide me 5 hypotheses that would explain this error.

- What are some options to statically link the binary?

# Challenge 2
- for the ssh, I created the following credentials in the jenkins, use the withCredentials format in the jenkinsfile to connect to target machine Target machine to ssh is defined as laborant@target ssh key id is TARGET_SSH_KEY. 
- Describe me the syntax of the unit file needed on the target
- how to switch the current per-user systemd task to a system-level unit?
- how to make sure the restart happens on on-failure?
# CHALLENGE 3
- Write a terraform/main.tf that declares aws_instance, aws_security_group, and aws_key_pair. How should I structure the variables and outputs? Run terraform apply from the Jenkins pipeline using credentials stored in Jenkins.

- My terraform files are being gitignored and I need to push them to the repo. What's the correct .gitignore configuration for Terraform projects?

- I noticed I hardcoded AWS resource IDs and a public IP address in my Jenkinsfile. Are these considered sensitive information that shouldn't be in version control?

- The pipeline is failing with "InvalidAMIID.NotFound" in eu-north-1. How do I find the correct Ubuntu AMI ID for a specific region using the AWS CLI?

- Why does the Jenkins pipeline need explicit AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY credentials when Terraform applies, even though I already have an AWS SSH key for deployment? Also, since Terraform creates a new EC2 instance each time, how do I handle the dynamic public IP in the Jenkinsfile instead of hardcoding it?

- The homework checker seems to not complete when validating my terraform/ directory. What are common issues that cause Terraform validation to fail or hang in automated checkers?

- Update PROMPTS.md with these questions in a concise format.

#!/bin/bash
# Cloudinit script
# - to store in OBS s3://obs-jla-repo
# - to execute through cloudinit running the following command
#   curl https://obs-jla-repo.oss.eu-west-0.prod-cloud-ocb.orange-business.com/EcsInit.sh | tee EcsInit.sh && chmod 755 EcsInit.sh && ./EcsInit.sh

# Install ICAgent for LTS [ECS Logs collect]
# 1. Setup the ICAgent                          : Done
# 2. Configure the log path for log collect     : Todo
sudo bash -c "curl http://icagent-eu-west-0.oss.eu-west-0.prod-cloud-ocb.orange-business.com/ICAgent_linux/apm_agent_install.sh > apm_agent_install.sh && REGION=eu-west-0 bash apm_agent_install.sh -accessip 100.125.0.94 -obsdomain oss.eu-west-0.prod-cloud-ocb.orange-business.com;"

# Install Agent for CES [ECS Monitoring]
# 1. Install the Agent                          : Done
# 2. Other? Agency?                             : Todo
sudo bash -c "cd /usr/local && curl -k https://telescope-eu-west-0.oss.eu-west-0.prod-cloud-ocb.orange-business.com/scripts/agentInstall.sh | tee agentInstall.sh && chmod 755 agentInstall.sh && ./agentInstall.sh"

# Install HwAgent for HSS [security management for ECS]
# 1. Install the HwAgent                        : Done
# 2. Enable the ECS                             : Todo
sudo bash -c "wget --no-check-certificate 'https://hss-agent.oss.eu-west-0.prod-cloud-ocb.orange-business.com/linux/HwAgentInstall_64.sh' && chmod +x HwAgentInstall_64.sh && ./HwAgentInstall_64.sh"

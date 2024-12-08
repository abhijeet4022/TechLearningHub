# See the service file location
systemctl show -p FragmentPath jenkins

# Change the old IP from jenki config
cat /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml
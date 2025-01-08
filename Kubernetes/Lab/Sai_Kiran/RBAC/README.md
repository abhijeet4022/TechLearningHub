apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: XXXXXXXXXXXXXXXXXXX
      server: https://api.learntechnology.cloud
      tls-server-name: api.internal.learntechnology.cloud
    name: learntechnology.cloud
contexts:
  - context:
      cluster: learntechnology.cloud
      namespace: development
      user: abhijeet
    name: abhijeet-context
current-context: abhijeet-context
kind: Config
users:
  - name: abhijeet
    user:
      client-certificate: /cert/abhijeet.crt
      client-key: /cert/abhijeet.key
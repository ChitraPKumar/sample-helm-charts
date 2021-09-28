# Admission Controller Helm Chart

Instructions for using HELM charts to deploy the Lacework-Dev Admission Controller.

## Contents

- [Admission Controller Helm Chart](#admission-controller-helm-chart)
    - [Prerequisites](#prerequisites)
        - [Clone the Repository](#clone-the-repository)
        - [Generate Certificates](#generate-certificates)
    - [Deploy the HELM chart](#deploy-the-helm-chart)
        - [Deploy Helios Admission Controller](#deploy-helios-admission-controller)
    - [Configurable parameters](#configurable-parameters)
    - [Issues and feedback](#issues-and-feedback)

## Prerequisites

### Clone the Repository

```bash
git clone https://github.com/lacework-dev/helios-go
```

### Generate Certificates

You can generate these certificates by executing the script:

```
./helm/generate-certs.sh
```

You can also use your own certificates without generating new ones for TLS authentication. All we need is a root CA certificate, a certificate signed by a CA, and a certificate key.

You can optionally configure the certificates generated from the script above in the ```values.yaml``` file.

You need to encode the certificates into base64 for ```ca.crt```, ```helios.crt``` and ```helios.key``` using this command:

```
cat <file-name> | base64 | tr -d '\n'
```

Provide the certificates previously obtained in the fields of the ```values.yaml``` file, as indicated here:

```
certs:
  name: helios-admission-certs
  serverCertificate: "<base64_encoded_helios.crt>"
  serverKey: "<base64_encoded_helios.key>"

webhooks:
  caBundle: "<base64_encoded_ca.crt>"
```

## Deploy the HELM chart

### Deploy Helios Admission Controller

1. Update the Helm charts `values.yaml` file with your environment's custom values (lacework account, key, secret, etc...)

2.

   First, create a namespace on that cluster named `lacework-dev`:
   ```bash
   $ kubectl create namespace lacework-dev
   ```
   Next, run the following command:

   ```shell
   $ helm install --namespace lacework-dev helios ./helm 
   ```


## Configurable parameters

| Parameter                         | Description                                                                 | Default                   | Mandatory               |
| --------------------------------- | --------------------------------------------------------------------------- | ------------------------- | ----------------------- |
| `logger.debug           `         | Set to enable debug logging                                                 | `false`                   | `YES`                   |
| `certs.create`                    | Set to create new secret for Helios certs                                   | `false`                   | `YES`                   |
| `certs.name`                      | Secret name for Helios certs                                                | `helios-admission-certs`  | `YES`                   |
| `certs.serverCertificate`         | Certificate for TLS authentication with the Kubernetes api-server           | `N/A`                     | `YES`                   |
| `certs.serverKey`                 | Certificate key for TLS authentication with the Kubernetes api-server       | `N/A`                     | `YES`                   |
| `webhooks.caBundle`               | Root certificate for TLS authentication with the Kubernetes api-server      | `N/A`                     | `YES`                   |
| `lacework.account`                | Your Lacework Account Name                                                  | `N/A`                     | `YES`                   |
| `lacework.api_key`                | Your Lacework API Token                                                     | `N/A`                     | `YES`                   |
| `lacework.api_secret`             | Your Lacework API Secret                                                    | `N/A`                     | `YES`                   |
| `policy.block_exec   `            | Set to enable deployment/pod block based on violation                       | `false`                   | `YES`                   |
| `policy.bypass_scope`             | CSV of namespaces to bypass                                                 | `kube-system,kube-public,lacework,lacework-dev`     | `YES`                   |
| `policy.opa`                      | Set to enable external OPA Server validation                                | `false`                   | `YES`                   |
| `policy.server`                   | Address of the OPA Server (https://<url>)                                   | `N/A`                     | `NO`                   |
| `policy.port`                     | Port of the OPA Server                                                      | `8443`                    | `NO`                   |
| `nodeSelector`                    | Kubernetes node selector                                                    | `{}`                      | `NO`                    |



## Issues and feedback

If you encounter any problems or would like to give us feedback on this deployment, we encourage you to raise issues here on GitHub.
PAM PoC Business App 
====================

To build and deploy to OpenShift:

1. Build `pam-poc-model`:

    ```
    cd ../pam-poc-model
    mvn clean install
    ```

1. Build `pam-poc-kjar`:

    ```
    cd ../pam-poc-jar
    mvn clean install
    ```

1. Create and kick off an OpenShift build:

    ```
    oc new-build --binary --strategy=docker --name pam-poc-service
    oc start-build pam-poc-service --from-dir=. --follow
    ```

To configure monitoring with Prometheus and Grafana:

1. Ensure that the Prometheus and Grafana operators are installed.

1. Create a Prometheus instance:

    ```
    oc apply -f monitoring/prometheus-cr.yaml
    ```

1. Configure Prometheus to scrape PAM PoC metrics:

    ```
    oc apply -f monitoring/service-monitor.yaml
    ```

1. Create a Grafana instance:

    ```
    oc apply -f monitoring/grafana-cr.yaml
    ```

1. Configure theGrafana datasource instance:

    ```
    oc apply -f monitoring/grafana-datasource.yaml-cr.yaml
    ```

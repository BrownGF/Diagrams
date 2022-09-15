
# How to use Dapr
[Official Doc](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)
## Prerequisites

-   Install  [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/)
-   Install  [kubectl](https://kubernetes.io/docs/tasks/tools/)
-   Kubernetes cluster

# Setup Infra

##  Setup Dapr บน Kubernetes
`dapr init -k`
ติดตั้ง Dapr บน kubernetes โดยอ้างอิงตาม context ปัจจุบันของ kubectl

จะมี Application ต่าง ๆ ของ Dapr อยู่ใน dapr-system namespace เกิดขึ้นมา

## เปิดช่องทางให้ Dapr สามารถเชื่อมต่อได้จากด้านนอก
ให้ภายนอกเชื่อมต่อเข้ามาได้ผ่าน Ingress
https://carlos.mendible.com/2020/04/05/kubernetes-nginx-ingress-controller-with-dapr/

# Setup Application และ Example สำหรับ Gofive

## ใส่ Sidecar Dapr ให้ Deployment
เพิ่ม annotation เข้าไปใน metadata
```yaml
annotations:
  dapr.io/enabled: "true"
  # app-id เอาไว้อ้างอิงจาก app ตัวอื่นด้วย
  dapr.io/app-id: "crm"
  # app-port ให้ match กับ ContainerPort
  dapr.io/app-port: "80"
  dapr.io/enable-api-logging: "true"
```

Example
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crm
  labels:
    app: crm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crm
  template:
    metadata:
      labels:
        app: crm
      annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "crm"
        dapr.io/app-port: "80"
        dapr.io/enable-api-logging: "true"
    spec:
      containers:
        - name: crm
        image: docker.gofive.io/crm:v1
        ports:
          - containerPort: 80
        imagePullPolicy: Always
```

## ตัวอย่างการเปลี่ยนให้ระบบยิงผ่าน Dapr
แก้ configuration env ให้เป็นไปตาม Dapr


ตัวอย่างจาก 
Venio.BLL\Services\ActivityService.cs ใน **FindDistance** function
```c#
var url =  $"{urlsConfig.LocationService}{UrlsConfig.LocationOperations.DistanceMatrix(startlat, startlong, endlat, endlong)}";
using var response = await  httpClient.SendGetAsync(url);
string data = await response.Content.ReadAsStringAsync();
```

เทียบตาม config ตอนนี้ก็จะเป็น
`https://veniouat.southeastasia.cloudapp.azure.com/api/location/places/distance-matrix?origin={startlat},{startlong}&destination={endlat},{endlong}`

### วิธีเปลี่ยนไปใช้ Dapr คือการเปลี่ยนค่า config ให้ตรงกับ endpoint ของ Dapr

ตัวอย่าง url ที่อยู่บน Dapr
`https://<ingress ip>/v1.0/invoke/<app-id>/method/<method>`

`https://<ingress ip>/v1.0/invoke/<app-id>/method/location/places/distance-matrix?origin={startlat},{startlong}&destination={endlat},{endlong}`

### แก้ urlsConfig
urlsConfig.LocationService จาก `https://veniouat.southeastasia.cloudapp.azure.com/api/location/`
 ก็เขียนเป็น `https://<ingress-ip>/v1.0/invoke/<app-id>/method/` เป็นต้น

และ UrlsConfig.LocationOperations.DistanceMatrix    ก็ไว้ตามเดิม

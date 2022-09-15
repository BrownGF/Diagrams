# How to use Dapr
[Official Doc](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)
## Prerequisites

-   Install  [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/)
-   Install  [kubectl](https://kubernetes.io/docs/tasks/tools/)
-   Kubernetes cluster

## Setup Infra

###  Setup Dapr บน Kubernetes
`dapr init -k`
ติดตั้ง Dapr บน kubernetes โดยอ้างอิงตาม context ปัจจุบันของ kubectl

จะมี Application ต่าง ๆ ของ Dapr อยู่ใน dapr-system namespace เกิดขึ้นมา

### เปิดช่องทางให้ Dapr สามารถเชื่อมต่อได้จากด้านนอก
ให้ภายนอกเชื่อมต่อเข้ามาได้ผ่าน Ingress
https://carlos.mendible.com/2020/04/05/kubernetes-nginx-ingress-controller-with-dapr/

### Pub/sub message broker
Create State store component โดยใช้ redis
```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
  namespace: default
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: <REPLACE WITH HOSTNAME>
  - name: redisPassword
    secretKeyRef: # <REPLACE WITH YOUR SECRET>
      name: redis
      key: redis-password
  # uncomment below for connecting to redis cache instances over TLS (ex - Azure Redis Cache)
  # - name: enableTLS
  #   value: true 
```

Create Pub/sub message broker component (ตัวอย่างคือ redis)
ส่วน RabbitMQ ดู format ได้ตรงนี่: [Link](https://docs.dapr.io/reference/components-reference/supported-pubsub/setup-rabbitmq/)
อื่นๆ: [Link](https://docs.dapr.io/reference/components-reference/supported-pubsub/)
```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: pubsub # เอาไว้อ้างอิง pubsub name
  namespace: default
spec:
  type: pubsub.redis
  version: v1
  metadata:
  - name: redisHost
    value: <REPLACE WITH HOSTNAME>
  - name: redisPassword
    secretKeyRef: # <REPLACE WITH YOUR SECRET>
      name: redis
      key: redis-password
 # uncomment below for connecting to redis cache instances over TLS (ex - Azure Redis Cache)
  # - name: enableTLS
  #   value: true 
```

## Setup Application และ Example สำหรับ Gofive

### ใส่ Sidecar Dapr ให้ Deployment
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

### เปลี่ยนให้ระบบยิงผ่าน Dapr
แก้ configuration env ให้เป็นไปตามที่ Dapr วางไว้



1. ตัวอย่างจาก  Venio.API/Controllers/UserController.cs ใน **UpdateOnboarding** function
```c#
// เปลี่ยน UrlsConfig.GofiveCore ให้เป็นไปตาม Dapr endpoint

string url =  configuration.GetSection("UrlsConfig")["GofiveCore"].ToString();
url +=  "v1/Profiles/onboarding";

/*
ตาม url นี้ตอนแรกอาจเป็น
https://gofiveCore.api.com/v1/Profiles/onboarding
จะกลายเป็น
https://<ingress ip>/v1.0/invoke/<app-id>/method/v1/Profiles/onboarding
*/

var request =  new RequestOnboard { UserId = identityUserId, StatusOnboard = status };

var postContent =  JsonConvert.SerializeObject(request);
var httpClient =  clientFactory.CreateClient();

using  var message =  new HttpRequestMessage();
var token =  Request.Headers["Authorization"].ToString()[7..];

message.Headers.Authorization  =  new AuthenticationHeaderValue("Bearer", token);
message.Method  =  HttpMethod.Post;
message.RequestUri  =  new Uri(url);
message.Content  =  new StringContent(postContent, Encoding.UTF8, "application/json");

using  var response = await httpClient.SendAsync(message);
```

2. ตัวอย่างจาก Venio.BLL/Services/NotificationEmailService.cs ใน **GenEmailTemplateAsync** function 
```c#
var dataContent = new StringContent(JObject.FromObject(email).ToString(Newtonsoft.Json.Formatting.None), Encoding.UTF8, "application/json");
var httpClient = httpClientFactory.CreateClient("RabbitMailHttpClient");
await httpClient.SendPostAsync(urlsConfig.RabbitEmail, dataContent);
```

เราจะเปลี่ยนแค่ urlsConfig.RabbitEmail อย่างเดียว
ตัวอย่าง url ที่อยู่บน Dapr
`http://<ingress-ip>/v1.0/publish/<pubsub-name>/<topic>`
[อ้างอิง](https://docs.dapr.io/developing-applications/building-blocks/pubsub/howto-publish-subscribe/)

**การ track การเรียกใช้ของ pub/sub**
โดยปกติเราไม่สามารถ track การเรียกใช้ pub/sub ได้
ต้องเปลี่ยนการส่งข้อมูลเป็น CloudEvent โดยเริ่มจากการแก้ให้การ subscribe รองรับ Content-Type `application/cloudevents+json` (เช่น subscribe จาก SDK)

และการส่งข้อมูลไปต้องมี property เหล่านี้
id
source
specversion
type
traceparent
datacontenttype (optional)

ตัวอย่างการเรียกด้วย curl `curl -X POST http://localhost:3601/v1.0/publish/order-pub-sub/orders -H "Content-Type: application/cloudevents+json" -d '{"specversion" : "1.0", "type" : "com.dapr.cloudevent.sent", "source" : "testcloudeventspubsub", "subject" : "Cloud Events Test", "id" : "someCloudEventId", "time" : "2021-08-02T09:00:00Z", "datacontenttype" : "application/cloudevents+json", "data" : {"orderId": "100"}}'
`


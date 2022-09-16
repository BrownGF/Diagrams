workspace {

    model {
        companyEmployee = person "Company Employee" "An employee of the company"
        Venio = softwareSystem "Venio" "managing all your company's relationships and interactions with customers and potential customers. The goal is improve business relationships to grow your business." {
            venioAPI = container "Core API" "Legacy?" ".NET" {
                accountController = component "Account Controller" "Manage user credential,." ".NET MVC Rest Controller"
                account2Controller = component "Account2 Controller" "Manage user credential,." ".NET MVC Rest Controller"
            }
            activity = container "Activity API" "" ".NET"
            announcement = container "Announcement API" "" ".NET"
            contract = container "Contract API" "" ".NET"
            customer = container "Customer API" "" ".NET"
            expense = container "Expense API" "" ".NET"
            identity = container "Identity API" "" ".NET"
            notification = container "Notification API" "" ".NET"
            product = container "Product API" "" ".NET"
            quotation = container "Quotation API" "" ".NET"
            salesOrder = container "SalesOrder API" "" ".NET"
            report = container "Report API" "" ".NET"
            webApplication = container "Web Application" "Allows employees to view and manage information regarding the veterinarians, the clients, and their pets." "Java and Spring"
            database = container "Database" "Stores information regarding the veterinarians, the clients, and their pets." "Relational Database Schema"
        }

        companyEmployee -> webApplication "Uses"
        webApplication -> database "Reads from and writes to" "JDBC"
    }

    views {
        systemContext Venio {
            include *
            autolayout
        }

        container Venio {
            include *
        }
        
        styles {
            element "Component" {
                background #438dd5
                color #ffffff
            }
            element "Web Application" {
                color #801515
            }
            element "Software System" {
                background #801515
                shape RoundedBox
            }
            element "Financial Risk System" {
                background #550000
                color #ffffff
            }
            element "Future State" {
                opacity 30
            }
            element "Person" {
                background #d46a6a
                shape Person
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Asynchronous" {
                dashed true
            }
            relationship "Alert" {
                color #ff0000
            }
            relationship "Future State" {
                opacity 30
            }
       }
    }

}

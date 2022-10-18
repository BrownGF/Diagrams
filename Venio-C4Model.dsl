workspace {

    model {
        user = person "User"
        venio = softwareSystem "Venio System" {
            main = container "Main API" "" "Microservice"
            bff = container "Business Bff" "" "Microservice"
            activity = container "Activity Service" "" "Microservice"
            announcement = container "Announcement Service" "" "Microservice"
            contract = container "Contract Service" "" "Microservice"
            customer = container "Customer Service" "" "Microservice"
            expense = container "Expense Service" "" "Microservice"
            identity = container "Identity Service" "" "Microservice"
            notification = container "Notification Service" "" "Microservice"
            product = container "Product Service" "" "Microservice"
            quotation = container "Quotation Service" "" "Microservice"
            saleOrder = container "SaleOrder Service" "" "Microservice"
            storage = container "Storage Service" "" "Microservice"
            report = container "Report Service" "" "Microservice"
            location = container "Location Service" "" "Microservice"
            chat = container "Chat Service" "" "Microservice"
        }
        empeo = softwareSystem "empeo System" "" "empeo Tag" {
            
        }
        core = softwareSystem "Core System" "" "empeo Tag" {
            
        }
        rabbitmail = softwareSystem "Rabbit mail" {
            
        }
        clientPortal = softwareSystem "Client Portal" {
            
        }
        shortenURL = softwareSystem "Shorten URL" {
            
        }
        
        # Relation between systems
        venio -> empeo "Using"
        venio -> core "Using"
        
        # Relation between inside of Venio
        # main:
        main -> identity "Using"
        main -> storage "Using"
        main -> chat "Using"
        
        # bff:
        bff -> activity "Using"
        bff -> main "Using"
        bff -> customer "Using"
        bff -> product "Using"
        bff -> quotation "Using"
        bff -> saleOrder "Using"
        bff -> identity "Using"
        
        # activity:
        activity -> empeo "Using"
        activity -> chat "Using"
        activity -> core "Using"
        activity -> storage "Using"
        activity -> identity "Using"
        
        # announcement:
        announcement -> core "Using"
        announcement -> main "Using"
        
        # contract:
        contract -> identity "Using"
        contract -> main "Using"
        
        # customer:
        customer -> core "Using"
        customer -> chat "Using"
        customer -> identity "Using"
        
        # expense:
        expense -> main "Using"
        expense -> empeo "Using"
        expense -> core "Using"
        expense -> storage "Using"
        expense -> identity "Using"
        
        # identity:
        identity -> empeo "Using"
        identity -> main "Using"
        
        # notification:
        notification -> main "Using"
        notification -> rabbitmail "Using"
        notification -> empeo "Using"
        notification -> core "Using"
        
        # product:
        
        # quotation:
        quotation -> clientPortal "Using"
        quotation -> main "Using"
        quotation -> storage "Using"
        quotation -> identity "Using"
        
        # saleOrder:
        saleOrder -> identity "Using"
        
        # storage:
        
        # report:
        report -> identity "Using"
        
        # location:
        
        # chat:
        chat -> main "Using"
        chat -> shortenURL "Using"
        chat -> customer "Using"
        chat -> identity "Using"
        chat -> core "Using"
        
        # Relation between inside of Venio to other systems
        main -> core
        
    }

    views {
        systemContext venio {
            include *
            autolayout lr
        }

        container venio {
            include *
            autolayout lr
        }

        theme default
        
        styles {
            element "empeo Tag" {
                background #df643d
            }
        }
    }

}

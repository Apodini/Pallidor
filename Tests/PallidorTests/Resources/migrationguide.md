   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object" : {
                   "name" : "NewAddress"
               },
               "target" : "Signature",
               "original-id" : "Address"
           },
           {
               "object" : {
                   "name" : "Customer"
               },
               "target" : "Property",
               "replacement-id" : "address",
                "type" : "NewAddress",
              "custom-convert" : "function conversion(o) { return o }",
              "custom-revert" : "function conversion(o) { return o }",
               "replaced" : {
                   "name" : "address",
                   "type" : "[Address]"
               }
           }
       ]
   }

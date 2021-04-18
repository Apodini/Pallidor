{
  "openapi" : "3.0.3",
  "info" : {
    "title" : "Product API Suite",
    "description" : "This  **Product API** enables website teams and external third parties to retrieve information about products currently available in the product catalog\n\n# Changes in 1.3.0\n-  **Enhancement:**  Additional information provides for those pre-sell products which will accept an installment payment via a deposit mechanism *(SUN-9038)*\n  - The *paymentInstallmentSchedule* property is introduced on the *sku* object to support richer payment installment features.  This supercedes the *installments* property and as a result that property is now deprecated.",
    "contact" : {
      "email" : "apisupport@laithwaiteswine.com"
    },
    "version" : "1.3.1"
  },
  "servers" : [ {
    "url" : "https://virtserver.swaggerhub.com/Direct_Wines/ProductAPI/1.3.1",
    "description" : "SwaggerHub API Auto Mocking"
  }, {
    "url" : "/api",
    "description" : "This Website"
  } ],
  "paths" : {
    "/product/item/{itemCode}" : {
      "get" : {
        "tags" : [ "Product API Suite" ],
        "summary" : "Fetch the Product information based ont eh item code passed",
        "description" : "This API provides the production information based on the item code passed to it\n",
        "operationId" : "getItem",
        "parameters" : [ {
          "name" : "itemCode",
          "in" : "path",
          "description" : "The item code of the production\n",
          "required" : true,
          "style" : "simple",
          "explode" : false,
          "schema" : {
            "type" : "string"
          }
        } ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "content" : {
              "application/json" : {
                "schema" : {
                  "$ref" : "#/components/schemas/ProductAPIResponse"
                },
                "examples" : {
                  "getItem-PreSell-PSD-US" : {
                    "$ref" : "#/components/examples/getItem-PreSell-PSD-US"
                  },
                  "getItem-PreSell-PSI-UK" : {
                    "$ref" : "#/components/examples/getItem-PreSell-PSI-UK"
                  }
                }
              }
            }
          },
          "422" : {
            "description" : "A validation error occured when calling this method.  For example it may be that the supplied account Id was invalid or was unauthorized for this user.",
            "content" : {
              "application/json" : {
                "schema" : {
                  "$ref" : "#/components/schemas/CommonResponseHeader"
                }
              }
            }
          }
        }
      }
    },
    "/product/itemByBarCode/{barCode}" : {
      "get" : {
        "tags" : [ "Product API Suite" ],
        "summary" : "Fetch the Product information based on the ean number / bar code passed",
        "description" : "This API provides the production information based on the item code passed to it\n",
        "operationId" : "findbyBarcode",
        "parameters" : [ {
          "name" : "barCode",
          "in" : "path",
          "description" : "The Bar code / EAN for the list of item code of the product\n",
          "required" : true,
          "style" : "simple",
          "explode" : false,
          "schema" : {
            "type" : "string"
          }
        } ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "content" : {
              "application/json" : {
                "schema" : {
                  "$ref" : "#/components/schemas/ProductListAPIResponse"
                }
              }
            }
          },
          "422" : {
            "description" : "A validation error occured when calling this method.  For example it may be that the supplied account Id was invalid or was unauthorized for this user.",
            "content" : {
              "application/json" : {
                "schema" : {
                  "$ref" : "#/components/schemas/CommonResponseHeader"
                }
              }
            }
          }
        }
      }
    }
  },
  "components" : {
    "schemas" : {
      "Product" : {
        "type" : "object",
        "properties" : {
          "skus" : {
            "type" : "array",
            "items" : {
              "$ref" : "#/components/schemas/Sku"
            }
          },
          "id" : {
            "type" : "string",
            "example" : "eprod3110111"
          },
          "salesActivity" : {
            "type" : "string",
            "example" : "Mailings"
          },
          "itemCode" : {
            "type" : "integer",
            "example" : "M12080"
          },
          "name" : {
            "type" : "string",
            "example" : "Aussie Red Superstars"
          },
          "description" : {
            "type" : "string",
            "example" : "Every red in this collection delivers exactly what Australia is known and loved for – bear-hug-in-a-glass flavours of warming black fruit richness and sumptuous spice."
          },
          "longDescription" : {
            "type" : "string",
            "example" : "Every red in this collection delivers exactly what Australia is known and loved for – bear-hug-in-a-glass flavours of warming black fruit richness and sumptuous spice."
          },
          "description1" : {
            "type" : "string",
            "example" : "Every red in this collection delivers exactly what Australia is known and loved for – bear-hug-in-a-glass flavours of warming black fruit richness and sumptuous spice."
          },
          "description2" : {
            "type" : "string",
            "example" : "Every red in this collection delivers exactly what Australia is known and loved for – bear-hug-in-a-glass flavours of warming black fruit richness and sumptuous spice."
          },
          "description3" : {
            "type" : "string",
            "example" : "Every red in this collection delivers exactly what Australia is known and loved for – bear-hug-in-a-glass flavours of warming black fruit richness and sumptuous spice."
          },
          "webHeadline" : {
            "type" : "string",
            "example" : "A stonking lineup of our top-performing Oz reds – from just £7.99 a bottle"
          },
          "styleName" : {
            "type" : "string"
          },
          "styleId" : {
            "type" : "string"
          },
          "grapeName" : {
            "type" : "string"
          },
          "grapeId" : {
            "type" : "integer"
          },
          "appellationName" : {
            "type" : "string"
          },
          "appellationId" : {
            "type" : "string"
          },
          "regionName" : {
            "type" : "string"
          },
          "regionId" : {
            "type" : "integer"
          },
          "countryName" : {
            "type" : "string",
            "example" : "Australia"
          },
          "countryId" : {
            "type" : "string",
            "example" : "AU"
          },
          "colourName" : {
            "type" : "string",
            "example" : "Red"
          },
          "colourId" : {
            "type" : "string",
            "example" : "Red"
          },
          "vintage" : {
            "type" : "integer"
          },
          "smallImage" : {
            "type" : "string",
            "example" : "/images/uk/en/law/product/M12080.png"
          },
          "largeImage" : {
            "type" : "string",
            "example" : "/images/uk/en/law/product/M12080b.png"
          },
          "thumbnailImage" : {
            "type" : "string",
            "example" : "/images/uk/en/law/product/M12080.png"
          },
          "mixed" : {
            "type" : "boolean",
            "example" : true
          },
          "lowestPricePerBottle" : {
            "type" : "number",
            "format" : "double",
            "example" : 10.2
          },
          "enPrimeurFlag" : {
            "type" : "boolean",
            "example" : false
          },
          "accolades" : {
            "type" : "array",
            "items" : {
              "$ref" : "#/components/schemas/Accolade"
            }
          },
          "vppQualifier" : {
            "type" : "boolean",
            "example" : false
          },
          "tastingNotes" : {
            "$ref" : "#/components/schemas/TastingNotes"
          },
          "drinkCharacteristics" : {
            "$ref" : "#/components/schemas/DrinkCharacteristics"
          },
          "inventoryInfo" : {
            "$ref" : "#/components/schemas/InventoryInfo"
          },
          "drinkByDate" : {
            "type" : "integer"
          },
          "drinkByDateAsString" : {
            "type" : "string"
          },
          "serveCode" : {
            "type" : "string"
          },
          "alcoholPercent" : {
            "type" : "number",
            "format" : "double",
            "example" : 3
          },
          "alcoholUnits" : {
            "type" : "number",
            "format" : "double",
            "example" : 1
          },
          "bottleSize" : {
            "type" : "string",
            "example" : "2"
          },
          "productType" : {
            "type" : "string",
            "example" : "wine"
          },
          "subProductType" : {
            "type" : "string",
            "example" : "Z099"
          },
          "ratingDetails" : {
            "$ref" : "#/components/schemas/RatingDetails"
          },
          "hasSubstitution" : {
            "type" : "boolean",
            "example" : true
          },
          "flexiMatrixFlag" : {
            "type" : "boolean",
            "example" : true
          },
          "unitOfMeasure" : {
            "type" : "string"
          },
          "genericGrapeName" : {
            "type" : "string"
          },
          "genericGrapeId" : {
            "type" : "string"
          },
          "unlimitedItem" : {
            "type" : "boolean",
            "example" : true
          },
          "winePlanFlag" : {
            "type" : "boolean",
            "example" : true
          },
          "wineName" : {
            "type" : "string"
          }
        }
      },
      "RatingDetails" : {
          "type" : "object",
          "properties" : {
              "productRating" : {
                "$ref" : "#/components/schemas/ProductRating"
              }
          }
      },
      "Sku" : {
        "type" : "object",
        "properties" : {
          "id" : {
            "type" : "string",
            "description" : "This is an internal sku-id which can be used to uniquely identfy the SKU",
            "example" : "esku3230197"
          },
          "itemCode" : {
            "type" : "integer",
            "description" : "The item code is the public identifier for a product sku.\n"
          },
          "numberOfBottles" : {
            "type" : "integer",
            "description" : "The number of bottle in this sku.",
            "format" : "int32",
            "example" : 12
          },
          "listPrice" : {
            "type" : "number",
            "description" : "This is the current recommended retail price (RRP) price for this sku.",
            "format" : "double",
            "example" : 10.2
          },
          "salePrice" : {
            "type" : "number",
            "description" : "This is the current standard selling price (SSP) for this sku.",
            "format" : "double",
            "example" : 10.2
          },
          "salePricePerBottle" : {
            "type" : "number",
            "description" : "For multi-bottle skus, this contain the price of a single bottle.  This is calculated from the SSP price.",
            "format" : "double",
            "example" : 10.2
          },
          "promotionalPrice" : {
            "type" : "number",
            "description" : "This is used to define promotional price for sku.",
            "format" : "double",
            "example" : 10.2
          },
          "vppApplier" : {
            "type" : "boolean",
            "example" : true
          },
          "vppPrice" : {
            "type" : "number",
            "format" : "double",
            "example" : 10.2
          },
          "vppDiscountPct" : {
            "type" : "number",
            "format" : "double",
            "example" : 10.2
          },
          "preSellItem" : {
            "type" : "boolean",
            "description" : "This sku is a 'Pre Sell' item.\nIt is an item that can be paid for in installments.\nThe installment schedule is provide by the details in the installments property\n",
            "example" : true
          },
          "installments" : {
            "type" : "array",
            "description" : "This property is deprecated and will be remove in a future version of the Product API\n\nClients should now use the paymentInstallmentSchedule instead\n",
            "deprecated" : true,
            "items" : {
              "$ref" : "#/components/schemas/Installment"
            }
          },
          "paymentInstallmentSchedule" : {
            "$ref" : "#/components/schemas/PaymentInstallmentSchedule"
          },
          "preReleaseItem" : {
            "type" : "boolean",
            "description" : "This sku is a 'Pre Release' item or as it is better known an 'En Premeur' item.\n\nEn Primeur wines allow customers to buy selected high quality wines before they are bottled\nand released onto the market.\n\nThey can be purchased exclusive of duty and VAT and then shipped onve the vintage becomes available.\n",
            "example" : false
          },
          "giftFlag" : {
            "type" : "boolean",
            "description" : "This indicates whether this SKU is provided as a gift.\n\nIf present then the customer will normally be invited to provide a gift message\nwhen placing the order\n",
            "example" : false
          },
          "caseTypeDesc" : {
            "type" : "string"
          },
          "saleable" : {
            "type" : "boolean",
            "example" : true
          },
          "webEnabled" : {
            "type" : "boolean",
            "description" : "indicates whether this sku can be purchased on the website."
          },
          "stockHeld" : {
            "type" : "boolean",
            "description" : "This is used to define stock held property for sku.",
            "example" : true
          },
          "marginPercent" : {
            "type" : "number",
            "description" : "This property is no longer used and will be removed from a future version of the API",
            "format" : "double",
            "example" : 1.25,
            "deprecated" : true
          },
          "salesCode" : {
            "type" : "string",
            "description" : "This property is no longer used and will be removed from a future version of the API",
            "deprecated" : true
          },
          "currentSalesCode" : {
            "type" : "string",
            "description" : "This property is no longer used and will be removed from a future version of the API",
            "deprecated" : true
          },
          "salesCodeDetails" : {
            "$ref" : "#/components/schemas/SalesCode"
          },
          "bonusPoints" : {
            "type" : "integer",
            "description" : "This is an optional property that contains the number of bonus points that a customer would earn if they purchased this sku.\n\nIf preseent, it will only applies if a points scheme is currently operational.\n",
            "format" : "int32"
          },
          "barCode" : {
            "type" : "string"
          }
        }
      },
      "SalesCode" : {
        "type" : "object",
        "properties" : {
          "addOn" : {
            "type" : "boolean"
          },
          "installments" : {
            "type" : "array",
            "items" : {
              "$ref" : "#/components/schemas/Installment"
            }
          },
          "outBound" : {
            "type" : "boolean"
          },
          "marginPercent" : {
            "type" : "number",
            "format" : "double"
          }
        },
        "description" : "This object is no longer used and will be removed from a future version of the API",
        "deprecated" : true
      },
      "PaymentInstallmentSchedule" : {
        "description" : "A Payment Installment Scheme is available for certain types of products such as Pre-Sell Items\n\nThese are typically products such as popular vintages of wine where next years vintage is 'still in the ground' or 'still maturing in the cellar'\n\nThe installment schedule has the advantage of both allowing a customer to spread the cost of the wine and ensuring they are reserved a batch of the wine before it gets to its release date and goes on general sale.\n\nTwo type of installment scheme may be offered based on product and duristiction. \n",
        "example" : {
          "type" : "PSI",
          "installments" : [ {
            "installmentDate" : "02-07-2019",
            "installmentPrice" : 96,
            "productDispatchFlag" : false
          }, {
            "installmentDate" : "10-06-2020",
            "installmentPrice" : 96,
            "productDispatchFlag" : true
          } ]
        },
        "discriminator" : {
          "propertyName" : "type"
        },
        "oneOf" : [ {
          "$ref" : "#/components/schemas/PsiInstallmentSchedule"
        }, {
          "$ref" : "#/components/schemas/PsdInstallmentSchedule"
        } ]
      },
      "PsiInstallmentSchedule" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/InstallmentSchedule"
        }, {
          "type" : "object",
          "properties" : {
            "installments" : {
              "type" : "array",
              "items" : {
                "$ref" : "#/components/schemas/StandardInstallment"
              }
            }
          }
        } ]
      },
      "PsdInstallmentSchedule" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/InstallmentSchedule"
        }, {
          "type" : "object",
          "properties" : {
            "installments" : {
              "type" : "array",
              "items" : {
                "$ref" : "#/components/schemas/DepositInstallment"
              }
            }
          }
        } ]
      },
      "InstallmentSchedule" : {
        "type" : "object",
        "properties" : {
          "type" : {
            "$ref" : "#/components/schemas/InstallmentSchemeType"
          }
        }
      },
      "StandardInstallment" : {
        "type" : "object",
        "properties" : {
          "installmentDate" : {
            "type" : "string",
            "description" : "The date when the installment payment is due.\n\nNormally this payment is collected automatically by the system after the customer has made the initial payment and provided the customer has provided permission to make a repeating payment. If not the later payments may be made by calling the customer service centre.\n\nThe product will be dispatched once the final payment has been dispatched.  \n\nThis is retuned as an ISO-8601 relative date in 'YYYY-MM-DD' format\n",
            "readOnly" : true,
            "example" : "2020-06-01"
          },
          "installmentPrice" : {
            "type" : "number",
            "format" : "double",
            "example" : 59.69
          },
          "productDispatchFlag" : {
            "type" : "boolean",
            "description" : "This flag informs whether the main product will be dispatched to the customer after this installment is paid.\n",
            "default" : false
          }
        }
      },
      "DepositInstallment" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/StandardInstallment"
        }, {
          "type" : "object",
          "properties" : {
            "depositItemCode" : {
              "type" : "string",
              "description" : "This is the item code of a service item that will be used to collect the payment of this deposit.\n\nThis item code is provided for information only, there is no requirement for a developer to use this code.\n\nHowever it is worth noting, how this would be used by the system as that use is not immediately obvious.   Where a customer purchases this type of pre-sell item,  for the initial purchase the system will substitute this deposit item for this item,  and that will then appear in the customers basket rather that the item-code of the main pre-sell item.  It is this mechansim that ensures that a customer only pays a deposit and is not required to pay any tax on the deposit\n"
            }
          },
          "description" : "A Deposit Installment is related to the 'PSD' (Pre-Sell Deposit) scheme\n\nThis scheme is a variation to the PSI scheme,  in that initially a deposit payment is made for a service item, rather than the advertised product.  The advertised product is then purchased and dispatched via a later installment with any deposit payments deducted from the final price\n\nThis is normally the default scheme used in duristictions where sales tax is excluded in the price of the product, such as the United States.  This mechanism has the advantage that tax does not beome due until the final payment is made and the product is dispatched.\n"
        } ]
      },
      "Installment" : {
        "type" : "object",
        "properties" : {
          "installmentDate" : {
            "type" : "number"
          },
          "installmentDateAsString" : {
            "type" : "string",
            "example" : "2 July, 2019"
          },
          "installmentPrice" : {
            "type" : "number",
            "format" : "double",
            "example" : 59.69
          }
        },
        "deprecated" : true
      },
      "Accolade" : {
        "type" : "object",
        "properties" : {
          "accoladeYear" : {
            "type" : "integer"
          },
          "accoladePerson" : {
            "type" : "string"
          },
          "accoladeDate" : {
            "type" : "integer"
          },
          "accoladeNameText" : {
            "type" : "string"
          },
          "accoladeStandardText" : {
            "type" : "string"
          },
          "accoladeCategoryText" : {
            "type" : "string"
          },
          "accoladeDescription" : {
            "type" : "string"
          },
          "categoryId" : {
            "type" : "integer"
          },
          "awardingCountry" : {
            "type" : "string"
          },
          "id" : {
            "type" : "integer"
          },
          "organisationTypeId" : {
            "type" : "integer"
          },
          "organisationTypeDesc" : {
            "type" : "string"
          },
          "organisationTypeImage" : {
            "type" : "string"
          },
          "levelTypeId" : {
            "type" : "integer"
          },
          "levelTypeDesc" : {
            "type" : "string"
          },
          "levelTypeImage" : {
            "type" : "string"
          },
          "awardTypeId" : {
            "type" : "integer"
          },
          "awardTypeDesc" : {
            "type" : "string"
          },
          "awardTypeImage" : {
            "type" : "string"
          },
          "entryTypeId" : {
            "type" : "integer"
          },
          "entryTypeDesc" : {
            "type" : "string"
          },
          "entryTypeImage" : {
            "type" : "string"
          },
          "entryImage" : {
            "type" : "string"
          },
          "organisation" : {
            "type" : "string"
          }
        }
      },
      "DrinkCharacteristics" : {
        "type" : "object",
        "properties" : {
          "calories" : {
            "type" : "number",
            "format" : "double"
          },
          "organic" : {
            "type" : "boolean",
            "example" : true
          },
          "vegan" : {
            "type" : "boolean",
            "example" : true
          },
          "vegetarian" : {
            "type" : "boolean",
            "example" : true
          },
          "qcScore" : {
            "type" : "number",
            "format" : "double"
          },
          "biodynamic" : {
            "type" : "boolean",
            "example" : true
          },
          "decant" : {
            "type" : "boolean",
            "example" : true
          },
          "fairTrade" : {
            "type" : "boolean",
            "example" : false
          },
          "kosher" : {
            "type" : "boolean",
            "example" : true
          },
          "oaked" : {
            "type" : "boolean",
            "example" : false
          },
          "pronunciation" : {
            "type" : "string"
          },
          "foodMatches" : {
            "type" : "array",
            "items" : {
              "type" : "string"
            }
          }
        },
        "description" : "Attributes related to appearance, taste, aroma, nutrition and serving advice"
      },
      "TastingNotes" : {
        "type" : "object",
        "properties" : {
          "shortTastingNotesColor" : {
            "type" : "string",
            "description" : "This is used to define tasting notes for colour of item."
          },
          "shortTastingNotesAroma" : {
            "type" : "string",
            "description" : "This is used to define tasting notes for aroma of item."
          },
          "shortTastingNotesTaste" : {
            "type" : "string",
            "description" : "This is used to define tasting notes for taste of item."
          },
          "largeBottleImageFile" : {
            "type" : "string"
          },
          "accoladeImageFile" : {
            "type" : "string"
          },
          "mapImageFile" : {
            "type" : "string"
          },
          "otherImageFile" : {
            "type" : "string"
          }
        }
      },
      "ProductRating" : {
        "type" : "object",
        "properties" : {
          "avgRating" : {
            "type" : "number",
            "description" : "This is used to define average rating for the product.",
            "format" : "double"
          },
          "numberOfReviews" : {
            "type" : "integer",
            "description" : "This is used to define number of reviews added for product."
          },
          "roundAvgRating" : {
            "type" : "integer",
            "description" : "This is used to define average rating for the product.",
          }
        }
      },
      "UserProductRating" : {
        "type" : "object",
        "properties" : {
          "productId" : {
            "type" : "string",
            "description" : "This is used to define id for product."
          },
          "itemCode" : {
            "type" : "integer",
            "description" : "This is used to define item code for product."
          },
          "reviewText" : {
            "type" : "string",
            "description" : "This is used to define reviews added for product."
          },
          "brand" : {
            "type" : "string",
            "description" : "This is used to define brand for product."
          },
          "ratingLoadDate" : {
            "type" : "string",
            "description" : "This is used to define date on which ratings has been added for product.",
            "format" : "date"
          },
          "reviewDate" : {
            "type" : "string",
            "description" : "This is used to define date on which reviews has been added for product.",
            "format" : "date"
          }
        }
      },
      "DateMidnight" : {
        "type" : "object",
        "properties" : {
          "iInstant" : {
            "type" : "string",
            "format" : "date-time"
          },
          "iField" : {
            "type" : "string",
            "format" : "date-time"
          }
        }
      },
      "ConsolidatedProductRating" : {
        "type" : "object",
        "properties" : {
          "productRating" : {
            "$ref" : "#/components/schemas/ProductRating"
          },
          "userProductRating" : {
            "$ref" : "#/components/schemas/UserProductRating"
          }
        }
      },
      "HowToServe" : {
        "type" : "object",
        "properties" : {
          "howToServeId" : {
            "type" : "string"
          },
          "axTimestamp" : {
            "type" : "string",
            "format" : "date-time"
          },
          "howToServeDescription" : {
            "type" : "string"
          }
        }
      },
      "InstallmentSchemeType" : {
        "type" : "string",
        "description" : "This enumeration is used to differentiate the different 'payment by installment' scheme types.\n- **PSI**  refers to the 'Pre-Sell by Installments' scheme\n- **PSD**  refers to the 'Pre-Sell by Deposit' scheme\n",
        "enum" : [ "PSI", "PSD" ]
      },
      "ProductAPIResponse" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/ApiResponse"
        }, {
          "type" : "object",
          "properties" : {
            "response" : {
              "$ref" : "#/components/schemas/Product"
            }
          }
        } ]
      },
      "ProductListAPIResponse" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/ApiResponse"
        }, {
          "type" : "object",
          "properties" : {
            "products" : {
              "type" : "array",
              "items" : {
                "$ref" : "#/components/schemas/Product"
              }
            }
          }
        } ]
      },
      "CommonResponseHeader" : {
        "required" : [ "errorResponse", "statusCode", "statusMessage" ],
        "type" : "object",
        "properties" : {
          "statusCode" : {
            "type" : "integer",
            "description" : "A status code.  If successful this will return 0,  otherwise it will reflect the HTTP response code.",
            "example" : 200
          },
          "statusMessage" : {
            "type" : "string",
            "description" : "When a non-zero statusCode is returned,  this property will return a descriptive error message to describe the actual error that prevented the method call completing successfully.",
            "example" : "successful"
          },
          "errorResponse" : {
            "$ref" : "#/components/schemas/ExtendedErrorModel"
          }
        },
        "description" : "The Generic Response payload describes the standard properties that will be returned by any DW API method.   Individual API methods then return structured reponse objects within the response property."
      },
      "ExtendedErrorModel" : {
        "allOf" : [ {
          "$ref" : "#/components/schemas/ErrorModel"
        }, {
          "type" : "object",
          "properties" : {
            "rootCause" : {
              "type" : "string"
            }
          }
        } ]
      },
      "ErrorModel" : {
        "required" : [ "code", "message" ],
        "type" : "object",
        "properties" : {
          "code" : {
            "type" : "string",
            "example" : "INPUT_VALIDATION_ERRORS"
          },
          "message" : {
            "type" : "string",
            "example" : "[Delivery Phone Number is invalid,]"
          },
          "details" : {
              "type" : "array",
              "items" : {
                "$ref" : "#/components/schemas/ValidationError"
              }
          }
        },
        "discriminator" : {
          "propertyName" : "type"
        }
      },
      "ValidationError" : {
        "type" : "object",
        "properties" : {
          "validationCode" : {
            "type" : "string",
            "example" : "checkout.personalDetails.deliveryPhoneNumberInvalid"
          },
          "validationMessage" : {
            "type" : "string",
            "example" : "Delivery Phone Number is invalid."
          }
        }
      },
      "InventoryInfo" : {
        "type" : "object",
        "properties" : {
          "availabilityStatus" : {
            "type" : "integer",
            "description" : "A value which indicates the current stock availability status. Returnable values are:-\n- 1000   This item is 'in stock'.  An item is designated as 'in stock' if the following rules apply\n  - It is associated with a positive stock quantity value.\n  - It is associated with an item which has no inventory but can be assumed to be in stock.  For example,  tickets and literature items fall into this category.\n- 1001   This item is 'out of stock'\n- 1006   The item is available but is at a 'low stock' level. As such it may sell out soon.\n",
            "format" : "int32",
            "example" : 1000
          },
          "summaryAvailabilityStatus" : {
            "type" : "string",
            "description" : "This also indicates the stock availability status but as a string enumeration for readability.\n",
            "example" : "in_stock",
            "enum" : [ "in_stock", "out_of_stock", "low_stock" ]
          },
          "stockQty" : {
            "type" : "integer",
            "description" : "The amount of stock currently available for this item.\n\n- A positive stock quantity will normally be associated with a status of 'in_stock'  or 'low_stock'.\n- A stock quantity of 0 normally indicates an item is 'out_of_stock' however there a few noteworthy caveats:-\n  - An item can have a quantity of 0 and still be in an 'in stock' status.   See the description for the 'availabilityStatus' which defines the scenario where this can occur.\n  - An item which has a quantity of 0 and is currently in an 'out_of_stock' status,  may only be in that status for a temporary period, because more stock is expected in shortly. See the description for the 'happyToWaitEnabled' flag which explains the circumstances for this scenario.\n",
            "format" : "int32",
            "example" : 5000
          },
          "availabilityDate" : {
            "type" : "string",
            "description" : "If set, this indicates the date when the next delivery of additional stock is expected. \n\nThe 'backOrderLevel' property indicates the quantity of stock that is expected at that date.\nIn other words:-  At that future date,  the 'stockQty' amount will be boosted by the amount in 'backOrderLevel'\n\nThis date is returned an a posix epoch date expressed in seconds.\n",
            "format" : "date"
          },
          "availabilityDateAsString" : {
            "type" : "string",
            "description" : "If set, this also contains the availability date but as a string generated in the format.\n\nIt is supplied as a string according to the following format \"31 December, 2020\".\n\nThis version of the property is only intended to be used for support purposes and the \nimplementation reserves the right to change the format in a future version\n\nAs such any API client should ALWAYS use the 'availabilityDate' property in preference to this property.\n"
          },
          "backOrderLevel" : {
            "type" : "integer",
            "description" : "If set, this indicates the additional stock that is expected in the next delivery for this item\n\nThe 'availabilityDate' property indicates the date when that additional stock is expected.\nIn other words:- At that future date,  the 'stockQty' amount will be boosted by the amount in 'backOrderLevel'\n",
            "format" : "int64",
            "default" : 0
          },
          "happyToWaitEnabled" : {
            "type" : "boolean",
            "description" : "Most often when a wine item goes 'out of stock' it will stay 'out of stock'.  At the end of the day a vinyard may just have a very limited supply!\n\nHowever, whereever possible we endeavour to replenish our supplies from the wine producers in a timely manner.\nIn this situation, a break in supply is occasionally feasible, and if so we provide a 'happy to wait' flag against our inventory for the wine.\n\nIf this flag is set to true,  it indicates that the item is currently ina 'out of stock' status but that additional stock will be available for this item in the near future.  The 'near future' usually means 'within 30 days'.\n\nThis means that the customer will still be allowed to place an order for this items provided they are 'happy to wait' until the designated availability date.\n\nThe 'availabilityDate' property describes how long it will be until the item becomes available.\n",
            "default" : false
          },
          "stockAlgorithm" : {
            "type" : "string",
            "description" : "This provides information about the stock algorithm that has been used to determine the stock information.\n\nThere are 2 supported values that may be returned.\n- DEFAULT This provides stock information based on currently available stock\n- FUTURE  This provides stock information based on what is available currently and as far into the future as the stock system can see.   This option is sometimes used for wines which are 'still in the ground' but are planned to be available in the future,  such as confrere or en-premeur wines\n",
            "default" : "DEFAULT",
            "enum" : [ "DEFAULT", "FUTURE" ]
          },
          "stockNotificationAvailable" : {
            "type" : "boolean",
            "description" : "This indicates whether a stock notification feature is available for products when they go 'out of stock'.   If so, then it allows a customer to subscribe for notification messages to be sent when the product (or a future vintage of the product) has renewed stock in the future.\n",
            "default" : false
          },
          "happyToWaitDate" : {
            "type" : "integer",
            "description" : "This property is no longer used and will be removed by a future version of the API\n\nThat is because the date in this property is duplicated by the date in the availabilityDate property.\n",
            "format" : "int64",
            "deprecated" : true
          },
          "happyToWaitDateAsString" : {
            "type" : "string",
            "description" : "This property is no longer used and will be removed by a future version of the API\n\nThe date in this flag is duplicated by the availabilityDateAsString property.\n",
            "deprecated" : true
          }
        }
      },
      "ApiResponse" : {
        "type" : "object",
        "properties" : {
          "statusMessage" : {
            "type" : "string",
            "example" : "Success"
          },
          "statusCode" : {
            "type" : "integer",
            "example" : 200
          }
        }
      }
    },
    "examples" : {
      "getItem-PreSell-PSD-US" : {
        "summary" : "Example response for US Presell Product",
        "value" : {
          "response" : {
            "ratingDetails" : {
              "productRating" : {
                "avgRating" : 5,
                "numberOfReviews" : 1,
                "roundAvgRating" : 5
              }
            },
            "mixed" : false,
            "drinkByDateAsString" : "31 December, 2025",
            "skus" : [ {
              "caseType" : "Single Bottle",
              "itemCode" : 1919815,
              "id" : "sku3572121",
              "numberOfBottles" : 1,
              "listPrice" : 69.99,
              "salePrice" : 69.99,
              "salePricePerBottle" : 69.99,
              "vppApplier" : false,
              "preSellItem" : true,
              "paymentInstallmentSchedule" : {
                "type" : "PSD",
                "installments" : [ {
                  "installmentDate" : "02-07-2020",
                  "installmentPrice" : 30,
                  "productDispatchFlag" : false,
                  "depositItemCode" : "000445SV"
                }, {
                  "installmentDate" : "10-06-2021",
                  "installmentPrice" : 39.99,
                  "productDispatchFlag" : true,
                  "depositItemCode" : "000445SV"
                } ]
              },
              "installments" : [ {
                "installmentDate" : 1562022000000,
                "installmentDateAsString" : "2 July, 2020",
                "installmentPrice" : 30
              }, {
                "installmentDate" : 1591743600000,
                "installmentDateAsString" : "10 June, 2021",
                "installmentPrice" : 39.99
              } ],
              "preReleaseItem" : false,
              "giftFlag" : false,
              "caseTypeDesc" : "Single Bottle",
              "saleable" : true,
              "webEnabled" : true,
              "stockHeld" : false,
              "bonusPoints" : 0
            } ],
            "id" : "prod3300901",
            "salesActivity" : "Mailings",
            "itemCode" : 1919815,
            "name" : "Chateau Lagrange Pomerol",
            "description" : "Jancis Robinson, MW says that “Bordeaux lovers will certainly want to have some 2015s in their cellars.” So you’ll have to move quickly to secure your taste – especially with this luxurious, highly acclaimed Pomerol from a <i>very</i> big name ...",
            "longDescription" : "<p style=\"text-align:center; color:#986a16; font-weight:bold; padding:10px; font-size:14px;\">“A tight and silky red with lovely blackberry and walnut shell character. Full body, firm and silky tannins and a long and flavorful finish. Gorgeous balance.” 93-94 points<br><span style=\"font-weight:bold; font-style:italic; font-size:11px; color:#666666;\"> Bordeaux expert, James Suckling</span></p>",
            "webHeadline" : "93-94 Point Pomerol",
            "styleName" : "Red - Medium to full bodied",
            "styleId" : "RedD",
            "grapeName" : "Merlot Based Blend",
            "grapeId" : 75,
            "appellationName" : "Pomerol AOC",
            "appellationId" : "FR0085",
            "regionName" : "Bordeaux",
            "regionId" : 9,
            "countryName" : "France",
            "countryId" : "FR",
            "colourName" : "Red",
            "colourId" : "Red",
            "vintage" : 2015,
            "smallImage" : "/images/us/en/product/1919815_S.jpg",
            "largeImage" : "/images/us/en/product/1919815_L.jpg",
            "thumbnailImage" : "/images/us/en/product/1919815_T.jpg",
            "isMixed" : false,
            "lowestPricePerBottle" : 69.99,
            "enPrimeurFlag" : false,
            "accolades" : [ {
              "accoladeYear" : 2020,
              "accoladeDate" : 1586818800000,
              "awardingCountry" : "US",
              "id" : 25212741,
              "organisationTypeId" : 192,
              "organisationTypeDesc" : "James Suckling",
              "organisationTypeImage" : "/images/us/law/accolades/organisation/192.jpg",
              "levelTypeId" : 107,
              "levelTypeDesc" : "93-94",
              "levelTypeImage" : "/images/us/law/accolades/leveltype/blank.jpg",
              "awardTypeId" : 4,
              "awardTypeDesc" : "Points",
              "awardTypeImage" : "/images/us/law/accolades/awardtype/4.jpg",
              "entryTypeId" : 2,
              "entryTypeDesc" : "Rating",
              "entryImage" : "/images/us/law/accolades/entrytype/2.jpg"
            } ],
            "vppQualifier" : true,
            "drinkCharacteristics" : {
              "organic" : false,
              "vegan" : false,
              "vegetarian" : false,
              "biodynamic" : false,
              "decant" : false,
              "fairTrade" : false,
              "kosher" : false,
              "oaked" : true
            },
            "inventoryInfo" : {
              "availabilityStatus" : 1000,
              "summaryAvailabilityStatus" : "in_stock",
              "stockQty" : 37,
              "backOrderLevel" : 0,
              "happyToWaitEnabled" : false
            },
            "drinkByDate" : 1767139200000,
            "alcoholPercent" : 14,
            "alcoholUnits" : 10.5,
            "bottleSize" : "750.0",
            "productType" : "wine",
            "subProductType" : "Z010",
            "productRating" : {
              "productRating" : {
                "avgRating" : 5,
                "numberOfReviews" : 1,
                "roundAvgRating" : 5
              }
            },
            "flexiMatrixFlag" : false,
            "unitOfMeasure" : "ML",
            "unlimitedItem" : false,
            "winePlanFlag" : false
          },
          "statusMessage" : "successful",
          "statusCode" : 0
        }
      },
      "getItem-PreSell-PSI-UK" : {
        "summary" : "Example response for UK Presell Product",
        "value" : {
          "response" : {
            "mixed" : true,
            "skus" : [ {
              "caseType" : "Red Mixed Case",
              "itemCode" : "C05353",
              "id" : "esku3090156",
              "numberOfBottles" : 12,
              "listPrice" : 300,
              "salePrice" : 192,
              "salePricePerBottle" : 16,
              "vppApplier" : false,
              "preSellItem" : true,
              "paymentInstallmentSchedule" : {
                "type" : "PSI",
                "installments" : [ {
                  "installmentDate" : "02-07-2019",
                  "installmentPrice" : 96,
                  "productDispatchFlag" : false
                }, {
                  "installmentDate" : "10-06-2020",
                  "installmentPrice" : 96,
                  "productDispatchFlag" : true
                } ]
              },
              "installments" : [ {
                "installmentDate" : 1562022000000,
                "installmentDateAsString" : "2 July, 2019",
                "installmentPrice" : 96
              }, {
                "installmentDate" : 1591743600000,
                "installmentDateAsString" : "10 June, 2020",
                "installmentPrice" : 96
              } ],
              "preReleaseItem" : false,
              "giftFlag" : false,
              "caseTypeDesc" : "Red Mixed Case",
              "saleable" : true,
              "webEnabled" : true,
              "stockHeld" : false,
              "bonusPoints" : 0
            } ],
            "id" : "eprod2970064",
            "salesActivity" : "Wine Plan Upgrades",
            "itemCode" : "C05353",
            "name" : "Château La Clarière Laithwaite",
            "webHeadline" : "2018 rewarded those vigilant in the vineyard. A wonderfully rich, ripe vintage with fruity depth",
            "grapeName" : "Merlot-based blend",
            "grapeId" : 75,
            "regionName" : "Bordeaux",
            "regionId" : 9,
            "countryName" : "France",
            "countryId" : "FR",
            "colourName" : "Red",
            "colourId" : "Red",
            "vintage" : 2018,
            "smallImage" : "/images/uk/en/law/product/C05353.png",
            "largeImage" : "/images/uk/en/law/product/C05353b.png",
            "thumbnailImage" : "/images/uk/en/law/product/C05353.png",
            "isMixed" : true,
            "lowestPricePerBottle" : 16,
            "enPrimeurFlag" : false,
            "vppQualifier" : true,
            "drinkCharacteristics" : {
              "calories" : 0,
              "organic" : false,
              "vegan" : false,
              "vegetarian" : false,
              "qcScore" : 0,
              "biodynamic" : false,
              "decant" : false,
              "fairTrade" : false,
              "kosher" : false,
              "oaked" : false
            },
            "inventoryInfo" : {
              "availabilityStatus" : 1000,
              "summaryAvailabilityStatus" : "in_stock",
              "stockQty" : 550,
              "backOrderLevel" : 0,
              "happyToWaitEnabled" : false
            },
            "alcoholPercent" : 0,
            "alcoholUnits" : 0,
            "productType" : "wineplanproduct",
            "subProductType" : "Z099",
            "hasSubstitution" : false,
            "flexiMatrixFlag" : false,
            "unlimitedItem" : false,
            "winePlanFlag" : true
          },
          "statusMessage" : "successful",
          "statusCode" : 0
        }
      }
    }
  }
}

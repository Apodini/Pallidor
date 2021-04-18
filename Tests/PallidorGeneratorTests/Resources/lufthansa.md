{
    "openapi": "3.0.0",
    "info": {
        "title": "Flight Schedules API",
        "version": "1.0.0",
        "description": "This API provides Lufthansa's flight schedule information.\n\nA search functionality is available based on a number of criteria:\n  * airlines\n  * flight number\n  * start and end date\n  * days of operation\n  * origin and destination\n  * aircraft types\n  \nDepending on access it enables to view passenger flights, cargo flights or both.\n\nThe flights returned are date-wise aggregated. \nTheir structure and attributes follow the standards and definitions provided by the IATA Standard Schedules Information Manual (SSIM, Chapter 2).\n",
        "contact": {
            "name": "Lufthansa Group API Support",
            "email": "api.support@lufthansa.com"
        }
    },
    "servers": [
        {
            "url": "https://api.lufthansa.com/v1/flight-schedules"
        }
    ],
    "tags": [
        {
            "name": "schedule",
            "description": "Flight schedule information"
        }
    ],
    "components": {
        "securitySchemes": {
            "Bearer": {
                "type": "oauth2",
                "flows": {
                    "clientCredentials": {
                        "tokenUrl": "https://api.lufthansa.com/v1/oauth/token",
                        "scopes": {
                          "write:lh": "modify lh in your account",
                          "read:lh": "read your lh"
                        }
                    }
                }
            }
        },
        "parameters": {
            "airlines": {
                "name": "airlines",
                "in": "query",
                "description": "The list of airline codes",
                "required": true,
                "explode": true,
                "schema": {
                    "type": "array",
                    "items": {
                        "$ref": "#/components/schemas/Airline"
                    }
                }
            },
            "flightNumberRanges": {
                "name": "flightNumberRanges",
                "in": "query",
                "description": "The flight number range filter string. e.g.: '-100, 200, 100-200, 300-'",
                "schema": {
                    "type": "string"
                }
            },
            "startDate": {
                "name": "startDate",
                "in": "query",
                "description": "The period start date. SSIM date format DDMMMYY",
                "required": true,
                "schema": {
                    "$ref": "#/components/schemas/SSIMDate"
                }
            },
            "endDate": {
                "name": "endDate",
                "in": "query",
                "description": "The period end date. SSIM date format DDMMMYY",
                "required": true,
                "schema": {
                    "$ref": "#/components/schemas/SSIMDate"
                }
            },
            "daysOfOperation": {
                "name": "daysOfOperation",
                "in": "query",
                "description": "The days of operation, i.e. the days of the week. Whitespace padded to 7 chars. E.g.: '  34 6 '",
                "required": true,
                "schema": {
                    "$ref": "#/components/schemas/DaysOfOperation"
                }
            },
            "timeMode": {
                "name": "timeMode",
                "in": "query",
                "description": "The time mode of the period of operations",
                "required": true,
                "schema": {
                    "$ref": "#/components/schemas/TimeMode"
                }
            },
            "origin": {
                "name": "origin",
                "in": "query",
                "description": "Search for flights departing from this station. 3 letter IATA airport code.",
                "schema": {
                    "$ref": "#/components/schemas/Airport"
                }
            },
            "destination": {
                "name": "destination",
                "in": "query",
                "description": "Search for flights arriving at this station. 3 letter IATA airport code.",
                "schema": {
                    "$ref": "#/components/schemas/Airport"
                }
            },
            "aircraftTypes": {
                "name": "aircraftTypes",
                "in": "query",
                "description": "The list of aircraft types",
                "explode": true,
                "schema": {
                    "type": "array",
                    "items": {
                        "$ref": "#/components/schemas/AircraftType"
                    }
                }
            }
        },
        "schemas": {
            "AircraftType": {
                "description": "The fleet type identifier 3 characters, can contain letters and numbers.",
                "type": "string",
                "pattern": "^[0-9A-Z]{3}$",
                "example": 744
            },
            "Airport": {
                "description": "Airport represented by a 3 letter IATA airport code",
                "type": "string",
                "pattern": "^[A-Z]{3}$",
                "example": "FRA"
            },
            "Airline": {
                "description": "The airline code of the flight",
                "type": "string",
                "pattern": "^[0-9A-Z]{2,3}$",
                "example": "LH"
            },
            "DaysOfOperation": {
                "description": "String representation of the days of operation (weekdays) in the format 'fffffff' with whitespace padding",
                "type": "string",
                "pattern": "^[0-9 ]{7}$",
                "example": 1234567
            },
            "FlightNumber": {
                "description": "The flight number",
                "type": "integer",
                "minimum": 1,
                "maximum": 9999
            },
            "ServiceType": {
                "description": "Service type identifying whether the flight is a passenger or cargo flight (or something else). An uppercase letter.",
                "type": "string",
                "pattern": "^[A-Z]{1}$",
                "example": "J"
            },
            "SSIMDate": {
                "description": "A date represented in the format 'DDMMMYY'",
                "type": "string",
                "pattern": "^[0-9]{2}[A-Z]{3}[0-9]{2}$",
                "example": "01JAN19"
            },
            "Suffix": {
                "description": "Operational suffix. One character or empty string.",
                "type": "string",
                "pattern": "^[A-Z]{0,1}$"
            },
            "TimeMode": {
                "description": "The intended time mode. Either Universal Time Coordinated (UTC) or Local Time (LT)",
                "type": "string",
                "enum": [
                    "UTC",
                    "LT"
                ]
            },
            "PeriodOfOperation": {
                "description": "The combination of start date, end date and a weekday pattern",
                "type": "object",
                "required": [
                    "startDate",
                    "endDate",
                    "daysOfOperation"
                ],
                "properties": {
                    "startDate": {
                        "description": "The start date of this period in the format 'DDMMMYY'",
                                "$ref": "#/components/schemas/SSIMDate"

                    },
                    "endDate": {
                        "description": "The start date of this period in the format 'DDMMMYY'",
                                "$ref": "#/components/schemas/SSIMDate"
     
                    },
                    "daysOfOperation": {
                        "$ref": "#/components/schemas/DaysOfOperation"
                    }
                }
            },
            "DataElement": {
                "type": "object",
                "required": [
                    "startLegSequenceNumber",
                    "endLegSequenceNumber",
                    "id"
                ],
                "description": "A data element is an additional flight attribute as defined in SSIM, Chapter 2 dealing with a variety of characteristics, e.g.:\n* Traffic Restriction: 8\n* Codeshare - Duplicate leg cross-reference: 10\n* Codeshare - Operational leg cross-reference: 50\n* Departure Terminal: 99\n* Arrival Terminal: 98\n* Passenger Reservation Booking Designator (PRBD): 106\n* Meal service note: 109\n* Inflight Service: 503\n* Electronic Ticket Indicator: 505\n* etc.\n",
                "properties": {
                    "startLegSequenceNumber": {
                        "description": "The sequence number of the leg where data element boardpoint belongs to",
                        "type": "integer",
                        "minimum": 1
                    },
                    "endLegSequenceNumber": {
                        "description": "The sequence number of the leg where data element offpoint belongs to",
                        "type": "integer",
                        "minimum": 1
                    },
                    "id": {
                        "description": "The data element identifier - see SSIM, Chapter 2 for additional information",
                        "type": "integer",
                        "minimum": 1,
                        "maximum": 999
                    },
                    "value": {
                        "description": "The data element value itself",
                        "type": "string",
                        "pattern": "^([0-9A-Z]|\\s|/|-)*$"
                    }
                }
            },
            "Leg": {
                "type": "object",
                "required": [
                    "sequenceNumber",
                    "origin",
                    "destination",
                    "serviceType",
                    "aircraftType"
                ],
                "description": "A flight's leg is a smaller part of an overall journey which involves landing at an intermediate airport",
                "properties": {
                    "sequenceNumber": {
                        "description": "The sequence number of this leg in the associated itinerary",
                        "type": "integer",
                        "minimum": 1
                    },
                    "origin": {
                        "description": "The departure airport code",

                                "$ref": "#/components/schemas/Airport"

                    },
                    "destination": {
                        "description": "The arrival airport code",

                                "$ref": "#/components/schemas/Airport"

                    },
                    "serviceType": {
                        "description": "The service type of the leg. An uppercase letter.",

                                "$ref": "#/components/schemas/ServiceType"

                    },
                    "aircraftOwner": {
                        "description": "The aircraft owner or administrative carrier (an airline code) of the leg",

                                "$ref": "#/components/schemas/Airline"
                    },
                    "aircraftType": {
                        "$ref": "#/components/schemas/AircraftType"
                    },
                    "aircraftConfigurationVersion": {
                        "description": "The Aircraft Configuration/Version.",
                        "type": "string",
                        "pattern": "^[A-Z0-9]*$"
                    },
                    "registration": {
                        "description": "Aircraft Registration Information",
                        "type": "string",
                        "pattern": "^[A-Z0-9]*$"
                    },
                    "op": {
                        "description": "Signals whether this is an operating or a marketing leg",
                        "type": "boolean"
                    },
                    "aircraftDepartureTimeUTC": {
                        "description": "The UTC Aircraft Scheduled Time of Departure for this leg in minutes",
                        "type": "integer",
                        "minimum": 0,
                        "maximum": 1439
                    },
                    "aircraftDepartureTimeDateDiffUTC": {
                        "description": "The date difference between the flight UTC date and the aircraft departure time of this leg in days.",
                        "type": "integer",
                        "minimum": -1,
                        "maximum": 10
                    },
                    "aircraftDepartureTimeLT": {
                        "description": "The LT Aircraft Scheduled Time of Departure for this leg in minutes",
                        "type": "integer",
                        "minimum": 0,
                        "maximum": 1439
                    },
                    "aircraftDepartureTimeDateDiffLT": {
                        "description": "The date difference between the flight LT date and the aircraft departure time of this leg in days.",
                        "type": "integer",
                        "minimum": -1,
                        "maximum": 10
                    },
                    "aircraftDepartureTimeVariation": {
                        "description": "The departure time difference between the LT and UTC time in minutes.",
                        "type": "integer"
                    },
                    "aircraftArrivalTimeUTC": {
                        "description": "The UTC Aircraft Scheduled Time of Arrival for this leg in minutes",
                        "type": "integer",
                        "minimum": 1,
                        "maximum": 1440
                    },
                    "aircraftArrivalTimeDateDiffUTC": {
                        "description": "The date difference between the flight UTC date and the aircraftarrival time of this leg in days.",
                        "type": "integer",
                        "minimum": -1,
                        "maximum": 10
                    },
                    "aircraftArrivalTimeLT": {
                        "description": "The LT Aircraft Scheduled Time of Arrival for this leg in minutes",
                        "type": "integer",
                        "minimum": 1,
                        "maximum": 1440
                    },
                    "aircraftArrivalTimeDateDiffLT": {
                        "description": "The date difference between the flight LT date and the aircraft arrival time of this leg in days.",
                        "type": "integer",
                        "minimum": -1,
                        "maximum": 10
                    },
                    "aircraftArrivalTimeVariation": {
                        "description": "The arrival time difference between the LT and UTC time in minutes.",
                        "type": "integer"
                    }
                }
            },
            "FlightAggregate": {
                "type": "object",
                "description": "A FlightAggregate is a date-wise aggregation of otherwise single-dated flights. I.e. flights with identical attributes are aggregated into periods of operation.",
                "properties": {
                    "airline": {
                        "$ref": "#/components/schemas/Airline"
                    },
                    "flightNumber": {
                        "$ref": "#/components/schemas/FlightNumber"
                    },
                    "suffix": {
                        "$ref": "#/components/schemas/Suffix"
                    },
                    "periodOfOperationUTC": {
                        "$ref": "#/components/schemas/PeriodOfOperation"
                    },
                    "periodOfOperationLT": {
                        "$ref": "#/components/schemas/PeriodOfOperation"
                    },
                    "legs": {
                        "description": "The legs",
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/Leg"
                        }
                    },
                    "dataElements": {
                        "description": "The data elements",
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/DataElement"
                        }
                    }
                }
            },
            "Message": {
                "type": "object",
                "properties": {
                    "text": {
                        "description": "Message text",
                        "type": "string"
                    },
                    "level": {
                        "$ref": "#/components/schemas/MessageLevel"
                    }
                }
            },
            "TechnicalMessage": {
                "type": "object",
                "properties": {
                    "text": {
                        "description": "Message text",
                        "type": "string"
                    }
                }
            },
            "MessageLevel": {
                "description": "The level of messages retured by the REST API to the Client",
                "type": "string",
                "enum": [
                    "INFO",
                    "WARNING",
                    "ERROR"
                ]
            },
            "ErrorResponse": {
                "type": "object",
                "properties": {
                    "httpStatus": {
                        "type": "integer"
                    },
                    "messages": {
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/Message"
                        }
                    },
                    "technicalMessages": {
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/TechnicalMessage"
                        }
                    }
                }
            },
            "FlightResponse": {
                "type": "array",
                "items": {
                    "$ref": "#/components/schemas/FlightAggregate"
                }
            }
        }
    },
    "paths": {
        "/flightschedules/passenger": {
            "get": {
                "summary": "Returns passenger flights",
                "security": [
                    {
                        "Bearer": []
                    }
                ],
                "description": "This operation returns schedules related only to passenger flights.\nIn case a flight is marked both as cargo and passenger it will also be returned.",
                "operationId": "getPassengerFlights",
                "tags": [
                    "schedule"
                ],
                "parameters": [
                    {
                        "$ref": "#/components/parameters/airlines"
                    },
                    {
                        "$ref": "#/components/parameters/flightNumberRanges"
                    },
                    {
                        "$ref": "#/components/parameters/startDate"
                    },
                    {
                        "$ref": "#/components/parameters/endDate"
                    },
                    {
                        "$ref": "#/components/parameters/daysOfOperation"
                    },
                    {
                        "$ref": "#/components/parameters/timeMode"
                    },
                    {
                        "$ref": "#/components/parameters/origin"
                    },
                    {
                        "$ref": "#/components/parameters/destination"
                    },
                    {
                        "$ref": "#/components/parameters/aircraftTypes"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Successful operation",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "206": {
                        "description": "Result truncated",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": "Validation error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Authentication required",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "404": {
                        "description": "Flight not found",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "500": {
                        "description": "Server error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    }
                }
            }
        },
        "/flightschedules/cargo": {
            "get": {
                "summary": "Returns cargo flights",
                "security": [
                    {
                        "Bearer": []
                    }
                ],
                "description": "This operation returns schedules related to cargo flights only.\nIn case a flight is marked both as cargo and passenger it will also be returned.",
                "operationId": "getCargoFlights",
                "tags": [
                    "schedule"
                ],
                "parameters": [
                    {
                        "$ref": "#/components/parameters/airlines"
                    },
                    {
                        "$ref": "#/components/parameters/flightNumberRanges"
                    },
                    {
                        "$ref": "#/components/parameters/startDate"
                    },
                    {
                        "$ref": "#/components/parameters/endDate"
                    },
                    {
                        "$ref": "#/components/parameters/daysOfOperation"
                    },
                    {
                        "$ref": "#/components/parameters/timeMode"
                    },
                    {
                        "$ref": "#/components/parameters/origin"
                    },
                    {
                        "$ref": "#/components/parameters/destination"
                    },
                    {
                        "$ref": "#/components/parameters/aircraftTypes"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Successful operation",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "206": {
                        "description": "Result truncated",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": "Validation error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Authentication required",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "404": {
                        "description": "Flight not found",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "500": {
                        "description": "Server error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    }
                }
            }
        },
        "/flightschedules": {
            "get": {
                "summary": "Search all flights",
                "security": [
                    {
                        "Bearer": []
                    }
                ],
                "description": "Returns information about all flights based on available search criteria. Some criteria are mandatory to make a call to the API.",
                "operationId": "getAllFlights",
                "tags": [
                    "schedule"
                ],
                "parameters": [
                    {
                        "$ref": "#/components/parameters/airlines"
                    },
                    {
                        "$ref": "#/components/parameters/flightNumberRanges"
                    },
                    {
                        "$ref": "#/components/parameters/startDate"
                    },
                    {
                        "$ref": "#/components/parameters/endDate"
                    },
                    {
                        "$ref": "#/components/parameters/daysOfOperation"
                    },
                    {
                        "$ref": "#/components/parameters/timeMode"
                    },
                    {
                        "$ref": "#/components/parameters/origin"
                    },
                    {
                        "$ref": "#/components/parameters/destination"
                    },
                    {
                        "$ref": "#/components/parameters/aircraftTypes"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Successful operation",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "206": {
                        "description": "Result truncated",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/FlightResponse"
                                }
                            }
                        }
                    },
                    "400": {
                        "description": "Validation error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "401": {
                        "description": "Authentication required",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "404": {
                        "description": "Flight not found",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    },
                    "500": {
                        "description": "Server error",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "$ref": "#/components/schemas/ErrorResponse"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

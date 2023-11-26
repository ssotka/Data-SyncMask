**Data::SyncMask**

The purpose of this module is to provide masked (faked) PII given a JSON defined record identifying the types of PII data on the incoming data set along with a non-changing external identifier. The faked PII data will then be saved to a SQLite database in which each related record is associated with the external ID. This allows all the systems which share that ID to share the faked PII.

This is especially useful when a copy of production data is used to provide non-production testing data.

**Dependencies**

* DB::SQLite
* JSON::Fast

**Available Mask Types**

* First Names (en-US)
* Sur Names (en-US)
* Dates
* Cities (en-US)
* States/Provinces (en-US)
* Phone Numbers
* Street Number
* Street Name
* Building
* Suite
* Gov't ID (en-US)
* IPv4 address
* IPv6 address

The data used to provide some of the above masked data is specific to geographic locale, mostly because that was the data I had available but also in hopes of adding other locale data over time. If and when more locales are available it will be possible to request either locale-specific masked data or non-locale-specific (global) masked data.

Example define the following mask: 
```
my $template = q( {
    "ID" : "external-id",
    "firstName" : "first-name",
    "lastName"  : "sur-name",
    "street" : { "type" : [ "street-number", "street-name", "building", suite" ],
                 "format" : "|<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                },
    "city" : "city",
    "state" : "state-prov",
    "country" : "US",
    "phone" : { "type" : "phone-number",
                "format" : "(###) ###-####"
                },
    "ssn" : { "type" : "gov-id",
              "format" : "###-##-####"
              },
     "dob" : { "type" : "date",
               "formula" : "±5Y"
               },
     "ip-addr" : "ipv4-addr"
} );
my $db-file = './obfusbar.db'; # opens if exists else create
my $locale = 'en-US'; # default
my $sMask = Data::SyncMask.new( :$mask, $db-file, :$locale );
for @list -> $record {
    say $sMask.obfuscate($record);
}
```
Then send in the following data:
```
{
    "ID" : "001810500003YX1AA",
    "firstName" : "James",
    "lastName"  : "Kirk",
    "street" : "5641 Starfleet Tower, ste 4544",
    "city" : "San Francisco",
    "state" : "CA",
    "country" : "US",
    "phone" : "6505558150",
    "ssn" : "317-24-9910",
     "dob" : "2233-03-22",
     "ip-addr" : "128.0.0.1"
}
```
Get the following back (and stored in the SQLite DB):
```
{
    "ID" : "001810500003YX1AA",
    "firstName" : "Jose",
    "lastName"  : "McMillan",
    "street" : "1281 Winchester, Envoy Bldg, apt 1024",
    "city" : "Phoenix",
    "state" : "AZ",
    "country" : "US",
    "phone" : "(408) 555-1111",
    "ssn" : "111-22-1111",
    "dob" : "2228-12-01",
    "ip-addr" : "98.243.11.18"
}
```
Systems which share data using the same external ID can then use the same data in their systems for the given ID.

**COPYRIGHT and LICENSE**

© 2022 Scott Sotka. Licensed under the Artistic License 2.0.

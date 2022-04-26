# High Resolution AD Object Tracking

## How does it work?

* Each domain controller tracks changes with Update Sequence Numbers (USN)
* USNs are unique to the domain controller, each DC tracks USNs itself
* USNs are unique, each change increments the USN
* AD objects have a uSNChanged and uSNCreated attribute
* When a change is committed to AD the USN number for the transaction is recorded to the AD object

## Use Cases

* Sync to cache
* Pull changes to HRS
* Pull changes to application
use IaC Terrafrom to build the following resource besides requirement specifications:

* Use S3 to store Terraform statefile using "erakiterrafromstatefiles" bucket
* Consider to use difrrent name that others (i.e. specify a unique name for state file key)
* Create an S3 Bucket
* Create Directories as (e.g. /log, /outgoing, /incomming)
* Today's Example will Create an Amazon S3 storage and configure the S3 Lifecycle rules as as the following:
* Transition all files under /log to infrequent access (i.e. Standard-IA) 30 consecutive days after creation time.
* Transition all files under /log to Archive access (i.e. Glacier) 90 consecutive days after creation time.
* Transition all files under /log to Deep Archive access (i.e. Glacier Deep Archive) 180 consecutive days after creation time.
* Remove all files under /log 365 consecutive days after creation time.
* Transition all files under /outgoing with tag "notDeepArchive" to infrequent access (i.e. Standard-IA) 30 consecutive days after creation time.
* Transition all files under /outgoing to Archive access (i.e. Glacier) with tag "notDeepArchive" 90 consecutive days after creation time.
* Transition all files under /incoming with size between 1MB to 1G to infrequent access (i.e. Standard-IA) 30 consecutive days after creation time.
* Transition all files under /incoming with size between 1MB to 1G to Archive access (i.e. Glacier) 90 consecutive days after creation time.


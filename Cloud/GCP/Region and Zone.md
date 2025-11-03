# Total number of google region : https://cloud.google.com/about/locations#:~:text=October%2030%2C%202025-,42,-Regions
# Region details: https://docs.cloud.google.com/compute/docs/regions-zones

In AWS we called region and AZ but in GCP its called region and zone.
Mumbai Region: In every region there are minimum 3 zones.

- GCP resources are hosted in multiple locations globally.
- Region – is a specific independent geographic location that consists of zones.
- Zones – should be considered a single failure domain within a region. It's a actual data center.
- Each region consists of multiple zones.
- GCP offers connections to services from 146 locations across the globe, this is called edge location (POP).

Note: All these DC are interconnected with google dedicated private network (Dedicated Cable). Cables goes by ocean.

- A resource which is live and available in a zone is called a zonal resource.
  * Example: disks, VM instances, etc.

- A resource which is available in a region is called a regional resource.
  * Example: external IP, instance groups, etc.

- A resource available in every region and zone is called a global resource.
  * Example: VPC, Images, snapshots, etc.

In GCP we called account as project.
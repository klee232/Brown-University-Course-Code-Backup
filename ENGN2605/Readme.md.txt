Main Driver:

lab5.m: intiate all performance at once

=============================================================================
Problem 1

Code:
corner_detector.m: detecting corners (features) (copied from lab 4)
region_descriptors.m: outputing descriptors based on input string
find_matches.m: finding matches pairs between descriptor 1 and 2
coordinates_find.m: finding the corresponding coordinates for feature matches
accuracy_compute.m: computing feature repeating accuracy
coordinates_find_sift.m: finding the corresponding coordinates for SIFT features

Results:
illumination_change_results: SIFT and original results
planar_rotation_change_results: SIFT and original results
scale_rotation_change_results: SIFT and original results
view_change_results: SIFT and original results

=============================================================================
Problem 2

Code: 
find_matches_revised.m: implemented bidirectional consistency and feature uniquness

Results:
illumination_change_results: revised results
planar_rotation_change_results: revised results
scale_rotation_change_results: revised results
view_change_results: revised results
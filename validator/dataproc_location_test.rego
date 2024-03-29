#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPDataprocLocationConstraintV1

import data.validator.gcp.lib as lib

#Importing the test data
import data.test.fixtures.dataproc_location.assets as fixture_assets

# Importing the test constraints
import data.test.fixtures.dataproc_location.constraints as fixture_constraint

# Find all violations on our test cases
find_all_violations[violation] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as resources
		with input.constraint as constraint

	violation := issues[_]
}

cluster_violations[violation] {
	constraints := [fixture_constraint]
	violations := find_all_violations with data.resources as fixture_assets
		with data.test_constraints as constraints

	violation := violations[_]
}

test_dataproc_location_violations {
	violations := cluster_violations

	count(violations) == 2

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_name := {
		"//dataproc.googleapis.com/projects/my-test-project/regions/global/clusters/cluster-a1b6-test-dataproc",
		"//dataproc.googleapis.com/projects/my-test-project/regions/europe-west2/clusters/cluster-320f",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

#
# Copyright 2018 Google LLC
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

package templates.gcp.GCPGKEEnableStackdriverKubernetesEngineMonitoringV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.gke_enable_stackdriver_kubernetes_engine_monitoring.assets[_]
	constraint := data.test.fixtures.gke_enable_stackdriver_kubernetes_engine_monitoring.constraints

	issues := deny with input.asset as resource
		with input.constraint as constraint

	violation := issues[_]
}

test_stackdriver_kubernetes_engine_monitoring_disabled {
	#	count(all_violations) == 3
	violation_resources := {r | r = all_violations[_].details.resource}
	violation_resources == {
		"//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/legacy",
		"//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/legacy-monitoring",
		"//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/legacy-logging",
	}

	not violation_resources["//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/good"]
}

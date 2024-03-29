#
# Copyright 2022 Google LLC
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

package templates.gcp.TFGCPComputeIpForwardConstraintV2

import data.validator.gcp.lib as lib

###########################
# Find allowlist/denylist Violations
###########################
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Instance"

	instance := asset.resource.data

	params.allow_forward == instance.canIpForward

	message := sprintf("%v is not allowed to have IP forwarding enabled.", [asset.name])
	metadata := {"resource": asset.name}
}

#!/bin/bash
#
# Script to release projects based on changes to the deliverables
# files in the openstack/releases repository.
#
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -e

TOOLSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $TOOLSDIR/functions

function usage {
    echo "Usage: release_from_yaml.sh releases_repository [deliverable_files]"
    echo
    echo "Example: release_from_yaml.sh ~/repos/openstack/releases"
    echo "Example: release_from_yaml.sh ~/repos/openstack/releases"
    echo "Example: release_from_yaml.sh ~/repos/openstack/releases deliverables/mitaka/oslo.config.yaml"
}

if [ $# -lt 1 ]; then
    echo "ERROR: No releases_repository specified"
    echo
    usage
    exit 1
fi

RELEASES_REPO="$1"
shift
DELIVERABLES="$@"

$TOOLSDIR/list_deliverable_changes.py -r $RELEASES_REPO $DELIVERABLES \
| while read deliverable series version repo hash announce_to; do
    title "$repo $series $version $hash $announce_to"
    $TOOLSDIR/release.sh $repo $series $version $hash $announce_to
done

exit 0

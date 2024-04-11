#!/bin/bash
# Copyright (c) 2024, Lincoln Wallace
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License. 

target_core=$1

if [ -z "$target_core" ]; then
	echo "[ERROR] Please provide the core number that you wish to check"
    echo "Usage: $0 <core_number>"
	exit 1
fi

echo -e "Core $target_core has the IRQs associated:"
echo -e "IRQ\tAffinity mask"
# Iterate over the folders inside /proc/irq
for irq_folder in /proc/irq/*; do
    if [ -d "$irq_folder" ]; then
        irq_number=$(basename "$irq_folder")
        smp_affinity_file="$irq_folder/smp_affinity"

        # Check if smp_affinity file exists
        if [ -e "$smp_affinity_file" ]; then
            # Read the content of smp_affinity
            affinity_mask=$(cat "$smp_affinity_file")

            # Check if the affinity mask is associated with the target core
            if (( (1 << target_core) & 0x$affinity_mask )); then
                echo -e "$irq_number\t$affinity_mask"
            fi
        fi
    fi
done

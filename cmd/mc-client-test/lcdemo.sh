#!/bin/bash

# Copyright 2023 The KubeStellar Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. demo-magic.sh
clear

TYPE_SPEED=10
DEMO_PROMPT="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

MGT_NAME="mgt"
MGT_CTX="kind-$MGT_NAME"

#1 Create mgt cluster
pei "kind create cluster --name $MGT_NAME"
echo "  "

#2 list the kind clusters
pei "kind get clusters"
echo "  "

#3 Apply the LC and provider CRDs on the mgt cluster
pei "kubectl --context $MGT_CTX create -f config/crds/logicalcluster.kubestellar.io_logicalclusters.yaml"
pei "kubectl --context $MGT_CTX create -f config/crds/logicalcluster.kubestellar.io_clusterproviderdescs.yaml"
p "Start the manager in a second window and press <enter> to continue."

#4 Start the manager in a second window
echo "  "

#5 Create a provider (show the provider yaml,  filter prefix, etc..)
pei "cat config/samples/clusterproviderdesc.yaml" 
echo " "
echo " "
pei "kubectl --context $MGT_CTX create -f config/samples/clusterproviderdesc.yaml" 
echo " "
pei  "kubectl --context $MGT_CTX get clusterproviderdescs"
echo " "

#6 Show the created NS
pei "kubectl --context $MGT_CTX get namespaces" 
echo " "

#7 Create a LC-X1
pei "cat config/samples/logicalcluster_lc1.yaml" 
echo " "
echo " "
pei "kubectl --context $MGT_CTX create -f config/samples/logicalcluster_lc1.yaml" 
echo " "

#8 Show status of LC-X1 changes from initializing to READY
i=0; while ((i<5)); do kubectl --context $MGT_CTX describe logicalcluster lc1 -n lcprovider-default  2>&1 | grep 'Phase: '; sleep 2; ((i=i+1)); done
kubectl --context $MGT_CTX wait logicalclusters -n lcprovider-default lc1 --for=jsonpath='{.status.Phase}'=Ready  &>/dev/null
kubectl --context $MGT_CTX describe logicalcluster lc1 -n lcprovider-default  2>&1 | grep 'Phase: '
echo " "

#9 Create a LC-X1
echo " "
pei "kubectl --context $MGT_CTX create -f config/samples/logicalcluster_lc2.yaml" 
echo " "

#10 Show status of LC-X1 changes from initializing to READY
i=0; while ((i<5)); do kubectl --context $MGT_CTX describe logicalcluster lc2 -n lcprovider-default  2>&1 | grep 'Phase: ' ; sleep 2; ((i=i+1)); done
kubectl --context $MGT_CTX wait logicalclusters -n lcprovider-default lc2 --for=jsonpath='{.status.Phase}'=Ready  &>/dev/null
kubectl --context $MGT_CTX describe logicalcluster lc2 -n lcprovider-default  2>&1 | grep 'Phase: '
echo " "

#11 list kind clusters - show the created clusters X1 & X2
pei "kind get clusters"
echo "  "

#12 delete LC-X1
pei "kubectl --context $MGT_CTX delete logicalcluster -n lcprovider-default lc1"
echo "  "

#13 List kinds - show that X1 is deleted
pei "kind get clusters"
echo "  "

#14 Delete X2 on the kind
pei "kind delete cluster --name lc2"
echo "  "

#15 Show LC-X2 is in "not-ready" state
pei "kubectl --context $MGT_CTX describe logicalcluster lc2 -n lcprovider-default | grep 'Phase: '"
echo "  "

#16 Delete LC-X2
pei "kubectl --context $MGT_CTX delete logicalcluster -n lcprovider-default lc2"
echo "  "

#17 Create Y1 on kind
pei "kind create cluster --name lc3"
echo "  "

pei "kind get clusters"
echo "  "

pei "kubectl --context $MGT_CTX get logicalclusters -A"
echo "  "

#18 Create prefix-Y2 on kind
pei "kind create cluster --name ks-lc4"
echo "  "

#19 List LCs - show that we discover only prefix-Y2
pei "kubectl --context $MGT_CTX get logicalclusters -A"
echo "  "


/*
Copyright 2023 The KCP Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// TODO(waltforme): cleanup this file and all references to its contents

package scheduler

import (
	"fmt"
)

func (s *internalData) show() {
	fmt.Println("----")
	fmt.Println("epsBySelectedLoc", s.epsBySelectedLoc)
	fmt.Println("locsBySelectedSt", s.locsBySelectedSt)
	fmt.Println("epsByUsedSt", s.epsByUsedSt)
	fmt.Println("----")
}

func (s *internalData) manuallyFillIn() {
	s.epsBySelectedLoc["qg6uhayltmxxfong|dev"] = []string{"kvdk2spgmbix|dev"} // ~|dev selects root:compute|dev
}

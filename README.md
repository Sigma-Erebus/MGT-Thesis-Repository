This repository serves as a collection of relevant files for the Master's thesis titled:

Accelerating Unreal Engine Compilation by Utilizing Developer Workstations

Written by Hidde Derks, during his studies for the Master Game Technologies at Breda University of Applied Sciences. This thesis is also included in this repository.

The primary data, along with visualizations can be found in the two Microsoft Excel files, with the 'Survey Results.xlsx' detailing participant experiences with Unreal Horde (the target of this research). 

The 'Scaling Tests.xlsx' Excel file details the scaling tests that were performed separately, these tests focused on finding how well certain tasks parallelized (and could be acceelrated) with specific hardware configurations. The server and agent configurations that were used for these scaling tests can be found in the 'Horde Server Files' and 'Kubernetes (Docker) Agent Files' respectively. In these tests, the initiators were laptops with an i9-10980HK CPU and 32GB of RAM. The remote agents were set up on a Kubernetes node with dual Ryzen Epyc 9554 CPUs, and 1.5TB of RAM; the actual allocation of agents varied throughout the tests, but any resources that were assigned to an agent pod within kubernetes, were pinned to be exclusively available for said agent. In cases where the thesis or Excel file refer to '0 cores' or 'Baseline', this was a run without agent acceleration, being run solely on the initiator laptop.
In the scaling tests, three different targets were evaluated (all from the Unreal 5.6.1 source code that can be found at https://www.unrealengine.com/ue-on-github):
- UE5: The full engine target consisting of 7914 compile actions
- UnrealInsights: A smaller profiling tool consisting of 501 compile actions
- UnrealPackageTool: A very small packaging tool consisting of 65 compile actions

The 'Scaling Test Trace Files' folder contains the trace files for each individual test, which can be cross-referenced with the raw data to be found in the 'Scaling Tests.xlsx' file.
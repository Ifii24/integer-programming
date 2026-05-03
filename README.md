# Integer Programming — Crew Work Assignment

![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![Course](https://img.shields.io/badge/DTU-42114%20Integer%20Programming-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)

Project assignment for DTU course 42114 Integer Programming (2023).
**Authors:** Ifigeneia Tziola (s222569), Charalampos Kozaris (s230224), Antonios Kostoudis (s233560)

---

## The Problem

You have `n = 6` tasks with the following durations (in minutes):

| Task | 1 | 2 | 3 | 4 | 5 | 6 |
|------|-----|-----|-----|-----|-----|-----|
| Duration | 100 | 200 | 400 | 500 | 900 | 700 |

The tasks must be split into `k = 3` groups. Each group must consist of **consecutive tasks** — you cannot skip tasks or rearrange them. The goal is to minimise the duration of the **longest group** (the makespan).

This is a classic **set partitioning** problem with a minimax objective.

---

## Formulation

Since tasks must be consecutive, all possible valid assignments can be enumerated upfront. With 6 tasks, there are `W = 21` possible consecutive blocks (e.g. {1}, {1,2}, {1,2,3}, {2}, {2,3}, ..., {6}).

**Matrix D** (`t × W`) encodes which tasks each assignment covers: `D[j, i] = 1` if task `j` is in assignment `i`.

**Variables:**
- `x[i] ∈ {0,1}` — 1 if assignment `i` is selected
- `M ≥ 0` — the makespan (duration of the longest selected assignment)

**Constraints:**
```
∑ D[j,i] * x[i] = 1    ∀ j        (each task covered exactly once)
∑ x[i] = k                         (exactly k assignments selected)
M ≥ c[i] * x[i]         ∀ i        (M is at least as large as each selected assignment)
```

**Objective:**
```
min M
```

---

## Solution

Running the model gives:

| Assignment | Tasks | Duration |
|------------|-------|----------|
| 4 | 1, 2, 3, 4 | 1200 min |
| 19 | 5 | 900 min |
| 21 | 6 | 700 min |

**Optimal makespan: 1200 minutes.** This matches the result obtained independently via dynamic programming recursion.

---

## How to Run

```julia
# Install dependencies (once)
using Pkg
Pkg.add(["JuMP", "GLPK"])

# Run
julia solution.jl
```

**Expected output:**
```
Optimal makespan: 1200.0 minutes

Selected assignments:
  Assignment 4  — Tasks: [1, 2, 3, 4] — Duration: 1200 min
  Assignment 19 — Tasks: [5]           — Duration: 900 min
  Assignment 21 — Tasks: [6]           — Duration: 700 min
```

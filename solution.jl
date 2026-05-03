# Integer Programming — Crew Work Assignment (Consecutive Tasks)
# Course: 42114 Integer Programming, DTU 2023
# Authors: Ifigeneia Tziola (s222569), Charalampos Kozaris (s230224), Antonios Kostoudis (s233560)
#
# Problem: Assign n=6 tasks to k=3 groups of consecutive tasks.
# Each group is a contiguous block of tasks. Minimise the duration of the longest group.
#
# Usage:
#   julia solution.jl
#
# Dependencies:
#   using Pkg; Pkg.add(["JuMP", "GLPK"])

using JuMP, GLPK

# Number of possible consecutive assignments (columns of D)
W = 21

# Number of assignments in the solution
k = 3

# Number of tasks
t = 6

# D[j, i] = 1 if task j is covered by assignment i (columns = assignments, rows = tasks)
D = [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0;
     0 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0;
     0 0 0 1 1 1 0 0 1 1 1 0 1 1 1 1 1 1 0 0 0;
     0 0 0 0 1 1 0 0 0 1 1 0 0 1 1 0 1 1 1 1 0;
     0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 1 1]

# Cost (duration in minutes) of each of the 21 possible assignments
c = [100 300 700 1200 2100 2800 200 600 1100 2000 2700 400 900 1800 2500 500 1400 2100 900 1600 700]

model = Model(GLPK.Optimizer)

# x[i] = 1 if assignment i is selected, 0 otherwise
@variable(model, x[1:W], Bin)

# Auxiliary variable for the makespan (duration of the longest assignment)
@variable(model, M >= 0)

# Each task must be covered by exactly one selected assignment
@constraint(model, [j in 1:t], sum(D[j, i] * x[i] for i in 1:W) == 1)

# Exactly k assignments must be selected
@constraint(model, sum(x[i] for i in 1:W) == k)

# M must be >= the duration of every selected assignment
@constraint(model, [i in 1:W], M >= c[i] * x[i])

# Minimise the longest assignment duration
@objective(model, Min, M)

JuMP.optimize!(model)

if termination_status(model) == MOI.OPTIMAL
    println("Optimal makespan: ", JuMP.objective_value(model), " minutes")
    println()
    println("Selected assignments:")
    for i in 1:W
        if JuMP.value(x[i]) > 0.5
            tasks = [j for j in 1:t if D[j, i] == 1]
            println("  Assignment $i — Tasks: $tasks — Duration: $(c[i]) min")
        end
    end
else
    println("No optimal solution found. Status: ", termination_status(model))
end

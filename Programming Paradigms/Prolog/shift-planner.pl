%Helper predicate to list all employees
all_employees(Employees) :-
    findall(E, employee(E), Employees).

%Helper predicate to list all workstations
all_workstations(Workstations) :-
    findall(W, workstation(W, _, _), Workstations).

%Helper predicate to determine if a workstation is active during a shift
workstation_active(Workstation, Shift) :-
    \+ workstation_idle(Workstation, Shift).

%Helper predicate to check if an employee can work at a workstation
can_work_at_workstation(Employee, Workstation) :-
    \+ avoid_workstation(Employee, Workstation).

%Helper predicate to check if an employee can work at a shift
can_work_at_shift(Employee, Shift) :-
    \+ avoid_shift(Employee, Shift).

%Extract employee names from a single workstation
get_names_from_workstation(workstation(_, Employees), Employees).

%Extract employee names from all workstations
get_names([], []).
get_names([Workstation | Rest], Names) :-
    get_names_from_workstation(Workstation, WorkstationNames),
    get_names(Rest, RestNames),
    append(WorkstationNames, RestNames, Names).

%Helper predicate to assign employees to a workstation
assign_employees_to_workstation([], _, _, _, []).
assign_employees_to_workstation([Employee | Rest], Workstation, Shift, Assigned, [Employee | Result]) :-
    \+ member(Employee, Assigned),
    can_work_at_workstation(Employee, Workstation),
    can_work_at_shift(Employee, Shift),
    length([Assigned], Count),
    workstation(Workstation, Min, Max),
    Count =< Max,
    assign_employees_to_workstation(Rest, Workstation, Shift, [Employee | Assigned], Result).
assign_employees_to_workstation([_ | Rest], Workstation, Shift, Assigned, Result) :-
    assign_employees_to_workstation(Rest, Workstation, Shift, Assigned, Result).

%Helper predicate to create a shift plan by iterating through each workstation of the shift.
create_shift([], _, _, _, []).
create_shift([Workstation | Rest], Employees, Shift, Assigned, [workstation(Workstation, Result) | Plan]) :-
    workstation_active(Workstation, Shift),
    assign_employees_to_workstation(Employees, Workstation, Shift, Assigned, Result),
    create_shift(Rest, Employees, Shift, Result, Plan).
create_shift([_ | Rest], Employees, Shift, Assigned, Plan) :-
    create_shift(Rest, Employees, Shift, Assigned, Plan).

%Plan predicate
plan(plan(Morning, Evening, Night)) :-
    all_employees(Employees),
    all_workstations(Workstations),
    create_shift(Workstations, Employees, morning, [], Morning),
    get_names(Morning, MorningNewAssigned), %Get a list of all who were assigned a morning shift
    create_shift(Workstations, Employees, evening, MorningNewAssigned, Evening),
    get_names(Evening, EveningNewAssigned), %Get a list of all who were assinged an evening
    create_shift(Workstations, Employees, night, EveningNewAssigned, Night).

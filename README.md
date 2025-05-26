# Prolog-University-System

This project implements an intelligent class scheduling system in Prolog, automating the creation of conflict-free course timetables for university students. The project leverages knowledge-based reasoning and constraint satisfaction to ensure valid schedules, provide guaranteed days off, and identify common free time slots for all students.

Key features:

Knowledge Base Integration: Utilizes an external knowledge base to represent students, courses, and weekly schedules, enabling dynamic and customizable timetable generation.
Conflict-Free Scheduling: Ensures that no student is assigned overlapping courses, maintaining complete schedule consistency.
Study Day Constraints: Enforces a minimum number of days off for each student, supporting well-balanced timetables.
Common Free Slot Detection: Identifies all time slots where every student is simultaneously available, useful for assembly hours or group activities.
Declarative Constraint Solving: Employs Prolog’s logical inference engine to handle scheduling rules, clash detection, and day calculations efficiently.
Modular Predicate Design: Implements a suite of reusable predicates for generating schedules, validating constraints, and extracting useful scheduling insights.

This project demonstrates the practical application of logic programming to solve real-world scheduling problems, providing a foundation for further exploration of constraint satisfaction, automated planning, and knowledge-based systems in Prolog.

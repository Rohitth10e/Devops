student_marks = {
    "Alice": [80, 85, 90],
    "Bob": [70, 75, 80],
    "Charlie": [60, 65, 70],
    "Dave": [50, 55, 60],
}

def add_student(name, marks):
    if name in student_marks:
        print(f"{name} already exists.")
        return
    student_marks[name] = marks
    print(f"{name} added successfully.")

def update_student(name, marks):
    if name not in student_marks:
        print(f"{name} does not exist.")
        return
    student_marks[name] = marks
    print(f"{name} updated successfully.")

def print_all_students():
    for name, marks in student_marks.items():
        print(f"{name}: {marks}")

add_student("Eve", [90, 95, 100])
update_student("Alice", [85, 90, 95])
print_all_students()
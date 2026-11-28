-- Завдання:
--      Для кожного студента знайти його середній бал у порівнянні з середнім балом по групі
--      Очікувані колонки результату:
--          - ідентифікатор студента (student_id)
--          - повне ім'я студента (full_name)
--          - середній бал студента (avg_student_grade) - округлити результат до 2 знаків після коми
--          - назва групи (group_name)
--          - середній бал по групі (avg_group_grade) - округлити результат до 2 знаків після коми
--      Результат відсортувати за:
--          - за назвою групи, потім за іменем студента, потім за ідентифікатором студента

-- Рішення:
with student_grades as (
select s.student_id,
p.first_name || ' ' || p.last_name as full_name,
sg.group_id,
sg.group_name,
avg(e.grade) as raw_student_avg
from student s
join person p on s.person_id = p.person_id
join student_group_assignment sga on sga.student_id = s.student_id
join student_group sg on sg.group_id = sga.group_id
left join enrolment e on e.student_id = s.student_id
group by s.student_id, p.person_id, sg.group_id
)
select 
student_id,
full_name,
round(raw_student_avg, 2) as avg_student_grade,
group_name,
round(avg(raw_student_avg) over (partition by group_id), 2) as avg_group_grade
from student_grades
order by group_name, full_name, student_id;
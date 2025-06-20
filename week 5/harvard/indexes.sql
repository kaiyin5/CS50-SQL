CREATE INDEX "enrollments_student_index" ON "enrollments"("student_id");
CREATE INDEX "enrollments_course_id_index" ON "enrollments"("course_id");
CREATE INDEX "courses_semester_index" ON "courses"("semester");
CREATE INDEX "courses_cs_index" ON "courses"("department")
WHERE "department" = 'Computer Science';
CREATE INDEX "satisfies_course_id_index" ON "satisfies"("course_id");
-- objective: eliminate 'SCAN' keyword in every queries with minimal indexes created
-- ------------------------ Exploratory Data Analysis ------------------------------
-- ---------------------------------------------------------------------------------

SELECT 
    COUNT(DISTINCT appointment.PatientID) AS patients_with_appt
FROM
    appointment;

-- 2. How many appointments were scheduled in each month?
SELECT 
    appointment.Month_no AS month_no,
    appointment.Month AS month,
    COUNT(appointment.AppointmentID) AS total_appt
FROM
    appointment
GROUP BY month , month_no
ORDER BY month_no;

-- 3. How many appointments were scheduled in each year?
SELECT 
    appointment.Year AS year,
    COUNT(appointment.AppointmentID) AS total_appt
FROM
    appointment
GROUP BY year;

-- 4. What are the most common reasons for appointments?
SELECT 
    billing.Items AS items,
    COUNT(appointment.AppointmentID) AS total_appt
FROM
    appointment
        JOIN
    billing ON appointment.PatientID = billing.PatientID
GROUP BY items
ORDER BY total_appt DESC
LIMIT 3;

-- 5. What is the average billing amount per patient?
SELECT 
    patient.PatientID AS PatientID,
    patient.FullName AS FullName,
    IFNULL(ROUND(AVG(billing.Amount), 2), 0) AS avg_bill
FROM
    patient
        LEFT JOIN
    billing ON billing.PatientID = patient.PatientID
GROUP BY PatientID , FullName;

-- 6. How many unique doctors are in the dataset?
SELECT 
    COUNT(DISTINCT doctor.DoctorID) AS total_doctors
FROM
    doctor;

-- 7. What is the distribution of doctors by specialization?
SELECT 
    doctor.Specialization AS specialization,
    COUNT(DISTINCT doctor.DoctorName) AS total_doctors_per_spec
FROM
    doctor
GROUP BY specialization;

-- 8. How many unique medical procedures are available?
SELECT 
    COUNT(DISTINCT med_procedure.ProcedureID) AS total_med_proc
FROM
    med_procedure;

-- 9. What is the most common procedure performed?
SELECT 
    med_procedure.ProcedureName AS most_common_proc,
    COUNT(med_procedure.ProcedureName) AS total_proc
FROM
    med_procedure
GROUP BY most_common_proc
ORDER BY total_proc DESC
LIMIT 1;

-- 10. What is the average cost of procedures?
SELECT 
    med_procedure.ProcedureName AS procedure_name,
    IFNULL(ROUND(AVG(billing.Amount), 2), 0) AS total_cost_of_procedure
FROM
    med_procedure
        LEFT JOIN
    appointment ON med_procedure.AppointmentID = appointment.AppointmentID
        LEFT JOIN
    billing ON appointment.PatientID = billing.PatientID
GROUP BY procedure_name;

-- 11. What is the daily trend in appointment scheduling?
SELECT DISTINCT
    appointment.Date AS date,
    COUNT(appointment.AppointmentID) AS total_appt_per_day
FROM
    appointment
GROUP BY date
ORDER BY date;

-- 12. What is the weekly trend in appointment scheduling?
SELECT DISTINCT
    appointment.Weekday AS weekday,
    COUNT(appointment.AppointmentID) AS total_appt_per_day
FROM
    appointment
GROUP BY weekday
ORDER BY FIELD(weekday,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');

-- 13. How many patients does each doctor see each month?
SELECT DISTINCT
    appointment.Month AS month,
    doctor.DoctorName AS doctor,
    COUNT(appointment.PatientID) AS patients
FROM
    doctor
        LEFT JOIN
    appointment ON appointment.DoctorID = doctor.DoctorID
GROUP BY doctor , month
ORDER BY FIELD(appointment.Month,
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec');

-- 14. Which doctor has the highest number of patient appointments?
SELECT 
    doctor.DoctorName AS doctor,
    COUNT(appointment.AppointmentID) AS patient_appt
FROM
    doctor
        LEFT JOIN
    appointment ON appointment.DoctorID = doctor.DoctorID
GROUP BY doctor
ORDER BY patient_appt DESC
LIMIT 1;

-- 15. What is the total billing amount for each patient?
SELECT 
    patient.PatientID AS PatientID,
    patient.FullName AS FullName,
    IFNULL(ROUND(SUM(billing.Amount), 2), 0) AS total_bill
FROM
    patient
        LEFT JOIN
    billing ON billing.PatientID = patient.PatientID
GROUP BY PatientID , FullName;

-- 16. What is the ratio of patients to doctors across different specializations?
SELECT 
    patient_count.specialization AS all_specializations,
    total_patients,
    total_doctors,
    IFNULL(ROUND(total_patients / total_doctors, 2),
            0) AS doc_pat_ratio
FROM
    (SELECT 
        doctor.Specialization AS Specialization,
            COUNT(appointment.PatientID) AS total_patients
    FROM
        doctor
    LEFT JOIN appointment ON doctor.DoctorID = appointment.DoctorID
    GROUP BY Specialization) AS patient_count
        JOIN
    (SELECT 
        Specialization, COUNT(DISTINCT DoctorID) AS total_doctors
    FROM
        doctor
    GROUP BY Specialization) AS doctor_count ON patient_count.Specialization = doctor_count.Specialization;
    
-- 17. What is the total number of procedures performed by each doctor?
SELECT DISTINCT
    doctor.DoctorName AS doctor_name,
    IFNULL(COUNT(med_procedure.ProcedureID), 0) AS total_procedure
FROM
    doctor
        LEFT JOIN
    appointment ON doctor.DoctorID = appointment.DoctorID
        LEFT JOIN
    med_procedure ON med_procedure.AppointmentID = appointment.AppointmentID
GROUP BY doctor_name;

-- 18. What percentage of patients have undergone multiple procedures?

SELECT 
    SUM(multiple_procedures) * 100 / COUNT(DISTINCT patient_id) AS perc_of_patients_mult_proc
FROM
    (SELECT 
        patient_id,
            (CASE
                WHEN total_proc > 1 THEN 1
                ELSE 0
            END) AS multiple_procedures
    FROM
        (SELECT 
        patient.PatientID AS patient_id,
            COUNT(med_procedure.ProcedureID) AS total_proc
    FROM
        patient
    LEFT JOIN appointment ON patient.PatientID = appointment.PatientID
    LEFT JOIN med_procedure ON appointment.AppointmentID = med_procedure.AppointmentID
    GROUP BY patient_id) AS patient_proc_count) AS count_med_proc;

-- 19. Which days of the week have the highest number of appointments?
SELECT 
    appointment.Weekday AS weekday,
    IFNULL(COUNT(appointment.AppointmentID), 0) AS total_appointments
FROM
    appointment
GROUP BY weekday
ORDER BY total_appointments DESC
LIMIT 3;

-- 20. What is the trend in billing amounts over time?
SELECT 
    DATE_FORMAT(appointment.Date, '%Y-%m') AS billing_month,
    SUM(billing.Amount) AS total_billing
FROM
    appointment
        LEFT JOIN
    billing ON appointment.PatientID = billing.PatientID
GROUP BY billing_month
ORDER BY billing_month;




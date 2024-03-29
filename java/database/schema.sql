BEGIN;

DROP TABLE IF EXISTS daysOfTheWeek, users, office, patients, doctors, appointments, prescriptions, reviews, availability CASCADE;

CREATE TABLE daysOfTheWeek (
    day_id int,
    day_description VARCHAR(9),
    CONSTRAINT PK_day_id PRIMARY KEY (day_id)
);

CREATE TABLE users (
    user_id SERIAL,
    username varchar(50) NOT NULL UNIQUE,
    password_hash varchar(200) NOT NULL,
    role varchar(50) NOT NULL,
    CONSTRAINT PK_user PRIMARY KEY (user_id)
);
CREATE TABLE office (
    office_id SERIAL,
    name varchar(50) NOT NULL ,
    address varchar(200) ,
    phone_number varchar(50) ,
    office_hr varchar(20),
    CONSTRAINT PK_office_id PRIMARY KEY (office_id)
);

CREATE TABLE doctors (
    doctor_id SERIAL,
    user_id int,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    specialty varchar(50) NOT NULL,
    headshot varchar(100),
    CONSTRAINT PK_doctors PRIMARY KEY (doctor_id),
    CONSTRAINT FK_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE patients (
    patient_id SERIAL,
    user_id int,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    birthdate date NOT NULL,
    phone_number varchar(50) NOT NULL,
    email varchar(100) NOT NULL,
    CONSTRAINT PK_patients PRIMARY KEY (patient_id),
    CONSTRAINT FK_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE appointments (
    appointment_id SERIAL,
    doctor_id int,
    patient_id int,
    appointment_start_time timestamp with time zone NOT NULL,
    appointment_end_time timestamp with time zone,
    notes varchar(50) NOT NULL,
    CONSTRAINT PK_appointment PRIMARY KEY (appointment_id),
    CONSTRAINT FK_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    CONSTRAINT FK_patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE prescriptions (
    prescription_id SERIAL,
    patient_id int,
    doctor_id int,
    name varchar(50) NOT NULL,
    cost int NOT NULL,
    CONSTRAINT PK_prescriptions PRIMARY KEY (prescription_id),
    CONSTRAINT FK_patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT FK_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    review_id SERIAL,
    doctor_id int,
    response varchar(200),
    rating int,
    review_note varchar(200),
    CONSTRAINT PK_review_id PRIMARY KEY (review_id),
    CONSTRAINT FK_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

CREATE TABLE availability (
    availability_id SERIAL,
    doctor_id int,
    day_id int,
    start_time time,
    end_time time,
    CONSTRAINT PK_availability_id PRIMARY KEY (availability_id),
    CONSTRAINT FK_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    CONSTRAINT FK_day_id FOREIGN KEY (day_id) REFERENCES daysOfTheWeek(day_id)
);

COMMIT TRANSACTION;
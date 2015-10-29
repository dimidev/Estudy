institution = Institution.find_or_create_by(
  title: 'ΤΕΙ ΔΥΤΙΚΗΣ ΜΑΚΕΔΟΝΙΑΣ ΠΑΡΑΡΤΗΜΑ ΚΑΣΤΟΡΙΑΣ',
  foundation_date: '2003'
)

Superadmin.find_or_create_by(
  institution: institution,
  email: 'superadmin@demo.com',
  password: 'superadmindemo'
)

informatics = institution.departments.find_or_create_by(
  title: 'ΤΜΗΜΑ ΜΗΧΑΝΙΚΩΝ ΠΛΗΡΟΦΟΡΙΚΗΣ Τ.Ε.',
  foundation_date: '2003'
)

programme = informatics.studies_programmes.find_or_create_by(
  diploma_title: 'ΜΗΧΑΝΙΚΩΝ ΠΛΗΡΟΦΟΡΙΚΗΣ Τ.Ε.',
  studies_level: 'undergraduate',
  semesters: 8
)

informatics.admins.find_or_create_by(
    email: 'admin@demo.com',
    password: 'admindemo',
    name: 'Admin',
    lastname: 'Demo',
    gender: %w(male female).sample,
    birthdate: Faker::Date.between(20.years.ago, Date.current)
)

20.times do |i|
  Student.find_or_create_by(
      department_id: informatics,
      studies_programme_id: programme,
      stc: i,
      email: Faker::Internet.free_email,
      password: 'studentdemo',
      name: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      gender: %w(male female).sample,
      birthdate: Faker::Date.between(20.years.ago, Date.current),
      semester: rand(1..12)
  )
end

Student.find_or_create_by(
    department_id: informatics,
    studies_programme_id: programme,
    stc: 1220,
    email: 'student@demo.com',
    password: 'studentdemo',
    name: 'Student',
    lastname: 'Demo',
    gender: 'male',
    birthdate: '1989-12-04',
    semester: rand(1..12)
)

programme.courses.find_or_create_by(
  title: 'ΑΡΧΕΣ ΟΙΚΟΝΟΜΙΚΗΣ ΘΕΩΡΙΑΣ',
  semester: 1,
  course_type: 'compulsory',
  ects: rand(2..8),
  hours: rand(4..6)
)

programme.courses.find_or_create_by(
  title: 'ΓΡΑΜΜΙΚΗ ΑΛΓΕΒΡΑ',
  semester: 1,
  course_type: 'compulsory',
  ects: rand(2..8),
  hours: rand(4..6)
)
programme.courses.find_or_create_by(
  title: 'ΔΟΜΕΣ ΔΕΔΟΜΕΝΩΝ',
  semester: 2,
  course_type: 'compulsory',
  ects: rand(2..8),
  hours: rand(4..6)
)
programme.courses.find_or_create_by(
  title: 'ΠΛΗΡΟΦΟΡΙΚΗ ΚΑΙ ΚΟΙΝΩΝΙΑ',
  semester: 3,
  course_type: 'compulsory',
  ects: rand(2..8),
  hours: rand(4..6)
)
programme.courses.find_or_create_by(
  title: 'ΚΑΤΑΝΕΜΗΜΕΝΑ ΣΥΣΤΗΜΑΤΑ',
  semester: 5,
  course_type: 'compulsory',
  ects: rand(2..8),
  hours: rand(4..6)
)


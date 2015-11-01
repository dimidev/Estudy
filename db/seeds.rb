institution = Institution.create(
  title: 'ΤΕΙ Δυτικης Μακεδονίας',
  foundation_date: '2003',
  address: Address.new(
    country: 'GR',
    city: 'Καστοριά',
    postal_code: '52100',
    address: 'Φούρκα')
)

Superadmin.create(
  institution: institution,
  email: 'superadmin@estudy.com',
  password: 'superadmindemo'
)

informatics = Department.create(
  title: 'Τμήμα Μηχανικών Πληροφορικής Τ.Ε.',
  foundation_date: '2003',
    address: Address.new(
    country: 'GR',
    city: 'Καστοριά',
    postal_code: '52100',
    address: 'Φούρκα')
)

Admin.create(
  department: informatics,
  email: 'admin@estudy.com',
  password: 'admindemo',
  name: 'Admin',
  lastname: 'Demo',
  gender: 'male',
  birthdate: '2015-12-04'
)
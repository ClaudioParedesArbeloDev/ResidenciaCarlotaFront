<p align="center">
  <img src="assets/images/LogoCarlota.png" alt="Residencia Carlota" width="140" />
</p>

<h1 align="center">Residencia Carlota · App</h1>

<p align="center">
  App de gestión para residencias geriátricas, para escritorio y móvil · Elderly care home management app for desktop and mobile
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" />
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
  <img src="https://img.shields.io/badge/macOS_/_iOS-000000?style=for-the-badge&logo=apple&logoColor=white" />
</p>

<p align="center">
  <a href="#-español">Español</a> · <a href="#-english">English</a>
</p>

> API Laravel: **[ResidenciaCarlotaBack](https://github.com/ClaudioParedesArbeloDev/ResidenciaCarlotaBack)**

---

## 🇪🇸 Español

### Qué es

Aplicación Flutter que usa el personal de una residencia geriátrica para llevar la **historia clínica** de cada residente, las **indicaciones de medicación**, los **signos vitales** y la **ocupación de camas**. Una sola base de código corre en las PCs de enfermería (Windows/Linux/macOS) y en celulares (Android/iOS). Lo que ve y puede editar cada usuario depende de su rol (admin, médico, enfermería, kinesiología, nutrición, trabajo social).

### Pantallas

- **Inicio** con accesos según rol.
- **Pacientes:** listado, alta y ficha con pestañas — datos personales, contactos familiares, alergias, diagnósticos (buscador **CIE-10**), cama asignada e historia clínica.
- **Clínica:** evoluciones, estudios médicos, signos vitales, prescripciones con horarios.
- **Medicamentos:** vademécum interno.
- **Habitaciones y camas:** ocupación y asignaciones.
- **Empleados:** alta, detalle y especialidades.
- **Login** con email/contraseña o Google, recuperación de contraseña con deep link.

### Estructura

```
lib/
├── core/            # config, colores, helpers de plataforma y fechas
├── data/
│   ├── models/      # modelos (paciente, prescripción, signo vital…)
│   └── repositories/# acceso a la API por recurso
├── services/        # cliente HTTP, Google Sign-In, deep links
└── screens/         # una carpeta por módulo
```

### Cómo correrlo

```bash
git clone https://github.com/ClaudioParedesArbeloDev/ResidenciaCarlotaFront.git
cd ResidenciaCarlotaFront
flutter pub get
flutter run -d windows   # o linux, macos, android, ios
```

La URL de la API se configura en `lib/core/config.dart`.

---

## 🇬🇧 English

### What it is

Flutter app used by the staff of an elderly care home to keep each resident's **medical record**, **medication orders**, **vital signs** and **bed occupancy**. A single codebase runs on nursing-station PCs (Windows/Linux/macOS) and phones (Android/iOS). What each user can see and edit depends on their role (admin, doctor, nurse, physiotherapy, nutrition, social work).

### Screens

- **Home** with role-based shortcuts.
- **Patients:** list, create and a tabbed profile — personal data, family contacts, allergies, diagnoses (**ICD-10** search), assigned bed and medical history.
- **Clinical:** progress notes, medical studies, vital signs, prescriptions with schedules.
- **Medications** catalogue.
- **Rooms & beds:** occupancy and assignments.
- **Employees:** create, view and assign specialties.
- **Sign-in** with email/password or Google; password reset via deep link.

### Running it

```bash
flutter pub get
flutter run -d windows   # or linux, macos, android, ios
```

The API URL lives in `lib/core/config.dart`.

---

<p align="center">
  Hecho por / Built by <a href="https://github.com/ClaudioParedesArbeloDev"><b>Claudio Paredes Arbelo</b></a> · <a href="https://www.claudioparedes.site">Code & Lens Solutions</a>
</p>

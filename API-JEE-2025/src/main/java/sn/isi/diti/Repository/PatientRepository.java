package sn.isi.diti.Repository;

import sn.isi.diti.JPAUtil;
import sn.isi.diti.Model.Patient;

import javax.persistence.EntityManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientRepository {
    private EntityManager db;

    public PatientRepository() {
        db = JPAUtil
                .getEntityManagerFactory()
                .createEntityManager();
    }

    public List<Patient> getAll() throws SQLException {
        List<Patient> list = new ArrayList<>();
        db.getTransaction().begin();
        List<Patient> resultat = db.createQuery("FROM Patient", Patient.class).getResultList();
        db.getTransaction().commit();
        for (Patient p : resultat) {
            Patient patient = new Patient();
            patient.setId(p.getId());
            patient.setNom(p.getNom());
            patient.setPrenom(p.getPrenom());
            patient.setAge(p.getAge());
            patient.setSexe(p.getSexe());
            patient.setTelephone(p.getTelephone());
            patient.setMaladie(p.getMaladie());
            list.add(patient);
        }
        return list;
    }

    public void add(Patient patient) throws SQLException {
        db.getTransaction().begin();
        db.persist(patient);
        db.getTransaction().commit();
    }

    public void update(Patient patient) throws SQLException {
        db.getTransaction().begin();
        Patient patientORM = getById(patient.getId());
        if (patientORM != null) {
            patientORM.setNom(patient.getNom());
            patientORM.setPrenom(patient.getPrenom());
            patientORM.setAge(patient.getAge());
            patientORM.setSexe(patient.getSexe());
            patientORM.setTelephone(patient.getTelephone());
            patientORM.setMaladie(patient.getMaladie());
            db.getTransaction().commit();
        } else {
            db.getTransaction().rollback();
            throw new SQLException("Patient avec l'ID " + patient.getId() + " non trouvé");
        }
    }

    public void delete(int id) throws SQLException {
        db.getTransaction().begin();
        Patient patient = this.getById(id);
        if (patient != null) {
            db.remove(patient);
            db.getTransaction().commit();
        } else {
            db.getTransaction().rollback();
            throw new SQLException("Patient avec l'ID " + id + " non trouvé");
        }
    }

    public Patient getById(int id) {
        return db.find(Patient.class, id);
    }

    public List<Patient> getSearch(String data) throws SQLException {
        List<Patient> list = new ArrayList<>();
        db.getTransaction().begin();
        List<Patient> resultat = db.createQuery(
                "FROM Patient p WHERE p.nom LIKE '%" + data + "%'", Patient.class
        ).getResultList();
        db.getTransaction().commit();
        for (Patient p : resultat) {
            Patient patient = new Patient();
            patient.setId(p.getId());
            patient.setNom(p.getNom());
            patient.setPrenom(p.getPrenom());
            patient.setAge(p.getAge());
            patient.setSexe(p.getSexe());
            patient.setTelephone(p.getTelephone());
            patient.setMaladie(p.getMaladie());
            list.add(patient);
        }
        return list;
    }
}

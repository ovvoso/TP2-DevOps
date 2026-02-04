package sn.isi.diti.rest;

import sn.isi.diti.Model.Patient;
import sn.isi.diti.Repository.PatientRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.SQLException;
import java.util.List;

@Path("/patients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PatientRest {

    private PatientRepository patientRepository = new PatientRepository();

    @GET
    public Response getAllPatients() throws SQLException {
        List<Patient> patients = patientRepository.getAll();
        return Response.ok(patients).build();
    }

    @POST
    public Response addPatient(Patient patient) throws SQLException {
        patientRepository.add(patient);
        return Response.status(Response.Status.CREATED).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deletePatient(@PathParam("id") int id) throws SQLException {
        patientRepository.delete(id);
        return Response.status(204).build();
    }

    @PUT
    public Response updatePatient(Patient patient) throws SQLException {
        patientRepository.update(patient);
        return Response.status(200).build();
    }
}

package sn.isi.diti.rest;


import sn.isi.diti.Model.Personne;
import sn.isi.diti.Repository.PersonneRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.SQLException;
import java.util.List;

@Path("/personnes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PersonneRest {

    private PersonneRepository personneRepository = new PersonneRepository();

    @GET
    public Response getAllPersonnes() throws SQLException {
        List<Personne> personnes =  personneRepository.getAll();
        return Response.ok(personnes).build();
    }

    @POST
    public Response addPersonne(Personne personne) throws SQLException {

        personneRepository.add(personne);
        return Response.status(Response.Status.CREATED).build();

    }

    @DELETE
    @Path("/{id}")
    public Response deleteUser(@PathParam("id") int id) throws SQLException {
        personneRepository.delete(id);
        return Response.status(204).build();
    }

    @PUT
    public Response updateUser(Personne personne) throws SQLException {
        personneRepository.update(personne);
        return Response.status(200).build();
    }

}

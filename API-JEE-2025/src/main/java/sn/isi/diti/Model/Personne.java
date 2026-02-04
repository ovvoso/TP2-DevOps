package sn.isi.diti.Model;

import lombok.*;

import javax.persistence.*;

@Entity
/*@Getter
@Setter
@ToString
@RequiredArgsConstructor*/
@Builder
@RequiredArgsConstructor
@Data
@NoArgsConstructor
@AllArgsConstructor

public class Personne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column
    @NonNull
    private String nom;
    @Column
    @NonNull
    private String prenom;
    @Column
    @NonNull
    private int age;

}

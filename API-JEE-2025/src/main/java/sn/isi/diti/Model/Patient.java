package sn.isi.diti.Model;

import lombok.*;

import javax.persistence.*;

@Entity
@Builder
@RequiredArgsConstructor
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column(nullable = false)
    @NonNull
    private String nom;

    @Column(nullable = false)
    @NonNull
    private String prenom;

    @Column(nullable = false)
    @NonNull
    private int age;

    @Column(nullable = false)
    @NonNull
    private String sexe;

    @Column(nullable = false)
    @NonNull
    private String telephone;

    @Column(nullable = false)
    @NonNull
    private String maladie;
}

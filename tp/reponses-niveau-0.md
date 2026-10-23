# 0.2 Lire le schema relationnel

1. schema relationnel des 4 tables

categorie(__id__, libelle)
plat(__id__, nom, prix, #id_categorie)
commande(__id__, date_commande, numero_table)
commande_ligne(__id__, #id_commande, #id_plat, quantite, prix_unitaire) 

2. Pourquoi commande_ligne contient-elle une colonne prix_unitaire, alors que le prix est déjà dans plat ? Donnez un exemple concret où les deux valeurs seraient différentes.

car c'est le prix du plat au moment de la commande, si on le prix du plat n'etait pas enregistre dans cette table, les calculs seront fausse apres un changement de prix du plat. Exemple: si le cafe coute 100 ar au jour 1, et 200 ar le jour, et qu'au jour 1 on a eu 2 achat et au jour 2, 5

SI on enregistre le prix dans commande_ligne
jour 1 => cafe : 2 | pu : 100 ar
jour 2 => cafe : 5 | pu : 200 ar
REVENUE TOTAL : 1200 ar

SI on laisse le prix dans plats
EN BASE DE DONNE AU 1 ER JOUR
jour 1 => cafe : 2 | pu : 100 ar | total : 200 ar
MAIS EN BASE DE DONNE AU 2 EME JOUR
jour 1 => cafe : 2 | pu : 200 ar
jour 2 => cafe : 5 | pu : 200 ar
REVENUE TOTAL (FAUSSE) : 1400 ar

3. Que se passe-t-il pour les lignes d’une commande quand on supprime la commande ? Quelle instruction en est responsable ?

Elles sont supprime aussi. Le responsable est ON DELETE CASCADE

4. Repérez trois données absurdes que le schéma actuel accepte sans broncher (indice : essayez d’insérer à la main un prix négatif). Notez-les : vous les corrigerez au niveau 1 et 2.

prix negatif
quantite negatif
une intervalle negatif

# 0.3 Interroger l’API à la main
5. Le code obtenu est 201, car ce code est pour la reussite d'un insert

6. pour la requete d, c'est PostgreSQL qui bloque la suppression, car l'id est present dans un table commande qui l'a comme cle etrangere, donc la suppression bloque a moins que l'on j'ajoute une contrainte ON DELETE CASCADE
```php
catch (\Throwable $e) {
            // Le plat apparaît dans des commandes : la clé étrangère bloque la suppression.
            return $this->erreur('Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.', 409);
        }
```

7. commande curl sur la table table 6, deux Romazava et un Café
```bash
curl -i -X POST http://localhost:8080/api/commandes \
     -H "Content-Type: application/json" \
     -d '{"date_commande":"2026-10-23 10:00:00","numero_table":6, "lignes":[{"id_plat":4, "quantite":2},{"id_plat":10, "quantite":1}]}'
```
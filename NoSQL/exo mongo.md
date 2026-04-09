## 1. Prix par nuit du premier enregistrement

```javascript
db.listingsAndReviews.findOne({}, {price: 1, _id: 0})
```

## 2. Frais de nettoyage du premier enregistrement

```javascript
db.listingsAndReviews.findOne({}, {cleaning_fee: 1, _id: 0})
```

## 3. Nom, localisation et description du proprietaire du premier enregistrement

```javascript
db.listingsAndReviews.findOne({}, {"host.host_name": 1, "host.host_location": 1, "host.host_about": 1, _id: 0})
```

## 4. Nombre de chambres du premier enregistrement

```javascript
db.listingsAndReviews.findOne({}, {bedrooms: 1, _id: 0})
```

## 5. Nombre d'invites possibles du premier enregistrement

```javascript
db.listingsAndReviews.findOne({}, {guests_included: 1, _id: 0})
```

## 6. Verifier si l'hote du premier enregistrement a une photo de profil

```javascript
db.listingsAndReviews.findOne({}, {"host.host_has_profile_pic": 1, _id: 0})
```

## 7. Verifier si l'identite de l'hote du premier enregistrement a ete verifiee

```javascript
db.listingsAndReviews.findOne({}, {"host.host_identity_verified": 1, _id: 0})
```

## 8. Liste des annonces de type House

```javascript
db.listingsAndReviews.find({property_type: "House"})
```

## 9. Annonces avec un tarif superieur a 500

```javascript
db.listingsAndReviews.find({price: {$gt: 500}}, {listing_url: 1, "host.host_name": 1, price: 1, _id: 0})
```

## 10. Logements au Bresil avec une note d'au moins 9

```javascript
db.listingsAndReviews.find({"address.country": "Brazil", "review_scores.review_scores_rating": {$gte: 9}}, {name: 1, address: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 11. Logements aux Etats-Unis avec un jacuzzi

```javascript
db.listingsAndReviews.find({"address.country": "United States", amenities: "Hot tub"}, {name: 1, address: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 12. Annonces entre 200 et 400 avec piscine

```javascript
db.listingsAndReviews.find({price: {$gte: 200, $lte: 400}, amenities: "Pool"}, {name: 1, amenities: 1, price: 1, _id: 0})
```

## 13. Annonces au Canada ou au Mexique avec machine a laver

```javascript
db.listingsAndReviews.find({"address.country": {$in: ["Canada", "Mexico"]}, amenities: "Washer"}, {name: 1, amenities: 1, address: 1, _id: 0})
```

## 14. Annonces avec note >= 80 et equipements de base

```javascript
db.listingsAndReviews.find({"review_scores.review_scores_rating": {$gte: 80}, amenities: "Essentials"}, {listing_url: 1, name: 1, address: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 15. Annonce la plus chere

```javascript
db.listingsAndReviews.find({}, {listing_url: 1, name: 1, address: 1, amenities: 1, price: 1, review_scores: 1, _id: 0}).sort({price: -1}).limit(1)
```

## 16. Annonce la moins chere

```javascript
db.listingsAndReviews.find({}, {listing_url: 1, name: 1, address: 1, amenities: 1, price: 1, review_scores: 1, _id: 0}).sort({price: 1}).limit(1)
```

## 17. Annonces sans commentaires

```javascript
db.listingsAndReviews.find({number_of_reviews: 0}, {name: 1, address: 1, _id: 0})
```

## 18. Annonces ou l'hote est un super-hote

```javascript
db.listingsAndReviews.find({"host.host_is_superhost": true}, {name: 1, address: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 19. Annonces ou les coordonnees ne sont pas nulles

```javascript
db.listingsAndReviews.find({"address.location.coordinates": {$ne: null}}, {name: 1, address: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 20. Annonces avec nombre de lits >= 2

```javascript
db.listingsAndReviews.find({beds: {$gte: 2}}, {name: 1, bed_type: 1, beds: 1, "review_scores.review_scores_rating": 1, _id: 0})
```

## 21. Annonces dont le nom de l'hote contient livia

```javascript
db.listingsAndReviews.find({"host.host_name": {$regex: /livia/i}}, {name: 1, host: 1, _id: 0})
```

## 22. Annonces qui ont des frais de menage

```javascript
db.listingsAndReviews.find({cleaning_fee: {$exists: true, $ne: null}}, {listing_url: 1, name: 1, price: 1, bedrooms: 1, cleaning_fee: 1, _id: 0})
```

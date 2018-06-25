// Add kennel
KennelPedigrees.deployed().then(function(instance) {return instance.addKennel(web3.eth.accounts[1], 'Kennel de Nico', 'kennel_nico');}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})


KennelPedigrees.deployed().then(function(instance) {return instance.addDog('1234', 'caniche', 'toby', '11', '12', {from: web3.eth.accounts[1]});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Create var
var dogId;

// Search dog
KennelPedigrees.deployed().then(function(instance) {return instance.searchDog.call('kennel_nico', '1234');}).then(function(result) {dogId = result[0];console.log(result);}).catch(function(e) {console.log(e);})

// Owner of
KennelPedigrees.deployed().then(function(instance) {return instance.ownerOf(dogId);}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Approve
KennelPedigrees.deployed().then(function(instance) {return instance.approve(web3.eth.accounts[2], dogId, {from:web3.eth.accounts[1]});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Take ownership
KennelPedigrees.deployed().then(function(instance) {return instance.takeOwnership(dogId, {from: web3.eth.accounts[2]});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Set Dog price
KennelPedigrees.deployed().then(function(instance) {return instance.setDogPrice(dogId, web3.toWei(1,'ether'), {from: web3.eth.accounts[2]});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Set dog on onSale
KennelPedigrees.deployed().then(function(instance) {return instance.setDogOnSale(dogId, true, {from: web3.eth.accounts[2]});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Buy doggo
KennelPedigrees.deployed().then(function(instance) {return instance.buyDog(dogId, {from: web3.eth.accounts[3], value: web3.toWei(1,'ether')});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

// Cant buy doggo because dog is not on sale
KennelPedigrees.deployed().then(function(instance) {return instance.buyDog(dogId, {from: web3.eth.accounts[4], value: web3.toWei(1,'ether')});}).then(function(result) {console.log(result);}).catch(function(e) {console.log(e);})

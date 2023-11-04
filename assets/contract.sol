// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EHealthManagementSystem {
    
    struct Patient {
        string name;
        uint age;
        address publicAddress;
        string emailAddress;
    }
    
    struct Doctor {
        string name;
        uint age;
        address publicAddress;
        string emailAddress;
    }
    
    struct Prescription {
        string date;
        string prescriptionDetails;
        address doctorPublicAddress;
        string doctorName;
    }
    
    mapping(address => Patient) public patients;
    mapping(address => Doctor) public doctors;
    mapping(address => Prescription[]) public patientPrescriptions;

    address public owner; // Declare the owner address

    modifier onlyDoctor() {
        require(doctors[msg.sender].publicAddress == msg.sender, "Only doctors can execute this function");
        _;
    }
    
    constructor() {
        owner = msg.sender; // The contract deployer is set as the owner in the constructor
    }
    
    function addPatient(string memory name, uint age, address publicAddress, string memory email) public {
        patients[publicAddress] = Patient(name, age, publicAddress, email);
    }
    
    function addDoctor(string memory name, uint age, address publicAddress, string memory email) public {
        doctors[publicAddress] = Doctor(name, age, publicAddress, email);
    }
    
    function addPrescription(address patientAddress, string memory date, string memory prescription, string memory doctorName) public onlyDoctor {
        require(patients[patientAddress].publicAddress == patientAddress, "Patient not found");
        
        Prescription memory newPrescription = Prescription(date, prescription, msg.sender, doctorName);
        patientPrescriptions[patientAddress].push(newPrescription);
    }
    
    function viewMedicalHistory(address patientAddress) public view returns (Prescription[] memory) {
        require(patients[patientAddress].publicAddress == patientAddress, "Patient not found");
        return patientPrescriptions[patientAddress];
    }

    function updatePatientInfo(address patientAddress, string memory newName, uint newAge, string memory newEmail) public {
        require(msg.sender == patientAddress || msg.sender == owner, "You can only update your own information or the contract owner can update any patient's information");
        
        Patient storage patient = patients[patientAddress];
        require(patient.publicAddress != address(0), "Patient not found");
        
        patient.name = newName;
        patient.age = newAge;
        patient.emailAddress = newEmail;
    }
}

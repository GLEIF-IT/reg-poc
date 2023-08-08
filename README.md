# reg-poc

Proof of concept for ECR login, file upload and verification.

### Build
```
docker-compose up --build
```


### Run
Navigate to [http://localhost:5173/](http://localhost:5173/) in your browser.

Use the passcode `0123456789abcdefghijk`.


### Upload

Samples can be found under the `samples/` directory.


### Architecture

This brings together all the moving pieces inside this PoC.

* Witness network ([keripy](https://github.com/weboftrust/keripy))
  * The KERI witness network provides a receipt service for identifiers (AIDs) in the network. These receipts provide the public cryptographic verifiability to determine that an AID has consistent key event state. Phrased another way, the witness network is a set of servers that collectively allow watchers/verifiers to detect duplicity of key events for an AID. Duplicity means the cryptographic verifiablility of an AID is ambiguous. When an AID is created (incepted) it specifies witnesses that it trusts to provide signed receipts of all of the key events of the AID. We call this state the Key Event Log (KEL) and when the witness network provides receipts for each event, it is called a Key Event Receipt Log (KERL). Witness networks are decentralized, meaning anyone (organization, person, government, etc) can stand-up a witness network for the KERI protocol. The user of an AID specifies the witnesses that it trusts to provide receipts for it's key events, both at inception and during any rotations. That means the AID has cryptographically committed to those witnesses to provide the KERLs for that AID. GLEIF hosts a witness network. Provenant (GLEIF QVI) hosts a witness network. Other organizations, QVIs, governments will host witness networks of their own.
* vLEI server (cached schema) ([vLEI](https://github.com/weboftrust/vlei))
  * The vLEI server hosts vLEI specific information like the schemas of the vLEI credentials. In order to properly present, verify, and process a vLEI credential, you need to know the schema (fields, types, structure, etc). You can see the different [vLEI credential schemas here](https://github.com/WebOfTrust/vLEI#credential-schema-and-vlei-samples). This vLEI specific information sits on top of the generic KERI protocol, providing the information necessary for vLEI users to participate and verify one another's vLEI credentials. Note that even credential schemas are verifiable in KERI/ACDCs. This is an important aspect of end-verifiability that prevents several attacks on credentials. You can see the tamper-evident [self-addressing identifiers (SAIDs) here](https://github.com/WebOfTrust/vLEI/blob/dev/docs/Schema_Registry.md). 
* KERI Agent ([KERIA](https://github.com/weboftrust/keria))
  * KERIA is the cloud agent server for KERI clients that use Signify. Signify clients are minimally sufficient clients that only provide user cryptographic operations, like digitally signing, from their edge devices. KERIA provides a persistent service where all other KERI operations necessary for the client to participate in the KERI/vLEI ecosystem. It is important to understand that a Signify client never shares its key secrets with the KERIA agent. And that all information, like additional keys, are encrypted on the KERIA agent storage so that it cannot by compromised on the server. This design allows clients to retain self-sovereign control of their cryptographic keys, while at the same time allowing the Signify client to be incredibly light-weight. KERIA provides the secure API to create identifiers (managed AIDs), present credentials, manage asynchronous operations like coordinating/waiting for signatures from other participants in a multi-sig operation, and much more. Signify clients send API calls to their KERIA server from web pages, IoT devices, mobile phones, etc.
* [reg-poc-webapp](https://github.com/GLEIF-IT/reg-poc-webapp)
  * The webapp provides the web UI for our users. It is a Signify client that uses [signify-ts](https://github.com/WebOfTrust/signify-ts) that allows users to securely interact with KERIA, the server backend, and the verifier service. The user logs into the portal by supplying a password to unlock it's KERIA agent to retrieve the identifier and vLEI credential that allows them to submit signed reports. <img width="938" alt="image" src="https://github.com/GLEIF-IT/reg-poc/assets/681493/efe8d28c-b00f-43b6-9825-355c13ad98d0">
  * After login, the user can upload signed reports or check that status of reports they previously submitted. All of these server API calls are secured with Signify signed headers. <img width="1003" alt="image" src="https://github.com/GLEIF-IT/reg-poc/assets/681493/0e2dc73a-009c-4a33-ab72-917ca8c51bd1">
  * The user uploads reports by selecting a properly formatted zip file containing the report files and report metadata which includes the report signatures. <img width="683" alt="image" src="https://github.com/GLEIF-IT/reg-poc/assets/681493/ab989182-955a-4414-9abf-f45a7f9179d5">
  * The user checks that status of their uploaded reports from the status page. <img width="1021" alt="image" src="https://github.com/GLEIF-IT/reg-poc/assets/681493/e80710ac-f402-449c-a9ea-7757a3e68082">
* [reg-poc-server](https://github.com/GLEIF-IT/reg-poc-server)
  * The server backend provides the secure API for verifying the user identifier and vLEI credential role, uploading reports, verifying signatures, and checking the status of uploaded reports. You can see the list of API calls from the swagger API page and we provide example values to test these operations: <img width="866" alt="image" src="https://github.com/GLEIF-IT/reg-poc/assets/681493/6d80374c-cf30-4bd7-ac5e-3d404fa2e344">
  * The server itself doesn't provide KERI functionality. The webapp is the Signify client that uses a KERIA agent. And the actual signature verification on request headers and the uploaded reports is done by the verifier service.
* [reg-poc-verifier](https://github.com/GLEIF-IT/reg-poc-verifier)
  * The verifier service uses KERI, the vLEI server, and witness networks to cryptographically verify all client supplied content; [Report submitter client AID and report submitter ECR credential] (https://github.com/GLEIF-IT/reg-poc-verifier/tree/main#registering-an-aid-as-a-valid-report-submitter), signatures on uploaded reports, and header signatures on server API calls. All of these API calls are made from the server backend.
  * There are [scripts in this project](https://github.com/GLEIF-IT/reg-poc-verifier/tree/main/scripts) for generating [the test files](https://github.com/GLEIF-IT/reg-poc-verifier/tree/main/tests/data/report) for triggering success or to exercise various failure conditions like reports that are missing signatures, missing the report metadata, proper zip structure, etc.

The `data` directory contains the output from a [signifypy](https://github.com/weboftrust/signifypy) script that establishes the Root of Trust, Qualified vLEI Issuer, Legal Entity, ECR Auth and ECR credentials [here](https://github.com/WebOfTrust/signifypy/blob/main/scripts/issue-ecr.sh).

![architectture](./poc.png)

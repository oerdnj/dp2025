#set page(
  paper: "a4",
  margin: (
    top: 1.18in,
    bottom: 0.79in,
    left: 1.38in,
    right: 0.79in,
  ),
  numbering: none,
  number-align: center,
)

#set text(14.5pt, font: "PT Sans", lang: "en")

#set align(top + center)

#upper[
    University of Ostrava\
    Faculty of Science\
    Department of Informatics and Computers\
]

#set align(horizon + center)
#text(24pt, [Feasibility of the new Post Quantum Cryptography for DNSSEC])
#set align(horizon + center)
#text([THESIS])

#set align(bottom + left)
#table(
  columns: 2,
  stroke: none,
  [Author:], [#text(lang: "cs", [Bc. Ondřej Surý])],
  [Supervisor:], [#text(lang: "cs", [RNDr. Matej Zuzčák PhD.])],
)

#set align(horizon + center)

2025

#pagebreak()

#set par(
  // spacing: 6pt,
  first-line-indent: 0em,
  justify: true,
  linebreaks: auto,
  // leading: 1.5em,
)

#set text(12pt, font:"PT Serif")

#let leading = 1.5em
#let leading = leading - 0.75em // "Normalization"
#set block(spacing: leading)
#set par(spacing: leading)
#set par(leading: leading)

#set text(top-edge: 0.75em, bottom-edge: -0.3em)
// #set par(leading: 0.5em)

#set align(top + left)

#page(numbering: none, footer: none, header: none, background: image("zadani1.png"), [])
#page(numbering: none, footer: none, header: none, background: image("zadani2.png"), [])

// reset our page counter to ensure they don't interfere with it
// this depends on your document, you may omit this
// #counter(page).update(n => n - count)

#pagebreak()

#text(16pt, upper[Abstract])

The Domain Name System (DNS) is a critical part of the internet that maps domain names to their corresponding IP addresses. DNS Security Extensions (DNSSEC) were developed to secure DNS, preventing attacks like cache poisoning and man-in-the-middle attacks by authenticating DNS data with cryptographic signatures. However, the rise of quantum computing presents major risks to current cryptographic systems because many public-key crypto-systems can be broken by quantum algorithms.
 
As a result, the National Institute of Standards and Technology (NIST) is currently working on standardizing more post-quantum cryptographic algorithms because current post-quantum signature schemes standardized by NIST have large public keys and/or signatures that can make DNSSEC operations more complicated and burdensome.
 
Beernink @beernink suggested the solution of putting the public keys on web-servers that would decrease the size of DNSSEC records but would add complexity, for instance, dependence on the HTTP protocol and the need for the DNS resolver operators to have web-servers. 
 
In this work, we investigate the appropriateness of the new post-quantum cryptography schemes for the DNSSEC.

#v(2em)


Keywords: \
DNS, DNSSEC, Post-Quantum, Cryptography

#pagebreak()

#text(16pt, lang: "cs", [ČESTNÉ PROHLÁŠENÍ])

#text(lang: "cs", [Já, níže podepsaný student, tímto čestně prohlašuji, že text mnou odevzdané závěrečné práce v~písemné podobě je totožný s~textem závěrečné práce vloženým v~databázi DIPL2.])

#v(4em)

#text(lang: "cs", [V Ostravě XX.dubna 2025])
#v(2em)

………………………………\
#text(lang: "cs", [Bc. Ondřej Surý])

#pagebreak()

FIXME: Thanks 

I hereby state that this submitted thesis is my original author work and that I elaborated it myself. I properly cite all references and other sources that I used to work up the thesis. Those references and other sources are given in the list of references.

#v(4em)

Ostrava, XX. May 2025
#v(2em)

………………………………\
Bc. Ondřej Surý

#pagebreak()

#outline()

#pagebreak()

#set heading(numbering: "1.1")
#show heading: it => [
  #if it.level == 1 {
    set text(16pt)
    upper(it)    
  } else {
    if it.level == 2 {
      set text(16pt)
    } else {
      set text(14pt)
    }
    it
  }
]

#set text(12pt)

#set page(numbering: "1")

= Introduction

== Domain Name System

The Domain Name System (DNS) is one of the most important parts of the modern Internet, which is the key to changing domain names to IP addresses that devices understand. This is a de-centralized, hierarchical and very much like an encyclopedia, a distributed database system that was created in 1983 to overcome the scalability issues of the original HOSTS.TXT file system and has become a very important part of the architecture of the internet to map domain names to different types of resources.

In simplest terms, DNS is a translator; it converts domain names, such as _example.com_ into numbers like `192.0.2.1` that computers can recognize and use to identify and communicate with other devices on the Internet. This is what is known as an abstraction, where the user can use easily memorable domain names and the internal system takes care of the network addressing.esides the straight forward name-to-IP address lookup, DNS supports numerous other resource records including MX records for mailing purposes, TXT records for domain verification and SRV records for service location.

The Domain Name System is a hierarchical structure with the root domain (_._) at the top, then the Top Level Domains (TLDs), the generic TLDs (gTLDs) such as _.com_, _.org_, the country code TLDs (ccTLDs) such as _.uk_ or _.cz_, sponsored TLDs (sTLDs) for particular purposes like _.cat_ (not the animals, but the top-level domain for the Catalan linguistic and cultural community), _.edu_ (for Institutions of higher learning in the US) or .aero (for members of the air transport industry), and in the ICANN era, the newTLDs or the new top-level domains for people who have enough funds. This hierarchical structure helps in the assignment of different parts of the DNS tree to different entities thereby enhancing the control of administration while at the same time enhancing the connectivity of the system. For instance, while ICANN has the responsibility of the root zone, other organizations can manage their domains independently within the system, which makes the system very flexible and easy to administer.

The hierarchical and distributed nature of DNS has several consequences in several areas as shown below; The distribution of authority also has a tendency of eliminating single points of failure as each zone cane handled by several servers. The second is the caching system at different levels of the DNS which reduces the burden of the network and increases the rate of response to queries by storing frequently sought after records closer to the user. The third is the delegation model, which helps in management of regions while at the same time providing a clear chain of authority from the root servers, all the way to the individual domain records, globally.

The DNS architecture is composed of the following elements that work together to deliver efficient name resolution services:

1. Root Servers: The basic structure of DNS is the 13 sets of root server clusters which are in the control of different entities across the world. These servers contain the information on the authoritative name servers for all the top level domains. The organizations are however not affiliated with ICANN and constitute the Root Server System Advisory Committee (RSSAC).
2. Top-Level Domain (TLD) Servers: These servers control the zones for TLDs and contain information on the authoritative name servers for domains under the jurisdictions of their respective TLDs.
3. Authoritative Name Servers: These servers hold the real DNS records for particular domains and provide definitive answers to queries regarding domains within their zone.
4. Recursive Resolvers: These systems sit in the middle between clients and authoritative servers and carry o but DNS queries on behalf of the end users, with very complex caching diameters to enhance on throughput and decrease on delay.

The functioning of these components is done through a well-defined protocol that allows for both recursive and iterative queries; this helps in achieving reasonable resolution paths as well as convenience of the system. This architectural design allows DNS to deal with billions of queries in a day without faltering or crashing due to failures or attacks @rfc1034 @rfc1035.

== Importance of DNSSEC

The initial development of the Domain Name System (DNS) took place without secure practices as built-in components in its fundamental protocols because early Internet operations relied on trust-based systems. The fundamental problem with this initial design scheme is that it functioned only enough to provide basic name resolution service while exposing the system to numerous types of attacks.  Without authentication and integrity verification, the DNS responses could be intercepted, modified, or completely fabricated and the threat to Internet users and services would remain undetected. 

The DNS Security Extensions (DNSSEC) were developed and standardized through a sequence of RFC documents which started with RFC2535 @rfc2535 in 1999 and continued with RFC4033, RFC4034, and RFC4035 @rfc4033 @rfc4034 @rfc4035 in 2005. DNSSEC improves the Domain Name System security through a cryptographic signature hierarchy that follows the DNS naming hierarchy. This extension brings security features to the DNS together with backwards compatibility for the historical DNS infrastructure. 

At its core DNSSEC operates through a chain of trust to perform multiple types of cryptographic signatures and record types: 
1. Zone Signing Keys (ZSK) and Key Signing Keys (KSK): 
 - ZSKs are used to sign individual DNS records within a zone
 - KSKs sign the ZSKs to establish a secure key management structure
 - The dual-key system provides effective controls for key rotation and management activities.
2. New Record Types:
 - RRSIG (Resource Record Signature): Holds the cryptographic signatures for all DNS record sets.
 - DNSKEY: Holds public keys which are used to verify signatures in the DNS.
 - DS (Delegation Signer): Developing trust relationships between parent and child zones through DS records.
 - NSEC/NSEC3: Delivers authenticated denial of existence for DNS records making sure that record absence is verifiable.
 
These security mechanisms effectively address several critical vulnerabilities that could otherwise be exploited for malicious activities:
 
1. Cache Poisoning Prevention:
 - DNSSEC stops attackers from inserting fake records into DNS caches
 - Each response contains cryptographic signatures which can be checked against the zone's public key
 - Altered responses will fail signature verification to block unauthorized modifications on the network
 
2. DNS Spoofing Protection:
 - Cryptographic signatures guarantee that DNS responses are sent by authorized entities
 - Signature verification exposes any man-in-the-middle attacks occurring during communication
 - Response validation prevents acceptance of forged or modified DNS data
 
3. Authentication Chain Verification:
 - DNSSEC sets up a chain of trust which extends from configured trust anchors (usually the DNS root) all the way to specific domain records
 - Each cryptographic layer in the hierarchy directly links to the preceding layer
 - Trust anchors including the root zone KSK enable the validation process to start from a known position
 
The implementation of DNSSEC extends beyond basic DNS security, playing a crucial role in broader Internet security frameworks:
 
1. DANE (DNS-based Authentication of Named Entities) @rfc7671:
 - Allows TLS certificate information to be stored in DNS
 - Offers a different trust model to that of traditional Certificate Authorities
 - Improves security for email transport and other TLS-enabled services
 
2. Resource Record Security:
 - Secures extra DNS record types which include those beyond A Records.
 - Protects MX records which contain email routing information.
 - Maintains record integrity for service locations denoted by SRV records.
 
3. Key Distribution:
 - Makes the proper transfer of cryptographic keys possible
 - Servicing different security protocols as well as other services
 - New security applications that use DNS infrastructure are enabled such as OpenSSH clients which verify the server's certificate fingerprints stored in SSHFP resource records to manage key and algorithm settings for OpenSSH server operators more effectively. @rfc4255
 
Despite its significant security benefits, DNSSEC deployment faces several challenges:
 
1. Operational Complexity:
 - Key management and rotation require strategic planning and execution.
 - Zone signing generates additional administrative tasks.
 - Validation failures produce network availability problems which require proper management to resolve.
2. Implementation Considerations:
 - Signature addition increases DNS response sizes
 - Validation requires additional processing power
 - Backward compatibility needs to be maintained with systems that do not support DNSSEC.
3. Deployment Challenges:
 - Multi-party cooperation is needed for deployment.
 - Gradual adoption creates limitations on security benefits implementation.
 - Education together with technical expertise remains a crucial resource.
 
The continually developing nature of cyber-threats makes DNSSEC deployment essential to protect Internet infrastructure fundamental systems and this need is anticipated to grow in the future. This system stands as a foundation for other security approaches and serves to safeguard against developing DNS infrastructure threats. Organizations that deploy DNSSEC advance internet security and create a protected environment which allows users to reach their desired online services without interference. 

== The DNSSEC keys and digital signatures

The DNS Security Extensions (DNSSEC) uses a number of cryptographic algorithms to authenticate and protect the integrity of DNS data. These algorithms generate digital signatures that prove the source and integrity of the DNS records, which are an essential part of the DNSSEC security architecture. Each algorithm has its own set of features that differ in terms of security, speed, and the resources it consumes. Some of the major cryptographic algorithms used in DNSSEC include RSA, ECDSA and EdDSA.

=== RSA (Rivest–Shamir–Adleman)

RSA is one of the most traditional and popular cryptography in use in DNSSEC today due to its sound security properties and a thorough validation. It is a public key cryptographic system based on the idea of factoring a large composite number into its prime factors @rfc6594.

Key Characteristics:
- The security of the system is based on the hardest problem of the large composite number factorization
- It needs a larger key size of 2048-4096 bits for secure encryption
- It is a very time-consuming especially for the signing operations
- It has very good known security properties and has withstood numerous cryptanalysis for decades
- It is supported by all DNSSEC implementations without an exception.

Performance Considerations:
- It is relatively slower in generating the signature when compared to other newer algorithms.
- The verification processes are faster than the signing processes
- The use of larger key and signature increases the size of the DNS message
- Higher CPU usage because of the cryptographic processes

=== ECDSA (Elliptic Curve Digital Signature Algorithm)

ECDSA brought a great improvement into the DNSSEC cryptography, it provides the same level of security as RSA but with much lower implementation costs and smaller public key and signature sizes.  It is based on the mathematical concepts of the elliptic curve cryptography (ECC) @rfc6605. Current recommended algorithm for DNSSEC implementation is ECDSAP256SHA256 @rfc8624, @rfc9157.

Key Characteristics:
- Secured by the elliptic curve discrete logarithm problem.
- Requires smaller key sizes of 256-384 bits than RSA keys for the same level of security.
- Faster than RSA, the algorithm can generate the signatures in very fast manner.
- Standardized NIST curves (P-256, P-384) provide interoperability.

Comparison with RSA:
- Key Size: The 256-bit key of ECDSA is equivalent to the 3072-bit key of RSA.
- Signature Size: The size of the signature of ECDSA is about 1/6 that of the signature of RSA for the same security level.

Performance Considerations:
- The signature generation time is 5-10 times faster than that of RSA.
- The speed of verification is as good as that of RSA or even slightly better.

Resource Usage:
- Lower memory usage because of the smaller key sizes.
- Lower network traffic due to the use of smaller signatures.
- More effective use of CPU time for signing processes.

=== EdDSA (Edwards-curve Digital Signature Algorithm)

EdDSA is the most recent development in DNSSEC cryptography @rfc8080, with enhanced performance and different security features compared to RSA and ECDSA.  It employs the twisted Edwards curves and brings in some improvements particularly for digital signatures @CryptSafeCurvesIntroduction.

Key Characteristics:
- It is based on the Ed25519 and Ed448 Goldilocks curves of twisted Edwards curves.
- It was designed to provide fast signature generation.
- It has a built-in protection against some implementation vulnerabilities.
- It produces deterministic signatures.
- There is no need to use cryptographically secure pseudo random number generation during the signing process.

Comparison with ECDSA:

Security Properties:
- More resistant to implementation errors.
- Easier and constant time implementation.
- Stronger protection against side channel attacks.

Performance Advantages:
- Signature generation time is 20-30% faster.
- Up to 50% faster verification.
- More effective batch verification.

Implementation benefits:
- Less complex implementation means less chance of security vulnerabilities.
- Deterministic signatures remove the need for entropy at the time of signing.
- Lower likelihood of severe failures because of poor PRNG.

== Quantum Computing

Quantum computing represents a fundamental shift in computational paradigms that uses quantum mechanical principles to perform information processing. The new computational system disparate from classical computing systems. Quantum computing systems have their fundamental operational principles and capabilities. While classical computing systems use binary digits (bits) as 0 or 1, quantum computing systems use quantum bits (qubits) that harness the quantum mechanical phenomena of superposition and entanglement @etsi_quantum_safe.

In quantum mechanical systems, superposition means that each qubit can exist in multiple quantum states at once, with complex probability amplitudes until measurement collapses the quantum wave-function to a classical state. Furthermore, quantum entanglement is the connection of multiple qubits such that the system can store and compute exponentially more information than classical bits. It means that these quantum mechanical properties provide computational advantages that grow exponentially with the size of the problems as a function of the number of qubits for certain classes of computational problems.

=== Quantum Computing and Cryptographic Threats

The quantum computing systems can create major changes in the current cryptographic systems and methods used in cyber security. Today's public key cryptography is mainly based on the idea of the computational difficulty of certain mathematical problems in the traditional computing systems. The security of the RSA public key crypto-system, for instance, is based on the idea that there is no known method of factoring a large composite number into its two prime factors using conventional algorithms. However, cryptographic protocols such as DSA and Elliptic Curve Cryptography (ECC) are secure because it is hard to solve the discrete logarithm problem in classical computation.
 
However, these security assumptions are broken by quantum algorithms. In 1994, Shor's algorithm was published, which described a quantum computational approach to solving both the integer factorization and discrete logarithm problems in polynomial time – an exponential improvement on the best classical algorithms. This is a theoretical result and does not at present threaten the security of widely used public key systems, but it does show that sufficiently large quantum computers could break the cryptography that is used to protect a very large part of the world's data.
 
However, the latter one, Grover's search algorithm, offers a quadratic improvement for quantum search in an unstructured database, which affects the security parameters of symmetric keyed systems. Although less disastrous to the current cryptographic implementations than Shor's algorithm, Grover's algorithm demands the keys in symmetric systems to be twice as long to have the same level of security against quantum attacks.

Bernstein @Bernstein2009 lists three basic reasons why we need to focus on the Quantum-Safe cryptography now rather than later:

1. The efficiency of the post-quantum cryptography needs to be improved - on the algorithmic and the implementation level
2. There needs to be more confidence in the post-quantum cryptography - from the cryptographers and from the implementors
3. The usability of the post-quantum cryptography needs to be improved - there are cryptographic algorithms that are already Quantum-Safe, but their properties make them unusable for practical deployments

== Current Post-Quantum Cryptography Research

Bernstein @Bernstein2009 says that this has sparked a lot of research in post-quantum cryptography to come up with and analyze new and strong cryptographic systems that will be secure against both classical and quantum computational attacks. These post-quantum cryptographic are based on the following:
 
1. Lattice based cryptography: This is based on the idea of using the difficulty of certain problems in lattices as the basis of the cryptography.
 
2. Hash based signature schemes: These are secure because cryptographic hash functions are thought to be resistant to quantum attacks.
 
3. Code based cryptography: This is based on the hardness of decoding general linear codes.
 
4. Multivariate cryptography: This is based on the idea that it is hard to solve systems of many polynomials of many variables.
 
5. Super-singular isogeny based crypto-systems: This is based on the idea of the hardness of elliptic curve isogeny problems.
 
The shift to quantum secure cryptographic systems is also quite complex and one has to consider the issue of compatibility, efficiency, and security of the new systems. This migration strategy requires the use of mixed cryptographic techniques that provide security against classical and quantum attacks during the transition phase. Therefore, the systematic implementation and deployment of quantum-resistant cryptographic protocols is a critical initiative to ensure confidentiality and integrity of communications in future digital communication systems. This technological evolution calls for further theoretical work, more secure and proper analysis, and practical considerations in the implementation of the cryptographic protocols in the quantum computing environment in order to maintain the efficacy of the cryptographic security.

= Post-Quantum Cryptography Standardization

The National Institute of Standards and Technology (NIST) @nist_pqc has launched a thorough standardization effort to deal with the cryptographic weaknesses brought about by quantum computing. This systematic endeavor is meant to define solid standards for quantum-resistant public-key cryptographic algorithms; an essential advancement in digital security architecture.
 
The current cryptographic architecture, defined by NIST, is represented by several fundamental standard documents. Federal Information Processing Standard (FIPS) 186-4 is understood to be the Digital Signature Standard, which prescribes major rules for digital signature algorithms. Additional guidelines for key establishment protocols are shown in Special Publication SP 800-56A Revision 2 which covers discrete logarithm cryptography and SP 800-56B Revision 1 which targets integer factorization cryptography. These standards have effectively secured digital communications through the implementation of widely deployed algorithms such as RSA, DSA and elliptic curve cryptography. However, as detailed in NISTIR 8105, Report on Post-Quantum Cryptography, such algorithms have been found to have certain vulnerabilities to quantum computational attacks and therefore new quantum-resistant alternatives need to be developed and standardized.
 
The NIST post-quantum cryptography standardization effort involves a thorough, three-phase assessment protocol. The first phase that took place between 2017 and 2019 was characterized by the submission of sixty-nine candidate algorithms. The first round of screening was carried o but to assess the preliminary security of the submitted algorithms and their basic implementation in terms of mathematical soundness and theoretical security.
 
The second phase that took place between 2019 and 2020 focused on twenty-six remaining candidates. This stage involved detailed security assessment against classical and quantum attacks, as well as comparative performance evaluation across different hardware platforms. The assessment criteria included not only the security properties of the schemes but also their practical implementation aspects and their suitability for real-world use.
 
The third phase that took place between 2020 and 2022 was directed towards the seven finalist candidates and eight alternative candidates. This stage allowed the global cryptographic research community to perform in-depth cryptanalysis while the researchers also worked on performance improvement and implementation flaws. The assessment took into consideration the particular use case needs and operational bounds.
 
The current stage of the process, which started in 2022, has resulted in the selection of the first algorithms for standardization while still examining other candidates. This phase includes the establishment of formal specifications, implementation guidance, and interim guidance and migration strategies for practical application.
 
NIST uses several criteria to assess the candidates. From a security point of view, candidates should have strong key and signature sizes,e free from classical and quantum attacks, and have sufficient security buffers against future cryptographic attacks. The evaluation also entails formal security proofs and detailed assessment of the resistance to side-channel attacks.
 
Performance assessment involves evaluating the computational cost of the algorithms on different platforms, the memory usage of the algorithms, the size of the keys and signatures, and the bandwidth usage. Complexity and correctness considerations, side-channel attack vulnerability in real implementations, and the ability to integrate the schemes with other systems form the basis of implementation assessment. Other factors include issues related to intellectual property and standardization.
 
In this thorough evaluation, NIST has concluded that the following are promising candidates for standardization.
 
CRYSTALS-Kyber has been chosen as the best approach for general encryption and key management while CRYSTALS-Dilithium has been recommended for digital signature scheme. FALCON offers another digital signature scheme while SPHINCS+ offers a stateless hash-based signature scheme. These selections are based on different mathematical techniques and security requirements.
 
CRYSTALS-Kyber and CRYSTALS-Dilithium which are lattice-based cryptographic schemes derive their security from the module learning with errors problem and have good implementation properties while being very secure. SPHINCS+ is a conservative approach whose security properties are well understood, but at the expense of larger signature sizes. FALCON offers another choice with different implementation characteristics which are suitable for certain applications.
 
The standardization process all the time looks at the practical implementation properties. The adoption strategy involves a step-by-step model for algorithm take up, including co-existence modes during the transition periods and ensuring that the client can downgrade.
 
The implementation guidance includes reference implementations, performance optimization guidelines, and security recommendations, while the validation requirements cover cryptographic module validation and compliance verification procedures.
 
The ongoing standardization initiative is still ongoing and is still being developed to include algorithm selection for the standard, protocol integration considerations, and industry adoption requirements. The process still focuses on IP standards integration, TLS transport security, and email security. Also, the initiative focuses on providing commercial implementation advice, hardware support flags, and deployment recommendations.
 
This far reaching standardization project is a significant progress in the protection of digital communications in the post-quantum world. Using a systematic method of evaluating and selecting quantum-resistant algorithms, NIST creates a foundation for maintaining cryptographic security in the future technological environments. The achievement of this goal will depend on the continued interaction between academic researchers, industry practitioners, and standardization bodies to guarantee the availability of strong and effective post-quantum cryptographic products.

== Post-Quantum Cryptography: Selected Algorithms 2022

In this section, an overview of the currently standardized PQC algorithms is given.

=== CRYSTALS

The “Cryptographic Suite for Algebraic Lattices” (CRYSTALS) @crystals-kyber @crystals-dilithium is comprised of two cryptographic primitives: The Kyber system is an IND-CCA2 secure key encapsulation mechanism (KEM) and Dilithium is a strongly EUF-CMA secure digital signature scheme. These schemes are in fact conceived with the ability to hold their ground against large quantum computers, and have been p but forward as part of the NIST post-quantum cryptography project.

*Module Lattices*

We can consider module lattices as those lattices which are closer to the ones employed in defining the LWE problem than those employed in Ring LWE, yet simpler than the former. The following are the advantages that our cryptographic algorithms enjoy when they are implemented using these lattices, for a ring that has a sufficiently high degree (like 256):
 
The only operations required for Kyber and Dilithium for all security levels are: the Keccak variants, additions/multiplications in $Z_q$ where $q$ is a constant, and the NTT for the ring $Z_q[X]/(X^256+1)$. This means that changing the security level comes at virtually no cost of implementing the schemes again in software or hardware. It is sufficient to modify several parameters to transform an optimized implementation of a scheme at one security level into an optimized implementation at another security level. The lattices used in Kyber and Dilithium are less structured in the algebraic sense than those used for Ring LWE and are more similar to the unstructured lattices used in LWE. It is therefore possible that if any algebraic attacks against Ring LWE do appear (and there are none that we are aware of at this point), then they may be less effective against schemes like Kyber and Dilithium.

=== FALCON

Fast-Fourier Lattice-based Compact Signature over NTRU (FALCON) @falcon is a cryptographic signature algorithm submitted to NIST Post-Quantum Cryptography Project on November 30th, 2017.

The point of a post-quantum cryptographic algorithm is to keep on ensuring its security characteristics even faced with quantum computers. Quantum computers are deemed feasible, according to our current understanding of the laws of physics, but some significant technological issues remain to be solved in order to build a fully operational unit. Such a quantum computer would very efficiently break the usual asymmetric encryption and digital signature algorithms based on number theory (RSA, DSA, Diffie-Hellman, ElGamal, and their elliptic curve variants).

Falcon is based on the theoretical framework of Gentry, Peikert and Vaikuntanathan for lattice-based signature schemes. We instantiate that framework over NTRU lattices, with a trapdoor sampler called "fast Fourier sampling". The underlying hard problem is the short integer solution problem (SIS) over NTRU lattices, for which no efficient solving algorithm is currently known in the general case, even with the help of quantum computers.

*Algorithm Highlights*

Falcon offers the following features:

- *Security*: a true Gaussian sampler is used internally, which guarantees negligible leakage of information on the secret key up to a practically infinite number of signatures (more than 264).
- *Compactness*: thanks to the use of NTRU lattices, signatures are substantially shorter than in any lattice-based signature scheme with the same security guarantees, while the public keys are around the same size.
- *Speed*: use of fast Fourier sampling allows for very fast implementations, in the thousands of signatures per second on a common computer; verification is five to ten times faster.
- *Scalability*: operations have cost $O(n log n)$ for degree $n$, allowing the use of very long-term security parameters at moderate cost.
- *RAM Economy*: the enhanced key generation algorithm of Falcon uses less than 30 kilobytes of RAM, a hundredfold improvement over previous designs such as NTRUSign. Falcon is compatible with small, memory-constrained embedded devices.

=== SPHINCS#super[+]

SPHINCS#super[+] @oswald_sphincs_2015 is a stateless hash-based signature scheme, which was submitted to the NIST post-quantum crypto project. The design advances the SPHINCS signature scheme, which was presented at EUROCRYPT 2015. It incorporates multiple improvements, specifically aimed at reducing signature size. @bernstein_sphincs_2019

The submission proposes three different signature schemes:

SPHINCS#super[+]-SHAKE256
SPHINCS#super[+]-SHA-256
SPHINCS#super[+]-Haraka

These signature schemes are obtained by instantiating the SPHINCS#super[+] construction with SHAKE256, SHA-256, and Haraka, respectively.

The second round submission of SPHINCS#super[+] introduces a split of the above three signature schemes into a simple and a robust variant for each choice of hash function. The robust variant is exactly the SPHINCS#super[+] version from the first round submission and comes with all the conservative security guarantees given before. The simple variants are pure random oracle instantiations. These instantiations achieve abo but a factor three speed-up compared to the robust counterparts. This comes at the cost of a purely heuristic security argument.

Prof. Ronen suggested @ronen2024 that if being stateless is very important, SPHINCS+ variant that can support a maximum of 2^16 signatures instead of 2^64 can be considered, such change will result in a much smaller signature.

== Post-Quantum Cryptography: Additional Digital Signature Schemes

In the PQC standardization process, NIST announced that the process is continuing with a fourth round, and the following KEMs are still under consideration: IKE, Classic  McEliece, HQC, and SIKE. However, there are no candidates for digital signatures under consideration any longer. Consequently, NIST is requesting more proposals for digital signatures to be considered in the PQC standardization process @alagic_status_2022. 
 
The main interest of NIST is in additional general-purpose signature schemes that are not based on the structured lattices. For certain applications, e.g. certificate transparency,  NIST may be interested in signature schemes with short signatures and fast verification. NIST is not closed for  the additional submissions of structured lattice based signature schemes, however, the intention of the standard is to diversify post-quantum signature standards. Hence, if any structured lattice based signature proposal is made, it would have to be significantly better than CRYSTALS-Dilithium and FALCON in the relevant applications and/or must offer significantly greater security to be considered for standardization. @nist_additional_dss

The Additional Digital Signature Schemes is currently at the Round 2 and the following algorithms remain @alagic_status_2024.

=== CROSS -- Codes and Restricted Objects Signature Scheme

CROSS (Codes and Restricted Objects Signature Scheme) @cross_algorithm_2025 is a post-quantum digital signature scheme based on the Restricted Syndrome Decoding Problem and derived from Zero-Knowledge (ZK) proofs and is based on the hardness of decoding restricted vectors. CROSS is obtained by transforming an interactive zero-knowledge protocol (CROSS-ID) into a signature scheme via the Fiat-Shamir transform.

The sizes of the secret key, the public key and the signatures can be found in @cross-sizes.

=== LESS -- Linear Equivalence Signature Scheme

LESS (Linear Equivalence Signature Scheme) @less_algorithm_2025 is a Post-Quantum Code-based signature scheme based on the hardness of the Linear Code Equivalence problem.  LESS stands for Linear Equivalence Signature Scheme. It is constructed by applying the Fiat-Shamir transformation [FS86] to a zero-knowledge identification scheme. The latter is obtained, essentially,y iterating the one-round Sigma protocol of Figure 2. The final protocol includes several modifications, which we will describe individually in Section 3. These do not impact security nor the goal of the protocol, affecting instead only its modus operandi.

The sizes of the secret key, the public key and the signatures can be found in @less-sizes.

=== SQIsign

SQISign (for Short Quaternion and Isogeny Signature) @NISTPQC-ADD-R2:SQIsign25 is based on a mathematical correspondence between two seemingly distant mathematical worlds: supersingular elliptic curves and isogenies defined over finite fields on one side, maximal orders and ideals of quaternion algebras on the other side.  It is a new signature scheme from isogeny graphs of supersingular elliptic curves. The signature scheme is derived from a new one-round, high soundness, interactive identification protocol. Targeting the post-quantum NIST-1 level of security, our implementation results in signatures of 204 bytes, secret keys of 16 bytes and public keys of 64 bytes @sqisign_2020.

SQIsignHD @sqisign_hd_2023 was the first variant of SQIsign to use higher dimensional isogeny representations. Its eight-dimensional variant is geared towards provable security but is deemed unpractical. Its four-dimensional variant is geared towards efficiency and has significantly faster signing times than SQIsign, but slower verification owing to the complexity of the four-dimensional representation. Its authors commented on the apparent difficulty of getting any improvement over SQIsign by using two-dimensional representations.

SQIsign2D-West @sqisign_west_2023 introduces new algorithmic tools that make two-dimensional representations a viable alternative. These lead to a signature scheme with sizes comparable to SQIsignHD, slightly slower signing than SQIsignHD but still much faster than SQIsign, and the fastest verification of any known variant of SQIsign. We achieve this without compromising on the security proof: the assumptions behind SQIsign2D-West are similar to those of the eight-dimensional variant of SQIsignHD. Additionally, like SQIsignHD, SQIsign2D-West favourably scales to high levels of security Concretely, for NIST level I we achieve signing times of 80 ms and verifying times of 4.5 ms, using optimised arithmetic based on intrinsics available to the Ice Lake architecture. For NIST level V, we achieve 470 ms for signing and 31 ms for verifying.

The SQISign submission in the Round 2 of the Additional Digital Signature Scheme is based on the SQIsign2D-West @NISTPQC-ADD-R2:SQIsign25.

The sizes of the secret key, the public key and the signatures can be found in @sqisign-sizes.

=== HAWK

HAWK @NISTPQC-ADD-R2:HAWK25 is a signature scheme inspired by the introduction of the lattice isomorphism problem (LIP) to signatures moving this to a practical variant by introducing module structure and using simpler sampling procedures to create signatures. The practical security of HAWK is determined by extensive lattice reduction experiments along with a detailed cryptanalysis. The theoretical security of HAWK is given by a lattice problem called the one more (approximate) shortest vector problem, or omSVP. In particular, violating the SUF-CMA security of HAWK allows one to solve omSVP. The problem of direct secret key recovery from public information is an instance of the search module lattice isomorphism problem, or smLIP. Compared to HAWK-AC22 the experimental cryptanalysis has been extended and the reduction to omSVP has been modularized, extended to the qROM and its loss has been made explicit. Throughout we work under the premise that our formal reductions and problems give us confidence in the robustness of our design, and our cryptanalysis gives us confidence in the robustness of our parameters.

The sizes of the secret key, the public key and the signatures can be found in @hawk-sizes.

=== Mirath

Mirath @NISTPQC-ADD-R2:MIRATH25 is a post-quantum digital signature scheme based on the hardness of the MinRank problem. Informally, the MinRank problem asks to find a non-trivial low-rank linear combination of some given matrices over a finite field (actually, Mirath employs an equivalent “dual version” of this problem). Mirath is based on a Zero-Knowledge Proof of Knowledge (ZKPoK) of a solution to an instance of the MinRank problem. This ZKPoK is designed following the Multi-Party-Computation-in-the-Head (MPCitH) paradigm. More precisely, we rely on the Threshold-Computation-in-the-Head (TCitH) framework to build Mirath, while a variant is possible using VOLE-in-the-Head (VOLEitH) framework. The ZKPoK is then converted into a signature scheme using the Fiat–Shamir transform. Mirath has been developed by the merger of two teams, each of which had previously devised its own post-quantum digital signature scheme based on the hardness of the MinRank problem, namely MIRA and MiRitH. The name “Mirath” itself is composed from the names “MIRA” and “MiRitH.”

The sizes of the secret key, the public key and the signatures can be found in @mirath-sizes.

=== MQOM -- MQ on my Mind

MQOM (MQ-on-my-Mind) @NISTPQC-ADD-R2:MOQM25 is a digital signature scheme derived from a zero-knowledge proof-of-knowledge of a secret solution to a random MQ instance. This zero-knowledge proof leverages the MPC-in-the-Head (MPCitH) paradigm and is converted into a signature scheme using the Fiat-Shamir heuristic. 

The sizes of the secret key, the public key and the signatures can be found in @mqom-sizes.

=== PERK

PERK @NISTPQC-ADD-R2:PERK25 is a digital signature scheme that is designed to provide security against attacks which may use quantum computers, as well as attacks by classical computers. The scheme builds on a zero-knowledge proof of knowledge system based on the conjectured post-quantum security of a variant of the Permuted Kernel Problem (PKP), and hash functions modelled as random oracles. The zero-knowledge proof is constructed from the well established MPC-in-the-head paradigm, and it is then converted into a signature scheme using the Fiat-Shamir transform in the random oracle model. The name of the scheme stems from the difficult problem based on PERmuted Kernels, at the core of the security of the protocol.

The sizes of the secret key, the public key and the signatures can be found in @perk-sizes.

=== RYDE

RYDE @NISTPQC-ADD-R2:RYDE25 is a post-quantum signature digital signature scheme based on the hardness of the Rank Syndrome Decoding (RSD). Informally, given a syndrome $y$ and a parity-check matrix $H$, the Rank Syndrome Decoding problem asks to find an error $x$ of small rank weight, whose syndrome is $y$. RYDE relies on a Zero-Knowledge Proof of Knowledge (ZKPoK) of an RSD solution. This ZKPoK is based on the Multi Party Computation in the Head (MPCitH) paradigm. In particular, RYDE relies on the Threshold Computation in the Head (TCitH) framework. A variant using VOLE in the Head (VOLEitH) framework is also described. The ZKPoK is then converted into a signature scheme using the Fiat-Shamir transform.

The sizes of the secret key, the public key and the signatures can be found in @ryde-sizes.

=== SDitH -- Syndrome Decoding in the Head

The Syndrome-Decoding-in-the-Head (SD-in-the-Head) @NISTPQC-ADD-R2:SDitH25 is a digital signature scheme based on the hardness of the syndrome decoding (SD) problem for random linear codes on a finite field. It consists in a zero-knowledge proof of knowledge of a low-weight vector x solution of a syndrome decoding instance $y = H times x$, which is made non-interactive using the Fiat-Shamir transform.

The sizes of the secret key, the public key and the signatures can be found in @sdith-sizes.

=== MAYO

The Oil and Vinegar signature scheme, proposed in 1997 by Patarin @patarin1997oil, is one of the oldest and best understood multivariate quadratic signature schemes. It has excellent performance and signature sizes but suffers from large key sizes on the order of 50 KB, which makes it less practical as a general-purpose signature scheme.

MAYO @NISTPQC-ADD-R2:MAYO25, a variant of the UOV signature scheme solves this problem by making the public keys are two orders of magnitude smaller. MAYO works by using a UOV map with an unusually small oil space, which makes it possible to represent the public key very compactly. The usual UOV signing algorithm fails if the oil space is too small, but MAYO works around this problem by "whipping up" the base oil and vinegar map into a larger map, that does have a sufficiently large oil space.

The sizes of the secret key, the public key and the signatures can be found in @mayo-sizes.

=== QR-UOV

QR-UOV (Quotient Ring Unbalanced Oil and Vinegar) @NISTPQC-ADD-R2:QR-UOV25 is an improved version of the Unbalanced Oil and Vinegar cryptographic scheme (UOV), which is designed to increase the security and performance of post-quantum cryptography. The public key size is reduced by 50-60% over the plain UOVwhile maintaining a compact signature size of a few hundred bits. This enhancement is made possible by the use of quotient ring structure, which allow for more efficient representation and computation of the public key. The security of the scheme is based on the UOV and QR-MQ problems and the formal proofs are provided in the quantum random oracle model (QROM). QR-UOV  is especially interesting due to its simplicity and efficiency, it is based on straight forward linear algebra computations over small finite fields and can be easily applied to a wide range of constrained resources systems. Nevertheless, the main drawback of QR-UOV is the size of the public key which is still quite large as compared to the lattice based schemes and this may limit its application in some applications such as smart cards. However, its strong security and the possibility of future improvements make it a good candidate for future cryptographic systems. 

The sizes of the secret key, the public key and the signatures can be found in @qr-uov-sizes.

=== SNOVA

SNOVA (Simple Noncommutative-ring based UOV with key-randomness Alignment) @cryptoeprint:2022-1742 is a digital signature algorithm that is a variant of the UOV algorithm, retaining the UOV's characteristic of short signatures while offering a shorter public key length compared to the traditional UOV algorithm, thereby providing advantages in both security and efficiency aspects of digital signatures.

Furthermore, the SNOVA algorithm provides three different parameter options for each security level, including various combinations of public key and signature lengths. This feature brings greater flexibility and adaptability to the application side, enabling SNOVA to be well-suited for diverse scenarios, whether it be resource-constrained devices or applications requiring high-security protection, as it allows for the selection of parameter configurations that best suit the specific use case.

The sizes of the secret key, the public key and the signatures can be found in @snova-sizes.

=== UOV

UOV @NISTPQC-ADD-R2:UOV25 is a digital signature scheme that remains secure even against quantum computers. It is built from the trap-doored multivariate quadratic maps by following the hash-and-sign paradigm.

The sizes of the secret key, the public key and the signatures can be found in @uov-sizes.

=== FAEST

FAEST @cryptoeprint:2023-996 is a digital signature algorithm designed to be secure against quantum computers. The security of FAEST is based on standard cryptographic hashes and ciphers, specifically SHA3 and AES, which are believed to remain secure against quantum adversaries.

In FAEST, the secret signing key is an AES key, while the public verification key is a plaintext-ciphertext pair, obtained by encrypting a random message under the signing key. A signature consists of a non-interactive zero-knowledge proof of knowledge of an AES key which maps the message to the ciphertext. This follows the design principle of the Picnic signature scheme, except using the well-analyzed AES cipher as a one-way function instead of LowMC. FAEST also uses a new zero-knowledge proof technique called VOLE-in-the-head, which improves upon the established MPC-in-the-head paradigm.

The sizes of the secret key, the public key and the signatures can be found in @faest-sizes.

=== ANTRAG-512


Antrag (Annular NTRU Trapdoor Generation) @cryptoeprint:2023-1335 introduce a novel trapdoor generation technique for Prest's hybrid sampler over NTRU lattices. Prest's sampler is used in particular in the recently proposed Mitaka signature scheme , a variant of the Falcon signature scheme, one of the candidates selected by NIST for standardization. Mitaka was introduced to address Falcon's main drawback, namely the fact that the lattice Gaussian sampler used in its signature generation is highly complex, difficult to implement correctly, to parallelize or protect against side-channels, and to instantiate over rings of dimension not a power of two to reach intermediate security levels. Prest's sampler is considerably simpler and solves these various issues, but when applying the same trapdoor generation approach as Falcon, the resulting signatures have far lower security in equal dimension. The Mitaka paper showed how certain randomness-recycling techniques could be used to mitigate this security loss, but the resulting scheme is still substantially less secure than Falcon (by around 20 to 50 bits of CoreSVP security depending on the parameters), and has much slower key generation.

The new trapdoor generation techniques solves all of those issues satisfactorily: it gives rise to a much simpler and faster key generation algorithm than Mitaka's (achieving similar speeds to Falcon), and is able to comfortably generate trapdoors reaching the same NIST security levels as Falcon as well. It can also be easily adapted to rings of intermediate dimensions, in order to support the same versatility as Mitaka in terms of parameter selection. All in all, this new technique combines all the advantages of both Falcon and Mitaka (and more) with none of the drawbacks.

= Research Problem

As DNSSEC uses the three algorithms that are not Quantum-Safe, both the DNS and cryptographic community needs to work together to have a suitable algorithm that can be used for DNSSEC ready before the classical algorithms are completely broken by quantum computers.  The usage of quantum-safe cryptographic algorithm for DNSSEC needs to be efficient and it has to fit the needs of the DNS protocol (more on that below).  The DNS community needs to work with the cryptographers as the DNSSEC has different properties and requirements than the regular cryptographic usage that require long-term resistance against cryptanalysis.

In this work, we focus on assessing the suitability of the existing post-quantum algorithms for DNSSEC, and their implementation in BIND 9 open-source DNS server.  Read world-like testing is then used to assess the compatibility and performance of the chosen algorithms.

== Related Work

There are several ongoing proposals in the form of Internet Drafts that propose extending the DNSSEC protocol with PostQuantum Cryptography.

=== Retrofitting post-quantum cryptography in internet protocols: a case study of DNSSEC

Müller et al. @10.1145-3431832.3431838 provided a case study, analyzing the impact of PQC on the Domain Name System (DNS) and its Security Extensions (DNSSEC).  They have evaluated current candidate PQC signature algorithms in the third round of the NIST competition on their suitability for use in DNSSEC and show that three algorithms, partially, meet DNSSEC's requirements but also show where and how we would still need to adapt DNSSEC.

=== Stateful Hash-based Signatures For DNSSEC

Fregly and van Rijswijk-Deij proposed @afrvrd-dnsop-stateful-hbs-for-dnssec-00 how to use stateful hash-based signature schemes (SHBSS) with the DNS Security Extensions (DNSSEC). The schemes include the Hierarchical Signature System (HSS) variant of Leighton-Micali Hash-Based Signatures (HSS/LMS), the eXtended Merkle Signature Scheme (XMSS), and XMSS Multi-Tree (XMSS^MT). In addition, DNSKEY and RRSIG record formats for the signature algorithms are defined and new algorithm identifiers are described.

=== Stateless Hash-based Signatures in Merkle Tree Ladder Mode (SLH-DSA-MTL) for DNSSEC

Fregly et al. @fregly-dnsop-slh-dsa-mtl-dnssec-04 proposed how to apply the Stateless Hash-Based Digital Signature Algorithm in Merkle Tree Ladder mode to the DNS Security Extensions.  This combination is referred to as the SLH-DSA-MTL Signature scheme.  This document describes how to specify SLH-DSA-MTL keys and signatures in DNSSEC.  It uses both the SHA2 and SHAKE family of hash functions.  This document also provides guidance for use of EDNS(0) in signature retrieval.

Sury @sury-dnsop pointed out that a malicious zone operator can return a different rung for every query which effectively makes the resolver request a new signed ladder every time it makes a remote DNS request.  This removes any benefit that the resolvers gain from using the Merkle Tree Ladder mode.  A resistance against the repeated key refetching needs to be built into the protocol, and putting limits on frequency is not going to be enough.

= Methodology

== Research Design

For the purpose of this study, the selected post-quantum algorithms will be implemented in the BIND 9 open-source DNS server.  BIND 9 @bind9-arm is a complete implementation of the DNS protocol. BIND 9 can be configured (using its named.conf file) as an authoritative name server, a resolver, and, on supported hosts, a stub resolver. While large operators usually dedicate DNS servers to a single function per system, smaller operators will find that BIND 9’s flexible configuration features support multiple functions, such as a single DNS server acting as both an authoritative name server and a resolver.

The implementation of each post-quantum algorithm will then be used to test various phases of DNSSEC deployment.  In all phases, the current DNSSEC algorithms will be tested along with the selected post-quantum algorithms for a comparison.  Specifically RSASHA256 with 2048-bit keys, ECDSAP256SHA256 and ED25519 algorithms will be used.

=== Testing Environment

The testing environment will be Ubuntu Linux 24.04 running on a specific machine rather than in the "cloud".  The physical hardware was chosen to control the stable environment for all the conducted tests.  The system will be solely used for the testing, so no other users can affect the measurements.  Also the extra care will be taken to make sure the random generator for the system will have enough entropy for the duration of the tests, so the measurements are not affected by the lack of entropy from the operating system.

=== Software Used

The BIND 9 open-source DNS software will be used as a base software where the selected PQC algorithms will be implemented.  Namely, the libdns component of the BIND 9 will be expanded to use the unused DNSSEC algorithm numbers to prevent clashing with any possible existing deployments.

=== DNSSEC Keys

DNSSEC Keys for all tested DNSSEC algorithms will be generated several times and the generation times will be measured and recorded.

=== DNSSEC Signing

Zones of various sizes will be DNSSEC-signed with the `dnssec-signzone` tool using the classical signature algorithms (RSA, ECDSA, EdDSA) and the selected PQC algorithms and the time required for signing each of the zones will be measured and recorded.

=== DNSSEC Verification

The same tool (`dnssec-signzone`) will be then used to run the verification of the signed zones for the validity and completeness.

=== DNSSEC Resolving

A mock testing environment simulating the DNS hierarchy will be created on the local machine and the realistic resolver workload will be replayed to test the performance using the typical query-pattern as seen on the Internet.

== Selection of PQC Schemes

=== Criteria for selecting PQC algorithms

The selected PQC algorithms must be suitable for DNSSEC, and ideally have parameters that are suitable to seamlessly replace the classical computing cryptographic algorithms.  The important parameters are: public key size, signature size, speed of the signature verification, and last but not least the speed of the signing.

== Evaluation Metrics

Each of the algorithms will be evaluated using several metrics.

=== DNS transport protocol

DNS protocol can use UDP or TCP as the transport protocol.  It is also possible to use recently standardized encrypted DNS-over-QUIC (DoQ; FIXME: RFC ????) on top of the UDP protocol, and DNS-over-TLS (DoT) or DNS-over-HTTP (DoH) on top of the TCP protocol.

There's a major difference in the performance between the two main families (UDP vs TCP).  The UDP protocol is stateless and has no connection negotiation and thus the DNS server can reach millions of responses per second even on the commodity hardware.  The TCP protocol is state-full, the operating system kernel needs to keep state, opening the TCP connection requires three-way handshake, and closing the TCP connection requires four-way handshake.  Even with optimizations like TCP Fast Open that can send the initial data within the final IP packet of the three-way handshake, the DNS protocol can't be fully switched from UDP to TCP without major and extensive upgrade of the DNS infrastructure.  Any new PQC DNSSEC algorithm that would require the DNS protocol to use TCP for majority of the operations would have to bring major benefits to the security of the Internet as whole.

=== IP Fragmentation Avoidance in DNS over UDP

The original DNS specification limited the maximum DNS message size to 512 octets (FIXME: cite RFC 1034/35).  This limitation has been removed via the widely deployed Extension Mechanisms for DNS (EDNS(0)).  This extension of the DNS protocol enables a DNS receiver to indicate a maximum UDP message size capacity, which allows the DNS server to send larger DNS responses over UDP protocol. However, large DNS/UDP messages are more likely to be fragmented, and IP fragmentation has exposed weaknesses in the application protocols.  It is possible to avoid IP fragmentation in DNS by limiting the response size where possible and signaling the need to upgrade from UDP to TCP transport where necessary.  (FIXME: Cite RFC 9715).

RFC 9715 describe various techniques to avoid IP fragmentation of DNS message over UDP protocol applicable for use on the global Internet. In the Appendix A, the authors discuss the maximum safe UDP message size that's is not going to be fragmented on the IP level, and they made following observations: 

 - "Most of the Internet, especially the inner core, has an MTU of at least 1500 octets.  Maximum DNS/UDP payload size for IPv6 on an MTU 1500 Ethernet is 1452 (1500 minus 40 (IPv6 header size) minus 8 (UDP header size)).  To allow for possible IP options and distant tunnel overhead, the recommendation of default maximum DNS/UDP payload size is 1400."

 - "[FIXME: Huston2021] analyzes the result of [FIXME: DNSFlagDay2020] and reports that their measurements suggest that in the interior of the Internet between recursive resolvers and authoritative servers, the prevailing MTU is 1500 and there is no measurable signal of in this part of the Internet.  They propose that their measurements suggest setting the EDNS(0) requestor's UDP payload size to 1472 octets for IPv4 and 1452 octets for IPv6."

=== The Public Key Size

Firstly, the public key of the algorithm has to fit into the DNSKEY Resource Record, but this is not the only metric.  The current DNSSEC setup include at least two DNSKEY records - one for Key Signing Key (KSK) and one for Zone Signing Key (ZSK).  The space for ZSK and KSK rotation needs to be also considered.  And finally, the whole DNSKEY Resource Record Set (RRSet) is signed with at least one RRSIG signature, possibly with more.  Thus the overall consideration abo but the public key needs to span from one DNSKEY for Combined Signing Key (KSK) and a single signature, to three DNSKEY RRs with two RRSIG Resource Records.  Majority of DNS traffic uses UDP protocol with the maximum size of the UDP payload of 1232, but for the purposes of this work, we will consider sizes up to 1452 octets.  Optionally, if the DNS payload cannot fit into the UDP packet, the DNS server will mark the DNS answer with Truncation (TC) flag and the DNS client should use TCP to get the answer.  Maximum size of the DNS message over TCP is limited to 16-bit length (64k), but such large TCP message are impractical.

It also needs to be considered, that typical ISP-level DNS resolver might need to resolver millions of different zones, possibly validating all of them.  Having large public keys might make the caching impractical leading to high churn in the DNS resolver cache and more cache-misses.

It should be also noted, that any algorithm used for DNSSEC needs to be considered from the viewpoint of using such setup for an attack.  There are multiple attack vectors on DNS that cane amplified using large public key sizes.

The first type of the attack is any attack on the resolver itself.  If the attacker can force the resolver to download, validate and store large public keys in the DNS resolver cache, they would be able to make the DNS resolver to consume bandwidth, CPU resources and memory resources.

The second type of the attack is using large Resource Records for Distributed Denial of Service by using the DNS resolver in the reflection type of the attack.  The nature of the UDP with the lack of reverse-path filtering (FIXME: cite BCP38) allows the attacker to send the DNS queries over UDP with spoofed source IP address making the DNS resolver to send the DNS answer to the victim IP address.  Combine this with small size of the DNS queries and relatively large sizes of DNS answers this allows 10-100x amplification factor in such attacks.

At least these attack vectors needs to be considered when adding new PQC algorithms to DNSSEC.

=== The Signature Sizes

In DNSSEC, the signatures are stored in the RRSIG Resource Records.  The RRSIG RRs are attached to DNS answers when DNSSEC responses are requested enlarging the answers by fixed amount.

As with the public key sizes, we need to consider the maximum DNS message payload in the UDP datagrams and consider the possible attack vectors similar to the ones listed in the Public Key Sizes section.

The overall ratio of the RRSIG RRs with signatures to DNSKEYs is many to few.  There's usually only few DNSKEYs in the zones, but many signatures.  The choice of PQC algorithm for DNSSEC should prefer algorithm with smaller signature sizes rather than smaller public key sizes.

=== The Signing Speed

In most common DNSSEC deployment scenarios, the DNSSEC signatures are generated "offline".  This means that DNS queries do not cause the DNS server to compute signatures, but rather the signatures are generated independently of the normal DNS server operation.

Thus it might seem that the signing speed is not important factor when choosing the PQC algorithm for DNSSEC.  However, there are several caveats:

1. Large Zones - while most of the DNS zones are on the small end, the DNS zones can get large at the TLD level.  As an example, the .com zone has abo but 150 millions of registered domains, the .de and .cn also having tens of millions of registered domain, and even the .cz TLD has around 1.5 million of registered domains.  The Resource Records inside the zone has to be signed in an amount of time that a) will not cause operational failures and) allows the whole zone resigning in case of any emergency.  It would note feasible to wait hours for the signing process to complete.

2. Online Signing – some DNS servers allows mode of operation where the Resource Records are signed at the time of the DNS queries and possibly cached.  This is required for DNS zones where the Resource Records are generated.  As a specific example, some DNS servers allow the IPv6 reverse Resource Records (PTR) to be synthetised according to the local policy and rules.  Signing synthetised records must be done at the time of the generation and thus signing speed is important for any DNS operator using this function of the DNS server.

3. NSEC Grey Lies - The NSEC Resource Records provide means for DNS servers to provide a proof of non-existence of a Resource Records.  However, such proof reveals all the zone contents due to the design of the NSEC Resource Records (FIXME:cite?).  To overcome this deficiency Hashed Authenticated Denial of Existence records were added to DNSSEC3 - NSEC3 Resource Records.  Daniel J.ernstein showed that due to the nature of DNS data, the NSEC3 records might used to reveal most of the zone contents using offline methods.  At least one large DNS operator thus introduced a method called NSEC(3) white lies (FIXME: Add RFCs).  And NSEC or NSEC3 white lies can onlye implemented with online signing.  Thus the signing speed is also very important for the DNS operators using NSEC(3) white lies in the DNS zones they are hosting.  (FIXME: https://blog.cloudflare.com/dnssec-complexities-and-considerations/

=== The Verification computation overhead

When the DNS Resolver receives signed answer from the authoritative server, it needs to verify whether the signature matches the received data, and the verification needs to be done very quickly, as the busy DNS resolver can provide hundred thousands of DNS answers to the DNS clients per second.

As with the previous considerations on size, the normal mode of operation is not of a large concern because the received DNS answers will be stored in the DNS resolver cache, but the outliers are the real minefield here.

It was shown that if the attacker can make the DNS resolver to process many DNSKEYs and many RRSIGs, it can grid the resolver to almost full stop (FIXME: Add KeyTrap reference...).  At least in BIND 9, the KeyTrap attack was mitigatedy limiting the number of DNSKEY-RRSIG pairs and also by offloading the cryptographical operations to a different thread-pool, so it does not interfere with non-DNSSEC traffic and the server function of the DNS server when responding DNS queries for local zones or data already in the cache of the DNS resolver.

The other trap lies again in the field of Authenticated Denial of Existence (NSEC).  An attacker can use a technique called Pseudo-Random Subdomain-Attack (PRSD) to force the DNS resolver to ask the upstream authoritative servers again and again for random subdomains that don't exist and validate the NSEC answer from the authoritative server again and again. The Hashed Authenticated Denial of Existence (NSEC3) records suffer from the exactly same problem, and the same mechanism cane used to mitigate the attack. This cane mitigated by Aggressive Use of DNSSEC-Validated Cache (FIXME: RFC 8198, 9077) - using the already cached Authenticated Denial of Existence records from the DNS resolver cache to validate the existence/non-existence of the queried name to prevent the sending the DNS query to the upstream DNS server in the case we already know that the pseudo-random sub-domain lies within the range covered by the NSEC(3) record.  The implication of this is that for any PQC algorithm slower than the existing algorithms, the Aggressive Use of DNSSEC-Validated Cache must be implemented in any DNS server implementation along with PQC algorithm validation.

== Suitable algorithms

Considering the evaluation metrics, following algorithms has been chosen for the implementation, testing and measurements:

=== FALCON-512

The FALCON algorithm has been standardized by NIST as one of the Digital Signature Algorithms, and FALCON-512 matches the Level 1 of the NIST security category.  This algorithm has been included because there's a great chance that the government agencies (at least in the United States) will be required to use NIST-certified algorithm at the FIPS-level.

=== HAWK-256 and HAWK-512

The HAWK algorithm has been submitted for the Round 2 of the Additional Digital Signature Schemes and while it is also lattice-based algorithm (same as FALCON) it has smaller public key and smaller digital signatures.  HAWK-512 matches the Level 1 of the NIST security category, and while HAWK-256 has been submitted only as "Challenge" for the people trying to break the algorithm, its properties nicely matches the requirements for using the algorithm for DNS, and the requirements for usage of the algorithm in the DNS might be more lenient than for long term digital signatures.  This is yet for the cryptographic community to decide.

=== SQIsign

The SQIsign algorithm would suit the intended usage in the DNS because of the small public key and signature sizes, but the signing and verification speed might be problematic.  Nevertheless, this is an interesting algorithm and it might be possible to use it for DNSSEC under certain constraints. Also the SQIsign has been included because it is not lattice-based, but isogeny-based algorithm.

=== MAYO

The MAYO algorithm has been included in the testing as the signature sizes fit very well into DNS.  Unfortunately, the public key size is bit more on the higher end.  MAYO is one of the Oil and Vinegar based schemes.

=== ANTRAG-512

The last algorithm included in this work hasn't be submitted into the NIST Additional Digital Signature Scheme Round 2, but it has been presented during ASIACRYPT (FIXME).  It builds on the FALCON digital signing scheme, but achieves smaller public key and signature sizes compared to other latice-based algorithms.  Specifically, the public key size is smaller than both FALCON-512 and HAWK-512, and the signature size is smaller than FALCON-512 and only slightly larger than HAWK-512.

== Implementation Status

During the implementation of the new cryptographic algorithms, the cryptographic API in the BIND 9 has been cleaned up.  Duplicate functions (`verify`, and `verify2`) have been merged and unused functions (`createctx2`, `computesecret`, `paramcompare`, and `cleanup`) have been removed.  This has been submitted to the upstream project in the `ondrej/dst_api-cleanup` branch.

During implementation of the algorithm with larger secret key, public key or signature sizes, it was discovered that additional modifications to the BIND 9 code were needed, specifically sizes of various internal buffers and data structures that hold the secret key, public keys and signatures.
Additionally, the limits of allowed outgoing DNS queries had to be increased because the increase in the DNS response sizes causes some of the queries to fallback to TCP which in turn would increase the number of outgoing queries needed to resolve a domain name.  For some algorithms, this would lead to initial failures in the DNS resolving, skewing the results.

=== FALCON

As the FALCON algorithm has been already standardized by NIST, multiple implementations exists.  PQclean (FIXME) project provides clean, tested and vetted implementation of the FALCON algorithm that can be easily integrated into other projects.  The liboqs library (FIXME) that extends OpenSSL library has also been considered, but for the testing purposes an implementation that can be fully embedded into BIND 9 project was more suitable.

The copy of the FALCON PQclean code has been embedded into BIND 9 project in the `ondrej/pqc-falcon` project.

=== HAWK

HAWK project provides a neat implementation suitable for direct embedding into other projects that made the testing of the HAWK algorithm very easy and straightforward.  No further modifications of the BIND 9 source code was needed.  The code was embedded directly into the BIND 9 in the `ondrej/pqc-hawk-256` and `ondrej/pqc-hawk-512` branch.

=== SQISign

The official implementation of the SQIsign algorithm has been updated for the Round 2 submission and is now based on the SQIsign-2D-West version of the algorithm.  This implementation does solve some of the deficiencies of the previous version.  The most serious problem that the previous version has was thread-safety.  Still, the implementation mostly focuses on the NIST submission and doesn't make it easy for other projects to use and test the algorithm.  The implementation is riddled with overly complicated CMake build system that is very hard to modify.  The build system produces only static libraries that are not suitable for linking into other projects as that would require linking multiple static libraries scattered across multiple directories.  Therefore the implementation has been modified to produce shared libraries that can be dynamically linked into the BIND 9.  The SQIsign authors provide two variants - the reference implementation and the broadwell-optimized implementation.  The reference implementation has been used in this project as the broadwell-optimized implementation includes some hand-crafted assembly that is not PIC (Position Independent Code) compatible and can't be used when linking the code into shared library.

The implementation also currently doesn't produce public header files.  There are three files in the `./include` directory: `mem.h`, `rng.h` and `sig.h`.  The build system has been modified for the purposes of this work to install these files to `sqisign/{mem,rng,sig}.h`, but generally speaking the `rng.h` header exports two functions called `randombytes_init()` and `randombytes()` that are not really suitable to be used in the common name-space.  Those functions should be moved under the `sqisign_` prefixed name-space.

The integration of the SQIsign algorithm has been published in the `ondrej/pqc-sqisign` branch of the BIND 9 project.  The shared libraries compiled with the optimizations enabled have been added into the branch for the testing purposes.

SQIsign at the NIST Security Level 1 has been tested and marked as SQIsign-I below.

=== MAYO

The MAYO implementation follows that similar pattern as the SQIsign implementation.  The MAYO team currently focuses on the NIST Additional DSS Round 2 submission and the MAYO implementation uses that same anti-patterns - overly complicated CMake build system, no shared libraries, little to none API documentation.  The same modifications have been done – the build system has been modified to produce the shared libraries and install the headers into appropriate places.

The MAYO algorithm has been integrated into BIND 9 in the `ondrej/pqc-mayo` branch.  The shared libraries compiled with the optimizations enabled have been added into the branch for the testing purposes.

MAYO at the NIST Security Level 1 has been tested and marked as MAYO-I below.

=== ANTRAG

The ANTRAG authors provided a implementation in a form of a benchmark.  The implementation is definitely not suitable for integration into other projects, but the integration has been completed for the purposes of this work by integrating the source code of ANTRAG-512 into the BIND 9 source code and embedding the GMP (FIXME) shared library into the source tree.  The result can be found in the `ondrej/pqc-antrag` branch of the BIND 9 source code repository.

== Experimental Setup

The measurements in this experiment has been conducted on two different platforms - local and remote testing.

=== Local testing

The local testing has been conducted on System76 Meerkat machine that features Intel® Core™ Ultra 7 155H processor (FIXME: https://www.intel.com/content/www/us/en/products/sku/236847/intel-core-ultra-7-processor-155h-24m-cache-up-to-4-80-ghz/specifications.html).  This processor includes 6 performance cores, 8 efficient cores and 2 low power efficient-cores.  To achieve a stability in the benchmarks, the Intel® Turbo Boost and Hyper-Threading have been disabled, and the benchmarking has been pinned to the the 6 performance cores.

The Intel® Turbo Boost has been disabled with `echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo` command, the Hyper-Threading has been disabled using `echo off | sudo tee /sys/devices/system/cpu/smt/control` command and the performance cores has been selected using the `lscpu --all --extended` utility:

#figure(
    table(
      columns: 8,
  
      stroke: (x: none),
  
      table.header([CPU], [NODE], [SOCKET], [CORE], [L1d:L1i:L2:L3], [ONLINE], [MAXMHZ], [MINMHZ]),

      [$0$], [$0$], [$0$], [$0$], [$16$:$16$:$4$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$1$], [$0$], [$0$], [$1$], [$8$:$8$:$2$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$2$], [-], [-], [-], [-], [no], [-], [-],
      [$3$], [$0$], [$0$], [$2$], [$12$:$12$:$3$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$4$], [-], [-], [-], [-], [no], [-], [-],
      [$5$], [-], [-], [-], [-], [no], [-], [-],
      [$6$], [$0$], [$0$], [$3$], [$20$:$20$:$5$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$7$], [-], [-], [-], [-], [no], [-], [-],
      [$8$], [$0$], [$0$], [$4$], [$24$:$24$:$6$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$9$], [-], [-], [-], [-], [no], [-], [-],
      [$10$], [$0$], [$0$], [$5$], [$28$:$28$:$7$:$0$], [yes], [$1400.0000$], [$400.0000$],
      [$11$], [-], [-], [-], [-], [no], [-], [-],
      [$12$], [$0$], [$0$], [$6$], [$0$:$0$:$0$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$13$], [$0$], [$0$], [$7$], [$2$:$2$:$0$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$14$], [$0$], [$0$], [$8$], [$4$:$4$:$0$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$15$], [$0$], [$0$], [$9$], [$6$:$6$:$0$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$16$], [$0$], [$0$], [$10$], [$1$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$17$], [$0$], [$0$], [$11$], [$10$:$10$:$1$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$18$], [$0$], [$0$], [$12$], [$1$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$19$], [$0$], [$0$], [$13$], [$14$:$14$:$1$:$0$], [yes], [$900.0000$], [$400.0000$],
      [$20$], [$0$], [$0$], [$14$], [$64$:$64$:$8$], [yes], [$700.0000$], [$400.0000$],
      [$21$], [$0$], [$0$], [$15$], [$66$:$66$:$8$], [yes], [$700.0000$], [$400.0000$],
    ),
    caption: [Output of the `lscpu` command after disabling the Intel Turbo-Boost and the Hyper-Threading],
) <lscpu>

The testing command has been limited to the selected CPU using the `taskset -c 0,1,3,6,9,10` command, and the hyperfine (FIXME: https://github.com/sharkdp/hyperfine) – a command-line benchmarking tool that provides statistical analysis - has been used to run the commands several times in a row.

In the local testing, the key generation times, signing and verification times has been tested using the real DNS zones of various sizes located on the `tmpfs` file system.  The `tmpfs` file system is located in the memory of the operating system, thus it removes the effects of the solid state disk latency.

=== Remote testing

The second part of the testing is using the BIND 9 testing environment that simulates the DNS resolver traffic provided by Internet Service Provider (ISP).  Permission to name the ISP was not provided.

A mock DNS root zone server has been set up with the copy of the DNS root zone signed with each of the tested algorithms.  For each of the tested algorithms:

- the copy of the root zone has been stripped of the current signatures (RRSIG Resource Records, NSEC Resource Records) and public keys (DNSKEY Resource Records);
- exactly one Key Signing Key (KSK) and exactly one Zone Signing Key (ZSK) have been added to the zone;
- and the whole zone has been signed with the `dnssec-signzone` utility.

BIND 9 source code on the abovementioned git branches has been modified to use this mock DNS server to measure the effect of the different algorithms on the resolving process, and the each test has been started with configuration change to use the Key Signing Key for each of the tested algorithms.

= Analysis and Results

== Secret Key, Public Key and Signature Sizes

In the @sizes, summary of Secret Key, Public Key and Signature sizes are given.  The raw sizes without the encapsulation in the DNS protocol are listed.  It has to be noted that while all Public Key and Signature sizes fit within our chosen limit of 1452 octets, the DNS protocol will enlarge the final UDP message sizes.

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      stroke: (x: none),  
      table.header([*Algorithm*], [*NIST Level*], [*Secret Key*], [*Public Key*], [*Signature Size*]),
      [FALCON-512],				[I],					[$1281$],		[$897$],	[$666$],
      [HAWK-256],					[Challenge],	[$96$],			[$450$],	[$249$],
      [HAWK-512],					[I],					[$184$],		[$1024$],	[$555$],
      [SQIsign-I],				[I],					[$353$],		[$65$],		[$148$],
      [MAYO-I],						[I],					[$24$],			[$1420$],	[$454$],
      [ANTRAG-512],				[I],					[$59392$],	[$768$],	[$592$],
      [RSASHA256-2048],		[n/a],				[$1232$],		[$256$],	[$256$],
      [ECDSAP256SHA256],	[n/a],				[$32$],			[$64$],		[$64$],
      [ED25519],					[n/a],				[$32$],			[$32$],		[$64$],
    ),
    caption: [Secret Key, Public Key and Signature Sizes],
) <sizes>

== Signed Zone Size

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      stroke: (x: none),  
      table.header([*Algorithm*], [*Root Zone*], [*TLD Zone*], [*Small Zone*], [*Reverse Zone*]),
      [FALCON-512],				[I],					[$1281$],		[$897$],	[$666$],
      [HAWK-256],					[Challenge],	[$96$],			[$450$],	[$249$],
      [HAWK-512],					[I],					[$184$],		[$1024$],	[$555$],
      [SQIsign-I],				[I],					[$353$],		[$65$],		[$148$],
      [MAYO-I],						[I],					[$24$],			[$1420$],	[$454$],
      [ANTRAG-512],				[I],					[$59392$],	[$768$],	[$592$],
      [RSASHA256-2048],		[n/a],				[$1232$],		[$256$],	[$256$],
      [ECDSAP256SHA256],	[n/a],				[$32$],			[$64$],		[$64$],
      [ED25519],					[n/a],				[$32$],			[$32$],		[$64$],
    ),
    caption: [Secret Key, Public Key and Signature Sizes],
) <zone-sizes>

== DNS Response Sizes 

The final DNS messages sizes are provided in @dns-sizes.  All the DNS queries in this section had RD-bit (Recursion Desired) disabled, DO-bit (DNSSEC OK) enabled, and EDNS(0) Buffer Size enlarged to 1452 (`dig +dnssec +norec +bufsize=1452`).

Since the mock Root Zone was signed only with single Key Signing Key and single Zone Signing Key, all the signatures for DNSSEC-signed records contain only single `RRSIG` Resource Record.  In the case when more than single DNSSEC Keys were used, there would be multiple `RRSIG` Resource Records enlarging the DNS responses even more.  The `RRSIG` records contain signature generated with the Zone Signing Key unless specified otherwise.

The sizes of DNS responses for the following DNS queries are given:

- Start of Authority (SOA) query – this is a DNSSEC-signed Resource Record that is always present in every DNS zone
- DNSKEY query – usually, this could be the largest DNS response given as it includes two `DNSKEY` records (one for Key Signing Key, one for Zone Signing Key) and `RRSIG` Resource Record that contains signature from the Key Signing Key.
- Authenticated Denial of Existence (NSEC) query for non-extant name - this DNS response provides proof that the name from the DNS query doesn't exist in the DNS tree.  This is the other DNS response competing for the largest size as it includes `SOA` RR, two `NSEC` RRs and the respective DNSSEC signatures (3x).
- Authenticated Denial of Existence (NSEC) query for non-extant type - this DNS response provides proof that the DNS type for existing DNS name doesn't exist.  This DNS response includes `SOA` Resource Records, single `NSEC` Resource Records, and the respective DNSSEC signatures (2x).
- Delegation query - the DNS response returned to a DNS query for a name down-below in the delegation tree `www.osu.cz`.  The response includes set of unsigned nameservers (`NS`) Resource Records, DNSSEC-signed Delegation Signer (`DS`) record, and since the nameservers for *.CZ* zone are located below the *.CZ* namespace, it also has to include the GLUE records (copy of the IP addresses for the specified nameservers).

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
      stroke: (x: none),  
      table.header([*Algorithm*], [*SOA*], [*DNSKEY*], [*NSEC-Name*], [*NSEC-Type*], [*Delegation*]),
      [FALCON-512],				[$1532^*$],	[$2548^*$],	[$2251^*$],	[$1521^*$],	[$1031$],
      [HAWK-256],					[$675$],		[$1237$],		[$1004$],		[$688$],		[$614$],
      [HAWK-512],					[$1310$],		[$2691^*$],	[$1921^*$],	[$1299$],		[$920$],
      [SQIsign-I],				[$473$],		[$366$],		[$701$],		[$486$],		[$513$],
      [MAYO-I],						[$1108$],		[$3382^*$],	[$1618^*$], [$1097$],		[$819$],
      [ANTRAG-512],				[$1384$],		[$2216^*$],	[$2032^*$],	[$1373$],		[$957$],
      [RSASHA256-2048],		[$712$],		[$864$],		[$1024$],		[$701$],		[$621$],
      [ECDSAP256SHA256],	[$328$],		[$280$],		[$448$],		[$317$],		[$429$],
      [ED25519],					[$328$],		[$216$],		[$448$],		[$317$],		[$429$],
    ),
    caption: [DNS Response Sizes ($""^*$ - Truncated, retried in TCP mode.)],
) <dns-sizes>

There are only two PQC algorithms that generates DNS message that fit into the chosen UDP size (1452 octets) and the answers over UDP do not have the TC-bit (Truncated) bit set which mean that the client need to retry the DNS query over TCP protocol to get the complete answer - HAWK-256 and SQIsign-I.

== Performance Evaluation

=== Key Generation Times

During the DNSSEC operation, the process of generating the DNSSEC Keys is relatively rare for a single zone.  However, there are DNS hosting companies that host millions to hundred millions of zones and for such deployments the rare event of DNSSEC Key generation might become significant.

In the @keygen, the times to generate a single DNSSEC Key are listed.  For each algorithm, the process was repeated $100$-times and $1000$-times to stabilize the performance of the CPU with $10$ and $100$ warmup rounds respectively.

It has to be noted that the key generation process is not multi-threaded and thus the testing was bound to single CPU - CPU 0 in this case to eliminate any effect that the switching of the active CPU might have.

About $11.5$ ms is spent in the "System".  This means that the operating system overhead for each invocation of the `dnssec-keygen` utility is constant for all the algorithms and is around $11.5$ milliseconds.  The times in @keygen include the "System" overhead.

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      stroke: (x: none),
      table.header(table.cell(rowspan:2, align: bottom, [*Algorithm*]), table.cell(colspan: 2, [100 runs]), table.cell(colspan: 2, [1000 runs]), [*x̄*], [*σ*], [*x̄*], [*σ*]),
      [FALCON-512],				[$80.1$],		[$11.7$],		[$82.4$],		[$12.6$],
      [HAWK-256],					[$46.9$],		[$1.2$],		[$46.5$],		[$1.6$],
      [HAWK-512],					[$51.5$],		[$3.5$],		[$51.1$],		[$3.1$],
      [SQIsign-I],				[$97.8$],		[$4.4$],		[$98.2$],		[$4.2$],
      [MAYO-I],						[$45.1$],		[$2.9$],		[$45.1$],		[$2.9$],
      [ANTRAG-512],				[$71.9$],		[$2.6$],		[$71.9$],		[$1.3$],
      [RSASHA256-2048],		[$493.7$],	[$253.8$],	[$496.3$],	[$243.8$],
      [ECDSAP256SHA256],	[$45.1$],		[$2.3$],		[$45.1$],		[$2.3$],
      [ED25519],					[$45.2$],		[$2.3$],		[$44.9$],		[$2.5$],
    ),
    caption: [DNSSEC Key Generation Times in milliseconds],
) <keygen>

There's notable but expected fluctuation in the RSASHA256 (2048-bits) Key generation.

=== Zone Signing Times

Usually, the individual DNS Resource Records in the DNS Zones are only signed once in a while.  The exact signing times are determined by Key and Signing Policy (KASP) @rfc6781, but the default RRSIG end time is 30 days in the future.  However, there are at least three use cases where the signing times are important.  One was already mentioned above - the online signing of the Grey Lies.  Second use case is simply a large zone with many records, as the individual signatures are spread over the time, if there's enough records to cover the whole period, there could be a constant churn as the signatures expire and are resigned all the time.  The third use case is similar to the second use case -- the zone can be updated either by providing new version of the zone (f.e. generated from the database) or via DNS updates and again there's enough churn in the zone data to keep the signing process busy all the time.

In the @signing-times, the times to sign the current Root Zone are listed.  For each measured algorithm, the process was repeated $100$ times to stabilize the performance and the measurement and $10$ warmup rounds were used.

The Root Zone was downloaded from https://www.internic.net/domain/root.zone.  The existing DNSSEC records were stripped using `ldns-read-zone -s` utility and the exisint *DNSKEY* records were removed.  Afterwards, the Root Zone was pre-compiled from the plain text zone file format into raw zone format to minimize the effect of parsing the text zone file format.  There were $2790$ signatures generated with each `dnssec-signzone` invocation.  Post-signing zone verification has been disabled.

The zone signing is multi-threaded and the testing was pinned to these 6 performance cores with HyperThreading and Intel Turbo Boost disabled.

Following arguments were used `dnssec-signzone -n 6 -P -x -S -o . -I raw -O raw db.root` to sign the Root Zone.

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      stroke: (x: none),
      table.header([*Algorithm*], [*x̄*], [*σ*], [*Signatures per second*], [*System*]),
      [FALCON-512],				[$4881.9$],	  [$26.8$],   [$589.731$],    [$117.9$],
      [HAWK-256],					[$195.5$],	  [$4.9$],    [$62001.377$],  [$113.7$],
      [HAWK-512],					[$261.0$],	  [$9.6$],    [$49821.873$],  [$122.6$],
      [SQIsign-I],				[$54528.1$],	[$67.9$],   [$51.038$],     [$11971.8$],
      [MAYO-I],						[$1086.6$],	  [$48.7$],   [$2746.081$],   [$110.5$],
      [ANTRAG-512],				[$5339.6$],	  [$111.2$],  [$546.955$],    [$112.8$],
      [RSASHA256-2048],		[$845.7$],	  [$3.0$],    [$3980.056$],   [$113.5$],
      [ECDSAP256SHA256],	[$218.1$],	  [$10.2$],   [$44286.417$],  [$109.9$],
      [ED25519],					[$240.6$],	  [$6.3$],    [$47288.937$],  [$106.5$],
    ),
    caption: [DNSSEC Key Generation Times in milliseconds],
) <signing-times>

=== Zone Verification Times

Finally, the signatures in the signed zone was verified using the `dnssec-verify` utility.  While this test is very artificial as it does the verification sequentially, it gives a glimpse of the DNSSEC-validating resolver as the signature verification is the most common cryptographic operation.

In the @verification-times, the times to verify the current signed Root Zone are listed.  For each measured algorithm, the process was repeated $100$ times to stabilize the performance and the measurement and $10$ warmup rounds were used.

The signed Root Zones from the previous process for each respective algorithms were used.  Again, the zone for verification process was provided in the _raw_ zone format to minimize the effect of the plain text zone file format parsing.

Following arguments were used `~/Projects/bind9/bin/dnssec/dnssec-verify -I raw -o . -x db.root.signed` to verify the signed Root Zone.

#figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      stroke: (x: none),
      table.header(
      [*Algorithm*],      [*x̄*],        [*σ*],      [*System*]),
      [FALCON-512],				[$403.7$],	  [$1.1$],    [$20.3$],
      [HAWK-256],					[$232.5$],	  [$1.4$],    [$18.7$],
      [HAWK-512],					[$359.4$],	  [$66.0$],   [$21.3$],
      [SQIsign-I],				[$22338.5$],  [$35.0$],   [$19.9$],
      [MAYO-I],						[$995.8$],	  [$26.8$],   [$20.2$],
      [ANTRAG-512],				[$548.6$],	  [$1.4$],    [$20.2$],
      [RSASHA256-2048],		[$250.2$],	  [$1.1$],    [$18.9$],
      [ECDSAP256SHA256],	[$610.0$],	  [$2.3$],    [$18.4$],
      [ED25519],					[$819.4$],	  [$2.3$],    [$18.6$],
    ),
    caption: [DNSSEC Key Generation Times in milliseconds],
) <verification-times>

- Comparison of PQC schemes in terms of key generation, signing, and verification times. 
- Impact on DNSSEC response times and bandwidth usage. 

== DNS Resolver Benchmarking

In the previous sections, the sizes of the DNS messages and the speed of DNSSEC signing and verification were evaluated.  In this sections, everything will be put together into a DNS Resolver benchmarking test.  Modified BIND 9 with support for the above mentioned algorithms was used for benchmarking.

=== Experiment Setup

BIND 9 team already has a setup for benchmarking DNS Resolver called Shotgun CI that combines GitLab CI @gitlab-ci and DNS Shotgun.

DNS Shotgun @dns-shotgun is a realistic DNS benchmarking tool which supports multiple transport protocols.  It supports UDP, TCP, DNS-over-TLS (DoT), and DNS-over-HTTPS (DoH).  DNS Shotgun is capable of simulating hundreds of thousands of DoT/DoH
clients and it exports a number of statistics, such as query latencies, number of handshakes and connections, response rate, response codes etc. in JSON format.  The toolchain also provides scripts that can plot these into readable charts.

GitLab CI/CD @gitlab-ci is a tool to provide continuous methods of software development, where you continuously build, test, deploy, and monitor iterative code changes.

Shotgun CI @shotgun-ci combines GitLab CI/CD with DNS Shotgun to provide a convenient way to launch benchmarking over one or multiple git branches.  Each run of the CI can have different parameters.  The following parameters are tunable:

#image("Screenshot 2025-05-05 at 16.09.29.png")

In this experimental setup, the following variables has been altered from their respective defaults:

- `SHOTGUN_TEST_VERSION` was set to a tuple consisting of a base branch and the chosen algorithm branch
- `SHOTGUN_TRAFFIC_MULTIPLIER` was set to 20 - this corresponds to 186k queries-per-second
- `SHOTGUN_ROUNDS` was set to 5 repetitions.  As the testing happens on the real internet, there could be fluctuations between individual runs and 5 rounds can smoothen the results.  Additionally, individual results can be then evaluated and outliers can be assessed manually.
- `SHOTGUN_DURATION` was set to 600 seconds, e.g. 5 minutes.  This allows enough time to fill the cache and test both cold cache and hot cache scenarios with sufficient time and queries.
- `BIND_EXTRA_CONF` was used to setup custom DNSSEC trust anchors.  The custom trust anchors contain both the current DNSSEC root zone key signing keys (KSK) and a new custom root zone key signing key for each of the tested algorithms.

The Shotgun CI test setup consists of two stages.  The first stage generates the Continuous Integration (CI) configuration based on the given variables, and the second stage spins up enough machines (FIXME: Specification?) in the Amazon AWS Cloud and distributes the individual test runs to each AWS node.  When all the benchmarking runs are finished, a post-processing job collects all the logs from all the benchmarking runs and combines them into single output.  It generates number of charts and also provides a simplified basic view that contains aggregated performance charts (first half of the interval, second half of the interval and the whole interval), memory consumption, CPU load during the benchmark, and performance chart with all benchmarking runs plotted separately.  More charts can be generated based on the data gathered during the benchmarking runs, but for our purposes, these are enough to consider the impact of the PQC algorithms on the DNS Resolver Performance.

==== Logarithmic Percentile Histograms

Bert Hubert and Peter van Dijk @logperfhist have introduced the logarithmic percentile histograms into the DNS world.  In @loghisto, the both axes are logarithmic.  The x-axis show the _slowest_ percentile

#figure(
  image("log-histo3-Mar-15-2023-07-57-33-7669-AM.png"),
)<loghisto>


The $x$-axis describe the slowest percentiles on a logarithmic scale.  As an example, the $1%$ of the slowest queries can be found at $x=1$.  The matching value on the $y$-axis gives as the average latence of the answers for those $1%$ slowest queries – around 8 milliseconds for KPN fiber in the PowerDNS office, and around 90 milliseconds for the Middle East installation.

Similarly, the $0.01$ percentile of the queries are answered in around $1200$ milliseconds – and that's barely usable time as many DNS clients will already retry the query.

Looking from a different angle, $99.9%$ of queries ($x=0.01$) are answered under 200 milliseconds on the KPN fiber installation.  Such delay can be caused by various factors - some authoritative servers might be slow, down, mis-configured or unresponsive.  Some of the slowness in the DNS ecosystem can't be fixed by the DNS resolvers alone as they are not caused by the inefficiency in the DNS resolver code.

==== Custom Root Zone Server

A single instance of Ubuntu server was created in the same AWS region to minimize the effect of the latency on the results and was given a DNS name *nemoto.dns.rocks.*.  A BIND 9.20.8 was installed and configured.  The default configuration was modified to disable recursive DNS queries as this server (`recursion no;`), and maximum EDNS buffer size (e.g. maximum DNS message size over UDP) was bumped to `1452` with `edns-udp-size 1452;` and `max-udp-size 1452`.  Finally, custom root zone was added in a raw (pre-compiled) format.  The final configuration located in standard location `/etc/bind/named.conf` looked like this:

```
options {
        directory "/var/cache/bind";
        dnssec-validation auto;
        recursion no;
        edns-udp-size 1452;
        max-udp-size 1452;
        trust-anchor-telemetry no;
};

zone "." in {
        file "/etc/bind/<algorithm>/db.root.signed";
        type primary;
        masterfile-format raw;
};
```

==== Custom Root Zone

A up-to-date root zone with serial number $2025050200$ has been downloaded and all DNSSEC resource records have been stripped.  The *RRSIG* and *NSEC* resource records were stripped using *ldns* utility (`ldns-read-zone -s root.zone > db.root`) and then *DNSKEY* resource records have been stripped manually using text editor.

For every tested algorithm, following steps were done:

1. A Root Zone Key Signing Key was generated using `dnssec-keygen -a <algo> -f KSK  .` command
2. A Root Zone Zone Signing Key was generated using `dnssec-keygen -a <algo> .` command
3. A stripped Root Zone has been signed using `dnssec-signzone -S -O raw -I text -o . -f db.root.signed -R -Q -t <path_to>/db.root` command
4. The signed Root Zone (`db.root.signed`) has been uploaded to the Custom Root Zone Server
5. The BIND 9 on the Custom Root Zone Server has been configured to use the uploaded `db.root.signed` file with the matching algorithm to the PQC algorithm being tested

==== DNS Resolver Configuration

BIND 9 development version has been used for benchmarking.  All tested versions including the baseline versions have been modified to bump the `max-recursion-queries` from $50$ to $100$ and maximum EDNS(0) UDP size has been changed from $1232$ to $1452$ as some algorithms that would cause fallback from UDP to TCP could go over these configured limits and cause DNS resolution failures unrelated to the cryptographic operations.  The baseline version can be found in the `ondrej/pqc-main` branch in the upstream BIND 9 repository.  All tested BIND 9 versions (except the baseline version) have a common ancestor branch `ondrej/pqc-base` that contains changes from the `ondrej/pqc-main`, but also modifies the nameservers for the root zone from the original *[a-m].root-servers.net.* to *nemoto.dns.rocks.* with a single IPv4 address and a single IPv6 address.

==== DNS Resolver Test Data

The Shotgun CI uses a real-world data that were gracefully provided by a large-size telecommunication company and sanitized for privacy reasons – IP addresses were anonymized.  The test set reflects a real unfiltered DNS traffic captured from the networking interface of a large DNS resolver and reflects the traffic generated by Internet Service Provider users, various automated traffic, mis-configurations and miscreants (bots, worms, DDoS clients, etc.), e.g. the usual mix of DNS queries as found on the Internet.

=== DNS Resolver Benchmarking Results

In addition to the chosen PQC algorithms, the classic algorithms were also tested - RSASHA256 with 2048-bit keys, ECDSA-P256-SHA256 and ED25519.  The RSASHA256-2048 is the current algorithm used to sign the Root Zone, thus the baseline tests from the `ondrej/pqc-main` always tests the RSASHA246-2048 algorithm.

When evaluating the latency results, it is important to realize that these results were gathered on the real Internet and there will be slight differences between the individual runs and even between the individual branches.

==== RSASHA256 with 2048-bit keys Results

In @rsasha256-all-groups-latency-since_0-until_300, the results for a situation when the DNS cache is completely empty (also called Cold Cache) can be observed.  As the cache fills up with the data, the latency gradually improves (smaller is better), and effect of DNS cache (Hot Cache) can be observed in @rsasha256-all-groups-latency-since_300-until_600.  The differences between the normal Root Zone servers and the mock Root Zone server for benchmarking can be observed in this scenario, as the DNSSEC algorithm for both tested branches is the same.

#figure(
  image("rsasha256/_charts-all-groups/all-groups-latency-since_0-until_300.png"),
  caption: [RSASHA256/2048 All Groups Cold Cache Latency],
)<rsasha256-all-groups-latency-since_0-until_300>

#figure(
  image("rsasha256/_charts-all-groups/all-groups-latency-since_300-until_600.png"),
  caption: [RSASHA256/2048 All Groups Hot Cache Latency],
)<rsasha256-all-groups-latency-since_300-until_600>

The results in @rsasha256-all-groups-latency-since_0-until_300 and @rsasha256-all-groups-latency-since_300-until_600 show only slight variation in the results.

#figure(
  image("rsasha256/_charts-all-groups/all-groups-resmon.cpu.usage_percent.cg-docker.png"),
  caption: [RSASHA256/2048 All Groups CPU Usage Percent],
)<rsasha256-all-groups-resmon.cpu.usage_percent>

#figure(
  image("rsasha256/_charts-all-groups/all-groups-resmon.memory.current-docker.png"),
  caption: [RSASHA256/2048 All Groups Memory Usage],
)<rsasha256-all-groups-resmon.memory>

There are also no differences between the tested branches in the CPU usage in @rsasha256-all-groups-resmon.cpu.usage_percent and also no difference in memory usage as observed in @rsasha256-all-groups-resmon.memory.

Overall, it can be concluded that the benchmarking methodology and the setup is not a source of a difference on its own.

==== ECDSA-P256-SHA256

ECDSA-P256-SHA256 is a second algorithm that has been standardized for use in DNSSEC and is not Quantum Safe.  This algorithm has been also included here just for comparative purposes.

#figure(
  image("ecdsap256/_charts-all-groups/all-groups-latency-since_0-until_300.png"),
  caption: [ECDSA-P256-SHA256 All Groups Cold Cache Latency],
)<ecdsap256-all-groups-latency-since_0-until_300>

#figure(
  image("ecdsap256/_charts-all-groups/all-groups-latency-since_300-until_600.png"),
  caption: [ECDSA-P256-SHA256 All Groups Hot Cache Latency],
)<ecdsap256-all-groups-latency-since_300-until_600>

In @ecdsap256-all-groups-latency-since_0-until_300 and @ecdsap256-all-groups-latency-since_300-until_600

= Discussion (FIXME)

FIXME: Discuss the shortcomings of the testing methodology.

== Interpretation of Results
- Implications of the findings for DNSSEC and internet security. 

== Challenges and Limitations
- Technical and operational challenges in adopting PQC for DNSSEC. 
- Limitations of the study and areas for further research. 

== Recommendations
- Strategies for transitioning DNSSEC to PQC. 
- Policy and standardization considerations. 

---

= Conclusion
== Summary of Findings
- Recap of key results and their significance. 

== Contributions to the Field
- How the research advances the understanding of PQC in DNSSEC. 

== Future Work
- Potential directions for further research (e.g., hybrid schemes, optimization techniques). 


-- Personal conversation with Eyal Ronen, 24.7.2024 --
Hi Ondrej,

Nice to e-meet you.

I think that there are several other options for PQ signatures for DNSSEC, that can rely on the specific use case.
For example, assuming we have a known number of signatures for a specific zone, and we allow for the signer to be state-full, we can use XMSS (or even just one tree) directly as the signature. This will have a relatively small signature size and fast verification.
If being stateless is very important, we can consider SPHINCS+ variants that can support a maximum of 2^16 signatures instead of 2^64, which will also result in a much smaller signature.

Best regards,
Eyal Ronen
-- Personal conversation with Eyal Ronen, 24.7.2024 --

#pagebreak()
// #bibliography(title: "Literature", "items.bib", style: "iso-690-numeric")
#bibliography(title: "Literature", "items.bib", style: "ieee")

#set heading(numbering: none)

#set page(flipped: true)

= Appendices

== Tables

#figure(
    table(
      columns: (1fr, auto, 1fr, 1fr, 1fr),
      stroke: (x: none),
  
      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
      table.cell(rowspan:6, [1]),
        [CROSS-R-SDP fast],      [$32$],  [$77$], [$18432$],
        [CROSS-R-SDP balanced],    [$32$],  [$77$], [$13152$],
        [CROSS-R-SDP small],     [$32$],  [$77$], [$12432$],
        [CROSS-R-SDP(G) fast],   [$32$],  [$54$], [$11980$],
        [CROSS-R-SDP(G) balanced], [$32$],  [$54$],  [$9120$],
        [CROSS-R-SDP(G) small],  [$32$],  [$54$],  [$8960$],
      table.cell(rowspan:6, [3]),
        [CROSS-R-SDP fast],      [$48$], [$115$], [$41406$],
        [CROSS-R-SDP balanced],    [$48$], [$115$], [$29853$], 
        [CROSS-R-SDP small],     [$48$], [$115$], [$28391$],
        [CROSS-R-SDP(G) fast],   [$48$],  [$83$], [$26772$],
        [CROSS-R-SDP(G) balanced], [$48$],  [$83$], [$22464$],
        [CROSS-R-SDP(G) small],  [$48$],  [$83$], [$20452$],
      table.cell(rowspan:6, [5]),
        [CROSS-R-SDP fast],      [$64$], [$153$], [$74590$],
        [CROSS-R-SDP balanced],    [$64$], [$153$], [$53527$],
        [CROSS-R-SDP small],     [$64$], [$153$], [$50818$],
        [CROSS-R-SDP(G) fast],   [$64$], [$106$], [$48102$],
        [CROSS-R-SDP(G) balanced], [$64$], [$106$], [$40100$],
        [CROSS-R-SDP(G) small],  [$64$], [$106$], [$36454$],
    ),
    caption: [CROSS key and signature sizes in bytes for each security level],
) <cross-sizes>

#pagebreak()

#figure(
    table(
      columns: (1fr, auto, 1fr, 1fr, 1fr, 1fr),
  
      stroke: (x: none),
  
      table.header(table.cell(rowspan:2, [NIST Security Level]), table.cell(rowspan:2, [Parameter Set]), table.cell(rowspan:2, [Secret Key]), table.cell(rowspan:2, [Public Key]), table.cell(colspan:2, [Signature]),
      [Worst Case], [Avg. Case]),
  
      table.cell(rowspan:3, [1]),
        [LESS-252-192], [$32$],  [$13940$],  [$2625$], [$2289$],
        [LESS-252-68],  [$32$],  [$41788$],  [$1825$], [$1745$],
        [LESS-252-45],  [$32$],  [$97484$],  [$1329$], [$1313$],
      table.cell(rowspan:2, [3]),
        [LESS-400-220], [$48$],  [$35074$],  [$6329$], [$5585$],
        [LESS-400-102], [$48$], [$105174$],  [$4131$], [$3867$],
      table.cell(rowspan:2, [5]),
        [LESS-548-345], [$64$],  [$65793$], [$10680$], [$9464$],
        [LESS-548-137], [$64$], [$197315$],  [$7436$], [$7116$],
    ),
    caption: [LESS key and signature sizes in bytes for each security level],
  ) <less-sizes>

#pagebreak()

  
#figure(
    table(
      columns: (1fr, auto, 1fr, 1fr, 1fr),
      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
      table.cell(rowspan:1, [1]),
        [SQIsign NIST-I],   [$353$],  [$65$], [$148$],
      table.cell(rowspan:1, [3]),
        [SQIsign NIST-III], [$529$],  [$97$], [$224$],
      table.cell(rowspan:1, [5]),
        [SQIsign NIST-V],   [$701$], [$129$], [$292$],
    ),
    caption: [SQIsign key and signature sizes in bytes for each security level],
  ) <sqisign-sizes>

#pagebreak()

  
#figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
      table.cell(rowspan:1, [Challenge]),
        [HAWK-256],   [$96$],  [$450$],  [$249$],
      table.cell(rowspan:1, [1]),
        [HAWK-512],  [$184$], [$1024$],  [$555$],
      table.cell(rowspan:1, [5]),
        [HAWK-1024], [$360$], [$2440$], [$1221$],
    ),
    caption: [HAWK key and signature sizes in bytes for each security level],
  ) <hawk-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:4, [1]),
      [Mirath-1a-Short], [$32$], [$73$],  [$3078$],
      [Mirath-1b-Short], [$32$], [$57$],	[$2902$],
      [Mirath-1a-Fast],  [$32$], [$73$],	[$3728$],
      [Mirath-1b-Fast],  [$32$], [$57$],	[$3456$],
    table.cell(rowspan:4, [3]),
      [Mirath-3a-Short], [$48$], [$107$],	[$6907$],
      [Mirath-3b-Short], [$48$], [$84$],	[$6514$],
      [Mirath-3a-Fast],  [$48$], [$107$],	[$8537$],
      [Mirath-3b-Fast],  [$48$], [$84$],	[$7936$],
    table.cell(rowspan:4, [5]),
      [Mirath-5a-Short], [$64$], [$147$],	[$12413$],
      [Mirath-5b-Short], [$64$], [$112$],	[$11620$],
      [Mirath-5a-Fast],  [$64$], [$147$], [$15504$],
      [Mirath-5b-Fast],  [$64$], [$112$],	[$14262$],
    ),
    caption: [Mirath key and signature sizes in bytes for each security level],
) <mirath-sizes>

#pagebreak()
  
#figure(
    table(
      columns: (1fr, auto, 1fr, 1fr, 1fr, 1fr),
  
      stroke: (x: none),
  
      table.header(table.cell(rowspan:2, [NIST Security Level]), table.cell(rowspan:2, [Parameter Set]), table.cell(rowspan:2, [Secret Key]), table.cell(rowspan:2, [Public Key]), table.cell(colspan:2, [Signature]),
      [3-round], [5-round]),
  
      table.cell(rowspan:4, [1]),
        [MQOM2-L1-gf2-short],    [72],  [52], [2868],  [2820],
        [MQOM2-L1-gf256-short], [128],  [80], [3540],  [3156],
        [MQOM2-L1-gf2-fast],     [72],  [52], [3212],  [3144],
        [MQOM2-L1-gf256-fast],  [128],  [80], [4164],  [3620],
      table.cell(rowspan:4, [3]),
        [MQOM2-L1-gf2-short],   [108],  [78], [6388],  [6280],
        [MQOM2-L1-gf256-short], [192], [120], [7900],  [7036],
        [MQOM2-L1-gf2-fast],    [108],  [78], [7576],  [7414],
        [MQOM2-L1-gf256-fast],  [192], [120], [9844],  [8548],
      table.cell(rowspan:4, [5]),
        [MQOM2-L1-gf2-short],   [144], [104], [11764], [11564],
        [MQOM2-L1-gf256-short], [256], [160], [14564], [12964],
        [MQOM2-L1-gf2-fast],    [144], [104], [13412], [13124],
        [MQOM2-L1-gf256-fast],  [256], [160], [17444], [15140],
    ),
    caption: [MQOM key and signature sizes in bytes for each security level],
  ) <mqom-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:4, [1]),
      [PERK-I-fast3],  [$16$], [$150$],  [$8360$],
      [PERK-I-fast5],  [$16$], [$240$],  [$8030$],
      [PERK-I-short3], [$16$], [$150$],  [$6250$],
      [PERK-I-short5], [$16$], [$240$],  [$5780$],
    table.cell(rowspan:4, [3]),
      [PERK-III-fast3],  [$24$], [$230$], [$18800$],
      [PERK-III-fast5],  [$24$], [$370$], [$18000$],
      [PERK-III-short3], [$24$], [$230$], [$14300$],
      [PERK-III-short5], [$24$], [$370$], [$13200$],
    table.cell(rowspan:4, [5]),
      [PERK-V-fast3],  [$32$], [$310$], [$33300$],
      [PERK-V-fast5],  [$32$], [$510$], [$31700$],
      [PERK-V-short3], [$32$], [$310$], [$25100$],
      [PERK-V-short5], [$32$], [$510$], [$23000$],
    ),
    caption: [PERK key and signature sizes in bytes for each security level],
  ) <perk-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:2, [1]),
      [RYDE-1-Short], [$32$], [$69$],   [$2988$],
      [RYDE-1-Fast],  [$32$], [$69$],   [$3597$],
    table.cell(rowspan:2, [3]),
      [RYDE-3-Short], [$48$], [$101$],  [$6728$],
      [RYDE-3-Fast],  [$48$], [$101$],  [$8264$],
    table.cell(rowspan:2, [5]),
      [RYDE-5-Short], [$48$], [$133$], [$11819$],
      [RYDE-5-Fast],  [$48$], [$133$], [$14609$],
    ),
    caption: [RYDE key and signature sizes in bytes for each security level],
  ) <ryde-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:2, [1]),
      [SDitH2-L1-gf2-short],  [$70$], [$163$],  [$3705$],
      [SDitH2-L1-gf2-fast],   [$70$], [$163$],  [$4484$],
    table.cell(rowspan:2, [3]),
      [SDitH2-L3-gf2-short],  [$98$], [$232$],  [$7964$],
      [SDitH2-L3-gf2-fast],   [$98$], [$232$],  [$9916$],
    table.cell(rowspan:2, [5]),
      [SDitH2-L5-gf2-short], [$132$], [$307$], [$14121$],
      [SDitH2-L5-gf2-fast],  [$132$], [$307$], [$17540$],
    ),
    caption: [SDitH key and signature sizes in bytes for each security level],
  ) <sdith-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:2, [1]),
      [MAYO_one],   [$24$], [$1420$], [$454$],
      [MAYO_two],   [$24$], [$4912$], [$186$],
    table.cell(rowspan:1, [3]),
      [MAYO_three], [$32$], [$2986$], [$681$],
    table.cell(rowspan:1, [5]),
      [MAYO_five],  [$40$], [$5554$], [$964$],
    ),
    caption: [MAYO key and signature sizes in bytes for each security level],
  ) <mayo-sizes>

#pagebreak()

  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:4, [1]),
      [QR-UOV-I-main],   [$32$],  [$24255$], [$200$],
      [QR-UOV-I-aux1],   [$32$],  [$20641$], [$331$],
      [QR-UOV-I-aux2],   [$32$],  [$23641$], [$157$],
      [QR-UOV-I-aux3],   [$32$],  [$12266$], [$435$],
    table.cell(rowspan:4, [3]),
      [QR-UOV-III-main], [$48$],  [$71891$], [$292$],
      [QR-UOV-III-aux1], [$48$],  [$55149$], [$489$],
      [QR-UOV-III-aux2], [$48$],  [$70983$], [$232$],
      [QR-UOV-III-aux3], [$48$],  [$34399$], [$643$],
    table.cell(rowspan:4, [5]),
      [QR-UOV-V-main],   [$64$], [$173676$], [$392$],
      [QR-UOV-V-aux1],   [$64$], [$135407$], [$662$],
      [QR-UOV-V-aux2],   [$64$], [$158421$], [$306$],
      [QR-UOV-V-aux3],   [$64$],  [$58532$], [$807$],
    ),
    caption: [QR-UOV key and signature sizes in bytes for each security level],
  ) <qr-uov-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:3, [1]),
      [SNOVA-I-1],    [$90608(+48)$],  [$9826(+16)$], [$108(+16)$],
      [SNOVA-I-2],    [$37962(+48)$],  [$2304(+16)$], [$149(+16)$],
      [SNOVA-I-3],    [$34112(+48)$],  [$1000(+16)$], [$232(+16)$],
    table.cell(rowspan:3, [3]),
      [SNOVA-III-1], [$299632(+48)$], [$31250(+16)$], [$162(+16)$],
      [SNOVA-III-2], [$174798(+48)$],  [$5990(+16)$], [$270(+16)$],
      [SNOVA-III-3], [$128384(+48)$],  [$4096(+16)$], [$360(+16)$],
    table.cell(rowspan:3, [5]),
      [SNOVA-V-1],   [$702932(+48)$], [$71874(+16)$], [$216(+16)$],
      [SNOVA-V-2],   [$432297(+48)$], [$15188(+16)$], [$365(+16)$],
      [SNOVA-V-3],   [$389312(+48)$],  [$8000(+16)$], [$560(+16)$],
    ),
    caption: [SNOVA key and signature sizes in bytes for each security level],
  ) <snova-sizes>

  #pagebreak()

  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:2, [1]),
      [uov-Ip],   [$48$], [$43576$], [$128$],
      [uov-Is],   [$48$], [$66576$], [$96$],
    table.cell(rowspan:1, [3]),
      [uov-III], [$48$], [$189232$], [$200$],
    table.cell(rowspan:1, [5]),
      [uov-V],  [$48$], [$446992$], [$260$],
    ),
    caption: [UOV key and signature sizes in bytes for each security level],
  ) <uov-sizes>

#pagebreak()
  
  #figure(
    table(
      columns: 5,

      stroke: (x: none),

      table.header([NIST Security Level], [Parameter Set], [Secret Key], [Public Key], [Signature]),
    table.cell(rowspan:4, [1]),
      [128s],    [$32$], [$32$], [$4506$],
      [128f],    [$32$], [$32$], [$5924$],
      [EM-128s], [$32$], [$32$], [$3906$],
      [EM-128f], [$32$], [$32$], [$5060$],
    table.cell(rowspan:4, [3]),
      [192s],    [$40$], [$48$], [$11260$],
      [192f],    [$40$], [$48$], [$14948$],
      [EM-192s], [$48$], [$48$], [$9340$],
      [EM-192f], [$48$], [$48$], [$12380$],
    table.cell(rowspan:4, [5]),
      [256s],    [$64$], [$64$], [$20696$],
      [256f],    [$64$], [$64$], [$26548$],
      [EM-256s], [$64$], [$64$], [$17984$],
      [EM-256f], [$64$], [$64$], [$23476$],
    ),
    caption: [FAEST key and signature sizes in bytes for each security level],
  ) <faest-sizes>

Data 20x:
  - SQISign:    https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577905
  - HAWK-256:   https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577915
  - HAWK-512:   https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577934
  - MAYO:       https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577952
  - ANTRAG:     https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577983
  - FALCON-512: https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5577697
  - RSA2048:    https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5602029
  - ECDSAP256:  https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5578064
  - ED25519:    https://gitlab.isc.org/isc-projects/bind9-shotgun-ci/-/jobs/5578250
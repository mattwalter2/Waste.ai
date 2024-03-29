import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
          backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  IntroductionWidget(),
                  InformationCollectionWidget(),
                  InformationSharingWidget(),
                  DataSecurityWidget(),
                  UserRightsWidget(),
                  ChildrensPrivacyWidget(),
                  PolicyUpdateWidget(),
                  PrivacyContactWidget()
                ],
              ),
            ),
          ),
        ));
  }
}

class IntroductionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Introduction',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Description of the App and Its Purpose:\n'
          'bioWatch is an innovative mobile application designed to empower users to identify invasive species and contribute to the preservation of biodiversity. Utilizing advanced AI technology, bioWatch allows users to capture images of insects, plants and animals in their natural environment, receive instant species identification, and connect with a community of conservationists and experts. Our mission is to harness the power of citizen science for ecosystem conservation and promote environmental education.\n',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Statement of Commitment to Privacy:\n'
          'At bioWatch, we are deeply committed to protecting the privacy and security of our users. We understand the importance of personal data and are dedicated to managing it responsibly and transparently. This Privacy Policy outlines the types of information we collect, how it is used, and the steps we take to ensure your data is handled securely. Your trust is paramount to us, and we strive to implement rigorous data protection measures and give you control over your personal information.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class InformationCollectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Information Collection',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Types of Information Collected:\n',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          '• Personal Information: This may include, but is not limited to, your name, email address, '
          'and any other information you provide when creating an account, participating in our community, '
          'or contacting support.\n'
          '• Non-Personal Information: We collect anonymized, aggregate information that cannot be used to '
          'identify you personally, such as app usage patterns, preferences, and interactions with the app.\n'
          '• Location Data: To enhance the functionality of bioWatch, including species identification and '
          'contributing to biodiversity mapping, we collect precise or approximate location data from your device '
          'when permitted by you.\n',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Methods of Information Collection:\n',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          '• Direct from Users: We collect information you provide directly to us when you create an account, '
          'use the app to identify species, participate in forums, or communicate with us.\n'
          '• Through Third Parties: We may receive information about you from third-party services, for example, '
          'if you choose to connect your social media account with our app, subject to the privacy settings '
          'you have set in such accounts.\n'
          '• Automatically Collected Information: We automatically collect certain information when you use the '
          'app, such as details about your device, IP address, and app activity, to improve functionality and user experience.\n',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class InformationSharingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4. Information Sharing',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'bioWatch values your privacy and is committed to protecting your personal information. '
            'Information collected through the app is shared under specific circumstances, as outlined below:\n',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            '• With Consent: We may share your information with third parties when we have your explicit consent to do so. '
            'This includes sharing data for community-led conservation projects or with partners that offer services aligned with our mission.\n'
            '• Service Providers: Your information might be shared with third-party service providers who perform services on our behalf, '
            'including hosting, data analysis, customer service, email delivery, and marketing services. These providers have access to the '
            'personal information needed to perform their functions but are obligated not to disclose or use it for other purposes.\n'
            '• Legal Reasons: We may disclose your information if required by law or if we believe in good faith that such action is necessary to '
            'comply with a legal obligation, protect and defend our rights or property, ensure the safety of the public or any person, or prevent '
            'or stop activity we may consider being, or to pose a risk of being, illegal, unethical, or legally actionable.\n'
            '• Business Transfers: In the event of a merger, acquisition, reorganization, bankruptcy, or sale of some or all of our assets, your '
            'information may be transferred as part of that transaction. We will notify you of any such deal and outline your rights.\n'
            '• Aggregate and De-Identified Information: We may share aggregate or de-identified information, which cannot reasonably be used to '
            'identify you, with partners or for research purposes. This data may help in understanding trends and enhancing biodiversity conservation '
            'efforts without compromising individual privacy.\n',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            'Your trust is paramount to us, and we strive to ensure transparency and security in all information-sharing practices. '
            'bioWatch is dedicated to upholding the highest standards of data protection and privacy.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class DataSecurityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5. Data Security',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'At bioWatch, ensuring the security of your data is of utmost importance to us. '
            'We implement a comprehensive suite of security measures designed to protect your personal information '
            'against unauthorized access, alteration, disclosure, or destruction. These measures include, but are not limited to:\n',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            '• Login Authentication: We employ robust login authentication processes to verify the identity of our users. '
            'This includes the use of strong passwords and, where applicable, two-factor authentication (2FA) to add an extra layer of security to your bioWatch account.\n'
            '• Encryption: Your data is encrypted both in transit and at rest. This means that any information sent from your device to our servers, '
            'and vice versa, is protected using industry-standard encryption protocols. Similarly, data stored on our servers is encrypted to prevent unauthorized access.\n'
            '• Access Controls: Access to personal information is strictly limited to authorized bioWatch personnel and third-party service providers who need access to perform their job functions. '
            'They are bound by confidentiality obligations and may be subject to disciplinary action, including termination and legal action, for failing to meet these obligations.\n'
            '• Regular Security Assessments: We regularly review and update our security practices to address evolving threats and vulnerabilities. '
            'This includes conducting security assessments and penetration testing to identify and remediate potential security issues.\n'
            '• User-Controlled Privacy Settings: bioWatch provides users with privacy settings that allow you to control who can see your information and how it is used. '
            'We encourage users to review their privacy settings regularly and adjust them according to their comfort level.\n'
            '• Incident Response Plan: In the unlikely event of a data breach, we have an incident response plan in place to quickly address and mitigate the impact of the breach. '
            'We are committed to notifying affected users in accordance with applicable laws and regulations.\n',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            'We understand the importance of safeguarding your personal information and are committed to implementing and maintaining the highest standards of data security. '
            'By employing these practices, bioWatch aims to provide a secure environment for our users to enjoy the benefits of our app without compromising their privacy or security.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class UserRightsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '6. User Rights',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'bioWatch is committed to ensuring that our users have control over their personal information. '
            'We recognize the importance of your data rights and provide the following options to manage your information:\n',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            '• Access: Users have the right to access the personal information we hold about them. '
            'You can request an overview of your data to understand what information has been collected and how it is used.\n'
            '• Correction: If you find that any information we have about you is incorrect or incomplete, you have the right to request corrections. '
            'We encourage users to keep their information up to date for the most accurate experience.\n'
            '• Deletion: Users can request the deletion of their personal information from our systems. '
            'We will comply with such requests in accordance with applicable laws and regulations, bearing in mind that some information may be retained for specific legal or record-keeping requirements.\n'
            '• Data Portability: Where technically feasible, users have the right to request a copy of their data in a structured, commonly used, and machine-readable format. '
            'This allows you to transfer your information to another service if you wish.\n'
            '• Withdraw Consent: For activities based on consent, such as promotional communications, users have the right to withdraw their consent at any time. '
            'Following a withdrawal, we will stop processing your data for that specific purpose.\n'
            '• Object or Restrict Processing: Users have the right to object to or request the restriction of processing of their personal information under certain circumstances. '
            'When objected or restricted, we will assess the situation and either limit our use of the data or explain the legitimate grounds we have to continue processing it.\n\n',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            'To exercise any of these rights, please contact us through the app\'s support feature or via our designated contact details. '
            'We are dedicated to facilitating your requests in a timely manner, in accordance with our policies and relevant legislation.\n\n'
            'At bioWatch, we believe in transparency and empowering our users. Upholding your rights is a cornerstone of our commitment to privacy and data protection.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ChildrensPrivacyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7. Children\'s Privacy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'At bioWatch, we are deeply committed to protecting the privacy of younger users, especially those under the age of 13, who engage with our educational version designed for K-12 students. '
            'Our approach to children’s privacy is designed to comply with all applicable laws and regulations, including the Children\'s Online Privacy Protection Act (COPPA) in the United States and similar legislation globally. '
            'Here’s how we manage children’s data with care and responsibility:\n',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            '• Parental Consent: Before collecting any personal information from children, we require verified parental consent. '
            'Parents or guardians are fully informed of the data collection practices and have control over the information provided to us by their children.\n'
            '• Educational Purpose: The educational version of bioWatch is crafted to offer a safe, engaging platform for children to learn about and identify species. '
            'While fostering environmental awareness, we ensure that the use of the app for research purposes is clearly communicated and aligned with educational goals.\n'
            '• Data Collection: We limit the collection of personal information from children to what is reasonably necessary to participate in the educational activities provided by bioWatch. '
            'This may include data for creating a user profile and documenting the species identified, under strict parental control.\n'
            '• Use and Sharing: Any information collected from children is used solely for educational and research purposes, in collaboration with school educators. '
            'We do not disclose children\'s personal information to third parties unless necessary for the operation of the service, and always with explicit parental consent.\n'
            '• Access and Deletion: Parents or guardians have the right to review their child’s personal information, request corrections, or request the deletion of the data. '
            'Additionally, they can refuse further collection or use of their child’s information.\n'
            '• Security: We implement specific security measures to protect children\'s personal information from unauthorized access, alteration, or deletion. '
            'Our commitment to security is paramount in providing a safe environment for educational engagement.\n\n',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            'Our dedicated children’s privacy policy is tailored to meet the needs of our younger users and their guardians, ensuring a secure and enriching learning experience with bioWatch. '
            'We continuously work with educators, parents, and legal experts to refine our practices and uphold the highest standards of children’s privacy and safety.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PolicyUpdateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'bioWatch is committed to continuously enhancing our services and ensuring our practices align with the best interests of our users. '
        'As part of this commitment, our Privacy Policy may be updated from time to time to reflect changes in our operations, legal requirements, or user feedback.\n\n'
        'Notification of Changes:\n'
        '• Direct Communication: When significant changes are made to our Privacy Policy, we will notify our users directly via email or through in-app notifications. '
        'This ensures that you are aware of what information we collect, how we use it, and under what circumstances, if any, it is disclosed.\n'
        '• Policy Updates on Our Website: Minor updates and adjustments to the Privacy Policy will be posted on our website and within the app. '
        'The updated policy will include a revision date, allowing users to easily identify the most current version.\n'
        '• Encouragement to Review: We encourage all users to periodically review the Privacy Policy to stay informed about our data protection practices. '
        'Your continued use of BioWatch after any changes to the Privacy Policy take effect signifies your agreement to the updated terms.\n\n'
        'At bioWatch, transparency and trust are paramount. We are dedicated to keeping our users informed and maintaining open lines of communication regarding any changes to our privacy practices. '
        'Should you have any questions or concerns about these changes, we welcome you to contact us directly.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PrivacyContactWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'At bioWatch, we are dedicated to maintaining your trust and ensuring the security of your personal information. '
        'If you have any questions, concerns, or comments about our Privacy Policy or your data, we encourage you to reach out to us. '
        'Our team is ready to address any inquiries and provide the support you need regarding privacy-related matters.\n\n'
        'Here’s how you can contact us:\n'
        'Email: For a direct and efficient response, please email us at [yky5242@psu.edu]. '
        'Our privacy team will review your inquiry and get back to you as promptly as possible.\n\n'
        'Contact Form: You can also reach us through the contact form available on our website [https://biowatch.framer.website/contact]. '
        'Please select "Privacy Inquiry" as the subject to ensure your message is directed to the appropriate department.\n\n'
        'Mail: If you prefer to contact us by mail, please send your correspondence to:\n'
        'bioWatch Privacy Team\n'
        '3 Agricultural Engineering Building\n'
        'University Park, PA 16802\n'
        'Please include your contact information and a detailed description of your privacy inquiry or concern.\n\n'
        'Social Media: For general questions, feel free to reach out via our official social media channels. '
        'However, please avoid sharing sensitive personal information publicly. For specific privacy concerns, use the email or contact form options.\n\n'
        'We take your privacy concerns seriously and are committed to resolving any issues in a respectful and timely manner. '
        'Your feedback is invaluable to us as it helps us improve our privacy practices and enhance user experience.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}

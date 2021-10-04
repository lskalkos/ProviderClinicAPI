# README

For this side project I made a new Rails app, but there are a few files I'd like to direct your attention towards in particular as examples:

- ProviderClinic Model: https://github.com/lskalkos/ProviderClinicAPI/blob/main/app/models/provider_clinic.rb
- ProviderClinic Spec: https://github.com/lskalkos/ProviderClinicAPI/blob/main/spec/models/provider_clinic_spec.rb
- ProviderClinicsController: https://github.com/lskalkos/ProviderClinicAPI/blob/main/app/controllers/provider_clinics_controller.rb
- Provider Clinics Request Spec: https://github.com/lskalkos/ProviderClinicAPI/blob/main/spec/requests/provider_clinics_spec.rb
- ZipcodeAPI::Client: https://github.com/lskalkos/ProviderClinicAPI/blob/main/app/apis/zipcode_api/client.rb

A couple of notes about my sample:
- Let me know if there's any issue with the repo being public and I'm happy to make it private and invite users. 
- I don't consider it production ready! I would go through a lot more steps to make it so, including code review, actually testing the API through Postman, having a README, etc.
- The specs pass on my computer but I didn't worry about environment management, so not sure how things will work on your side if you clone the repo right now and try to run them. 
- I didn't worry about version control best practices for this, so you won't see much of a Git history. In real life I would have more atomic commits with better commit messages. I've included a lot of my comments with my thinking -- in practice my comments would be condensed. 
- I used this as an opportunity to experiment with YardDoc and the jsonapi-rails gem :)

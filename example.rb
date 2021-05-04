require 'krn/auth'

krn = Krn::Auth.new(
  name: 'KRN',
  crypt_key: '',
  hmac_secret: '',
  rest_key: '',
  rsa_key: ''
)

# send a s2s request
r = krn.send_request(method: 'GET', path: '/KRN/signing_test')
puts r.inspect
exit

sample = 'KRN:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJrcm4iLCJleHAiOjE2MjAxNjI1MjIsImlhdCI6MTYyMDE2MDcyMiwianRpIjoiZGMzNjJiYzItZmJiMC00YzVlLTg1OGItMGQ1NjViMmM1Y2JlIiwicGF5bG9hZCI6InN3ZFU2RGw3OWIrbWg2UlVpaFhENUtmYTYzR0J5ejV3R0djd0x1aEMrLzZGa0hkbHZxbW55UkpzWm1OUURHYmNrMmN2TkswZHRtbHhRSWdJSlFvbFNHSHNodmpIWERYUWdoWG9PbmRTWEZ2VkxXTzUxcSs3bG9tNWx0c1FKZ213NnVoWE5YNENIcXB3QTFXeVRiRkhRYnAwL3dFMlJjRGlwVUtaYytCUWd4ZDkzcFpydTFyOUo2M0FvWlhZZkVxOUhNM2s3NURXeHJKN3pkSU9KMFhQNXJxQVlORUgwNmRqTG5BaWpnYStUQW89Iiwic3ViIjoiMjYxMDRiMzQtMGU1ZC00NjkwLWI2YTgtOTRiOTQ4ZjY5ZWIzIn0.5nlKr3FX8U_crZCT-lQHXQbuqIEZxBBc5lMXuzEhrzc'

payload = krn.validate(passport: sample)
if payload
  puts 'Token Valid - Payload:'
  puts JSON.pretty_generate(payload)
else
  puts 'Token invalid'
end

puts 'DEEP VALIDATION'
payload = krn.deep_validate(passport: sample)

if payload
  puts 'Token Valid - Payload:'
  puts JSON.pretty_generate(payload)
else
  puts 'Token invalid'
end

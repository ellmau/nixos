{ config, pkgs, lib, ... }:
with lib; {
  config = {
    elss = {
      users = {
        meta = {
          ellmau = {
            description = "Stefan Ellmauthaler";
            mailAddress = "stefan.ellmauthaler@tu-dresden.de";
            hashedPassword = "$6$8TtAMwO3cf6EK0uH$k6MVV.H/DDNdb3yMWwv/z4Bo9TT9WYxCKqILh50t8YBR67SGbA1wRoho6FLTSRJmu.YGDUJARR3nXE27h.ve0/";
            publicKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0XgjNGsqo8gbtPTpH8pHCdGQyGNWdKcSAmyhiLBLM3 stefan.ellmauthaler@tu-dresden.de"
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyL/ynqq4pMhALzbLky9b/+Oledo8X21bWOKWUyBUlXp9u35WkU5BnSbHZ79TxuKl+Lw28hXItW/xtyDdVEPAKx6uopA9alMMbRr0ghpkEyc76Pdh3TcXDNj613i2Rwx9nHMJpcuWcl8rKtoorH4z3GzftJoWMQbvmYhy0kctLXsf81Ud9eKOELzftLILDYa7/L9C08x3b/vfK90vK0AdiQU0nZf+XmbPT5wosAjTzFrigSpSaoqdJhEhq9V3dRTPVM6DT7gEVCzgcFDJJKRGx944ivMubtzKffirF/RgDaLkD6WHlV3Ymg1gSpKAswY2QwcnV0mkRofWh8y1/eGckNJ0CJ7vv2GKZUI7AVjUyEZq1GxDMEhLN12SHoOby/hP3BeCTEcZeDqPj28ZlS8e+oF0dTJnwsD6nHPV5xlPdQeyD17QF7HUoNd/wV+SzRGzaVz6AEh2vodSt2t9eaugMK3L/xiOSrguhkyJEI95cJgBOC+i4BF+poOikACzZPIpQ8bx0HKEynDsM4QlNvKmjS6uBQuLaUjaQIHjEt24MiAJdhxHZIsSliMzmRycs9jRMBj4WiSolee6j+YDm7e/l1vSE3mRO23atPOWvIF+1+r1LGFWLQp2j8iQJJ6DyX4+5Nkk0VrM0JCinNWTj+1C4hxvqwzrZ5i5mMYgSTJYx0w== nucturne"
            ];
          };
        };
      };
    };
  };
}

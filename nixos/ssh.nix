{ ... }:

let
  legacyDesktopKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJLsatRyC4Ju4EGb1w8AWy/CycT4DcHnV5Hg7u5H+jj desktop@darcien.dev'';
  legacyLaptopKey = ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDX1H8YVSO6VPWNTVhQ1sDeHAfsS/D3qjogjlhL/yLYY7/tqK3fssjqkBOjAhBj+vxoTtsutrtDXwpyIv+SoA4dX4nJeNHcRgMURuPM7C2ra2SiwdqP3Bc1FD6uqfe+8iNZ6q3fZrgB5g0H960ea0ZhODvgCQzBTs+ekKNW9Got9dVSpHGn0UzessSSSF2W8bNS4vfw9bv7vUBvtLr4d+U/kUd8D0syuFM6D4UQhTPQV5hDstig045JGVaSEioom3T3plxMYGqCSFquGKK+hiu6CxGbgP+Z0ip3b5yErFcZjolV/8jj8gtc5PmRInklbfrg6OQRhEJxW8pI+kC6+n1ZekaMOglyQF3Xtk2n8nDejAcz2blbHudeuD2yfXt+EbbqM0m6aBbbjc746p+5xGWMoA5gehGI6Mepo+oFLW3hs6e3fU43xqG4vzQGI7eIn1D+YPFx82nDbwGBh3ijO4voDf92+3GFZa3OQW0GM4e4LUgi9DqGWhBf/PAmNBeIMTv2i8bumcxhtRbzV0IiOLwvDVnqd2VHnLFStdSfXDsD79LVUu0Zdp0w9IpIskyCSbSSCIlDFJvKojDZNwW34v+4PL2sFTl7GLnveM4Zkae2m9AqyVHAjUYFYep4CP/wOKazsFVpPLuxNAFt8a2qbPSZB/cI5NV1MJcHRs7tLota4Q== yosua.ian.sebastian@gmail.com'';
in

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    legacyDesktopKey
    legacyLaptopKey
  ];

  users.users.darcien = {
    openssh.authorizedKeys.keys = [
      legacyDesktopKey
      legacyLaptopKey
    ];
  };
}

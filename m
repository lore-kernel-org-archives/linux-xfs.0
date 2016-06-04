Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D18957CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 19:43:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D124AC01F
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 17:43:28 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id kz7TwkVy5J4qRb42 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 17:43:26 -0700 (PDT)
Date: Fri, 3 Jun 2016 20:43:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] Allow compiling xfsprogs in a cross compile environment.
Message-ID: <20160604004325.GZ7717@vapier.lan>
References: <AMHSBOU5+XsM503_3khtVBWa+Ymz9BrezGzpxpJEr3axCMuR1Q@mail.gmail.com>
	<1465000276-16554-1-git-send-email-gwendal@chromium.org>
MIME-Version: 1.0
In-Reply-To: <1465000276-16554-1-git-send-email-gwendal@chromium.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7495614736890081138=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Gwendal Grignou <gwendal@chromium.org>
Cc: hch@infradead.org, tytso@mit.edu, fstests@vger.kernel.org, xfs@oss.sgi.com


--===============7495614736890081138==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9+ohdFDUqiMJzwPo"
Content-Disposition: inline


--9+ohdFDUqiMJzwPo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Reviewed-by: Mike Frysinger <vapier@gentoo.org>
-mike

--9+ohdFDUqiMJzwPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXUiQsAAoJEEFjO5/oN/WBv2IP/Az8W7bMSzhiVcH/yT6UC98J
dGZrsP7meey44BCojV1TVfgaKEF2nzYAv9396wchEkKqOD4hb93dd4IZ2Ir75kX/
2ob4DQoBv/PmVRhvHvLfUVhTWUm7ax4L8dwmqQ5XEhHc0GApnSlZjFpVFuvUied/
GyorBn3CvQ9v7NhIoF0esDc+4k2YeflHhyVNZ8YSMbTqW7Sj70Dk5qXEx/IKn2fU
gHys/cdQKq15vD9v5JNXwalap+UAtwJAEAmj3K1OnJVL9/nAUxtOUQkwe7+JEj8C
/Kd4TwXZC6Kj7YXqqBWkfW9DTTOUY1ovkeYx6B+xw6Tcfnu+HsBCNrDc8enFweeN
+bwYQFnNGumtojGRSwckiqPZvHR4zaFSH2v8Xx7K4GWEWNQqbFD4y5pL8DSQHd6r
6mGomYv6yPxoJRI8LqF+eBGQTfduno0ZV5tgneCOpeoET1uSJZdpzMA8gy/0731X
mr2tmZgdjX1ri11Et+eopv6RdhoWB6jADDjbYUbQ9aS+F7AC1klZ0OuexbO4zxUI
b/AYkRu396a+wtMlXbM+/sd6LV7NR9/4HgtkeZ1dwJ/1TwDOrJekuAaRTOjidih5
OW1ONx+DojASxKizPZGNj9DrvS+p21+hcnGMDiGuI9vYddS2cnzswxF0PO/NGGXW
GF5mrtgCjhqi+hGa3p+M
=bRrJ
-----END PGP SIGNATURE-----

--9+ohdFDUqiMJzwPo--


--===============7495614736890081138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7495614736890081138==--

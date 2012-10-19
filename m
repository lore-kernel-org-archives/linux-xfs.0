Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9J4KHCG232557 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 23:20:18 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id i3dOaNrmkCv3hpRA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Oct 2012 21:21:56 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/3] respect DESTDIR when installing
Date: Fri, 19 Oct 2012 00:21:58 -0400
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-2-git-send-email-vapier@gentoo.org>
	<20120925094139.GK9189@infradead.org>
In-Reply-To: <20120925094139.GK9189@infradead.org>
MIME-Version: 1.0
Message-Id: <201210190021.59105.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5222996563211103580=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============5222996563211103580==
Content-Type: multipart/signed;
  boundary="nextPart1591937.2YnSkFMkGj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1591937.2YnSkFMkGj
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Tuesday 25 September 2012 05:41:39 Christoph Hellwig wrote:
> Looks good.  I guess this is for xfstests as it should be working for
> the real tools?

hmm, these don't appear to have been merged.  is there something i should do ?
-mike

--nextPart1591937.2YnSkFMkGj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQgNVnAAoJEEFjO5/oN/WBzLAQAKoZv0ZJBpv7f9p327swUeXd
t/GtUEkH8D3UHuqO1AHlBvY+YEfri+FaVkKI13FpHnvVxlpVQ5ylBZpa9Z7O7iVq
XwDiDLZlJsL2cOHVh0z0KMYneW9UW2VcY7e3JOW3KOIxk6JJ1ViTRv2vTEfvCVLv
kJFRq2aDyai+Jmud2H9HnIDvvozLpQYFYYumtesqOCzTu9olyg7//OzPlwPIzLsP
6FJArzc8T8p5ptA9oNLlnsVox9O7+O0zhbeiD9lHO00TD2YjAVfivyOV8O8JdWgw
jsVSZ3oqV7tJ6NdQUJy70gchc04YaI4By3arMl4jQ+xvX5wmKR3yj5lEx/65kW5r
7vpNrqke1CL0fgUqCXZbwEYAhCshbcn3hzQKNfhRAyKZTcQQPEUACJ2nUrQ7TYQj
Srq4kEvpDqzpK0OwawWcPJFXgXPkR6dvlCrf223O5+qZc88MERXQmMH3xMykCPwf
KohqlkSj4zYrZpixPj8aBMmsqqbKHsTiIDaJtyr7oq2Fykqs58CTGuAwz7Bmly3i
mJn9i2I78/JUsfG1m/K70E65uFrlS8LYeirUyo4PD/TnFXIrTJra/aRZJqM2US36
tW76N3DMs4C8cyg511t3y31+Um58DgzO2s4RVxiTeFNt2Ixr4r5M60BSIS6jF90b
sG4NO8NIcgguYtVbt40O
=UZwa
-----END PGP SIGNATURE-----

--nextPart1591937.2YnSkFMkGj--


--===============5222996563211103580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5222996563211103580==--
